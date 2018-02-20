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
      <ul class="nav navbar-nav">
        <li class="active"><a href="#">Park Me </a></li>
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

<div class="row">
<div class="well col-sm-offset-3 col-sm-6">
        <div class="imgstyle">
            <img src="/images/loginimage.png" alt="Login" class="imagestyle">   
         </div>

<h3>Log in to get the best</h3>
<div>
  <div class="form-group">
    <label for="username">Username:</label>
    <input type="text" class="form-control" placeholder="Enter Username" id="username" v-model="username">
  </div>
  <div class="form-group">
    <label for="password">Password:</label>
    <input type="password" class="form-control" placeholder="Enter Password" id="password" v-model="password">
  </div>
  <!--<button type="submit" class="btn btn-default" @click="showAlert">Submit</button>-->
   <div class="clearfix">
      <a href="#/signup"> <button class="signupbtn"> Signup </button></a>
      <button class="loginbtn" v-on:click="login">Log in</button>
    </div>
</div>
</div>
</div>
</div>

</template>
<script>
import auth from "./auth";

export default {
    data: function () {
        return {
            username: "",
            password: ""
        }
    },
    methods: {
        login: function() {
            // this.$alert.show({message: 'Clicked the button!' })
            console.log(`Username ${this.username}, password ${this.password}`);
            auth.login(this, {username: this.username, password: this.password}, "/");
        }

        
    }
}
</script>


