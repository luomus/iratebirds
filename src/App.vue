<template>
  <div>
    <div id="app">
      <router-view/>
    </div>

    <modal name="faq" height="auto" classes="modal" :max-width="500" :scrollable="true" :adaptive="true">
      <Faq></Faq>
    </modal>
    <modal name="about" height="auto" classes="modal" :max-width="500" :scrollable="true" :adaptive="true">
      <About></About>
    </modal>
    <modal name="questionnaire" height="auto" classes="modal" :max-width="500" :scrollable="true" :adaptive="true">
      <Questionnaire></Questionnaire>
    </modal>
  </div>
</template>

<script>
import Faq from './views/Faq.vue'
import About from './views/About.vue'
import Questionnaire from './views/Questionnaire.vue'

export default {
  components: { Faq, About, Questionnaire }
}
</script>

<style lang="scss">
@import "@/main";
</style>
