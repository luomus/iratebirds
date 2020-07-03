const emojis: {[key: string]: string} = {
  \u2139: '2139',
  '\uD83E\uDD70': '1f970',
  '\uD83E\uDD9C': '1f99c',
  '\uD83E\uDD37': '1f937',
  '\uD83D\uDC26': '1f426',
  '\uD83E\uDD85': '1f426',
  '\uD83D\uDE28': '1f628',
  '\uD83D\uDE0D': '1f60d',
  '\uD83E\uDD7A': '1f97a',
  '\uD83D\uDE4F': '1f64f',
  '\uD83D\uDC95': '1f495'
}

const emojiRegExp = new RegExp(Object.keys(emojis).join('|'), 'ug')

export default class EmojiFormatter {
  interpolate (message: string) {
    return [message.replace(
      emojiRegExp,
      (match) => `<img class="emoji" draggable="false" alt="${match}" src="https://twemoji.maxcdn.com/v/latest/svg/${emojis[match]}.svg">`
    )]
  }
}
