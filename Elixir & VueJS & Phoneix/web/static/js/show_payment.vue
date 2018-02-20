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
                                Invoice #: {{payment_info["invoice_no"]}}<br>
                                Created: {{payment_info["payment_date"]}}<br>
                                Due: {{payment_info["payment_date"]}}
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            
            <tr class="information">
                <td colspan="2">
                    <table>
                        <tr>
                            <td>
                                Parko, Inc.<br>
                                raatuse 22<br>
                                Tartu, 51009, Estonia
                            </td>
                            
                            <td>
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
                    {{payment_info["park_address"]}}
                </td>
                
                <td>
                    {{payment_info["end_time"] - payment_info["start_time"]}} minuits
                </td>
                <td>
                   {{payment_info["payment_method"]}}
                </td>
                
                <td>
                    {{payment_info["amount"]}} euro
                </td>                
            </tr>
            

            
            <tr class="total">
                <td></td><td></td><td></td>
                
                <td>
                   {{payment_info["amount"]}} euro
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
      payment_id: this.$route.params.data.payment_id,
      payment_info: this.$route.params.data.payment_info,
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
      if(!this.$route.params.data.payment_id)
      {
        window.location = "/";
      }
      console.log(this.$route.params.data.payment_id);
      console.log(this.$route.params.data.payment_info["amount"]);
    }
}
</script>

<style>
    .invoice-box {
        max-width: 800px;
        margin: auto;
        padding: 30px;
        border: 1px solid #eee;
        box-shadow: 0 0 10px rgba(0, 0, 0, .15);
        font-size: 14px;
        line-height: 24px;
        font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
        color: #555;
    }
    
    .invoice-box table {
        width: 100%;
        line-height: inherit;
        text-align: left;
    }
    
    .invoice-box table td {
        padding: 5px;
        vertical-align: top;
    }
    
    .invoice-box table tr td:nth-child(2) {
        text-align: right;
    }
    
    .invoice-box table tr.top table td {
        padding-bottom: 20px;
    }
    
    .invoice-box table tr.top table td.title {
        font-size: 30px;
        line-height: 45px;
        color: #333;
    }
    
    .invoice-box table tr.information table td {
        padding-bottom: 40px;
    }
    
    .invoice-box table tr.heading td {
        background: #eee;
        border-bottom: 1px solid #ddd;
        font-weight: bold;
    }
    
    .invoice-box table tr.details td {
        padding-bottom: 20px;
    }
    
    .invoice-box table tr.item td{
        border-bottom: 1px solid #eee;
    }
    
    .invoice-box table tr.item.last td {
        border-bottom: none;
    }
    
    .invoice-box table tr.total td:nth-child(2) {
        border-top: 2px solid #eee;
        font-weight: bold;
    }
    
    @media only screen and (max-width: 600px) {
        .invoice-box table tr.top table td {
            width: 100%;
            display: block;
            text-align: center;
        }
        
        .invoice-box table tr.information table td {
            width: 100%;
            display: block;
            text-align: center;
        }
    }
    
    /** RTL **/
    .rtl {
        direction: rtl;
        font-family: Tahoma, 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
    }
    
    .rtl table {
        text-align: right;
    }
    
    .rtl table tr td:nth-child(2) {
        text-align: left;
    }
</style>