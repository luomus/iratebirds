<template>
  <div class="d-flex">
    <h1>{{ $t("about.title") }}</h1>
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
      <a :href="$t('survey.url')">{{ $t('about.survey_request') }}</a>
    </div>
    <div class="fill-space"></div>
    <div class="text-xl spacer-lg">
      <router-link :to="'../' + $i18n.locale + '/go'">{{ $t("what.body4") }}</router-link>
    </div>
  </div>
</template>
