
class BoardController < ApplicationController
  include BoardHelper
  
  def board_params
    params.require(:board).permit(:user_id, :board_id, :sticks_chosen, :turn, :player1)
  end
  
  # shows current board
  def index
    # first get assigned user_ids
    @user_id ||= Board.maximum(:user_id) +1
    @init_user_board = [
      {:user_id => @user_id, :turn => 1, :row_one => 1,
        :row_two => 3,
        :row_three => 5,
        :row_four => 7}
    ]
    Board.create!(@init_user_board)
    @board = Board.where(user_id: @user_id).first
    
    @turn = @board[:turn]
    if params[:player1].nil?
      @player ||= 'computer'
    else
      @player = params[:player1]
      #if submitted redirect to show
      redirect_to board_path(@board, turn: @turn, player1: @player)
    end
    
  end
  
  def instructions
    # default: render 'instructions' template
  end
  
  
  def show
    # this will count the rows in the view
    @row_num = 0
    
    session[:first_player] = params[:player1] unless params[:player1].nil?
    # now get the map of whose turn it will be
    @players_turns = player_turn_map(session[:first_player])
    
    id=params[:id]
    @board=Board.find(id)
    @turn=@board[:turn].to_i
    
    @whose_turn = @players_turns[@turn%2.to_i]
    
    # flash current board status if it's human's turn
    if @whose_turn=='human'
      flash[:notice] = 'The current board now looks like:'
    end
    
    if @whose_turn=='computer'
      redirect_to computer_board_index_path(board_id: id)
    else
      redirect_to human_board_index_path(board_id: id)
    end

  end

  
  
  def human   
    session[:id] = params[:board_id] unless params[:board_id].nil?
    @id=session[:id]
    @board=Board.find(@id)
    @user_id = @board[:user_id]
    @board_sticks_hash = {1=> @board[:row_one], 2=> @board[:row_two], 
      3=> @board[:row_three], 4 => @board[:row_four]}
    @marienbad_board = Board.initialize(@board_sticks_hash)
    @human_lose = LosingSituations.game_over?(@board_sticks_hash.values)

    
    # add turn, to be used to update game later
    @current_turn=@board[:turn]
    @next_turn = @current_turn+1
        
    # this will count the rows in the view
    @row_num = 0

    
    # get the sticks which were checked 
    # :sticks_chosen is a params passed
    unless params[:sticks_chosen].nil?
      # check if more than one row is chosen
      if params[:sticks_chosen].values.to_set.size > 1
        flash[:notice] = "You can't choose sticks from different rows.
          try again."
        redirect_to human_board_index_path(board_id: @id)
      else
        @sticks_to_remove = params[:sticks_chosen]
        # get array of row, sticks
        @row = params[:sticks_chosen].values.first.to_i
        @num_sticks = params[:sticks_chosen].keys.size


        # use change fcn to change the board
        @new_marienbad_board=Board.change(@marienbad_board,@row,@num_sticks)

        @new_board = [
          {:user_id => @user_id, :turn => @next_turn,
            :row_one => @new_marienbad_board.row_of_sticks[1],
            :row_two => @new_marienbad_board.row_of_sticks[2],
            :row_three => @new_marienbad_board.row_of_sticks[3],
            :row_four => @new_marienbad_board.row_of_sticks[4]}
        ]

        Board.create!(@new_board)
        new_id=Board.where(user_id: @user_id, turn: @next_turn).first.id
        redirect_to board_path(id: new_id, turn: @next_turn)
      end

    end  
      
  end
  
  
  
  def computer
    session[:id] = params[:board_id] unless params[:board_id].nil?
    id=session[:id]
    @board=Board.find(id)
    @user_id = @board[:user_id]
    puts "computer uid:"
    puts @user_id
    @board_sticks_hash = {1=> @board[:row_one], 2=> @board[:row_two], 
      3=> @board[:row_three], 4 => @board[:row_four]}
    @marienbad_board = Board.initialize(@board_sticks_hash)
    
    @computer_lose = LosingSituations.game_over?(@board_sticks_hash.values)
    
    # this will count the rows in the view
    @row_num = 0
    
    @choice = ChoiceOperations.best_choice(@marienbad_board)
    
    # initializes array
    @bool_check = Array.new(4) { |i| Array.new(7) { |i| false }}

    
    # this gives the checked or not checked property based on choice
    @row_controller=0
    [:row_one, :row_two, :row_three, :row_four].each do |row|
      @row_controller+=1
      (1..@board[row]).each do |i|
        @bool_check[@row_controller-1][i-1] = 
          (@row_controller==@choice[0]&& i <= @choice[1]) ? true : false
      end
    end

    @current_turn=@board[:turn]
    @next_turn = @current_turn+1
    @new_marienbad_board=Board.change(@marienbad_board,@choice[0],@choice[1])

    @new_board = [
      {:user_id => @user_id, :turn => @next_turn,
        :row_one => @new_marienbad_board.row_of_sticks[1],
        :row_two => @new_marienbad_board.row_of_sticks[2],
        :row_three => @new_marienbad_board.row_of_sticks[3],
        :row_four => @new_marienbad_board.row_of_sticks[4]}
    ]

    Board.create!(@new_board)
    @new_id=Board.where(user_id: @user_id, turn: @next_turn).first.id
      
    
    #redirect_to board_path(id: new_id, turn: @next_turn)
  end
  
  def history
    @number_of_turns = params[:turn].to_i
    @user_id = params[:user_id].to_i
    puts 'history uid'
    puts @user_id
    # create board array (entries corresponding to turn)
    @board_array=Array.new
    (1..@number_of_turns).each do |i|
      @board_array[i-1] = Board.where(user_id: @user_id, turn: i).first
    end
    
    # create array of rows (entries corresponding to turn)
    @row_one_array=Array.new
    @row_two_array=Array.new
    @row_three_array=Array.new
    @row_four_array=Array.new
    
    (1..@number_of_turns).each do |i|
      @current_board = @board_array[i-1]
      if @current_board.nil?
        puts i
      end
      @row_one_array[i-1] = @current_board[:row_one]
      @row_two_array[i-1] = @current_board[:row_two]
      @row_three_array[i-1] = @current_board[:row_three]
      @row_four_array[i-1] = @current_board[:row_four]
    end
    
  end
  
  
end
  

