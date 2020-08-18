<template>
  <div class="locale-changer text-monospace">
    <v-select :value="locale" :clearable="false" :searchable="false" v-model="locale" :options="options" :reduce="country => country.value" label="label"></v-select>
  </div>
</template>

<style type="text/scss">
.locale-changer .vs__dropdown-menu,
.locale-changer .vs__dropdown-toggle {
  width: 16rem;
  background: #e3e3e3;
}

.locale-changer .vs__dropdown-menu {
  background: #fefefe;
}

.locale-changer .vs__open-indicator {
  fill: #161616;
}
</style>

<script>
import { UtilityService } from '@/service/utility.service'

const langMap = {
  ar: 'العربية',
  de: 'Deutsch',
  en: 'English',
  es: 'Español',
  fi: 'suomi',
  fr: 'français',
  hu: 'magyar',
  it: 'Italiano',
  ja: '日本語',
  kn: 'ಕನ್ನಡ',
  mr: 'मराठी',
  nl: 'Nederlands',
  'pt-BR': 'Português brasileiro',
  'pt-PT': 'Português europeu',
  ru: 'русский',
  sw: 'Kiswahili',
  zh: '中文'
}

export default {
  name: 'LangSelect',
  data () {
    return {
      options: Object.keys(this.$i18n.messages).map(value => ({ value, label: langMap[value] || value })),
      locale: this.$i18n.locale,
      langMap
    }
  },
  mounted () {
    if (localStorage.lang) {
      this.$i18n.locale = localStorage.lang
    } else {
      const lang = UtilityService.getBrowserDefaultLang()
      if (this.$i18n.messages[lang]) {
        this.$i18n.locale = lang
      }
    }
    this.locale = this.$i18n.locale
  },
  watch: {
    locale (newLocale) {
      if (newLocale) {
        this.$i18n.locale = newLocale
        localStorage.lang = newLocale
        this.$emit('change')
      }
    }
  }
}
</script>
