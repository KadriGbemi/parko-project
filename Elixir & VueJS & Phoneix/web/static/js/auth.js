import axios from "axios";

export default {
  user: { role: "", username: "" }, 
  login: function (context, creds, redirect) {
    console.log(`Username ${creds.username}, password ${creds.password}`);
    axios.post("/api/loginsession", creds)
      .then(response => {
        this.user.username = creds.username;
        this.user.role = response.data.role;
        window.localStorage.setItem('token-'+this.user.username, response.data.token);
        window.localStorage.setItem('username', this.user.username);
        console.log(window.localStorage.getItem('username'));
        if (redirect)
          context.$router.push({path: '/app'});
      })
      .catch(error => {
        console.log(error);
      });
    },
    logout: function(context, options) {
      console.log(options)
      axios.delete("/api/loginsession/1", options)
        .then(response => {
          console.log(this.user.username)
          window.localStorage.removeItem('token-'+this.username);
          window.localStorage.removeItem('username');
          this.user.username = "";
          this.user.role ="";
         context.$router.push({path: '/login'});
        }).catch(error => {
          console.log(error)
        });
    },
    authenticated: function() {
      this.username = this.getUsername();
      const jwt = window.localStorage.getItem('token-'+this.username);
      return !!jwt;
    },
    getUsername: function(){
      const username = window.localStorage.getItem('username');
      if (username){
        this.user.username = username;
      }
      return username || '';
    },
    getAuthHeader: function() {
      return {
        'Authorization': window.localStorage.getItem('token-'+this.username)
       }
      //return 'Bearer ' + window.localStorage.getItem('token'+this.username)
    }
}