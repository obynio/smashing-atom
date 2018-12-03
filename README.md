# Atom

[![DroneCI](https://drone.obyn.io/api/badges/obynio/atom/status.svg)](https://drone.obyn.io/obynio/atom)

> My daily-life dashboard

**Atom** is my personal dashboard running on a Raspberry Pi. The codebase is based on the [smashing](https://github.com/Smashing/smashing) modular dashboard with custom widgets on top of it.

![atom-dashboard](https://user-images.githubusercontent.com/2095991/49384040-72152980-f71a-11e8-86bf-d25b29b54f52.png)

## Features

* synchonized timetable for my school
* current time and date
* network latency
* current ethereum price
* nearby bus and metro schedules
* current weather in paris
* air pollution index and map
* xkcd daily comic
* epiquote.fr
* world clock
* fitbit activity tracking

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
