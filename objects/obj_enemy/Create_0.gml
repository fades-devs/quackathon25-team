// Enemy stats
hp = 50;
max_hp = 50;
damage = 1;
move_speed = 2;
attack_range = 40;
detection_range = 100;
attack_cooldown = 0;
attack_cooldown_max = 45;
state = "idle";
facing_right = true; // For horizontal flipping only
// Keep track of attack animation
attack_animation_active = false;
// Is enemy dead flag
is_dead = false;
// Initialize sprite
sprite_index = spr_enemy_walk;
image_speed = 0.5;
