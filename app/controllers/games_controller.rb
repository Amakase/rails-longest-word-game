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
    letters = params[:letters].split(",")
    guess = params[:guess].strip.upcase
    @score = session[:score]
    url = "https://dictionary.lewagon.com/#{guess}"
    valid = guess.chars.all? do |letter|
      guess.chars.count(letter) <= letters.count(letter)
    end
    if !valid
      @message = { start: "Sorry but ", strong: guess, end: " can't be built out of #{letters.join(", ")}. Your score has been reset." }
      session[:score] = 0
    elsif JSON.parse(URI.parse(url).read)["found"]
      @message = { start: "", strong: "Congratulations! ", end: "#{guess} is a valid English word!" }
      session[:score] += guess.length
    else
      @message = { start: "Sorry but ", strong: guess, end: " does not seem to be a valid English word... Your score has been reset." }
      session[:score] = 0
    end
  end
end
