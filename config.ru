require 'rubygems'
require 'bundler'
require 'uri'
Bundler.require
require './start'
run Sinatra::Application
