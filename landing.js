var landing_page = new Vue({
  el: '#landing_page',
  data: {
    "landing_page": {
      "title": Array(5).fill("")
    }
  },
  created: function () {
    fetch("content/en.json")
      .then(r => r.json())
      .then(content => {
        this.landing_page = content.landing_page;
      });
  }
});
