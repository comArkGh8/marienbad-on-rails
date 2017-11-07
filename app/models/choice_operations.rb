# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module ChoiceOperations
  
  # assumes not lost yet (i.e. board is not 1000)
  
  def best_choice 
    
    sorted_map=sort_by_increasing_sticks
    sorted_array = sorted_map.values


    if row_of_sticks.values==[1,3,5,7]
      random_row = rand(4)+1
      total_sticks = 1+2*(random_row -1)
      random_sticks = rand(total_sticks)+1

      return [random_row,random_sticks]
    end

    number_of_rows = RowOperations.number_of_non_zero_rows(sorted_array)
    max_row = get_order_at("row",number_of_rows)

    if LosingSituations.stick_array_is_loser?(sorted_array)
      return [max_row,1]
    end
    
    # check if removing a row produces a loser
    sorted_map.keys.each{|index|
      # get array with index removed
      array_index_removed = sorted_map.select{|k,v| k!=index }.values
      return [index,sorted_map[index]] if 
        LosingSituations.stick_array_is_loser?(array_index_removed)
    }
    
    # else go through case by case of numbers of non-zero rows
    case number_of_rows
      
      when 1 # do number- 1
        one_row = sorted_map.keys[0]
        one_sticks = sorted_map.values[0]
        return [one_row, one_sticks-1]
        
      when 2 # do max - min
        min_sticks = get_order_at("sticks",1)
        return [max_row, sorted_map[max_row]-min_sticks]
        
      when 3 # check case by case according to first two in array
        first_two_in_stick_array = sorted_array[0,2]
        max_sticks = get_order_at("sticks",3)
        
        case first_two_in_stick_array
          when [1,1] then return [max_row, max_sticks -1]
            
          when [1,2] then return [max_row, max_sticks -3] if max_sticks>3
            
          when [1,3] then return [max_row, max_sticks -2]
            
          when [1,4] then return [max_row, max_sticks -5]
            
          when [1,5] then return [max_row, max_sticks -4]
            
          when [2,3] then return [max_row, max_sticks -1]
            
        end
        
      when 4
        # check for double rows and change to min min k k
        if has_repeated_row?
          # first get other rows
          other_rows = [1,2,3,4] - two_same
          # get sorted map, select by other rows
          sorted_others = sorted_map.select{|k,v| other_rows.include? k }
          min_others = sorted_others.values[0]
          max_others = sorted_others.values[1]
          max_row_others = sorted_others.keys[1]
          return [max_row_others, max_others-min_others]
        end
      
    end
    
    # rest are point cases 
    min_row = get_order_at("row",1)
    mid_row = get_order_at("row",2)
    
    case sorted_array
      when [2,4,5] then return [min_row, 1]
        
      when [2,4,7] then return [max_row, 1]
        
      when [2,5,6] then return [mid_row, 1]
        
      when [3,4,5] then return [min_row, 2]
        
      when [3,4,6] then return [min_row, 1]
        
      when [3,5,7] then return [min_row, 1]
        
      when [1,3,4,7] then return [max_row, 1]
        
    end
    
    return [max_row,1]
  end

end
