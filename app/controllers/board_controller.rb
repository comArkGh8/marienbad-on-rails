
class BoardController < ApplicationController
  
  # shows current board
  def index
    number_of_boards = Board.all.size
    @board = Board.where(turn: number_of_boards).first
  end
  
end
