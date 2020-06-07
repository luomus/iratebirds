var landing = new Vue({
  el: '#landing',
  data: {
    "landing": {
      "title": Array(5).fill("")
    }
  },
  created: function () {
    fetch("content/en.json")
      .then(r => r.json())
      .then(content => {
        this.landing = content.landing;
      });
  }
});
