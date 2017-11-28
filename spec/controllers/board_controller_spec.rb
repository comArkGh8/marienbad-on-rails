

require 'rails_helper'

describe BoardController do
  describe 'Take one stick from row one' do
    it 'should call Board.change' do
      board = create(:board)
      board_id = board.id
      board_hash = {1=>board[:row_one], 2=> board[:row_two], 3=>board[:row_three],
        4=>board[:row_four]
      }
      board.stub(:row_of_sticks).and_return(board_hash)
      expect(Board).to receive(:change).with(board,1,1)
      board_intialized = board
      changed_board = create(:board, :row_one => 0)
      changed_hash = {1=>changed_board[:row_one], 2=> changed_board[:row_two],
        3=>changed_board[:row_three], 4=>changed_board[:row_four]
      }
      changed_board.stub(:row_of_sticks).and_return(changed_hash)
      

      Board.stub(:initialize).with(board_hash).and_return(board_intialized)
      Board.stub(:change).with(board,1,1).and_return(changed_board)
      get :human, params: {board_id: board_id, 
        sticks_chosen: {'sticks_chosen_11' => 1} }
      
      new_id = board_id +2
      puts new_id
      expect(assigns(:board)).to eql(board)
      expect(response).to redirect_to(board_url(id: new_id, turn: 2))
    end


  end

 
end
