if place_meeting(x, y, obj_house) {
    
    // Transition to the next room
    room_goto(house);
	instance_create_layer(0, 0, "Instances", obj_textbox_1);
    // Or go to a specific room:
    // room_goto(rm_level2);
}