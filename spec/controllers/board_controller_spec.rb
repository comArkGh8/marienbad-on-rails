

require 'rails_helper'

describe BoardController do
  describe 'human chooses sticks' do
    before(:each) do
      @board = create(:board)
      @board_id = @board.id
      @board_hash = {1=>@board[:row_one], 2=> @board[:row_two], 3=>@board[:row_three],
        4=>@board[:row_four]
      }
      @board.stub(:row_of_sticks).and_return(@board_hash)
    end
    
    it 'should call Board.change' do

      Board.stub(:initialize).with(@board_hash).and_return(@board)
      
      changed_board = create(:board, :row_one => 0)
      changed_hash = {1=>changed_board[:row_one], 2=> changed_board[:row_two],
        3=>changed_board[:row_three], 4=>changed_board[:row_four]
      }
      changed_board.stub(:row_of_sticks).and_return(changed_hash)
      
      Board.stub(:change).with(@board,1,1).and_return(changed_board)
      
      expect(Board).to receive(:change).with(@board,1,1)
      get :human, params: {board_id: @board_id, 
        sticks_chosen: {'sticks_chosen_11' => 1} }

    end
    
    it 'should assign board to the initial board' do

      get :human, params: {board_id: @board_id, 
        sticks_chosen: {'sticks_chosen_11' => 1} }
      new_id = @board_id +1

      expect(assigns(:board)).to eql(@board)
      expect(response).to redirect_to(board_url(id: new_id, turn: 2))
    end
    
    it 'should not allow choice of sticks from different rows' do
      get :human, params: {board_id: @board_id, 
        sticks_chosen: {'sticks_chosen_11' => 1, 'sticks_chosen_21' => 2} }
      expect(response).to redirect_to(human_board_index_url(board_id: @board_id))
    end
    
    
  end
  
 end
