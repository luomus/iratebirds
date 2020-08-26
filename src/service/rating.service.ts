import TAXA from '../assets/taxa.json'

interface Rating {
  iratebirds_userId: string;
  iratebirds_rating: number;
  iratebirds_lang: string;
  [key: string]: any;
}

const API_BASE = process.env.API_BASE || 'https://api.iratebirds.app'

class RatingService {
  private next: object | undefined

  constructor () {
    this.fetchNext()
  }

  rate (rating: Rating) {
    const requestOptions = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(rating)
    }
    fetch(`${API_BASE}/submit`, requestOptions)
  }

  getNextPhoto (): Promise<object> {
    if (this.next) {
      const result = new Promise<object>((resolve) => resolve(this.next))
      this.fetchNext()
      return result
    }
    return this.fetchPicture()
  }

  private fetchNext (): void {
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
    return fetch(`https://proxy.laji.fi/macaulaylibrary/api/v1/search?taxonCode=${code}&mediaType=p&clientapp=BAR&sort=rating_rank_desc&count=1`)
      .then(res => res.json())
      .then(res => res.results.count === 0 || !res.results?.content?.[0] ? this.fetchPicture(retry + 1) : res)
      .then(res => res.results.content[0])
      .catch(() => this.fetchPicture(retry + 1))
  }
}

export default new RatingService()
