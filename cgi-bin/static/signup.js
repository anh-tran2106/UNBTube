var app = new Vue({
    el: "#app",
  
    //------- data --------
    data: {
      serviceURL: "https://cs3103.cs.unb.ca:8026",
      input: {
        username: "",
        email:"",
        password: ""
      }
    },
    methods: {
      signup() {
        if (this.input.username != "" && this.input.email != "" && this.input.password != "") {
          axios
          .post(this.serviceURL+"/signup", {
              "username": this.input.username,
              "email":this.input.email,
              "password": this.input.password
          })
          .then(response => {
              if (response.data.status == "success") {
                alert("Account created successfully");
                window.location.href = "/"; // Redirect back to login page
              }
          })
          .catch(e => {
              alert("There was an error in the sign-up process, please try again");
              this.input.password = "";
              console.log(e);
          });
        } else {
          alert("A username, email and password must be present");
        }
      },
    }
    //------- END methods --------
  
  });
  