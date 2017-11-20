

Given /the following boards:/ do |board_table|
  board_table.hashes.each do |board|
    Board.create!(board)
  end
  @id = Board.where(turn: 1).first[:id]
  @board = Board.where(turn: 1).first
end

Given /^it is turn '(.+)'$/ do |player|
  visit path_to('board_page', @id, player)
end



# for clicking on submit, refresh etc.
When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

# for checking boxes
# from human.html.haml file, the check_box_tag id is "ratings_#{rating}"
# I check 1 stick from row_two
When /^(?:|I )check ([0-9]*) sticks? from ([^"]*)$/ do |sticks, row|
  row_sym = row.to_s
  (1..sticks.to_i).each do |i|
    check("sticks_chosen_#{row_sym}#{i}")
  end
end

When /^I check all the boxes in ([^"]*)$/ do |row|
  row_sym = row.to_s
  orig_number = @board[row_sym]
  (1..orig_number).each do |i|
    check("sticks_chosen_#{row_sym}#{i}")
  end
end

# Then calculate the number of boxes in each row
Then /^row two should have one less stick$/ do 
  # expect value of row 2 should be one(x two) less
  num_updated_row = 0
  all('input[type=checkbox]').each do |box|
    num_updated_row +=1 if box[:value]=='2'
  end
  expect(num_updated_row).to eq 2
end

Then /^row ([^"]*) should have ([0-9]*) sticks$/ do |row_num,stick_num|
  # expect value of row 2 should be one(x two) less
  num_updated_row = 0
  all('input[type=checkbox]').each do |box|
    num_updated_row +=1 if box[:value]==row_num
  end
  expect(num_updated_row).to eq stick_num.to_i
end