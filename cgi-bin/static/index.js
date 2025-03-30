var app = new Vue({
    el: "#app",
  
    //------- data --------
    data: {
      serviceURL: "https://cs3103.cs.unb.ca:8026",
      authenticated: false,
      loggedIn: null,
      input: {
        username: "",
        password: ""
      }
    },
    methods: {
      logout() {
        axios
        .delete(this.serviceURL+"/logout")
        .then(response => {
            location.reload();
        })
        .catch(e => {
          console.log(e);
        });
      },
    }
    //------- END methods --------
  
  });
  