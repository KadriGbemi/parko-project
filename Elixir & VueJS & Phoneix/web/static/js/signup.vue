<template>
 
<div class="row">
<div class="well col-sm-offset-3 col-sm-6">
        <div class="imgstyle">
            <img src="/images/loginimage.png" alt="Login" class="imagestyle">   
         </div>

<h3>Signup here</h3>
<div>
  <div class="form-group">
    <label for="username">Username:</label>
    <input type="text" class="form-control" placeholder="Enter Username" id="username" v-model="username">
  </div>
   <div class="form-group">
    <label for="username">Email:</label>
    <input type="text" class="form-control" placeholder="Enter Email" id="email" v-model="email">
  </div>
  <div class="form-group">
    <label for="password">Password:</label>
    <input type="password" class="form-control" placeholder="Enter Password" id="password" v-model="password">
  </div>
  <!-- <div class="form-group">
    <label for="password"> Repeat Password:</label>
    <input type="text" class="form-control" placeholder="Enter Password again" id="password" v-model="passwordone">
  </div>-->
  <div class="clearfix">
  <button type="submit" class="btn btn-default" v-on:click="signup">Signup</button>
  <a href="#/"> <button type="submit"> Cancel </button></a>
  </div>
  
</div>
</div>
</div>

</template>

<script>
import axios from "axios";
export default {
    data: function () {
        return {
            username: "",
            password: "",
            email: ""
        }
    },
    methods: {
        signup: function() {
             axios.post("/api/users", {username: this.username, email: this.email, password:this.password})
      .then(response => {
          this.$router.push({path: '/'});
      })
      .catch(error => {
        console.log(error);
      });
    },

            // this.$alert.show({message: 'Clicked the button!' })(redirect)
        
           // redirect = context.$router.push({path: '/app'});      
    }
}


</script>