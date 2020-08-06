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
  </div>
</template>

<script>
import Faq from './views/Faq.vue'
import About from './views/About.vue'
export default {
  components: { Faq, About }
}
</script>

<style lang="scss">
@import "@/main";
</style>
