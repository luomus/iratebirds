<template>
  <div class="text-xl">
    <span>
      {{ $t("landing.line1") }}<br>
      {{ $t("landing.line2") }}<br>
      {{ $t("landing.line3") }}
    </span>
    <span>
      {{ $t("landing.line4") }}<br>
      <router-link :to="nextPage()">{{ $t("landing.line5") }}</router-link>
    </span>
    <span>
      <LangSelect></LangSelect>
    </span>
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
