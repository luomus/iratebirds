var go = new Vue({
  el: '#go',
  data: {
    "go": {
      "title": Array(1).fill(""),
      "labels": Array(2).fill(""),
      "this_bird": Array(1).fill(""),
      "new_bird": Array(1).fill("")
    },
    "rating": 0,
    "photo": {
      "url": "https://test.cdn.download.ams.birds.cornell.edu/api/v1/asset/165879411/640",
      "sp_url": "https://ebird.org/species/comros",
      "sp_common_name": "Common Rosefinch",
      "sp_scientific_name": "Carpodacus erythrinus",
      "copyright_holder": "Will Morris",
      "location": "Uusimaa, Finland",
      "datetime": "2019-06-26T08:56:00",
      "display_date": "26 Jun 2019",
      "asset_url": "https://macaulaylibrary.org/asset/165879411",
      "asset_name": "ML165879411",
      "checklist_url": "https://ebird.org/view/checklist/S57701827",
      "checklist_name": "S57701827"
    }
  },
  created: function () {
    fetch("../content/en.json")
      .then(r => r.json())
      .then(content => {
        this.go = content.go;
      });
  }
});
