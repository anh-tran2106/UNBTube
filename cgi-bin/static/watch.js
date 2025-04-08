var app = new Vue({
    el: "#app",
    delimiters: ["[[", "]]"],
    data: {
      serviceURL: "https://cs3103.cs.unb.ca:8026",
      video: null,
      vidID: null
    },
    methods: {
      fetchVideo() {
        axios.get(this.serviceURL + "/video?v=" + this.vidID)
          .then(response => {
            console.log(response.data);
            this.video = response.data;
            console.log(this.video);
          })
          .catch(error => {
            console.error("Error loading video", error);
          });
      },
      likeVideo() {
        // Replace with actual API call if available
        //this.video.likes++;
      },
      dislikeVideo() {
        // Placeholder
        //this.video.likes = Math.max(0, this.video.likes - 1);
      },
      getQueryParam(name) {
        const url = new URL(window.location.href);
        return url.searchParams.get(name);
      }
    },
    created() {
      this.vidID = this.getQueryParam("v");
      this.fetchVideo();
      sleep(1000);
      console.log(this.vidID);
      console.log(this.video);
    }
    //------- END methods --------
  });