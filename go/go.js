var go = new Vue({
  el: '#go',
  data: {
    "go": {
      "title": Array(1).fill(""),
      "labels": Array(2).fill(""),
      "this_bird": Array(1).fill(""),
      "new_bird": Array(1).fill("")
    },
    "code": null,
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
    },
    "candidates": null
  },
  created: function () {
    fetch("../content/en.json")
      .then(content => content.json())
      .then(content => {
        this.go = content.go;
      });
    fetch("https://api.iratebirds.app/taxon")
      .then(res => res.json())
      .then(res => {
        this.code = res[0];
      });
  },
  methods: {
    rated() {
      this.rating = 0;
      fetch("https://search.macaulaylibrary.org/api/v1/search?taxonCode=comros&mediaType=p&sort=rating_rank_desc&count=20")
        .then(query => query.json())
        .then(query => {
          this.candidates = query.results.content;
        });
    }
  }
});
