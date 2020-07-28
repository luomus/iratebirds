<template>
  <div>
    <div class="text-xl spacer-lg">
      <div>
        <p class="text-monospace">
          <span v-html="$t('landing.line1')"></span><br>
          <span v-html="$t('landing.line2')"></span><br>
          <span v-html="$t('landing.line3')"></span>
        </p>
        <span v-html="$t('landing.line4')"></span>
      </div>
      <div>
        <router-link :to="nextPage()" v-html="$t('landing.line5')"></router-link>
      </div>
    </div>
    <div class="d-flex flex-row spacer-lg">
      <div class="fill-space"></div>
      <div class="lang-logo"><img class="emoji" draggable="false" alt="🌍" src="https://twemoji.maxcdn.com/v/latest/svg/1f30d.svg"></div>
      <LangSelect></LangSelect>
      <div class="fill-space"></div>
    </div>
  </div>
</template>

<script>
import LangSelect from '@/components/LangSelect'

export default {
  components: { LangSelect },
  methods: {
    nextPage () {
      if (localStorage.seenWhat) {
        return this.$i18n.locale + '/go'
      }
      return this.$i18n.locale + '/what'
    }
  }
}
</script>
