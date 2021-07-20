# Smashing Atom
> My daily-life dashboard

**Atom** is my personal dashboard running on a Raspberry Pi. The codebase is based on the [smashing](https://github.com/Smashing/smashing) modular dashboard with custom widgets build on top of it.

![atom-dashboard](https://user-images.githubusercontent.com/2095991/49383546-4776a100-f719-11e8-8803-b036705a175c.png)

## Features

* synchonized timetable for my school
* current time and date
* network latency
* current ethereum price
* current bitcoin price
* nearby bus and metro schedules
* current weather in paris, requires an openweathermap api key
* air pollution index and map
* xkcd daily comic
* epiquote.fr
* world clock
* currated news from bbc

## Deployment

```
# Adapt the `docker-compose` to fit your needs
$ docker-compose build
$ docker-compose up -d
```

## Development

```
# Install bundler
$ gem install bundler
# Install smashing
$ gem install smashing
# Install the bundle of atom specific gems
$ bundle
# Start atom
$ smashing start
```
