class Field
  # フィールドの広さ(固定)
  WIDTH = 4

  ###################################
  ## フィールド生成・処理           #
  ###################################
  # フィールドのリセット
  def initialize_field
    @field = Array.new(WIDTH){Array.new(WIDTH){0}}
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
    generate_seed
    generate_seed
  end

  # ゲームオーバーチェック
  def game_over_check
    tmp_field = @field
    left_slide
    right_slide
    up_slide
    down_slide
    if @field == tmp_field
      # game over時の出力
      p "Game Over!"
    else
      @field = tmp_field
    end
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

  ###################################
  ## キー入力によるフィールドの操作 #
  ###################################
  # 左入力時の処理
  def left_slide
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
  end

  # 右入力時の処理 
  def right_slide
    # @fieldへ格納する行の指定変数
    line_number = 0
    @field.each do |n1, n2, n3, n4|
      # 行に要素がある場合のみ移動を行う
      unless n1 == 0 && n2 == 0 && n3 == 0 && n4 == 0
        # 要素に0が含まれる場合、全て右に詰める
        line_arr = [n1, n2, n3, n4].select{|n| n != 0}
        while (WIDTH - line_arr.length) > 0 do
          line_arr.unshift(0)
        end
        # 右方向にunion_panelを利用
        @field[line_number] = union_panel(*line_arr.reverse)
      end
      line_number += 1
    end
  end

  # 上入力時の処理
  def up_slide
    # 転置行列の生成
    @field = @field.transpose
    left_slide
    # 転置を戻す
    @field = @field.transpose
  end

  # 下入力時の処理
  def down_slide
    # 転置行列の生成
    @field = @field.transpose
    right_slide
    # 転置を戻す
    @field = @field.transpose
  end

  ###################################
  ## 外部クラスへのアクション       #
  ###################################
  # 現在のフィールド配列を返す
  def return_field
    return @field
  end

  # 現在のフィールドをコンソールに表示する
  def show_field
    @field.each do |n1, n2, n3, n4|
      print("[#{n1}] [#{n2}] [#{n3}] [#{n4}]\n")
    end
  end

end
