<template>
  <div>
      <nav class="navbar navbar-inverse">
        <div class="container-fluid">
         <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
       <a class="navbar-brand" href="#/">Parko</a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav" >
        <li  class="active"> <a href= "/bookings">My Parkings </a></li>
         <li class="active"> <a href="/payments">My Payments </a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li v-if="!username" ><a href="#/login"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
          <li class="list-group-item" v-if="username"> Welcome, {{username}}  </li>
         <li v-if="username" v-on:click="logout()"><a ><span class="glyphicon glyphicon-log-in"></span> Logout</a></li>  
      </ul>
    </div>
  </div>
</nav>
         <div class="jumbotron" style= "background-image: url(/images/jumbo-back.jpg)">
            <div class="container text-center">
                <div class="coloring" style="color: rgb(226, 217, 217)">
                    <h1>Parko</h1>      
                    <p>Find the best parking place in Tartu</p>
                </div>
            </div>
        </div>
        <div>
            <div>
                <div class="col-sm-offset-1 col-sm-3"> 
                    <div id="custom-search-input">
                        <input type="number"  placeholder="Estimated duration" min = "1" max = "24" class="form-control" id="end_time" v-model="end_time" v-on:change = "searchRequest">
                    </div>     
                </div>
                <div class="col-sm-7">

                    <div id="custom-search-input">
                        <div class="input-group col-md-12">

                            <input type="text" class="form-control" id="destination_address" v-model="destination_address">
                            <span class="input-group-btn">
                                <button class="btn btn-info btn-lg" type="button"  v-on:click="searchRequest">
                                    <i class="glyphicon glyphicon-search"></i>
                                </button>
                            </span>
                        </div>
                    </div>
                </div>

            </div>
            <div v-if="showModal">
                <div class="modal-mask">
                    <div class="modal-wrapper">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-body no-padding-top">
                                    <div class="row no-padding">
                                        <div class="col-md-6 no-padding hidden-xs">
                                            <img src="/images/Parkimismaja.jpg" class="img-responsive" alt="Cinque Terre">
                                        </div>
                                        <div class="col-md-6">
                                            <div class="row">
                                                <div class="col-sm-12" style="padding-top:20px">
                                                    <h3 class="modal-title">Parking information</h3>
                                                </div>
                                                <div class="col-sm-12 padding-top-5">
                                                    <b class="modal-title">Aadress:</b>
                                                    <span>{{spaces_in_range[modal_id].address}}</span>
                                                </div>
                                                <div class="col-sm-12 padding-top-5">
                                                    <b class="modal-title">Price (hourly):</b>
                                                    <span v-if = "spaces_in_range[modal_id].est_price_hourly">{{spaces_in_range[modal_id].est_price_hourly}} €</span>
                                                    <span v-if = "!spaces_in_range[modal_id].est_price_hourly">Info not available</span>
                                                </div>
                                                <div class="col-sm-12 padding-top-5">
                                                    <b class="modal-title">Price (realtime):</b>
                                                    <span v-if = "spaces_in_range[modal_id].est_price_real_time">{{spaces_in_range[modal_id].est_price_real_time}} €</span>
                                                    <span v-if = "!spaces_in_range[modal_id].est_price_real_time">Info not available</span>
                                                </div>
                                                <div class="col-sm-12 padding-top-5">
                                                    <b class="modal-title">Available places:</b>
                                                    <span>{{spaces_in_range[modal_id].available_space}}</span>
                                                </div>
                                                <div class="col-sm-12 padding-top-5">
                                                    <b class="modal-title">Zone:</b>
                                                    <span>{{spaces_in_range[modal_id].zone}}</span>
                                                </div>
                                                <div class="col-sm-12 padding-top-5">
                                                    <b class="modal-title">Distance to destination:</b>
                                                    <span>{{spaces_in_range[modal_id].distance}} m</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">   
                                        <button type="button" class="btn btn-danger" @click="showModal=false">Cancel</button>
                                        <button v-if="username" type="button" class="btn btn-primary" v-on:click="submitBookingRequest(modal_id, 'HOURLY')">Pay hourly</button>
                                        <button v-if="username" type="button" class="btn btn-primary" v-on:click="submitBookingRequest(modal_id, 'REALTIME')">Pay realtime</button>
                                        <a v-else href = "/sessions/new" type="button" class="btn btn-primary">Log in to park here</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div> 

