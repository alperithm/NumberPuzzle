require 'curses'
require 'colorize'
require File.dirname(__FILE__) + "/Field"

def main
  # ゲーム画面の初期化
  Curses.init_screen
  # Arrowキー入力の許可
  Curses.stdscr.keypad(true)
  # ゲーム状態の初期化
  field = Field.new()
  field.game_start
  # コンソールへの操作受付開始
  begin
    while true
      Curses.clear
      field.show_field
      Curses.refresh
      case Curses.getch
      when Curses::Key::LEFT
        field.left_slide
      when Curses::Key::RIGHT
        field.right_slide
      when Curses::Key::UP
        field.up_slide
      when Curses::Key::DOWN
        field.down_slide
      when ?b
        field.bomb
      when ?r
        field.game_start
      when ?q
        break
      end 
    end 
  ensure
    Curses.close_screen
  end
end

main()
