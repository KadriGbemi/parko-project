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
<div class="container-fluid">
            <div class="row" v-if="payments">
                <div v-if="payments.length > 0" class="col-xs-12">
                    <div  class="col-12 col-sm-12 col-lg-12">
                        <h2 style="padding-left:5px">Your payments</h2>
                        <table class="table table-responsive table-condensed" style="border-collapse: collapse;" cellspacing="0" width="auto">
                            <thead>
                                <tr style="background-color:#fa4b2a;">
                                    <th>Parking</th>
                                    <th>Start time</th>
                                    <th>Duration</th>
                                    <th>Billed on</th>
                                    <th>Payment Duedate</th>
                                    <th>Payment Method</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class = "available_park" v-for ="(item, index) in payments" style="background-color:white">
                                    <td>{{item.park_address}}</td>
                                    <td>{{item.start_time}}</td>
                                    <td>{{item.end_time - item.start_time}}</td>
                                    <td>{{item.payment_date}}</td>
                                    <td>{{item.due_date}}</td>
                                    <td>{{item.payment_method}}</td>
                                    <td> <button  type="button" class="btn btn-default btn-sm"><router-link :to="{name: 'show_payment', params: {data: {payment_id: item.payment_id, payment_info: item}}}">Show</router-link></button></td>
                                    <!-- <td><button type="button" class="btn btn-default btn-sm" v-on:click="focusAndHighlight(index)">On map</button></td>

                                        <td v-if="user_name"><button type="button" class="btn btn-default btn-sm" v-on:click="submitBookingRequest(index, 'HOURLY')">Pay hourly</button></td>
                                        <td v-if="user_name"><button type="button" class="btn btn-default btn-sm" v-on:click="submitBookingRequest(index, 'REALTIME')">Pay realtime</button></td>

                                    <div v-else>
                                       
                                   </div> -->
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
</div>
</div>

</template>
<script>
import axios from 'axios';
import auth from "./auth";

export default {
    data: function () {
        return {
         payments: null,
          username: {}
        }
    },
    methods: {
        logout: function () {
                auth.logout(this, {headers: auth.getAuthHeader()})
                 this.username = auth.getUsername();
            }
    },
    mounted: function(){
     
        console.log("MOUNTED"); 
                axios.post("/api/list_payments",{headers: auth.getAuthHeader()})
                        .then(function (response) {
                         this.payments = response['data']['payments']; 
                         console.log(response['data']['payments']); 
                        }.bind(this))
                        .catch(function (error) {

                        });
    }

}
</script>


