# ijudgebirds

A web app to gauge the "attractiveness" of birds.

# Requirements

* `git`
* `docker`
* `docker-compose`

## Install
```
git clone https://github.com/luomus/ijudgebirds.git
```

## Run
To run the app on [http://localhost](http://localhost) 
```
cd ijudgebirds
HOST=localhost PGUSER=user PGPASSWORD=password docker-compose up -d --scale taxon=5
```
