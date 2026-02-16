class GamesController < ApplicationController
  def new
    @letters = []
    until @letters.any?(/[AEIOU]/)
      @letters = []
      10.times do |i|
        @letters << ("A".."Z").to_a.sample(1)[0]
      end
    end
    if session[:score].nil?
      session[:score] = 0
    end
  end

  def score
    require "json"
    require "open-uri"
    @letters = params[:letters].split(",")
    @guess = params[:guess].strip.upcase
    @score = session[:score]
    @url = "https://dictionary.lewagon.com/#{@guess}"
    @valid = @guess.chars.all? do |letter|
      @guess.chars.count(letter) <= @letters.count(letter)
    end
  end
end
