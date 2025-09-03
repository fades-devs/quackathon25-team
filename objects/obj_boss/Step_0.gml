// Find the player
var player = instance_nearest(x, y, obj_player);

if player != noone {
    var dist = point_distance(x, y, player.x, player.y);
    
    // Determine state based on distance to player
    if dist <= attack_range && attack_cooldown <= 0 && !attack_animation_active {
        state = "attacking";
        attack_cooldown = attack_cooldown_max;
        attack_animation_active = true;
        alarm[0] = 20; // Attack animation duration
        
        // Update facing direction
        facing_right = (player.x > x);
        
        // Deal damage to player
        with(player) {
            hp -= other.damage;
            // Add knockback to player
            var kb_dir = point_direction(other.x, other.y, x, y);
            x += lengthdir_x(8, kb_dir);
            y += lengthdir_y(8, kb_dir);
        }
        
        // Force sprite update immediately
        sprite_index = spr_enemy_attack;
    } else if dist <= detection_range && !attack_animation_active {
        state = "chasing";
        
        // Update facing direction
        facing_right = (player.x > x);
        
        // Calculate direction to player
        var dir = point_direction(x, y, player.x, player.y);
        
        // Move towards player, but maintain minimum distance
        if dist > 35 { // Minimum chase distance
            x += lengthdir_x(move_speed, dir);
            y += lengthdir_y(move_speed, dir);
        }
    } else if !attack_animation_active {
        state = "idle";
    }
    
    // Prevent overlapping with player
    if dist < 30 { // Minimum distance to maintain
        var dir = point_direction(x, y, player.x, player.y);
        x -= lengthdir_x(1, dir); // Slow push away
        y -= lengthdir_y(1, dir);
    }
    
    // Update sprite based on state
    if !attack_animation_active {
        switch(state) {
            case "idle":
            case "chasing":
                sprite_index = spr_enemy_walk;
                break;
        }
    }
    
    // Handle horizontal flipping only
    image_xscale = facing_right ? 4 : -4;
}

// Attack cooldown
if attack_cooldown > 0 {
    attack_cooldown--;
}

// Check if enemy is defeated
if hp <= 0 {
    instance_destroy();
}