<div v-if="showMessage">
    <div class="modal-mask">
        <div class="modal-wrapper">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body no-padding-top">
                        <div class="row no-padding">
                            <div class="col-md-6 no-padding hidden-xs">
                        <img src="/images/Parkimismaja.jpg" class="img-responsive" alt="Cinque Terre">
                    </div>
                    <div class="col-md-6">
                        <div class="row">
                            <div class="col-sm-12" style="padding-top:20px">
								<h3 class="modal-title">{{title}}</h3>
                            </div>
                            <div class="col-sm-12 padding-top-5">
                                <div v-html="message"></div>
                            </div>    
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
					<router-link v-if="booking_id" :to="{name: 'show_booking', params: {data: {booking_id: booking_id}}}" class="btn btn-primary">Show booking</router-link>
                    <router-link v-if="payment_id" :to="{name: 'show_payment', params: {data: {payment_id: payment_id, payment_info: payment_info}}}">Show invoice</router-link>
                    <button type="button" class="btn btn-primary" @click="showMessage=false">OK</button>				
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</div>
            <div id="map" style="width:100%;height:300px; top:30px;"></div>
            <div class="container-fluid">
            <div class="row" v-if="spaces_in_range" style="padding-top:20px;">
                <div v-if="spaces_in_range.length > 0" class="col-xs-12">
                    <div  class="col-12 col-sm-12 col-lg-12">
                        <h2 style="padding-top:20px; padding-left:5px"> Available parking spaces </h2>
                        <table class="table table-responsive table-condensed" width="auto">
                            <thead>
                                <tr>
                                    <th>Address</th>
                                    <th>Zone</th>
                                    <th>Price (hourly)</th>
                                    <th>Price (realtime)</th>
                                    <th>Available spaces</th>
                                    <th>Distance to destination</th>
                                    <th>Map View</th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class = "available_park" v-for ="(item, index) in spaces_in_range" style="background-color:white">
                                    <td>{{item.address}}</td>
                                    <td>{{item.zone}}</td>
                                    <td>{{item.est_price_hourly}} €</td>
                                    <td>{{item.est_price_real_time}} €</td>
                                    <td>{{item.available_space}}</td>
                                    <td>{{item.distance}} m</td>
                                    <td><button type="button" class="btn btn-primary btn-sm" v-on:click="focusAndHighlight(index)">Highlight</button></td>

                                        <td v-if="username"><button type="button" class="btn btn-primary btn-sm" v-on:click="submitBookingRequest(index, 'HOURLY')">Pay hourly</button></td>
                                        <td v-if="username"><button type="button" class="btn btn-primary btn-sm" v-on:click="submitBookingRequest(index, 'REALTIME')">Pay realtime</button></td>

                                    <div v-else>
                                       
                                   </div>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div v-else>
                <span>No available parking spaces where found</span>
            </div>
            </div>
        </div> 
        <div style="background-color: #f2f2f2;">
        <footer style="background-color: #f2f2f2; padding-bottom:100px;">
            <div class="">
            <h2>See more parking spaces </h2>
            <p>Click on the images to see more.</p>        
            <div class="row equal-height">
                <div class="col-xs-12 col-md-4">
                    <div class="thumbnail">
                        <img src="/images/Parkimismaja.jpg" class="img-fullsize">
                        <div class="caption">
                            <p>There is a nice parking space at Parkimismaja.</p>
                            <br>
                        </div>
                    </div>
                </div>

        <div class="col-xs-12 col-md-4">
            <div class="thumbnail">
                <img src="/images/EuroPark Ülikooli kliinikum.jpg" class="img-fullsize">
                <div class="caption">
                    <p>Another nice parking space at EuroPark Ülikooli kliinikum.</p>
                </div>
            </div>
        </div> <!-- /.col-xs-6.col-md-3 -->

        <div class="col-xs-12 col-md-4">
            <div class="thumbnail">
                <img src="/images/Parking place.jpg" class="img-fullsize">
                <div class="caption">
                    <p>Parking place is not left out.</p>
                    <br>
                </div>
            </div>
        </div> <!-- /.col-xs-6.col-md-3 -->
    </div>
</div>
        </footer>
        <div class= "visible-xs-block" style="padding-bottom: 600px"></div>
        </div>
 </div>
</template>

