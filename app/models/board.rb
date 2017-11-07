

class Board < ActiveRecord::Base
  
  #include Operation modules
  require_relative "row_operations"
  require_relative "losing_situations"
  require_relative "choice_operations"
  include RowOperations
  include LosingSituations
  include ChoiceOperations
  
  attr_accessor :row_of_sticks
  attr_accessor :two_same
  
  
  #make a board with input as a
  #given hash map or the startup board
  def self.initialize(initial_board=nil)
    new_board=Board.new
    initial_board.nil? ? new_board.row_of_sticks = {1 => 1, 2=>3, 3=>5, 4=>7}: 
      new_board.row_of_sticks = initial_board
      new_board.two_same = Array.new
      return new_board
  end
  
  
  def self.change(game_board,row,sticks)
    sticks_map = game_board.row_of_sticks
    
    orig_sticks = sticks_map[row.to_i] 
    
    # now create new list of rows with updated sticks
    sticks_map[row.to_i] = orig_sticks-sticks
    return initialize(sticks_map)
    
  end
  

  
end
