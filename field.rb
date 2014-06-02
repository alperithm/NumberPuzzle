require 'curses'

Curses.start_color
Curses.init_pair 1, Curses::COLOR_YELLOW, Curses::COLOR_BLACK
Curses.init_pair 2, Curses::COLOR_BLACK, Curses::COLOR_RED
Curses.init_pair 3, Curses::COLOR_RED, Curses::COLOR_WHITE
Curses.init_pair 4, Curses::COLOR_BLACK, Curses::COLOR_BLACK

class Field
  # フィールドの広さ(固定)
  WIDTH = 4
  # 生成する数値の設定
  NUMBER = 2
  # ゴール値の設定
  GOAL = 2048

  ###################################
  ## フィールド生成・処理           #
  ###################################
  # フィールドのリセット
  def initialize_field
    @field = Array.new(WIDTH){Array.new(WIDTH){0}}
    @score = 0
    @bomb_counter = 0
  end

  # パネルの自動生成(2か4を生成する)
  def generate_seed
    if @field.flatten.select{|n| n == 0}.length > 0
      # 生成する数値の決定
      seed = (rand(2)+1) * 2
      # 0のindex格納配列
      tmp = []
      @field.flatten.each_with_index do |n, i|
        if n == 0 then
          tmp << i
        end
      end
      # 生成する場所のランダム取得
      index = tmp.sample
      @field[index/WIDTH][index%WIDTH] = seed
    else
      game_over_check
    end
  end

  # ゲーム開始の状態にする
  def game_start
    initialize_field
    2.times{generate_seed}
  end

  # パネル合体時の処理(左スライド)
  def union_panel(n1, n2, n3, n4)
    if n1 == n2 then
      n1 += n2
      n2 = n3
      n3 = n4
      n4 = 0
    end
    if n2 == n3 then
      n2 += n3
      n3 = n4
      n4 = 0
    end   
    if n3 == n4 then
      n3 += n4
      n4 = 0
    end
    [ n1, n2, n3, n4 ]
  end

  # ボムの処理
  def bomb
    Curses.setpos(1, 0)
    Curses.addstr("Please choose the place to bomb")
    Curses.setpos(5, 0)
    Curses.addstr("+------a------b------c------+     ")
    Curses.setpos(9, 0)
    Curses.addstr("+------d------e------f------+     ")
    Curses.setpos(13, 0)
    Curses.addstr("+------g------h------i------+     ")
    case Curses.getch
      when ?a
        area_r = 0
        area_l = 0
      when ?b
        area_r = 0
        area_l = 1
      when ?c
        area_r = 0
        area_l = 2
      when ?d
        area_r = 1
        area_l = 0
      when ?e
        area_r = 1
        area_l = 1
      when ?f
        area_r = 1
        area_l = 2
      when ?g
        area_r = 2
        area_l = 0
      when ?h
        area_r = 2
        area_l = 1
      when ?i
        area_r = 2
        area_l = 2
      else
        return false
    end
    Curses.setpos(1, 0)
    Curses.addstr("+---------------------------+     ")
    Curses.setpos(area_r*4+2, area_l*7+1)
    Curses.addstr(",,(' ⌒｀; ;) ")
    Curses.setpos(area_r*4+3, area_l*7+1)
    Curses.addstr("(;;ﾉ;;　(;;;;")
    Curses.setpos(area_r*4+4, area_l*7+1)
    Curses.addstr("(´;^｀⌒);) ; ")
    Curses.setpos(area_r*4+5, area_l*7+1)
    Curses.addstr(",,(' ⌒｀; ;) ")
    Curses.setpos(area_r*4+6, area_l*7+1)
    Curses.addstr("(;;ﾉ;;　(;;;;")
    Curses.setpos(area_r*4+7, area_l*7+1)
    Curses.addstr("(´;^｀⌒);) ; ")
    Curses.setpos(area_r*4+8, area_l*7+1)
    Curses.addstr("(;;ﾉ;;　(;;;;")
    for i in 0..1 do
      for j in 0..1 do
        @field[area_r + i][area_l + j] = 0
      end
    end
    @bomb_counter += 1
    Curses.getch
    @score = @score / 2
    return true
  end

  ###################################
  ## キー入力によるフィールドの操作 #
  ###################################
  # 左入力時の処理
  def left_slide
    tmp_field = Marshal.load(Marshal.dump(@field))
    # @fieldへ格納する行の指定変数
    line_number = 0
    @field.each do |n1, n2, n3, n4|
      # 行に要素がある場合のみ移動を行う
      unless n1 == 0 && n2 == 0 && n3 == 0 && n4 == 0
        # 要素に0が含まれる場合、全て左に詰める
        line_arr = [n1, n2, n3, n4].select{|n| n != 0}
        while (WIDTH - line_arr.length) > 0 do
          line_arr << 0
        end
        @field[line_number] = union_panel(*line_arr)
      end
      line_number += 1
    end
    if @field != tmp_field
      generate_seed
    end
  end

  # 右入力時の処理 
  def right_slide
    @field.each{|n| n.reverse!}
    left_slide
    @field.each{|n| n.reverse!}
  end

  # 上入力時の処理
  def up_slide
    @field = @field.transpose
    left_slide
    @field = @field.transpose
  end

  # 下入力時の処理
  def down_slide
    @field = @field.transpose
    right_slide
    @field = @field.transpose
  end

  ###################################
  ## 外部クラスへのアクション       #
  ###################################
  # ゲーム画面の生成
  def show_field
    @score = @field.flatten.inject{|sum,n| sum + n} * 10 / (1 + @bomb_counter)
    Curses.setpos(0, 0)
    Curses.addstr("Score: #{@score}")
    @field.each_with_index do |row, y|
      Curses.setpos(y * 4 + 1, 0)
      Curses.addstr("+------+------+------+------+     ")
      Curses.setpos(y * 4 + 2, 0)
      Curses.addstr("|      |      |      |      |     ")
      line_str = "|" 
      row.each_with_index do |cell| c = cell == 0 ? " " : cell
      line_str += " #{c.to_s.center(4)} |"
      end 
      Curses.setpos(y * 4 + 3, 0)
      Curses.addstr(line_str)
      Curses.setpos(y * 4 + 4, 0)
      Curses.addstr("|      |      |      |      |     ")
    end 
    Curses.setpos(17, 0)
    Curses.addstr("+------+------+------+------+     ")
    Curses.setpos(18, 0)
    Curses.attrset(Curses.color_pair(1))
    Curses.addstr("+-+-+-Command list-+-+-+")
    Curses.setpos(19, 0)
    Curses.addstr("  ←      : panels move to the leftside")
    Curses.setpos(20, 0)
    Curses.addstr("  →      : panels move to the rightside")
    Curses.setpos(21, 0)
    Curses.addstr("  ↑      : panels move to the upside")
    Curses.setpos(22, 0)
    Curses.addstr("  ↓      : panels move to the downside")
    Curses.setpos(23, 0)
    Curses.addstr("  r      : restart this game")
    Curses.setpos(24, 0)
    Curses.addstr("  q      : exit this game")
    Curses.attroff(Curses::A_COLOR)
    Curses.attrset(Curses.color_pair(4))
    Curses.setpos(25, 0)
    Curses.addstr("  b      : bomb mode")
    Curses.setpos(26, 0)
    Curses.attroff(Curses::A_COLOR)
    if game_over_check
      Curses.setpos(9, 0)
      Curses.attrset(Curses.color_pair(2))
      Curses.addstr("|        Game Over!         |")
      Curses.attroff(Curses::A_COLOR)
    end
    if goal_check
      Curses.setpos(9, 0)
      Curses.attrset(Curses.color_pair(3))
      Curses.addstr("|      Conglaturation!      |")
      Curses.attroff(Curses::A_COLOR)
    end
  end 

  # ゲームクリアチェック
  def goal_check
    @field.flatten.max >= GOAL
  end

  # ゲームオーバーチェック
  def game_over_check
    tmp_field = Marshal.load(Marshal.dump(@field))
    left_slide
    right_slide
    up_slide
    down_slide
    if @field == tmp_field
      # game over時の出力
      return true
    else
      @field = tmp_field
      return false
    end
  end

end
