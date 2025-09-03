// Alarm 0 Event for obj_enemy
// This is for attack animation reset
attack_animation_active = false;
if state == "attacking" {
    state = "chasing";
}
sprite_index = spr_enemy_walk;
