NumberPuzzle
============

倍数パズルゲームプログラム

1.	フィールドの大きさ(正方形の一辺の長さ)・目標数値(2の累乗)を入力する
2.	フィールドに「2」または「4」を合計2つ生成する
3.	パネル移動方向の入力受付状態  
  I.	Up (u)  
  II.	Down (d)  
  III.	Left (l)  
  IV.	Right (r)  
4.	パネルを3.の方向に、フィールドの壁または他のパネルにぶつかるまで移動する  
  I.	パネルがフィールドの壁にぶつかった場合、そのまま  
  II.	パネルが異なる数のパネルにぶつかった場合、そのまま  
  III.	パネルが同じ数のパネルにぶつかった場合、3.の方向にパネルを1つに結合し、パネルの数値をお互いの数値の乗算とする  
5.	フィールドに「2」または「4」を1つ生成し、フィールドの状態をチェック  
  I.	3.のいずれかの操作でパネルが移動出来る場合、3.へ  
  II.	3.のいずれかの操作でパネルが移動出来ない場合、6.へ  
  III.	フィールド上のパネルのいずれかが目標数値の場合、7.へ  
6.	ゲームオーバー。Exit(exit)を入力すると終了。それ以外は1.へ
7.	ゲームクリア。Exit(exit)を入力すると終了。それ以外は1.へ
