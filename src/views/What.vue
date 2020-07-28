<template>
  <div class="d-flex text-monospace">
    <div class="text-sm spacer-lg">
      <h1>{{ $t("what.title") }}</h1>
      <div class="text-long-form">
        <p v-html="$t('what.body1')"></p>
        <p v-html="$t('what.body2')"></p>
        <p v-html="$t('what.body3')"></p>
      </div>
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
