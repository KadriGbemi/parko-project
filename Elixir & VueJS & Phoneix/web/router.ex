defmodule Parko.Router do
  use Parko.Web, :router

  def guardian_current_user(conn,_) do
    Plug.Conn.assign(conn, :current_user, Guardian.Plug.current_resource(conn))
  end
 
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource  
    plug Corsica, origins: "*", allow_headers: ["content-type", "authorization"]
  end

  pipeline :auth_api do
    plug Guardian.Plug.EnsureAuthenticated, handler: Parko.LoginsessionAPIController    
  end


  scope "/", Parko do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
  end

  scope "/", Parko do
    pipe_through [:browser, :browser_auth]# Use the default browser stack

    get "/", PageController, :index
    resources "/parks", ParkController
    resources "/bookings", BookingController
    resources "/points", PointController
    resources "/payments", PaymentController
  end

  # Other scopes may use custom stacks.
  scope "/api", Parko do
     pipe_through :api
     post "/loginsession", LoginsessionAPIController, :create
     post "/users", UserAPIController, :create
     
  end
  scope "/api", Parko do
    pipe_through [:api, :auth_api]
    post "/parking_find", ParkingApiController, :find
    post "/parking_book", ParkingApiController, :book
    post "/parking_elapse", ParkingApiController, :elapse
    post "/parking_finish", ParkingApiController, :finish
    post "/parking_extend", ParkingApiController, :extend
    post "/list_parking", ParkingApiController, :list_bookings
    post "/list_payments", ParkingApiController, :list_payments
    post "/list_payments", ParkingApiController, :list_payments
    delete "/loginsession/:id", LoginsessionAPIController, :delete
  end
end
