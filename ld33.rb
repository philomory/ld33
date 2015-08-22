#!/usr/bin/env ruby

require 'bundler/setup'

Bundler.require(:default)

APP_ROOT = File.dirname(__FILE__)
SOURCE_ROOT = File.join(APP_ROOT,'src')
MEDIA_ROOT = File.join(APP_ROOT,'media')

require_all File.join(File.dirname(__FILE__),'src')

Game.play!