<template>
  <div class="justify-content-center">
    <div class="d-flex flex-row spacer-sm">
      <h1 class="text-bold text-monospace" v-html="$t('go.title')"></h1>
      <div class="fill-space"></div>
      <div class="about-links">
        <a href="/"><img class="emoji" draggable="false" alt="🏠" src="https://twemoji.maxcdn.com/v/latest/svg/1f3e0.svg"></a>
        <a @click="showAbout()" v-html="$t('about.icon')"></a>
        <a @click="showFaq()">{{ $t("faq.title") }}</a>
      </div>
    </div>
    <div v-if="!error">
      <Photo :photo="photo"></Photo>
      <div class="d-flex justify-content-center">
        <div class="d-flex flex-row text-lg spacer-sm">
          <span v-html="$t('go.labels.hate')"></span>
          <span class="fill-space"></span>
          <span v-html="$t('go.labels.love')"></span>
        </div>
        <div class="d-flex justify-content-center spacer-sm" id="rating">
          <heart-rating :max-rating="10" :show-rating="false" :item-size="heartSize" inactive-color="#3d3333"
                        active-color="#dc2c44" border-color="#dc2c44" v-model="rating" @></heart-rating>
        </div>
        <div class="text-bold text-monospace d-flex justify-content-center font-weight-bolder">
          <p v-show="rating === 0"> {{ $t("go.this_bird") }} </p>
          <p v-show="rating > 0"><a class="new-bird-link" href="#" @click="next">{{ $t("go.new_bird") }}</a></p>
        </div>
      </div>
    </div>
    <div v-if="error" class="d-flex flex-column spacer-sm">
      <img src="/photo-library-down.png">
      <div class="error-message">
        {{ $t("go.system_down") }}
      </div>
    </div>
  </div>
</template>

<script>
import { HeartRating } from 'vue-rate-it'
import Photo from '../components/Photo.vue'
import RatingService from '@/service/rating.service'

let seen = 0
const showQuestionnaire = Math.floor(Math.random() * 10) + 10

export default {
  name: 'Go',
  components: {
    Photo,
    HeartRating
  },
  data () {
    return {
      error: false,
      rating: 0,
      photo: null,
      heartSize: 10
    }
  },
  methods: {
    showFaq () {
      this.$modal.show('faq')
    },
    showAbout () {
      this.$modal.show('about')
    },
    next () {
      seen++

      if (!localStorage.user) {
        const s = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
        localStorage.user = Array(32).fill('').map(() => s.charAt(Math.floor(Math.random() * s.length))).join('')
      }
      if (seen === showQuestionnaire) {
        this.$modal.show('questionnaire')
      }
      if (this.rating > 0) {
        RatingService.rate({
          ...this.photo,
          /* eslint-disable @typescript-eslint/camelcase */
          iratebirds_lang: this.$i18n.locale,
          iratebirds_rating: this.rating,
          iratebirds_userId: localStorage.user
          /* eslint-enable @typescript-eslint/camelcase */
        })
      }
      RatingService.getNextPhoto()
        .then(photo => {
          this.error = false
          this.photo = photo
          this.rating = 0
        })
        .catch(() => {
          this.error = true
        })
    },
    calculateHeartSize () {
      const el = document.querySelector('#rating')
      this.heartSize = (el.getBoundingClientRect().width - 50) / 10
    }
  },
  created () {
    if (!localStorage.seenWhat) {
      this.$router.push(`/${this.$i18n.locale}`)
    }
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
