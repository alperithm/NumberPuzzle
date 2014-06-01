require File.dirname(__FILE__) + "/Field"

field = Field.new
field.game_start
command = ''
while command != 'exit' do
  field.show_field
  p 'Command?(type \'h\' : show command list)'
  command = gets.chomp
  case command
  when 'l'
    field.left_slide
  when 'r'
    field.right_slide
  when 'u'
    field.up_slide
  when 'd'
    field.down_slide
  when 'restart'
    field.game_start
  when 'exit'
    p "Thank you for playing!"
    p "See you next time!"
  when 'h'
    p 'l        : panels move to the leftside'
    p 'r        : panels move to the rightside'
    p 'u        : panels move to the upside'
    p 'd        : panels move to the downside'
    p 'restart  : restart this game'
    p 'exit     : end this game'
  else
    p 'Oops.Please type a correct command!'
  end
  if field.goal_check
    p 'Conglaturation!'
    field.show_field
    break
  elsif field.game_over_check
    p 'Game Over!'
    field.show_field
    break
  end
end
