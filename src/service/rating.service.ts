interface Rating {
  iratebirds_userId: string;
  iratebirds_rating: number;
  iratebirds_lang: string;
  [key: string]: any;
}

class RatingService {
  private next: object | undefined;

  constructor () {
    this.fetchNext()
  }

  rate (rating: Rating) {
    // TODO send rating to server
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
      })
  }

  private fetchPicture (): Promise<object> {
    return fetch('https://api.iratebirds.app/taxon')
      .then(res => res.json())
      .then(res => res[0])
      .then(code => fetch(`https://proxy.laji.fi/macaulaylibrary/api/v1/search?taxonCode=${code}&mediaType=p&sort=rating_rank_desc&count=1`))
      .then(res => res.json())
      .then(res => res.results.count === 0 ? this.fetchPicture() : res)
      .then(res => res.results.content[0])
  }
}

export default new RatingService()
