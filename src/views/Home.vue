<template>
  <div>
    <div class="text-xl">
      <div class="spacer-lg">
        <p>
          {{ $t("landing.line1") }}<br>
          {{ $t("landing.line2") }}<br>
          {{ $t("landing.line3") }}
        </p>
        {{ $t("landing.line4") }}<br>
      </div>
      <div class="spacer-lg">
        <router-link :to="nextPage()">{{ $t("landing.line5") }}</router-link>
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
