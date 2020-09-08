<template>
  <div class="d-flex text-monospace">
    <h1 class="spacer-sm">{{ $t("faq.title") }}</h1>
    <div class="text-sm spacer-lg align-left">
      <p class="question">{{ $t("what.title") }}</p>
      <p class="answer" v-html="$t('what.body1')"></p>
      <p class="answer" v-html="$t('what.body2')"></p>
      <p class="question">{{ $t("faq.q1.question") }}</p>
      <p class="answer">{{ $t("faq.q1.answer") }}</p>
      <p class="question">{{ $t("faq.q2.question") }}</p>
      <p class="answer">{{ $t("faq.q2.answer") }}</p>
      <p class="question">{{ $t("faq.q3.question") }}</p>
      <p class="answer">{{ $t("faq.q3.answer") }}</p>
      <p class="question">{{ $t("faq.q4.question") }}</p>
      <p class="answer">{{ $t("faq.q4.answer") }}</p>
      <p class="question">{{ $t("what.body4") }}</p>
      <p class="answer">{{ $t("what.body5") }}<a href="https://laji.fi/en/about/848">{{ $t("what.body6") }}</a>{{ $t("what.body7") }}</p>
    </div>
    <div class="text-xl spacer-lg">
      <a @click="$modal.hide('faq')">{{ $t("about.return") }}</a>
    </div>
    <span class="spacer-lg"></span>
  </div>
</template>

<script>
export default {
  created () {
    const unregisterRouterGuard = this.$router.beforeEach((to, from, next) => {
      this.$modal.hide('faq')

      next(false)
    })

    this.$once('hook:destroyed', () => {
      unregisterRouterGuard()
    })
  }
}
</script>
