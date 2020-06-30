<template>
  <div class="justify-content-center">
    <h1 class="font-weight-bolder text-monospace">{{ $t("go.title") }}</h1>
    <Photo :photo="photo"></Photo>
    <div class="d-flex justify-content-center">
      <div class="d-flex flex-row text-lg spacer-sm">
        <span>{{ $t("go.labels.hate") }}</span>
        <span class="fill-space"></span>
        <span>{{ $t("go.labels.love") }}</span>
      </div>
      <div class="d-flex justify-content-center spacer-sm" id="rating">
        <heart-rating :max-rating="10" :show-rating="false" :item-size="heartSize" inactive-color="#ffffff"
                      active-color="#dc2c44" border-color="#dc2c44" v-model="rating" @></heart-rating>
      </div>
      <div class="d-flex justify-content-center">
        <p class="text-monospace" v-show="rating < 1"> {{ $t("go.this_bird") }} </p>
        <p class="text-monospace" v-show="rating > 1"><a href="#" @click="next">{{ $t("go.new_bird") }}</a></p>
      </div>
    </div>
  </div>
</template>

<script>
import Photo from '../components/Photo.vue'
import { HeartRating } from 'vue-rate-it'

export default {
  name: 'Go',
  components: {
    Photo,
    HeartRating
  },
  data: function () {
    return {
      rating: 0,
      photo: null,
      heartSize: 10
    }
  },
  methods: {
    next: function () {
      fetch('https://api.iratebirds.app/taxon')
        .then(res => res.json())
        .then(res => res[0])
        .then(code => fetch(`https://proxy.laji.fi/macaulaylibrary/api/v1/search?taxonCode=${code}&mediaType=p&sort=rating_rank_desc&count=1`))
        .then(res => res.json())
        .then(res => res.results.content[0])
        .then(photo => {
          this.photo = photo
          this.rating = 0
        })
    },
    calculateHeartSize: function () {
      const el = document.querySelector('#rating')
      this.heartSize = (el.getBoundingClientRect().width - 50) / 10
    }
  },
  created: function () {
    this.next()
  },
  mounted: function () {
    window.addEventListener('resize', this.calculateHeartSize)
    this.calculateHeartSize()
  },
  beforeDestroy: function () {
    window.removeEventListener('resize', this.calculateHeartSize)
  }
}
</script>
