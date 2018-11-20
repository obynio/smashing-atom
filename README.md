# Atom

[![DroneCI](https://drone.obyn.io/api/badges/obynio/atom/status.svg)](https://drone.obyn.io/obynio/atom)

> My daily-life dashboard

**Atom** is my personal dashboard running on a Raspberry Pi. The codebase is based on the [smashing](https://github.com/Smashing/smashing) modular dashboard with custom widgets on top of it.

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

## Installation

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

