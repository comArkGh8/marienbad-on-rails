

Given /the following boards:/ do |board_table|
  board_table.hashes.each do |board|
    Board.create!(board)
  end
end


# now copy needed from web_steps...