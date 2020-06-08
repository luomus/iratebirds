var go = new Vue({
  el: '#go',
  data: {
    "go": {
      "title": Array(1).fill(""),
      "labels": Array(2).fill(""),
      "this_bird": Array(1).fill(""),
      "new_bird": Array(1).fill("")
    },
    "rating": 0
  },
  created: function () {
    fetch("../content/en.json")
      .then(r => r.json())
      .then(content => {
        this.go = content.go;
      });
  }
});
