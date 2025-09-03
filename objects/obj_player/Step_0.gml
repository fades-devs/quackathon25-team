// Handle movement
var move_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var move_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// Set state to idle by default if not in special states
if state != "attacking" && !is_jumping {
    state = "idle";
}

// Determine current movement speed based on rampage mode
var current_move_speed = move_speed;
if rampage_mode {
    current_move_speed *= rampage_speed_multiplier;
}

// Handle jumping with spacebar
if keyboard_check_pressed(vk_space) && can_jump && !is_jumping {
    is_jumping = true;
    can_jump = false;
    jump_current = 0;
    alarm[1] = 30; // Jump cooldown (1/2 second at 60fps)
}

// Process jumping
if is_jumping {
    jump_current += 1;
    
    // Move up during first half of jump
    if jump_current < jump_height {
        y -= jump_speed * (1 - (jump_current / jump_height)); // Gradually slow down
    } 
    // Move down during second half
    else if jump_current < jump_height * 2 {
        y += jump_speed * ((jump_current - jump_height) / jump_height); // Gradually speed up
    } 
    // End jump
    else {
        is_jumping = false;
    }
}

// Process movement
if move_x != 0 || move_y != 0 {
    // Normalize diagonal movement (safely)
    var move_len = sqrt(move_x * move_x + move_y * move_y);
    if move_len > 0 { // Prevent division by zero
        move_x = move_x / move_len * current_move_speed;
        move_y = move_y / move_len * current_move_speed;
    }
    
    // Update facing direction based on horizontal movement
    if move_x != 0 {
        facing_right = (move_x > 0);
    }
    
    // Change state to walking if not attacking and not jumping
    if state != "attacking" && !is_jumping {
        state = "walking";
        // Force sprite update immediately for walking
        sprite_index = rampage_mode ? spr_duck_rampage_walk : spr_duck_walk;
    }
}

// Apply movement if not attacking (but allow horizontal movement while jumping)
if state != "attacking" {
    x += move_x;
    if !is_jumping {
        y += move_y;
    }
}

// Handle attack cooldown
if attack_cooldown > 0 {
    attack_cooldown--;
}

// Handle attack input
if mouse_check_button_pressed(mb_left) && attack_cooldown <= 0 {
    state = "attacking";
    attack_cooldown = rampage_mode ? (attack_cooldown_max / 3) : attack_cooldown_max; // Faster attacks in rampage mode
	alarm[0] = 15; // Duration of attack animation
    
    // Force sprite update immediately for attack
    sprite_index = rampage_mode ? spr_duck_rampage : spr_duck_attack;
    
    // Update facing direction based on mouse position
    facing_right = (mouse_x > x);
    
    // Check for enemies in attack range
    var attack_range = rampage_mode ? 100 : 50; // Larger attack range in rampage mode
    var attack_x = x + (facing_right ? attack_range/2 : -attack_range/2);
    
    // Calculate damage based on rampage mode
    var damage_to_deal = attack_damage;
    if rampage_mode {
        damage_to_deal *= rampage_damage_multiplier;
    }
    
    // Check for regular enemies
    var enemy = collision_circle(attack_x, y, attack_range/2, obj_enemy, false, true);
    if enemy != noone {
        // Deal damage
        with(enemy) {
            hp -= damage_to_deal;
            // Knockback
            var dir = point_direction(other.x, other.y, x, y);
            x += lengthdir_x(other.rampage_mode ? 30 : 15, dir); // Increased knockback in rampage mode
            y += lengthdir_y(other.rampage_mode ? 30 : 15, dir);
        }
    }
    
    // Check for boss enemies
    var boss = collision_circle(attack_x, y, attack_range/2, obj_boss, false, true);
    if boss != noone {
        // Deal damage
        with(boss) {
            hp -= damage_to_deal;
            // Knockback (optional for boss - less knockback)
            var dir = point_direction(other.x, other.y, x, y);
            x += lengthdir_x(other.rampage_mode ? 15 : 5, dir);
            y += lengthdir_y(other.rampage_mode ? 15 : 5, dir);
        }
    }
}

// Check for egg collision
var egg = instance_place(x, y, obj_egg);
if egg != noone {
    // Enter rampage mode
    rampage_mode = true;
    rampage_timer = rampage_duration;
    rampage_goose_spawned = 0;
    
    // Destroy the egg
    with(egg) {
        instance_destroy();
    }
    
    // Optional: Play a sound effect
    // audio_play_sound(snd_rampage_start, 1, false);
    
    // Create alarm for spawning geese (first one immediately)
    alarm[2] = 1;
}

// Rampage mode timer and effects
if rampage_mode {
    rampage_timer--;
    
    // Camera shake effect
    if rampage_timer % 2 == 0 { // Every other frame to reduce intensity
        var shake_amount = rampage_shake_intensity;
        view_xport[0] = random_range(-shake_amount, shake_amount);
        view_yport[0] = random_range(-shake_amount, shake_amount);
    } else {
        view_xport[0] = 0;
        view_yport[0] = 0;
    }
    
    if rampage_timer <= 0 {
        rampage_mode = false;
        // Reset camera position
        view_xport[0] = 0;
        view_yport[0] = 0;
		room_goto(Roomend);
        // Optional: Play sound when rampage ends
        // audio_play_sound(snd_rampage_end, 1, false);
    }
}

// Prevent overlapping with enemies
var enemy = instance_nearest(x, y, obj_enemy);
if enemy != noone {
    var dist = point_distance(x, y, enemy.x, enemy.y);
    if dist < 30 { // Minimum distance to maintain
        var dir = point_direction(enemy.x, enemy.y, x, y);
        x += lengthdir_x(1, dir); // Slow push away
        y += lengthdir_y(1, dir);
    }
}

// Update sprite based on state and rampage mode
if rampage_mode {
    // Rampage mode sprites
    if state == "idle" {
        sprite_index = spr_duck_rampage;
    } else if state == "walking" {
        sprite_index = spr_duck_rampage_walk;
    } else if state == "attacking" {
		audio_play_sound(quack, 0, false);
        sprite_index = spr_duck_rampage; // Or create a rampage attack sprite
    }
} else {
    // Normal sprites
    if state == "idle" {
        sprite_index = spr_duck_idle;
    } else if state == "walking" {
        sprite_index = spr_duck_walk;
    } else if state == "attacking" {
		audio_play_sound(quack, 0, false);
        sprite_index = spr_duck_attack;
    }
}

// Handle horizontal flipping only
image_xscale = facing_right ? 1.5 : -1.5;

// Check if player is defeated
if hp <= 0 {
    // Game over logic could go here
    show_message("Game Over!");
    game_restart();
}
