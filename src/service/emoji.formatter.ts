const emojis: {[key: string]: string} = {
  ℹ: '2139',
  '🥰': '1f970',
  '🦜': '1f99c',
  '🤷': '1f937',
  '🐦': '1f426',
  '😨️️': '1f628',
  '😍️️️️': '1f60d',
  '🥺️️️️': '1f97a',
  '🙏️️️️': '1f64f',
  '💕️️️️️': '1f495'
}

const emojiRegExp = new RegExp(Object.keys(emojis).join('|'), 'u')

export default class EmojiFormatter {
  interpolate (message: string) {
    return [message.replace(
      emojiRegExp,
      (match) => `<img class="emoji" draggable="false" alt="${match}" src="https://twemoji.maxcdn.com/v/latest/svg/${emojis[match]}.svg">`
    )]
  }
}
