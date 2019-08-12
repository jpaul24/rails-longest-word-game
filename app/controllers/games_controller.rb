require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = alphabet.sample(10)
  end

  def score
    if session[:score].nil?
      session[:score] = 0
    end
    @word = params[:word].upcase
    @letters = params[:collected_input]
    if english?
      if in_grid?(@word, @letters)
        @result = "Congratulations, #{@word} is a valid English word."
        session[:score] += @word.length
        @score = session[:score]
      else
        @result = "Sorry #{@word} is not a word in #{@letters}, try again"
      end
    else
      @result = "Sorry #{@word} is not an English word"
    end
  end

  def english?
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    attempt_check = open(url).read
    check_answer = JSON.parse(attempt_check)
    check_answer['found']
  end

  def in_grid?(attempt, letters)
    attempt.upcase.chars.all? do |letter|
      attempt.upcase.chars.count(letter) <= letters.count(letter)
    end
  end
end
