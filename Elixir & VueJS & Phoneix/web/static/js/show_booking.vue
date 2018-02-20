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
      <h1>{{sec}}</h1>
      <div class="appBox" id="pomoApp" >
        <div class="timer"> {{msg}} 
          <div v-bind:class= "extendClass">
            <div class="form-group col-sm-12">
              <label class="control-label  col-sm-3" for="end_time">Do you want to extend? </label>
              <div class="col-sm-2">
                <input type="number"  min = "1" max = "24" class="form-control" id="end_time" v-model="extend_time" >
              </div>
              <div class="col-sm-2">
                <button class="btn btn-default" id = "extend" v-on:click="extendParking()">Extend</button>
              </div>
              <br/>
              <div class="stopwatch">Usage: <span>{{hour}}</span> : <span>{{min}}</span>  <span v-bind:class= "secClass">{{sec}}</span> </div>
            </div>      
          </div>  
        </div>
      </div>
      <div class="timer-ctrl">
        <button type="button" class="btn btn-danger" v-on:click="endParking()" v-bind:class= "endClass" >End</button>
      </div> 
      <div v-if="showMessage">
      <div class="modal-mask2">
        <div class="modal-wrapper2">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" @click="showMessage=false">
                  <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">{{title}}</h4>
              </div>
              <div class="modal-body" v-html="message">
              </div>
              <div><button  v-if="payment_id" type="button" class="btn btn-default btn-sm"><router-link :to="{name: 'show_payment', params: {data: {payment_id: payment_id, payment_info: payment_info}}}">show invoice</router-link></button></div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default" @click="showMessage=false">OK</button>
              </div>  
            </div>
          </div>
        </div>
      </div>		
      <br/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import auth from "./auth";

export default {
    data: function() {
      return {
      booking_id: this.$route.params.data.booking_id,
      hour: "",
      min: "",
      sec: "",
      finished: false,
      endClass: "hidden",
      msg: "",
      extend_time: "",
      extendClass: "hidden",
      payment_method: null,
      secClass: "shown",
      showMessage: false,
      title: "",
      message: "",
      payment_id: "",
      payment_info: "",
       username: {}
  
      }
    },
    methods: {
      loadData: function () {
     //    this.username = auth.getUsername();
        let that = this;
        axios.post("/api/parking_elapse", {booking_id: this.booking_id},{headers: auth.getAuthHeader()})
        .then(function (response) { 
          this.payment_method = response['data']['payment'];
          var h = response['data']['elapse_h'];
          var m = response['data']['elapse_m'];
          var s = response['data']['elapse_s'];

          //console.log( response['data']['payment']);
          if(h < 10)
          {
            h = `0${h}`;
          } 
          if(m < 10)
          {
            m = `0${m}`;
          }
          if(s < 10)
          {
            s = `0${s}`;
          }
          that.hour = h;
          that.min = m;
          that.sec = s;
          var msg = response['data']['msg'];
          that.msg = msg;
          that.finished = response['data']['finished'];
          console.log(response['data']);
          console.log(that.payment_method);
          if(that.payment_method == "HOURLY") {
            if((!that.finished) && (that.extendClass == "hidden" || that.secClass == "hidden")) {
              console.log("1");
              that.extendClass = "shown";
              that.secClass = "shown";
            } else if(that.finished) {
              console.log("2");
              that.extendClass = "hidden";
            }
            console.log(response['data']['released']);
            if(response['data']['notify']) {
              AUDIO.play();
            }
          } else {
            console.log(that.finished);
            console.log(that.endClass);
            if((!that.finished)) {
              that.endClass = "shown";
              that.secClass = "shown";
            }
          }
          
          console.log(that.sec);

        }.bind(this))
        .catch(function (error) {
  
        }); 
      },

      logout: function () {
      auth.logout(this, {headers: auth.getAuthHeader()})
      this.username = auth.getUsername();
      },
      
      extendParking: function()
      {
        var end = this.extend_time*60

        axios.post("/api/parking_extend", {booking_id: this.booking_id, end:end}, {headers: auth.getAuthHeader()})
        .then(function (response) { 
          this.showMessage = true;
          this.title = "Confirmation";
          this.message = response['data']['msg'];
          if(response['data']['payment_id'] != "") 
          {
            this.payment_info = response['data']['payment_info'];
            this.payment_id = response['data']['payment_id'];
            this.message = this.message +  "<br> And payment has been made!  <a href=\"/payments/" + response['data']['payment_id'] +"\" > view invoice </a>";
          }
          
        }.bind(this))
        .catch(function (error) {
  
        }); 
      },
      endParking: function(){
        axios.post("/api/parking_finish", {booking_id: this.booking_id}, {headers: auth.getAuthHeader()})
        .then(function (response) { 
          var msg = response['data']['msg'];
          this.msg = msg;
          this.finished = true;
          this.endClass = "hidden";
          this.secClass = "hidden";

          this.showMessage = true;
          this.title = "Confirmation";
          this.message = response['data']['msg'];
          if(response['data']['payment_id'] != "") 
          {
            this.message = this.message +  "<br> And payment has been made!  <a href=\"/payments/" + response['data']['payment_id'] +"\" > view invoice </a>";
          }
          
        }.bind(this))
        .catch(function (error) {
  
        }); 
      }, 
    },

    mounted: function () {
      this.username = auth.getUsername();
      if(!this.$route.params.data.booking_id)
      {
        console.log(this.$route.params.data.booking_id);
        window.location = "/";
      }
      this.loadData();
      //console.log(this.payment_method)
     
      setInterval(function () {
        if(!this.finished)
        {
          this.loadData();
        }
        
      }.bind(this), 1000); 
    }
}
</script>

<style>

</style>