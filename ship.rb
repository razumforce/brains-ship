class Ship
	CELL = {1 => 4, 2 => 3, 3 => 2, 4 => 1}

	attr_accessor :overall, :hash

	def initialize
		@overall = []
		@hash = {}
		@hash[1], @hash[2], @hash[3], @hash[4] = [], [], [], []
	end

	def correct_corners?(col, row, battle_field)
		left_top, right_top, left_bottom, right_bottom = define_corners(col, row, battle_field)
		left_bottom == nil && right_top == nil && left_top == nil && right_bottom == nil
	end

	def correct_amount?
		@hash[1].size == CELL[1] && @hash[2].size == CELL[2] && @hash[3].size == CELL[3] && @hash[4].size == CELL[4]
	end

	def add_ship_to_hash
		@overall.each {|ship| self.hash[ship.size] << ship}
	end

	def non_repeat_coords?(col, row)
		@overall.empty? || @overall.map{|ship| ship.include?([col, row])}.uniq == [false]
	end

	def find_ship(col, row, ship, battle_field)
		ship << [col, row]
		l, r, t, b = 1, 1, 1, 1
		sides = {}
		sides = define_sides(sides, col, row, battle_field)
		while sides.has_value?(1)
			if sides["left"] == 1
				ship << [col - l, row]
				l += 1
			elsif sides["right"] == 1
				ship << [col + r, row]
				r += 1
			elsif sides["top"] == 1
				ship << [col, row + t]
				t += 1
			elsif sides["bottom"] == 1
				ship << [col, row - b]
				b += 1
			end
			sides = define_sides(l, r, t, b, sides, col, row, battle_field)
		end
		@overall << ship.sort!			
	end

	def add_ships
		coords_array = init_positions
		#ДОБАВЛЯЕМ 1 по 4 КЛЕТКИ
		ship = []
		surround = []
		col, row = coords_array.shuffle.pop
		ship << [col, row]
		dice_x, dice_y = coords_array.shuffle.pop
		if dice_x > dice_y #ТОГДА ВЕРТИКАЛЬНО
			if row <=2
				surround << [col-1, row] if col-1 > -1
				surround << [col+1, row] if col+1 < Draw::Game::BOARD_SIZE[0]
				surround << [col-1, row-1] if col-1 > -1 && row-1 > -1
				surround << [col+1, row-1] if col+1 < Draw::Game::BOARD_SIZE[0] && row-1 > -1
				surround << [col, row-1] if row-1 > -1
				surround << [col-1, row+4] if col-1 > -1 && row+4 < Draw::Game::BOARD_SIZE[1]
				surround << [col+1, row+4] if col+1 < Draw::Game::BOARD_SIZE[0] && row+4 < Draw::Game::BOARD_SIZE[1]
				surround << [col, row+4] if row+4 < Draw::Game::BOARD_SIZE[1]
				3.times do |i|
					ship << [col, row+i+1]
					surround << [col-1, row+i+1] if col-1 > -1
					surround << [col+1, row+i+1] if col+1 < Draw::Game::BOARD_SIZE[0]
				end
			else
				surround << [col-1, row] if col-1 > -1
				surround << [col+1, row] if col+1 < Draw::Game::BOARD_SIZE[0]
				surround << [col-1, row+1] if col-1 > -1 && row+1 < Draw::Game::BOARD_SIZE[1]
				surround << [col+1, row+1] if col+1 < Draw::Game::BOARD_SIZE[0] && row+1 < Draw::Game::BOARD_SIZE[1]
				surround << [col, row+1] if row+1 < Draw::Game::BOARD_SIZE[1]
				surround << [col-1, row-4] if col-1 > -1 && row-4 > -1
				surround << [col+1, row-4] if col+1 < Draw::Game::BOARD_SIZE[0] && row-4 > -1
				surround << [col, row-4] if row-4 > -1
				3.times do |i|
					ship << [col, row-i-1]
					surround << [col-1, row-i-1] if col-1 > -1
					surround << [col+1, row-i-1] if col+1 < Draw::Game::BOARD_SIZE[0]
				end
			end
		else #ТОГДА ГОРИЗОНТАЛЬНО
			if col <=2
				surround << [col, row-1] if row-1 > -1
				surround << [col, row+1] if row+1 < Draw::Game::BOARD_SIZE[1]
				surround << [col-1, row-1] if col-1 > -1 && row-1 > -1
				surround << [col-1, row+1] if col-1 > -1 && row+1 < Draw::Game::BOARD_SIZE[1]
				surround << [col-1, row] if col-1 > -1
				surround << [col+4, row-1] if col+4 < Draw::Game::BOARD_SIZE[0] && row-1 > -1
				surround << [col+4, row+1] if col+4 < Draw::Game::BOARD_SIZE[0] && row+1 < Draw::Game::BOARD_SIZE[1]
				surround << [col+4, row] if col+4 < Draw::Game::BOARD_SIZE[0]
				3.times do |i|
					ship << [col+i+1, row]
					surround << [col+i+1, row-1] if row-1 > -1
					surround << [col+i+1, row+1] if row+1 < Draw::Game::BOARD_SIZE[1]
				end
			else
				surround << [col, row-1] if row-1 > -1
				surround << [col, row+1] if row+1 < Draw::Game::BOARD_SIZE[1]
				surround << [col+1, row-1] if col+1 < Draw::Game::BOARD_SIZE[0] && row-1 > -1
				surround << [col+1, row+1] if col+1 < Draw::Game::BOARD_SIZE[0] && row+1 < Draw::Game::BOARD_SIZE[1]
				surround << [col+1, row] if col+1 < Draw::Game::BOARD_SIZE[0]
				surround << [col-4, row-1] if col-4 > -1 && row-1 > -1
				surround << [col-4, row+1] if col-4 > -1 && row+1 < Draw::Game::BOARD_SIZE[1]
				surround << [col-4, row] if col-4 > -1
				3.times do |i|
					ship << [col-i-1, row]
					surround << [col-i-1, row-1] if row-1 > -1
					surround << [col-i-1, row+1] if row+1 < Draw::Game::BOARD_SIZE[1]
				end
			end
		end
		@overall << ship.sort!
		coords_array -= ship
		coords_array -= surround
		
		p "coords_array:"
		p coords_array
		p "ship enemy"
		p ship
		p "surround"
		p surround

		# #ДОБАВЛЯЕМ 2 по 3 КЛЕТКИ
		# ship = []
		# col, row = coords_array.shuffle.pop
		# ship << [col, row]
		# dice_x, dice_y = coords_array.shuffle.pop
		# if dice_x > dice_y #ТОГДА ВЕРТИКАЛЬНО
		# 	if row <=2
		# 		3.times do |i|
		# 			ship << [col, row+i]
		# 		end
		# 	else
		# 		3.times do |i|
		# 			ship << [col, row-i]
		# 		end
		# 	end
		# else #ТОГДА ГОРИЗОНТАЛЬНО
		# 	if col <=2
		# 		3.times do |i|
		# 			ship << [col+i, row]
		# 		end
		# 	else
		# 		3.times do |i|
		# 			ship << [col-i, row]
		# 		end
		# 	end
		# end
		# @overall << ship.sort!

	end

	def mark_on_field(enemy_battle_field)
		@overall.each do |ship|
			ship.each do |coord|
				col, row = coord
				enemy_battle_field[col][row] ||= 1
			end
		end
	end

	private
	def define_sides(l = 1, r = 1, t = 1, b = 1, sides, col, row, battle_field)
		sides["bottom"] = battle_field[col][row-b] if (row-b) > -1
		sides["top"] = battle_field[col][row+t] if (row+t) < Draw::Game::BOARD_SIZE[1]
		sides["top"] = nil if (row+t) == Draw::Game::BOARD_SIZE[1]
		sides["right"] = battle_field[col+r][row] if (col+r) < Draw::Game::BOARD_SIZE[0]
		sides["right"] = nil if (col+r) == Draw::Game::BOARD_SIZE[0]
		sides["left"] = battle_field[col-l][row] if (col-l) > -1
		sides
	end

	def define_corners(col, row, battle_field)
		left_top = battle_field[col-1][row-1] if (col-1 > -1) && (row-1 > -1)
		right_top = battle_field[col+1][row-1] if (col+1 < Draw::Game::BOARD_SIZE[0]) && (row-1 > -1)
		left_bottom = battle_field[col-1][row+1] if (col-1 > -1) && (row+1 < Draw::Game::BOARD_SIZE[1])
		right_bottom = battle_field[col+1][row+1] if (col+1 < Draw::Game::BOARD_SIZE[0]) && (row+1 < Draw::Game::BOARD_SIZE[1])
		[left_top, right_top, left_bottom, right_bottom]
	end

	def init_positions
			init = Array.new(Draw::Game::BOARD_SIZE[0]*Draw::Game::BOARD_SIZE[1])
			x = 0
			i = 0
			Draw::Game::BOARD_SIZE[0].times do
				y = 0
				Draw::Game::BOARD_SIZE[1].times do
					init[i] = [x,y]
					i += 1
					y += 1
				end
				x += 1
			end
			return init
		end

end
