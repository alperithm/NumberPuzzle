class Field
  # フィールドの広さ(固定)
  WIDTH = 4
  # 生成する数値の設定
  NUMBER = 2
  # ゴール値の設定
  GOAL = 8

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
  # 現在のフィールド配列を返す
  def return_field
    return @field
  end

  # 現在のフィールドをコンソールに表示する
  def show_field
    @field.each do |n1, n2, n3, n4|
      s1 = n1.to_s
      s2 = n2.to_s
      s3 = n3.to_s
      s4 = n4.to_s
      while s1.length < 4
        s1 = " " << s1
      end
      while s2.length < 4
        s2 = " " << s2
      end
      while s3.length < 4
        s3 = " " << s3
      end
      while s4.length < 4
        s4 = " " << s4
      end
      print("[#{s1}] [#{s2}] [#{s3}] [#{s4}]\n")
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
