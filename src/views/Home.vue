<template>
  <div>
    <div class="text-xl text-monospace spacer-lg">
      <div>
        <p>
          <span v-html="$t('landing.line1')"></span><br>
          <span v-html="$t('landing.line2')"></span><br>
          <span v-html="$t('landing.line3')"></span>
        </p>
        <span v-html="$t('landing.line4')"></span>
      </div>
      <div>
        <router-link :to="to" v-html="$t('landing.line5')"></router-link>
      </div>
    </div>
    <div class="d-flex flex-row spacer-lg">
      <div class="fill-space"></div>
      <div class="large-logo"><img class="emoji" draggable="false" alt="🌍" src="https://twemoji.maxcdn.com/v/latest/svg/1f30d.svg"></div>
      <LangSelect v-on:change="langChange"></LangSelect>
      <div class="fill-space"></div>
    </div>
  </div>
</template>

<script>
import LangSelect from '@/components/LangSelect'

export default {
  components: { LangSelect },
  data () {
    return {
      to: ''
    }
  },
  mounted () {
    this.langChange()
  },
  methods: {
    langChange () {
      if (this.$i18n.locale === 'ar') {
        document.querySelector('body').classList.add('rtl')
      } else {
        document.querySelector('body').classList.remove('rtl')
      }
      this.to = localStorage.seenWhat === this.$i18n.locale ? this.$i18n.locale + '/go' : this.$i18n.locale + '/what'
    }
  }
}
</script>
