var app = new Vue({
  el: "#app",

  //------- data --------
  data: {
    serviceURL: "https://cs3103.cs.unb.ca:8027",
    authenticated: false,
    loggedIn: null,
    videos: [], // Store fetched videos
    input: {
      username: "",
      password: ""
    }
  },

  methods: {
    logout() {
      axios
      .delete(this.serviceURL + "/logout")
      .then(response => {
          location.reload();
      })
      .catch(e => {
        console.log(e);
      });
    },

    // Fetch all videos from the /video endpoint
    getVideos() {
      axios
      .get(this.serviceURL + "/videos")
      .then(response => {
        this.videos = response.data.videos; // Assuming API returns { videos: [...] }
      })
      .catch(e => {
        console.log("Error fetching videos:", e);
      });
    }
  },

  // Fetch videos when the component is created
  created() {
    this.getVideos();
  }
});