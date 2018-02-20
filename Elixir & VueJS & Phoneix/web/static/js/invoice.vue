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
    <div class="invoice-box">
        <table cellpadding="0" cellspacing="0">
            <tr class="top">
                <td colspan="3">
                    <table>
                        <tr>
                            <td class="title">
                                <img src='/images/logo.png' style="width:100%; max-width:300px;">
                            </td>
                            
                            <td>
                                Invoice #: {{ payment.id }} <br>
                                Created: {{ payment.payment_date }} <br>
                                Due: {{ payment.due_date }}
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            
            <tr class="information">
                <td colspan="12">
                    <table>
                        <tr>
                            <td>
                                Sparksuite, Inc.<br>
                                12345 Sunny Road<br>
                                Sunnyville, CA 12345
                            </td>
                            
                            <td>
                                Acme Corp.<br>
                                John Doe<br>
                                john@example.com
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr class="heading">
                <td> Parking adress</td>
                
                <td>
                    duration
                </td>
                
                <td>
                    payment method
                </td>

                <td>
                    amount
                </td>

            </tr>
            
            <tr class="item">
                <td>
                    <!-- Parking Address -->
                </td>
                
                <td>
                    {{ payment.end_time }} -  {{ payment.start_time }} minutes
                </td>
                <td>
                    <!-- Payment Method  -->
                </td>
                
                <td>
                    {{ payment.amount }} euro
                </td>                
            </tr>
            

            
            <tr class="total">
                <td></td><td></td><td></td>
                
                <td>
                   {{ payment.amount }} euro
                </td>
            </tr>
        </table>
    </div>
</div>
</template>

<script>
import axios from 'axios';
import auth from "./auth";
export default {
    data: function() {
        return {
            payment: {},
            username: {}
        }
        },
        methods: {
            logout: function () {
                auth.logout(this, {headers: auth.getAuthHeader()})
                 this.username = auth.getUsername();
            }
    },
      mounted: function () {
        this.username = auth.getUsername();
    }
    }
</script>

<style>

</style>