#!/usr/bin/env ruby
require 'io/console'
IO.console.winsize

class Life
  def initialize
    @rows = `tput li`.chomp.to_i
    @columns = `tput co`.chomp.to_i / 2
    print "rows = " + @rows.to_s + ", columns = " + @columns.to_s
    puts
    @grid = Array.new(@rows) {Array.new(@columns)}
    finished_inputting_values = false
    until finished_inputting_values
      input_cell
      puts 'Done'
      responce = gets.chomp
      if responce[0] == 'y'
        finished_inputting_values = true
      end
    end

    run
  end

  def input_cell
    puts 'Row?'
    row = gets.chomp.to_i
    puts 'Column?'
    column = gets.chomp.to_i
    @grid[row][column] = 'alive'
  end

  def print_grid
    row = 0
    column = 0
    @rows.times do
      puts
      column = 0
      @columns.times do
        if @grid[row][column] == nil
          print '  '
        else
          print 'X '
        end
        column += 1
      end
      row += 1
    end
  end

  def neighbors(row, column)
    neighbors = 0
    if row > 0
      if @grid[row - 1][column - 1] == 'alive' && (column > 0)
        neighbors += 1
      end
      if @grid[row - 1][column] == 'alive'
        neighbors += 1
      end
      if @grid[row - 1][column + 1] == 'alive' && (column < @columns - 1)
        neighbors += 1
      end
    end

    if @grid[row][column - 1] == 'alive' && (column > 0)
      neighbors += 1
    end
    if @grid[row][column + 1] == 'alive' && (column < @columns - 1)
      neighbors += 1
    end

    if row < @rows - 1
      if @grid[row + 1][column - 1] == 'alive' && (column > 0)
        neighbors += 1
      end
      if @grid[row + 1][column] == 'alive'
        neighbors += 1
      end
      if @grid[row + 1][column + 1] == 'alive' && (column < @columns - 1)
        neighbors += 1
      end
    end
    neighbors
  end

  def update
    next_grid = Array.new(@rows) {Array.new(@columns)}
    row = 0
    column = 0
    @rows.times do
      column = 0
      @columns.times do
        if @grid[row][column] == 'alive' && (neighbors(row, column) == 2 || neighbors(row, column) == 3)
          next_grid[row][column] = 'alive'
        elsif @grid[row][column] == 'alive' && (neighbors(row, column) < 2 || neighbors(row, column) > 3)
          next_grid[row][column] = nil
        elsif @grid[row][column] == nil && (neighbors(row, column) == 3)
          next_grid[row][column] = 'alive'
        else
          next_grid[row][column] = nil
        end
        column += 1
      end
      row += 1
    end
    @grid = next_grid.inject([]) { |a, element| a << element.dup }
  end

  def run
    loop do
      print_grid
      update
      sleep(0.1)
    end
  end
end

Life.new