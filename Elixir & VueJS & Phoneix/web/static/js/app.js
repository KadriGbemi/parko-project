import Vue from "vue";
import VueRouter from "vue-router";
import app from './app.vue';
import login from "./login";
import signup from "./signup";
//import invoice from './invoice';
import show_booking from "./show_booking";
import show_payment from "./show_payment";
import list_bookings from "./list_bookings";
import list_payments from "./list_payments";
import auth from './auth';

import "phoenix";
import "axios";
import "./socket";
import 'vueify/lib/insert-css'

auth.getUsername();

const requireAuth = (to, _from, next) => {
  console.log(auth.authenticated());
  if (!auth.authenticated()) {
    next98({
      path: '/login',
      query: { redirect: to.fullPath }
    });
  } else {
    next();
  }
}

const afterAuth = (_to, from, next) => {
  if (auth.authenticated()) {
    next(from.path);
  } else {
    next();
  }
}


Vue.use(VueRouter);

var router = new VueRouter({
  routes: [
    {path: '/', component: login},
    {path: '/app', component: app, beforeEnter: requireAuth},
    {path: '/login', component: login},
    {path: '/signup', component: signup},
    {path: '/bookings', component: list_bookings, beforeEnter: requireAuth},
    {path: '/payments', component: list_payments, beforeEnter: requireAuth},
    {path: '/show_payment', component: show_payment, beforeEnter: requireAuth},
    {path: '/show_booking', component: show_booking, beforeEnter: requireAuth},
    { name: 'show_booking', path: '/show_booking/:data', component: show_booking, beforeEnter: requireAuth},
    { name: 'show_payment', path: '/show_payment/:data', component: show_payment, beforeEnter: requireAuth},
    {path: '*', redirect: '/app'}
  ]

});

new Vue({
  router
}).$mount('#parko-app')




if(document.getElementById('timer'))
{
  const AUDIO = new Audio('https://www.dropbox.com/s/5d2dy8xr29246l3/KeyChimes.mp3?raw=1');
    
  var bookingId = "";
  if(document.getElementById('booking_id'))
  {
    bookingId = document.getElementById('booking_id').innerHTML;
  }

  new Vue({
    el: '#timer',
    data: {
      hour: "",
      min: "",
      sec: "",
      finished: false,
      endClass: "hidden",
      msg:"",
      booking_id: bookingId,
      extend_time: "",
      extendClass: "hidden",
      payment_method: null,
      secClass: "hidden",
      showMessage: false,
      title:"",
      message:""
    },
    methods: {
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
            this.message = this.message +  "<br> And payment has been made!  <a href=\"/payments/" + response['data']['payment_id'] +"\" > view invoice </a>";
          }
          
        }.bind(this))
        .catch(function (error) {
  
        }); 
      },
      endParking: function(){
        axios.post("/api/parking_finish", {booking_id: this.booking_id},{headers: auth.getAuthHeader()})
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
      loadData: function () {
        axios.post("/api/parking_elapse", {booking_id: this.booking_id},{headers: auth.getAuthHeader()})
        .then(function (response) { 
          this.payment_method = response['data']['payment'];
          var h = response['data']['elapse_h'];
          var m = response['data']['elapse_m'];
          var s = response['data']['elapse_s'];
          console.log( response['data']['payment']);

         
          
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
          this.hour = h;
          this.min = m;
          this.sec = s;
          var msg = response['data']['msg'];
          this.msg = msg;
          this.finished = response['data']['finished'];

          if(this.payment_method == "HOURLY")
          {
            if((!this.finished) && (this.extendClass == "hidden" || this.secClass == "hidden"))
            {
              console.log("1");
              this.extendClass = "shown";
              this.secClass = "shown";
            }
            else if(this.finished)
            {
              console.log("2");
              this.extendClass = "hidden";
            }
            console.log(response['data']['released']);
            if(response['data']['notify'])
            {
              AUDIO.play();
            }
          }
          else
          {
            if((!this.finished) && this.endClass == "hidden")
            {
              this.endClass = "shown";
              this.secClass = "shown";
            }

          }

        }.bind(this))
        .catch(function (error) {
  
        }); 
        
      }
    },
    mounted: function () {
      console.log(this.payment_method)
      this.loadData();
      console.log(this.payment_method)
     
      setInterval(function () {
        if(!this.finished)
        {
          this.loadData();
        }
        
      }.bind(this), 1000); 
    }
  });
  
}