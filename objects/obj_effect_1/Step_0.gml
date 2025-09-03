// Step Event for obj_dialogue
if (char_pos <= text_length) {
    text_current = string_copy(text, 1, floor(char_pos));
    char_pos += char_speed;
} else {
    text_finished = true;
}