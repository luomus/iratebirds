<template>
  <div class="locale-changer text-monospace">
    <select v-model="locale">
      <option v-for="(lang, i) in langs" :key="`Lang${i}`" :value="lang">{{ langMap[lang] || lang }}</option>
    </select>
  </div>
</template>

<script>
import { UtilityService } from '@/service/utility.service'

const langMap = {
  ar: 'Arabic',
  de: 'German',
  en: 'English',
  es: 'Spanish',
  fi: 'Finnish',
  fr: 'French',
  hu: 'Hungarian',
  it: 'Italian',
  ja: 'Japanese',
  kn: 'Kannada',
  mr: 'Marathi',
  nl: 'Dutch',
  'pt-BR': 'Portuguese (Brazil)',
  'pt-PT': 'Portuguese (Portugal)',
  ru: 'Russian',
  sv: 'Swedish',
  sw: 'Swahili',
  zh: 'Chinese'
}

export default {
  name: 'LangSelect',
  data () {
    return {
      langs: Object.keys(this.$i18n.messages),
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
      }
    }
  }
}
</script>
