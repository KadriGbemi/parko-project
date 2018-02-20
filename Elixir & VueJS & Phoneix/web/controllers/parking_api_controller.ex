defmodule Parko.ParkingApiController do
  use Parko.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias Parko.{Park, Repo, User, Booking, Payment}

  def find(conn, params) do

    IO.inspect conn|>get_session("user_id")
    lat = params["lat"]
    lng = params["lng"]

    if  params["end"] == nil do
    
      parks = Repo.all(Park)
    
      parks_json = parks
                    |>Enum.filter(fn(x) -> calc_dist_closest(x,lat,lng) <= 500.00 end )
                    |>Enum.filter(fn(x) -> x.available_space != 0 end)
                    |>Enum.sort(fn(x,y) -> calc_dist_closest(x,lat,lng) <= calc_dist_closest(y,lat,lng) end )
                    |>Enum.map(fn(x) -> %{"park_id" => x.id, "address" => x.address, 
                    "long" => x.lng, "lat" =>x.lat, "zone" => x.zone, 
                    "points"=>Repo.all(assoc(x, :points))|>Enum.map(fn(y) -> %{"long" => y.lng, "lat" =>y.lat} end),
                    "distance" =>  round(calc_dist_closest(x,lat,lng)),
                    "available_space" => x.available_space} end )
      
      conn |> put_status(201) |>  
      json(%{spaces_in_range: parks_json})               

    else
      
      {start_time, _} =  :string.to_integer(to_char_list(params["start"]))
      {end_time, _} = :string.to_integer(to_char_list(params["end"]))
      
 
      IO.inspect(start_time)
      #fetch all parking spaces available
      parks = Repo.all(Park)

      parks_json = parks
                   |>Enum.filter(fn(x) -> calc_dist_closest(x,lat,lng) <= 500.00 end )
                   |>Enum.filter(fn(x) -> x.available_space != 0 end)
                   |>Enum.sort(fn(x,y) -> calc_dist_closest(x,lat,lng) <= calc_dist_closest(y,lat,lng) end )
                   |>Enum.map(fn(x) -> %{"park_id" => x.id, "address" => x.address, 
                   "long" => x.lng, "lat" =>x.lat, "zone" => x.zone, 
                   "est_price_hourly" => zoneAmount(start_time,end_time,x.zone)["HOURLY"], 
                   "est_price_real_time" => zoneAmount(start_time,end_time,x.zone)["REALTIME"],
                   "points"=>Repo.all(assoc(x, :points))|>Enum.map(fn(y) -> %{"long" => y.lng, "lat" =>y.lat} end),
                   "distance" =>  round(calc_dist_closest(x,lat,lng)),
                   "available_space" => x.available_space} end )
      
      conn |> put_status(201) |>  
      json(%{spaces_in_range: parks_json})           
    end

  end
  
  def calc_dist(lat1, lng1, lat2, lng2) do
    earthRadius = 6371000; #meters
    dLat =(lat2-lat1)* :math.pi()/ 180;
    dLng = (lng2-lng1)*:math.pi()/ 180; 
    a = :math.sin(dLat/2) * :math.sin(dLat/2) +
        :math.cos((lat1)*:math.pi()/ 180) * :math.cos((lat2)*:math.pi()/ 180) *
        :math.sin(dLng/2) * :math.sin(dLng/2);
    c = 2 *:math.atan2(:math.sqrt(a), :math.sqrt(1-a));
    dist = earthRadius * c;

    dist
  end  

  def calc_dist_closest(park, lat, lng) do
  
    Repo.all(assoc(park, :points))|>Enum.map(fn(x) -> calc_dist(x.lat,x.lng,lat,lng) end)
    |>Enum.sort(fn(x,y) -> x <= y end)
    |>List.first

  end

  def zoneAmount(startime , endtime ,zone) do
    # Hourly payment
    # Zone A: 2 euros per hour
    # Zone B: 1 euro per hour
    # Real-time payment
    # Zone A: 16 cents per 5 minutes
    # Zone B: 8 cents per 5 minutes
    duration = 0
    if startime > endtime do
      duration = 1440 - startime + endtime
    else 
      duration = endtime-startime
    end  

    if zone=="A" do
      %{"HOURLY"=>(div(duration-5,60)+1)*2.0, 
      "REALTIME"=>(div(duration,5)+1)*0.16}
    else
      %{"HOURLY"=>(div(duration-5,60)+1)*1.0, 
      "REALTIME"=>(div(duration,5)+1)*0.08}
    end
  end
  
  def book(conn, params) do

    IO.inspect conn|>get_session("user_id")
    payment_method = params["payment_method"]
    park_id = params["park_id"]
    park = Repo.get(Park,park_id)

    if park.available_space != 0 do
      changeset = Ecto.Changeset.change park, available_space: park.available_space - 1
      park = Repo.update!(changeset)
    else
      conn 
      |> put_status(201)
      |>json(%{msg: "Parking space is full", booking_id: "", payment_id: ""})
    end

    
    user = Repo.get(User, conn|>get_session("user_id"))
    

    {start_time, _} =  :string.to_integer(to_char_list(params["start"]))
    {end_time, _} = :string.to_integer(to_char_list(params["end"]))

    booking =  Repo.insert!(%Booking{
        payment_method: payment_method,
        start_time: start_time,
        end_time: end_time,
        user: user,
        park: park
       })

    if is_nil(booking) do

      conn 
      |>put_status(501)
      |> json(%{msg: "Sorry, we couldn't make the booking!"})
      
    else
      payment_id = ""
      payment_info = "" 
      
      if payment_method == "HOURLY" do
        payment_id =  pay(booking, booking.start_time, booking.end_time)
        payment_info = get_invoice_info(payment_id)
      end 

      booking_id = booking.id
      
      IO.inspect payment_info
      conn 
      |> put_status(201)
      |>json(%{msg:  "Booking has been made successfully!", booking_id: booking_id, payment_id: payment_id, payment_info: payment_info})
  
    end

  end

  def pay(booking, start_time, end_time) do 

    park = Repo.get(Park, booking.park_id)
    user = Repo.get(User, booking.user_id)
    
    amount = zoneAmount(start_time, end_time, park.zone)[booking.payment_method]
 
    IO.inspect amount 

    payment =  Repo.insert!(%Payment{
      booking: booking,
      start_time: start_time,
      end_time: end_time,
      amount: amount,
      payment_date: Date.utc_today(),
      due_date: Date.utc_today()
     })
    IO.inspect payment.id
    if is_nil(payment) do 
      ""
    else
      payment.id 
    end

  end

  def elapse(conn, params) do

    booking_id = params["booking_id"]
    booking = Repo.get(Booking, booking_id)

    {_,{h,m,s}} = :calendar.local_time()
    end_time = h*60 + m
    
    start_time = booking.start_time
   
    elapse = 0
    if start_time > end_time do
      elapse = 1440 - start_time + end_time
    else 
      elapse = end_time-start_time
    end
   
    elapse_h =  div(elapse,60)
    elapse_m = rem(elapse,60) 


    limit = 0
    if start_time > booking.end_time do
      limit = 1440 - start_time + booking.end_time
    else 
      limit = booking.end_time-start_time
    end


    if booking.finished do
      msg = "You have finished parking"
      elapse_h =  div(limit,60)
      elapse_m = rem(limit,60) 
      s=0
    else
      msg = "You are parking!" 
      if booking.payment_method == "HOURLY" and elapse >= limit do 
        IO.inspect elapse
        IO.inspect limit
        finish(conn, params)  
      end
      notify = false
      if booking.payment_method == "HOURLY" and elapse >= limit-10 do 
        IO.inspect booking.released 
        if elapse >= limit-2 and !booking.released do
          IO.inspect "hi"
          park = Repo.get(Park, booking.park_id)
          changeset = Ecto.Changeset.change park, available_space: park.available_space + 1
          park = Repo.update!(changeset)
          
          changeset = Ecto.Changeset.change booking, %{released: true}
          booking = Repo.update!(changeset)
          
        end
        notify = true
        msg = "Your parking will end in #{limit-elapse} min"
      end
    end     
   

    conn 
    |> put_status(201)
    |> json(%{msg: msg, elapse_h: elapse_h,elapse_m: elapse_m, elapse_s: s, payment: booking.payment_method, finished: booking.finished, released: booking.released, notify: notify})

  end

  def finish(conn, params) do
    
         booking_id = params["booking_id"]
         booking = Repo.get(Booking, booking_id)

         

         {_,{h,m,s}} = :calendar.local_time()
         start_time = booking.start_time
         end_time = h*60 + m

         if booking.payment_method == "HOURLY" do
          end_time = booking.end_time
         else
          
         end  

        if !booking.released do
          park = Repo.get(Park, booking.park_id)
          changeset = Ecto.Changeset.change park, available_space: park.available_space + 1
          park = Repo.update!(changeset)
          
          changeset = Ecto.Changeset.change booking, %{released: true}
          booking = Repo.update!(changeset)

        end

        changeset = Ecto.Changeset.change booking, %{finished: true, end_time: end_time}
        booking = Repo.update!(changeset)


         elapse = 0
         s=0
         if start_time > end_time do
          elapse = 1440 - start_time + end_time
         else 
          elapse = end_time-start_time
         end
         
         elapse_h =  div(elapse,60)
         elapse_m = rem(elapse,60)

         payment_id =  pay(booking, booking.start_time, booking.end_time)
         payment_info = get_invoice_info(payment_id)
         IO.inspect payment_id
         conn 
         |> put_status(201)
         |>json(%{msg: "You have finished parking", booking_id: booking.id, elapse_h: elapse_h,elapse_m: elapse_m, elapse_s: s, payment_id: payment_id, payment_info: payment_info, payment_method: booking.payment_method, finished: booking.finished, released: booking.released})
    
  end

  def extend(conn, params) do
    
         booking_id = params["booking_id"]
         extend_m = params["end"]
         IO.inspect extend_m
         booking = Repo.get(Booking, booking_id)

         start_time = booking.start_time
         extend_time = booking.end_time + extend_m

        {_,{h,m,s}} = :calendar.local_time()
        end_time = h*60 + m 
       
        
        elapse = 0
   
        if start_time > end_time do
         elapse = 1440 - start_time + end_time
        else 
         elapse = end_time-start_time
        end
        
        elapse_h =  div(elapse,60)
        elapse_m = rem(elapse,60) 

        
        payment_id = ""
        if booking.released do
          park = Repo.get(Park, booking.park_id)
          if park.available_space != 0 do
            changeset = Ecto.Changeset.change park, available_space: park.available_space - 1
            park = Repo.update!(changeset)
            
            changeset = Ecto.Changeset.change booking, %{released: false}
            booking = Repo.update!(changeset)
          else
            conn 
            |> put_status(201)
            |>json(%{msg: "Parking space is full", booking_id: booking.id, elapse_h: elapse_h,elapse_m: elapse_m, elapse_s: s, payment_id: payment_id, payment_method: booking.payment_method, finished: booking.finished, released: booking.finished})
          end
        end
        
        payment_id =  pay(booking, booking.start_time, booking.end_time)
        payment_info = get_invoice_info(payment_id)
        changeset = Ecto.Changeset.change booking, %{end_time: extend_time, finished: false}
        booking = Repo.update!(changeset)

         conn 
         |> put_status(201)
         |>json(%{msg: "You have extended parking", booking_id: booking.id, elapse_h: elapse_h,elapse_m: elapse_m, elapse_s: s, payment_id: payment_id, payment_info: payment_info, payment_method: booking.payment_method, finished: booking.finished, released: booking.released})
    
  end

  def get_invoice_info(payment_id) do
  
    payment = Repo.get(Payment, payment_id)
    booking = Repo.get(Booking, payment.booking_id)
    user = Repo.get(User, booking.user_id)
    park = Repo.get(Park, booking.park_id)

    %{"invoice_no" => payment.id, "payment_date" => payment.payment_date,
     "due_date" => payment.due_date, "park_address" => park.address, 
     "end_time" => payment.end_time,"start_time" => payment.start_time, 
     "payment_method" => booking.payment_method,"amount" => payment.amount}

  end
  
  def list_bookings(conn, params) do

    user = Repo.get(User, conn|>get_session("user_id"))

    bookings = Repo.all(Booking)
               |>Enum.filter(fn x -> x.user_id == user.id end)
               |>Enum.map(fn x -> %{"booking_id" => x.id,
                                    "park_address" => Repo.get(Park, x.park_id).address,
                                    "start_time" => "#{div(x.start_time, 60)}:#{rem(x.start_time, 60)}",
                                     "duration" => x.end_time - x.start_time,
                                     "payment_method" => x.payment_method,
                                     "status" => if x.finished do " finished " else if x.released do "released" else "parking" end end ,
                                      } end)
   
    conn |> put_status(201) |> json(%{bookings: bookings})  
  end  
  def list_payments(conn, params) do
    
        user = Repo.get(User, conn|>get_session("user_id"))
    
        payments = Repo.all(Payment)
                   |>Enum.filter(fn x -> Repo.get(Booking,x.booking_id).user_id == user.id end)
                   |>Enum.map(fn x -> get_invoice_info(x.id) end)
       
        conn |> put_status(201) |> json(%{payments: payments})  
      end  

end