<template>
  <div class="justify-content-center">
    <div class="d-flex flex-row">
      <h1 class="font-weight-bolder text-monospace" v-html="$t('go.title')"></h1>
      <div class="fill-space"></div>
      <div class="about-links">
        <router-link :to="'../' + $i18n.locale + '/about'" v-html="$t('about.icon')"></router-link>
        <router-link :to="'../' + $i18n.locale + '/faq'">{{ $t("faq.title") }}</router-link>
      </div>
    </div>
    <Photo :photo="photo"></Photo>
    <div class="d-flex justify-content-center">
      <div class="d-flex flex-row text-lg spacer-sm">
        <span v-html="$t('go.labels.hate')"></span>
        <span class="fill-space"></span>
        <span v-html="$t('go.labels.love')"></span>
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
import RatingService from '@/service/rating.service'
import { HeartRating } from 'vue-rate-it'

export default {
  name: 'Go',
  components: {
    Photo,
    HeartRating
  },
  data () {
    return {
      rating: 0,
      photo: null,
      heartSize: 10
    }
  },
  methods: {
    next () {
      RatingService.getNextPhoto()
        .then(photo => {
          this.photo = photo
          this.rating = 0
        })
    },
    calculateHeartSize () {
      const el = document.querySelector('#rating')
      this.heartSize = (el.getBoundingClientRect().width - 50) / 10
    }
  },
  created () {
    this.next()
  },
  mounted () {
    window.addEventListener('resize', this.calculateHeartSize)
    this.calculateHeartSize()
  },
  beforeDestroy () {
    window.removeEventListener('resize', this.calculateHeartSize)
  }
}
</script>
