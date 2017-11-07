
class BoardController < ApplicationController
  
  def board_params
    params.require(:board).permit(:sticks_chosen)
  end
  
  # shows current board
  def index
    number_of_boards = Board.all.size
    puts number_of_boards
    @board = Board.where(turn: number_of_boards).first
    @board_sticks_hash = {1=> @board[:row_one], 2=> @board[:row_two], 
      3=> @board[:row_three], 4 => @board[:row_four]}
    # this will count the rows in the view
    @row_num = 0
 
    # get the sticks which were checked 
    # :sticks_chosen is a params passed
    # TODO: add safety that only one row can be chosen
    if params[:sticks_chosen].nil?
      @sticks_to_remove = [1,0]
    else 
      @sticks_to_remove = params[:sticks_chosen]
    
    
      # produce updated board:
      # get array of row, sticks
      @row = params[:sticks_chosen].values.first
      @num_sticks = params[:sticks_chosen].keys.size


      # initialize a board then use change fcn
      
      @marienbad_board = Board.initialize(@board_sticks_hash)
      @new_marienbad_board=Board.change(@marienbad_board,@row,@num_sticks)

      # add turn, then add to db
      @next_turn = @board[:turn]+1
      @new_board = [
        {:turn => @next_turn, :row_one => @new_marienbad_board.row_of_sticks[1],
          :row_two => @new_marienbad_board.row_of_sticks[2],
          :row_three => @new_marienbad_board.row_of_sticks[3],
          :row_four => @new_marienbad_board.row_of_sticks[4]}
      ]

      Board.create!(@new_board)
      number_of_boards+=1
      @board = Board.where(turn: number_of_boards).first
    end
    
  end
  
end
