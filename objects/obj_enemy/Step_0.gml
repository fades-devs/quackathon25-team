// Skip if enemy is dead
if is_dead {
    exit;
}
// Check if player is in rampage mode
var player = instance_nearest(x, y, obj_player);
if player != noone && variable_instance_exists(player, "rampage_mode") && player.rampage_mode {
    // Panic behavior
    state = "fleeing";
    sprite_index = spr_enemy_run;

    // Run away from player at increased speed
    var dir = point_direction(player.x, player.y, x, y);
    var panic_speed = move_speed * 2; // Double speed when fleeing
    x += lengthdir_x(panic_speed, dir);
    y += lengthdir_y(panic_speed, dir);

    // Add some randomness to fleeing
    if irandom(30) == 0 { // Occasionally change direction slightly
        dir += random_range(-45, 45);
        x += lengthdir_x(panic_speed * 0.5, dir);
        y += lengthdir_y(panic_speed * 0.5, dir);
    }

    // Face away from player
    facing_right = (x > player.x);

    // Still do damage check
    if hp <= 0 {
        is_dead = true;
        sprite_index = spr_enemy_dead;
        image_speed = 0.5;
        alarm[1] = 600; // Remove after 10 seconds (keep bodies around longer)
    }

    // Update sprite flipping
    image_xscale = facing_right ? 1.5 : -1.5;

    // Skip the rest of the AI
    exit;
}
// Normal enemy behavior
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
    image_xscale = facing_right ? 1.5 : -1.5;
}
// Attack cooldown
if attack_cooldown > 0 {
    attack_cooldown--;
}
// Check if enemy is defeated
if hp <= 0 {
    is_dead = true;
    sprite_index = spr_enemy_dead;
    image_speed = 0.5;
    // Keep bodies around longer during rampage mode
    var player = instance_nearest(x, y, obj_player);
    if player != noone && variable_instance_exists(player, "rampage_mode") && player.rampage_mode {
        alarm[1] = 600; // 10 seconds
    } else {
        alarm[1] = 120; // 2 seconds
    }
}