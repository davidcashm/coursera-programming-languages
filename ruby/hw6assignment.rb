# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # class array holding all the pieces and their rotations, including the three extras
  All_My_Pieces = All_Pieces + 
               [[[[0, 0], [-2, 0], [-1, 0], [1, 0], [2, 0]], # very long (only needs two)
               [[0, 0], [0, -2], [0, -1], [0, 1], [0, 2]]],
               rotations([[0, 0], [0, 1], [1, 1]]), # Small L
               rotations([[0, 0], [-1, 0], [0, -1], [0, 1], [-1, 1]]) # Square with jut
               ]
  
  # class method to choose the next piece
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  Cheat_Piece = [[[0,0]]]

  def self.cheat_piece (board)
    MyPiece.new(Cheat_Piece, board)
  end
  
end

class MyBoard < Board

  # I don't see a good alternative to copying all of initialize, since
  # I need to use MyPiece instead of Piece
  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
    @do_cheat = false
  end
  
  # gets the next piece
  def next_piece
    if @do_cheat
      @do_cheat = false
      @current_block = MyPiece.cheat_piece(self)
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  # rotates the current piece counterclockwise
  def rotate_one_eighty
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end
  
  # User pressed cheat.
  def cheat
    if !game_over? and
         @game.is_running? and
         not @do_cheat and
         @score >= 100
      @score -= 100
      @do_cheat = true
    end
    draw
  end
  
  # gets the information from the current piece about where it is and uses this
  # to store the piece on the board itself.  Then calls remove_filled.
  # Needs to over-ride default, because default assumes all pieces have 4
  # squares
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size-1)).each{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

end

class MyTetris < Tetris

  # creates a canvas and the board that interacts with it
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super # Add normal key bindings
    @root.bind('u', proc{@board.rotate_one_eighty})
    @root.bind('c', proc{@board.cheat})
  end
end


