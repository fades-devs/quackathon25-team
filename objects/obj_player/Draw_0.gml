draw_self();
// Draw health bar above player
var bar_width = 40;
var bar_height = 6;
var bar_x = x - bar_width/2;
var bar_y = y - sprite_height/2 - 10;
// Background of health bar
draw_set_color(c_gray);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);
// Health portion
draw_set_color(c_green);
var hp_width = (hp/max_hp) * bar_width;
draw_rectangle(bar_x, bar_y, bar_x + hp_width, bar_y + bar_height, false);
// Border
draw_set_color(c_black);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true);