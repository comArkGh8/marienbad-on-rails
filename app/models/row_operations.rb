# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module RowOperations
  
  require 'set'
  # input will already have zeros removed
  def self.number_of_non_zero_rows(stick_array)
    return stick_array.length
  end
  
  
  # returns copy of row map in ascending order
  # deletes the zero rows
  def sort_by_increasing_sticks
    sorted_map = row_of_sticks.sort_by {|k,v| v}.to_h
    sorted_minus_zeros = sorted_map.select{|k,v| v!=0}
  end
  
  
  # returns (row or sticks) in kth order (from 1-number of non-zero)
  def get_order_at(row_or_sticks,k)
    sorted_map=sort_by_increasing_sticks
    case row_or_sticks
      when "row" then return sorted_map.keys[k-1]
      when "sticks" then return sorted_map.values[k-1]
    end
  end
  
    
  # returns true if there are two repeated rows
  # in addition sets the two rows variable to a pair of rows
  def has_repeated_row?
    counts = Hash.new(0)
    # convert hash to array
    # go through each; count occurrence 
    row_of_sticks.to_a.each{|e|
      counts[e[1]] +=1 unless e[1]==0
    }
    array_of_pairs=row_of_sticks.select{|k,v| counts[v]>=2}.sort_by {|k,v| v}

    # if array_of_pairs not empty return true
    # if map_of_pairs not empty return true
    if array_of_pairs.empty?
        return false
      else
        two_same[0] = array_of_pairs[0][0]
        two_same[1] = array_of_pairs[1][0]
        return true
      end
    array_of_pairs.empty? ? (return false) : (return true)
    
  end
  
  # just gives true or false when applied to the stick array
  def self.array_has_repeated_row?(array)
    array.to_set.length<array.length ?  true : false
  end
 
    
end
