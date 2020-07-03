interface Rating {
  iratebirds_userId: string;
  iratebirds_rating: number;
  iratebirds_lang: string;
  [key: string]: any;
}

const API_BASE = process.env.API_BASE || 'https://api.iratebirds.app'

class RatingService {
  private next: object | undefined;

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
    this.fetchNext()
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

  private fetchPicture (): Promise<object> {
    return fetch(`${API_BASE}/taxon`)
      .then(res => res.json())
      .then(res => res[0])
      .then(code => fetch(`https://proxy.laji.fi/macaulaylibrary/api/v1/search?taxonCode=${code}&mediaType=p&sort=rating_rank_desc&count=1`))
      .then(res => res.json())
      .then(res => res.results.count === 0 ? this.fetchPicture() : res)
      .then(res => res.results.content[0])
  }
}

export default new RatingService()
