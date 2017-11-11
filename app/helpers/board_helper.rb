
module BoardHelper
  
  # puts player turn into a map
  # pass the player which is chosen on index page
  def player_turn_map(player)
    case player
      when 'human' 
        return {0 => 'computer', 1 => 'human'}
      when 'computer'
        return {0 => 'human', 1 => 'computer'}
    end
  end
  
end
