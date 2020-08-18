<template>
  <div class="d-flex text-monospace">
    <h1>{{ $t("about.title") }}</h1>
    <div class="text-sm spacer-lg">
      <a href="mailto:iratebirds@pm.me"><div class="large-logo"><img class="emoji" draggable="false" alt="📧" src="https://twemoji.maxcdn.com/v/latest/svg/1f4e7.svg"></div>iratebirds@pm.me</a>
    </div>
    <hr class="rule">
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
      <a :href="surveyUrl()">{{ $t('about.survey_request') }}</a>
    </div>
    <div class="text-xl spacer-lg">
      <a @click="$modal.hide('about')">{{ $t("about.return") }}</a>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    surveyUrl () {
      if (localStorage.seenWhat) {
        return this.$t('survey.url').replace('%userId%', localStorage.user)
      }
    }
  }
}
</script>
