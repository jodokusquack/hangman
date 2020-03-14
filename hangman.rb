#! /usr/bin/env ruby

begin
  # this game requires the colorize gem
  require 'colorize'
rescue LoadError
  puts "This game works best if you install the 'colorize' gem. Please consider installing it."
end
require 'json'

# require all files under the lib directory
Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }

game = Game.new
game.play