<script>
  import axios from 'axios';
    import auth from "./auth";
    var userName = null;
    if(document.getElementById('user_id'))
    {
      userName = document.getElementById('user_id').innerHTML;
    }
    
    console.log(userName);
    export default {
        data: function () {
            return {
                destination_address: null,
                start_time: "",
                end_time: "1",
                showModal: false,
                showMessage: false,
                spaces_in_range: null,
                message: "",
                title: "",
                modal_id: null,
                markers: [],
                polygons: [],
                username: ""
            }
        },
        methods: {
            submitBookingRequest: function (marker_index, payment_method) {
                var that = this;
                var park_id = this.spaces_in_range[marker_index].park_id
                var d = new Date(),
                        h = d.getHours(),
                        m = d.getMinutes();

                var start = h * 60 + m;
                var end = start + this.end_time * 60

                console.log(start);
                console.log(end);

                axios.post("api/parking_book", {park_id: park_id, payment_method: payment_method, start: start, end: end},{headers: auth.getAuthHeader()})
                        .then(function (response) {

                            that.searchRequest();
                            that.showMessage = true;
                            that.title = "Confirmation";
                            var booking_link = "";


                            that.message = response['data']['msg'] + "<br> <a href=\"/bookings/" + response['data']['booking_id'] + "\" > View the booking! </a>";
                            that.booking_id = response['data']['booking_id'];

                            if (response['data']['payment_id'] != "")
                            {
                                console.log(response['data']['payment_info']);
                                that.payment_info = response['data']['payment_info'];
                                that.payment_id = response['data']['payment_id'];
                                that.message = that.message + "<br> Payment has also been made! <br> <a href=\"/payments/" + response['data']['payment_id'] + "\" > View the invoice! </a>";
                            } else {
                                that.message = that.message + "<br> Payment will be made when you end the parking.";
                            }

                        })
                        .catch(function (error) {
                            that.title = "Something went wrong. Please try again.";
                            that.message = error.response.data.msg;
                        });

                //here you can find parking place id and make axios post to controller to deal with the booking
                this.showModal = false;
            },

            searchRequest: function () {
                var that = this;
                var my_map = this.map
                var address = this.destination_address;

                var d = new Date(),
                        h = d.getHours(),
                        m = d.getMinutes();

                console.log(h);
                console.log(m);

                var start = h * 60 + m;
                var end = start + this.end_time * 60

                console.log(start);
                console.log(end);

                this.geocoder.geocode({'address': address}, function (results, status) {
                    if (status == 'OK') {
                        this.map = new google.maps.Map(document.getElementById('map'), {zoom: 15, center: results[0].geometry.location});
                        var marker = new google.maps.Marker({
                            map: this.map,
                            position: results[0].geometry.location
                        });

                        var long = results[0].geometry.location.lng();
                        var lat = results[0].geometry.location.lat();

                        axios.post("api/parking_find", {lng: long, lat: lat, start: start, end: end},{headers: auth.getAuthHeader()})
                                .then(function (response) {
                                    that.spaces_in_range = response['data']['spaces_in_range'];
                                    //console.log(response['data']['spaces_in_range'])
                                    that.draw_map();
                                })
                                .catch(function (error) {
                                    console.log(error);
                                });
                    } else {
                        alert('Geocode was not successful for the following reason: ' + status);
                    }
                });
            },
            focusAndHighlight(index) {
                for (var i in this.polygons) {
                    const color = this.spaces_in_range[i].zone === 'A' ? '#3385ff' : '#33ff33';
                    this.polygons[i].setOptions({
                        strokeColor: color,
                        fillColor: color,
                    });
                }
                this.polygons[index].setOptions({
                    strokeColor: '#ff0000',
                    fillColor: '#ff0000',
                });
                map.setCenter(this.markers[index].getPosition());
            },
            showModalFn(index) {
                this.modal_id = index;
                this.showModal = true;
            },
            draw_map: function ()
            {
                var that = this;
                that.markers = [];
                that.polygons = [];
                //setMapOnAll(null);
                //map.setMapOnAll(null);
                for (var i in this.spaces_in_range) {
                    var item = this.spaces_in_range[i];

                    var loc = {lat: item.lat, lng: item.long}; //info marker location
                    var whichIcon = null;

                    //observer object to array of maps
                    const points = [];
                    for (var u in item.points) {
                        const longitude = item.points[u].long;
                        const latitude = item.points[u].lat;
                        points.push({lat: latitude, lng: longitude});
                    }

                    var color = null;

                    if (item['zone'] === 'A') {
                        color = '#3385ff';
                        whichIcon = '/images/parking_iconA.png';
                    } else {
                        color = '#33ff33';
                        whichIcon = '/images/parking_iconB.png';
                    }
                    var marker = new google.maps.Marker({
                        position: loc,
                        icon: whichIcon,
                        map: map
                    });

                    marker.metadata =
                            {'type': 'point',
                                'id': this.markers.length - 1};
                    this.markers.push(marker);
                    marker.addListener('click', (function (index) {
                        return function () {
                            console.log(index)
                            that.showModalFn(index);
                        };
                    })(this.markers.length - 1));

                    var poly = new google.maps.Polygon({
                        paths: points,
                        strokeColor: color,
                        strokeOpacity: 0.8,
                        strokeWeight: 2,
                        fillColor: color,
                        fillOpacity: 0.35
                    });

                    poly.setMap(map);
                    this.polygons.push(poly);
                }
            },
            logout: function () {
                auth.logout(this, {headers: auth.getAuthHeader()})
                 this.username = auth.getUsername();
            }
        },

        mounted: function () {
            this.username = auth.getUsername(); //To check if a user is logged into the system
            navigator.geolocation.getCurrentPosition(position => {
                let loc = {lat: position.coords.latitude, lng: position.coords.longitude};
                this.geocoder = new google.maps.Geocoder;
                this.geocoder.geocode({location: loc}, (results, status) => {
                    if (status === "OK" && results[0])
                        this.destination_address = results[0].formatted_address;
                    this.searchRequest();
                });
                // this.map = new google.maps.Map(document.getElementById('map'), {zoom: 15, center: loc});
                // new google.maps.Marker({position: loc, map: this.map, title: "Destination address"});


                //this.searchRequest();

            });
        }

    }
