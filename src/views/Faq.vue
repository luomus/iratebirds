<template>
  <div class="d-flex">
    <h1>{{ $t("faq.title") }}</h1>
    <div class="text-sm spacer-lg align-left">
      <p>
        {{ $t("faq.q1.question") }}<br><br>
        {{ $t("faq.q1.answer") }}
      </p>
      <p>
        {{ $t("faq.q2.question") }}<br><br>
        {{ $t("faq.q2.answer") }}
      </p>
      <p>
        {{ $t("faq.q3.question") }}<br><br>
        {{ $t("faq.q3.answer") }}
      </p>
      <p>
        {{ $t("faq.q4.question") }}<br><br>
        {{ $t("faq.q4.answer") }}
      </p>
    </div>
    <div class="text-xl spacer-lg">
      <a @click="$modal.hide('faq')">{{ $t("what.body4") }}</a>
    </div>
  </div>
</template>
