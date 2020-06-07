var what_page = new Vue({
  el: '#what_page',
  data: {
    "what_page": {
      "title": Array(1).fill(""),
      "body": Array(4).fill("")
    }
  },
  created: function () {
    fetch("../content/en.json")
      .then(r => r.json())
      .then(content => {
        this.what_page = content.what_page;
      });
  }
});
