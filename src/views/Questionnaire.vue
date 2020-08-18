<template>
  <div class="d-flex text-monospace">
    <h1 class="spacer-lg">
      <span v-html="$t('survey.title.char1')"></span>
      <span v-html="$t('survey.title.char2')"></span>
      <span v-html="$t('survey.title.char3')"></span>
    </h1>
    <div class="spacer-lg align-center">
      <p>{{ $t("survey.request") }}</p>
      <div class="spacer-lg">
         <a class="spacer-lg" :href="surveyUrl()" target="_blank" @click="$modal.hide('questionnaire')">{{ $t("survey.confirm") }}</a>
         <a class="spacer-lg" @click="$modal.hide('questionnaire')">{{ $t("survey.cancel") }}</a>
      </div>
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
