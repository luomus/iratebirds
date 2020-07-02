<template>
  <div class="d-flex">
    <div class="text-sm spacer-lg">
      <h1>{{ $t("what.title") }}</h1>
      <p v-html="$t('what.body1')"></p>
      <p v-html="$t('what.body2')"></p>
      <p v-html="$t('what.body3')"></p>
    </div>
    <div class="text-xl spacer-lg">
      <router-link :to="'../' + $i18n.locale + '/go'">{{ $t("what.body4") }}</router-link>
    </div>
  </div>
</template>

<script>
export default {
  created () {
    localStorage.seenWhat = true
  }
}
</script>