</script>


<style>
    #custom-search-input{
        padding: 3px;
        border: solid 1px #E4E4E4;
        border-radius: 6px;
        background-color: #fff;
    }

    .row.display-flex {
    display: flex;
    flex-wrap: wrap;
    }


    #custom-search-input input{
        border: 0;
        box-shadow: none;
    }

    #custom-search-input button{
        margin: 2px 0 0 0;
        background: none;
        box-shadow: none;
        border: 0;
        color: #666666;
        padding: 0 8px 0 10px;
        border-left: solid 1px #ccc;
    }

    #custom-search-input button:hover{
        border: 0;
        box-shadow: none;
        border-left: solid 1px #ccc;
    }

    #custom-search-input .glyphicon-search{
        font-size: 23px;
    }

    .modal-mask {
        position: fixed;
        z-index: 9998;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, .5);
        display: table;
        transition: opacity .3s ease;
        }

        .modal-wrapper {
        display: table-cell;
        vertical-align: middle;
        }

        .modal-container {
        width: 300px;
        margin: 0px auto;
        padding: 20px 30px;
        background-color: #fff;
        border-radius: 2px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
        transition: all .3s ease;
        font-family: Helvetica, Arial, sans-serif;
        }

        .modal-header h3 {
        margin-top: 0;
        color: #42b983;
        }

        .modal-body {
        margin: 20px 0;
        }

        .modal-default-button {
        float: right;
        }
    
    .no-padding{
        padding-left: 0px;
        padding-right: 0px;
        padding-top: 0px;
    }

    .no-padding-top{
        padding-top: 0px;
        margin-top: 0px;
        padding-bottom: 0px;
        margin-bottom: 0px;
    }

    .padding-top-5{
        padding-top: 4px;
    }

    .row.equal-height {
        display: flex;
        flex-wrap: wrap;
    }
    .row.equal-height > [class*='col-'] {
        display: flex;
        flex-direction: column;
    }
    .row.equal-height.row:after,
    .row.equal-height.row:before {
        display: flex;
    }

    .row.equal-height > [class*='col-'] > .thumbnail,
    .row.equal-height > [class*='col-'] > .thumbnail > .caption {
        display: flex;
        flex: 1 0 auto;
        flex-direction: column;
    }
    .row.equal-height > [class*='col-'] > .thumbnail > .caption > .flex-text {
        flex-grow: 1;
    }
    .row.equal-height > [class*='col-'] > .thumbnail > img {
        width: 100%;
        height: 200px; /* force image's height */

        /* force image fit inside it's "box" */
        -webkit-object-fit: cover;
           -moz-object-fit: cover;
            -ms-object-fit: cover;
             -o-object-fit: cover;
                object-fit: cover;
    }
</style>


