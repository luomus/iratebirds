<template>
  <div class="d-flex">
    <div class="text-sm spacer-lg">
      <h1>{{ $t("what.title") }}</h1>
      <p>{{ $t("what.body1") }}</p>
      <p>{{ $t("what.body2") }}</p>
      <p>{{ $t("what.body3") }}</p>
    </div>
    <div class="text-xl spacer-lg">
      <router-link :to="'../' + $i18n.locale + '/go'">{{ $t("what.body4") }}</router-link>
    </div>
  </div>
</template>
