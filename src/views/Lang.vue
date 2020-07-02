<template>
  <router-view />
</template>

<script>
export default {
  created () {
    const lang = this.$route.params.lang
    this.$i18n.locale = this.$i18n.messages[lang] ? lang : this.$i18n.fallbackLocale
  }
}
</script>
