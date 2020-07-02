export class UtilityService {
  public static getBrowserDefaultLang () {
    const navigatorLocale = navigator.languages !== undefined
      ? navigator.languages[0]
      : navigator.language
    return navigatorLocale ? navigatorLocale.trim().split(/[-_]/)[0] : ''
  }
}
