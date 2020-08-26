<template>
  <div class="d-flex text-monospace">
    <div class="text-sm spacer-lg">
      <h1>{{ $t("what.title") }}</h1>
      <div class="text-long-form">
        <p v-html="$t('what.body1')"></p>
        <p v-html="$t('what.body2')"></p>
        <p v-html="$t('what.body3')"></p>
        <div class="spacer-md"></div>
        <hr>
        <div class="align-center spacer-lg">
          <img class="luomus" alt="Finnish Muesum of Natural History" src="/luomus-logo-white-en.png">
        </div>
        <hr>
        <div class="spacer-md"></div>
        <h3 class="spacer-sm">{{ $t("what.body4") }}</h3>
        <p>{{ $t("what.body5") }}<a href="https://laji.fi/en/about/848">{{ $t("what.body6") }}</a>{{ $t("what.body7") }}</p>
      </div>
    </div>
    <div class="text-xl spacer-lg">
      <router-link :to="'../' + $i18n.locale + '/go'">{{ $t("what.body8") }}</router-link>
    </div>
    <span class="spacer-lg"></span>
  </div>
</template>

<script>
export default {
  created () {
    localStorage.seenWhat = this.$i18n.locale
  }
}
</script>
