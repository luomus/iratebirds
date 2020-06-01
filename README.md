# iratebirds

A web app to gauge the "attractiveness" of birds.

# Requirements

* `git`
* `docker`
* `docker-compose`

## Install
```
git clone https://github.com/luomus/iratebirds.git
```

## Run
To run the app on [http://localhost](http://localhost) 
```
cd iratebirds
HOST=localhost PGUSER=user PGPASSWORD=password docker-compose up -d --scale taxon=5
```
