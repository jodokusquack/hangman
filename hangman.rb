#! /usr/bin/env ruby

# require all files under the lib directory
Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }

game = Game.new
game.play

