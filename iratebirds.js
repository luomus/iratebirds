var landing_page = new Vue({
  el: '#landing_page',
  data: {
    title: ["", "", "", "", ""]
  },
  created: function () {
    fetch("content/en.json")
      .then(r => r.json())
      .then(content => {
        this.title=content.landing_page.title;
      });
  }
});
