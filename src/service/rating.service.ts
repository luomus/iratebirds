import TAXA from '../assets/taxa.json'

interface Rating {
  iratebirds_userId: string;
  iratebirds_rating: number;
  iratebirds_lang: string;
  [key: string]: any;
}

const API_BASE = process.env.API_BASE || 'https://api.iratebirds.app'
const PICTURE_API = process.env.PICTURE_API || 'https://proxy.laji.fi/macaulaylibrary/api/v1/search?taxonCode=%code%&mediaType=p&clientapp=BAR&sort=rating_rank_desc&count=5'

class RatingService {
  private next: object | undefined

  constructor () {
    this.prepareNextPhoto()
  }

  rate (rating: Rating): Promise<Response> {
    return fetch(`${API_BASE}/submit`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify([
        'sex', 'catalogId', 'age', 'location', 'userId', 'latitude',
        'longitude', 'rating', 'userDisplayName', 'sciName', 'speciesCode',
        'eBirdChecklistId', 'obsDttm', 'ratingCount', 'width', 'height',
        'commonName', 'source', 'iratebirds_userId', 'iratebirds_rating',
        'iratebirds_lang'
      ].reduce((obj, key) => {
        if (typeof rating[key] !== 'undefined' && rating[key] !== null) {
          obj[key] = rating[key]
        }
        return obj
      }, {} as Rating))
    })
  }

  getNextPhoto (): Promise<object> {
    if (this.next) {
      const result = new Promise<object>((resolve) => resolve(this.next))
      this.prepareNextPhoto()
      return result
    }
    this.prepareNextPhoto()
    return this.fetchPicture()
  }

  private prepareNextPhoto (): void {
    this.next = undefined
    this.fetchPicture()
      .then(photo => {
        this.next = photo
        if ('previewUrl' in photo) {
          const image = new Image()
          image.src = (photo as any).previewUrl
        }
      })
  }

  private fetchPicture (retry = 0): Promise<object> {
    if (retry > 3) {
      return new Promise<object>((resolve, reject) => { reject(new Error('Could not fetch image')) })
    }
    const code = TAXA[Math.floor(Math.random() * TAXA.length)]
    return fetch(PICTURE_API.replace('%code%', code))
      .then(res => res.json())
      .then(res => {
        const imgIdx = Math.floor(Math.random() * Math.min(5, res.results.count))
        if (res.results.count === 0 || !res.results?.content?.[imgIdx]) {
          return this.fetchPicture(retry + 1)
        }
        return res.results.content[imgIdx]
      })
      .catch(() => {
        const retryNumber = retry + 1
        return new Promise(resolve => setTimeout(() => resolve(), retryNumber * 300))
          .then(() => this.fetchPicture(retryNumber))
      })
  }
}

export default new RatingService()
