// Player stats
hp = 100;
max_hp = 100;
move_speed = 4;
attack_damage = 10;
attack_cooldown = 0;
attack_cooldown_max = 25;
state = "idle";
facing_right = true; // For horizontal flipping only
// Jumping variables
is_jumping = false;
can_jump = true;
jump_height = 15;
jump_speed = 6;
jump_current = 0;
// Rampage mode variables
rampage_mode = false;
rampage_timer = 0;
rampage_duration = 2400; // 20 seconds at 60fps
rampage_damage_multiplier = 50; // Instant kill
rampage_speed_multiplier = 2.5; // Much faster movement
rampage_goose_count = 30; // Number of geese to spawn
rampage_goose_spawned = 0; // Counter for spawned geese
rampage_shake_intensity = 4; // Camera shake intensity
// Initialize sprite
sprite_index = spr_duck_idle;
image_speed = 0.5;