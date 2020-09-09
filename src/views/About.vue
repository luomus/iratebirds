<template>
  <div class="d-flex text-monospace">
    <h1>{{ $t("about.title") }}</h1>
    <div class="text-sm spacer-lg">
      <a href="mailto:iratebirds@pm.me"><div class="large-logo"><img class="emoji" draggable="false" alt="📧" src="https://twemoji.maxcdn.com/v/latest/svg/1f4e7.svg"></div>iratebirds@pm.me</a>
    </div>
    <hr>
    <div class="align-center spacer-lg">
      <a href="" target="_blank"><img class="laji-logo" alt="laji.fi Finnish Biodiversity Information Facility" src="/laji-logo.png"></a>
    </div>
    <hr>
    <div class="text-sm spacer-lg align-left">
      <p>
        {{ $t("about.body1") }}
      </p>
      <p>
        {{ $t("about.body2") }}
      </p>
      <p>
        {{ $t("about.body3") }}
      </p>
    </div>
    <div class="text-sm spacer-lg">
      <a :href="surveyUrl" target="_blank">{{ $t('about.survey_request') }}</a>
    </div>
    <div class="text-xl spacer-lg">
      <a @click="$modal.hide('about')">{{ $t("about.return") }}</a>
    </div>
    <span class="spacer-lg"></span>
  </div>
</template>

<script>
export default {
  data () {
    return {
      surveyUrl: this.$t('survey.url').replace('%userId%', localStorage.user)
    }
  },
  created () {
    const unregisterRouterGuard = this.$router.beforeEach((to, from, next) => {
      this.$modal.hide('about')

      next(false)
    })

    this.$once('hook:destroyed', () => {
      unregisterRouterGuard()
    })
  }
}
</script>
