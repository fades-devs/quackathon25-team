// Draw the sprite
draw_self();

// Draw health bar above enemy
var bar_width = 30;
var bar_height = 4;
var bar_x = x - bar_width/2;
var bar_y = y - sprite_height/2 - 8;

// Background of health bar
draw_set_color(c_gray);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

// Health portion
draw_set_color(c_red);
var hp_width = max(0, (hp/max_hp) * bar_width); // Add max(0, ...) to prevent negative values
draw_rectangle(bar_x, bar_y, bar_x + hp_width, bar_y + bar_height, false);

// Border
draw_set_color(c_black);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true);
