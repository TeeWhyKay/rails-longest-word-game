# frozen_string_literal: true

require 'open-uri'

# GamesController has methods for a new game and to score a guess
class GamesController < ApplicationController
  def new
    alpha_arr = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << alpha_arr.sample }
  end

  def score
    @score = 0
    @word = params[:word]
    @letters = params[:letters]
    # check that every letter in your word appears in the grid
    # (remember you can only use each letter once).
    # binding.pry
    @within_grid = within_grid?(@letters.split(//), @word.split(//))

    # check if it's a valid word using lewagon dictionary api
    @valid = check_valid?(@word)
  end

  private

  # input letters array, word array
  def within_grid?(letters_arr, word_arr)
    word_arr.each do |letter|
      found_index = letters_arr.find_index(letter)
      return false if found_index.nil?

      puts "deleted #{letters_arr[found_index]}"
      letters_arr.delete_at(found_index)
    end
    true
  end

  def check_valid?(word)
    word_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read
    word = JSON.parse(word_serialized)
    word['found']
  end
end
