require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0..9).map { ('A'..'Z').to_a[rand(26)].chr }
  end

  def score
    @word = params[:word].upcase
    letters = params[:letters]

    api_call = URI.open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    check_word = JSON.parse(api_call)

    split = @word.split('')
    @score = 0
    @result = if (split.all? { |letter| letters.include?(letter) }) && (check_word['found'] == true)
                "Congratulations! #{@word} is a valid English word!"
              elsif check_word['found'] == false
                "Sorry but #{@word} does not seem to be a valid English word..."
              else
                "Sorry but #{@word} can't be built out of #{letters.gsub(' ', ', ')}."
              end
    @score = check_word['length']
  end
end
