// Place this in the Step Event:
if (start_fade) {
    // Increase alpha to make the screen darker
    alpha += fade_speed;
    
    // Adjust music volume based on alpha
    audio_sound_gain(music_id, 1 - alpha, 0);
    
    // When fade is complete
    if (alpha >= 1) {
        // Stop the music completely
        audio_stop_sound(music_id);
        
        // You can transition to another room or end the game here
        // game_end(); // Uncomment if you want to end the game
        // Or go to another room
        // room_goto(rm_credits);
    }
}