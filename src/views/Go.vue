<template>
  <div class="justify-content-center">
    <ShareNetwork
      network="facebook"
      url="https://news.vuejs.org/issues/180"
      title="Say hi to Vite! A brand new, extremely fast development setup for Vue."
      description="This week, I’d like to introduce you to 'Vite', which means 'Fast'. It’s a brand new development setup created by Evan You."
      quote="The hot reload is so fast it\'s near instant. - Evan You"
      hashtags="vuejs,vite"
    >
      Share on Facebook
    </ShareNetwork>
    <div class="d-flex flex-row spacer-sm">
      <h1 class="text-bold text-monospace" v-html="$t('go.title')"></h1>
      <div class="fill-space"></div>
      <div class="about-links">
        <a @click="showAbout()" v-html="$t('about.icon')"></a>
        <a @click="showFaq()">{{ $t("faq.title") }}</a>
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
        <heart-rating :max-rating="10" :show-rating="false" :item-size="heartSize" inactive-color="#3d3333"
                      active-color="#dc2c44" border-color="#dc2c44" v-model="rating" @></heart-rating>
      </div>
      <div class="text-bold text-monospace d-flex justify-content-center font-weight-bolder">
        <p v-show="rating === 0"> {{ $t("go.this_bird") }} </p>
        <p v-show="rating > 0"><a class="new-bird-link" href="#" @click="next">{{ $t("go.new_bird") }}</a></p>
      </div>
    </div>
  </div>
</template>

<script>
import { HeartRating } from 'vue-rate-it'
import { ShareNetwork } from 'vue-social-sharing'
import Photo from '../components/Photo.vue'
import RatingService from '@/service/rating.service'

let seen = 0
const showQuestioner = Math.floor(Math.random() * 6) + 5

export default {
  name: 'Go',
  components: {
    Photo,
    HeartRating,
    ShareNetwork
  },
  data () {
    return {
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
      if (seen === showQuestioner) {
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
