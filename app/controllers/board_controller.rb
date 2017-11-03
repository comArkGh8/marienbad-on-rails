
class BoardController < ApplicationController
  
  def index
    number_of_boards = Board.all.size
    @board = Board.where("turn = '#{number_of_boards}'")
    
  end
  
end
