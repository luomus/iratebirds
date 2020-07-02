<template>
  <div>
    <div class="text-xl">
      <div class="spacer-lg">
        <p>
          <span v-html="$t('landing.line1')"></span><br>
          <span v-html="$t('landing.line2')"></span><br>
          <span v-html="$t('landing.line3')"></span>
        </p>
        <span v-html="$t('landing.line4')"></span>
      </div>
      <div class="spacer-lg">
        <router-link :to="nextPage()" v-html="$t('landing.line5')"></router-link>
      </div>
    </div>
    <div class="d-flex flex-row spacer-lg">
      <div class="fill-space"></div>
      <div>{{ $t("lang") }}</div>
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
      return this.$i18n.locale + '/what'
    }
  }
}
</script>
