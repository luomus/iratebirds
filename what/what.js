var what = new Vue({
  el: '#what',
  data: {
    "what": {
      "title": Array(1).fill(""),
      "body": Array(4).fill("")
    }
  },
  created: function () {
    fetch("../content/en.json")
      .then(r => r.json())
      .then(content => {
        this.what = content.what;
      });
  }
});
