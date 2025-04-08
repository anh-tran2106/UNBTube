var app = new Vue({
  el: "#app",
  delimiters: ["[[", "]]"], // Change delimiters to avoid Jinja conflict

  //------- data --------
  data: {
    serviceURL: "https://cs3103.cs.unb.ca:8026",
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
        console.log("Fetched videos:", response.data);
        this.videos = response.data; // Assuming API returns { videos: [...] }
      })
      .catch(e => {
        console.log("Error fetching videos:", e);
      });
    },
    searchVideos(){
      axios
      .get(this.serviceURL + "/search?s=" + this.input.searchTerm)
      .then(response => {
        console.log("Fetched videos:", response.data);
        this.videos = null;
        this.videos = response.data;
        this.$nextTick(() => {
          const videos = this.$refs.videoPlayers;
          if (Array.isArray(videos)) {
            videos.forEach(video => {
              if (video && typeof video.load === 'function') {
                video.load();
              }
            });
          } else if (videoElements && typeof videoElements.load === 'function') {
            videos.load();
          }
        });
      })
      .catch(e =>{
        console.log("Error fetching videos:", e);
      });
    }
  },

  // Fetch videos when the component is created
  created() {
    this.getVideos();
  }
});