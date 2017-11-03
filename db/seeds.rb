# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Seed the Board DB with the initial Marienbad Board.
initial_board = [
  {:turn => 0, :row_one => 1, :row_two => 3,
    :row_three => 5, :row_four => 7}
]

Board.create!(initial_board)
