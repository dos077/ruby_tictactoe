class Game
    attr_accessor :p1_name, :p2_name

    def initialize(p1_name, p2_name)
        @p1_name = p1_name
        @p2_name = p2_name
        @p1_moves = []
        @p2_moves = []
        @values_map = [0, 8, 1, 6, 3, 5, 7, 4, 9, 2]
    end

    public

    def move(move, player)
        (player == 1)? (move_set = @p1_moves) : (move_set = @p2_moves)
        move_set << move
    end

    def display
        board = {}
        10.times do |i|
            if @p1_moves.include?(i)
                board[i] = "x"
            elsif @p2_moves.include?(i)
                board[i] = "o"
            else
                board[i] = "\s"
            end
        end

        return_string = ""

        3.times do |i|
            return_string += "+---+---+---+\n"
            return_string += "| #{board[3*i+1]} | #{board[3*i+2]} | #{board[3*i+3]} |\n"
        end

        return_string += "+---+---+---+\n"
        return_string
    end

    def victory?
        if @p1_moves.length > 2
            values = []
            @p1_moves.each { |i| values << @values_map[i] }
            return 1 if values.combination(3).to_a.any? { |e| e.inject(:+)==15 }
        end
        if @p2_moves.length > 2
            values = []
            @p2_moves.each { |i| values << @values_map[i] }
            return 2 if values.combination(3).to_a.any? { |e| e.inject(:+)==15 }
        end
        if (@p1_moves.length + @p2_moves.length) > 8
            return 3
        end
    end

    def legal_move?(move)
        (move.to_i < 10 && 
            move.to_i > 0 && 
            !@p1_moves.include?(move) && 
            !@p2_moves.include?(move)
            )
    end
    
    
end

puts "What's the name for player one?"
p1_name = gets.chomp
puts "What's the name for player two?"
p2_name = gets.chomp

game = Game.new(p1_name, p2_name)
puts "The board is divided to 9 squares: \n1 2 3\n4 5 6\n7 8 9"
puts "Ready player one."

until game.victory?
    p1_turn = true
    p2_turn = false
    while p1_turn
        puts "#{game.p1_name} please make your move"
        move = gets.chomp
        if game.legal_move?(move.to_i)
            game.move(move.to_i, 1)
            puts game.display
            break if game.victory?
            p1_turn, p2_turn = p2_turn, p1_turn
        else
            puts "#{move} is not a legal move."
        end
    end
    while p2_turn
        puts "#{game.p2_name} please make your move"
        move = gets.chomp
        if game.legal_move?(move.to_i)
            game.move(move.to_i, 2)
            puts game.display
            break if game.victory?
            p1_turn, p2_turn = p2_turn, p1_turn
        else
            puts "#{move} is not a legal move."
        end
    end
end

case game.victory?
when 1
    puts "Congradulation #{game.p1_name}, you won!"
when 2
    puts "Congradulation #{game.p2_name}, you won!"
when 3
    puts "It's a draw."
end