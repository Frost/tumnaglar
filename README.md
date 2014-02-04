# Tumnaglar

This is a tiny Sinatra app that is used to create thumbnails in custom sizes.

## Requirements

* Ruby >2.0
* ImageMagick

## Installation

    bundle install

## Configuration

Create a `config.yml` similar to the content of `config.yml.sample`:

* `image_url_path` (where your images live)
* `datastore_path` (where to store your images locally)
* `cache` vars - config for `Rack::Cache`

## Run

Run like any rack application, i.e. `bundle exec rerun rackup` in development.

## Routes

* `/:filename` - Get the file from the remote server and cache it locally
* `/:filename/:size` - Get the file and resize it using ImageMagick

