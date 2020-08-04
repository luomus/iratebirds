<template>
  <div class="d-flex text-monospace">
    <h1 class = "spacer-sm">{{ $t("faq.title") }}</h1>
    <div class="text-sm spacer-lg align-left">
      <p class="question">{{ $t("faq.q1.question") }}</p>
      <p class="answer">{{ $t("faq.q1.answer") }}</p>
      <p class="question">{{ $t("faq.q2.question") }}</p>
      <p class="answer">{{ $t("faq.q2.answer") }}</p>
      <p class="question">{{ $t("faq.q3.question") }}</p>
      <p class="answer">{{ $t("faq.q3.answer") }}</p>
      <p class="question">{{ $t("faq.q4.question") }}</p>
      <p class="answer">{{ $t("faq.q4.answer") }}</p>
    </div>
    <div class="text-xl spacer-lg">
      <a @click="$modal.hide('faq')">{{ $t("about.return") }}</a>
    </div>
  </div>
</template>
