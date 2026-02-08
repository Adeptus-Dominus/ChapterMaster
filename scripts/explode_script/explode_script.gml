/// @mixin
function explode_script(argument0, argument1) {
    // argument0: string
    // argument1: character that splits the string

    string1 = argument0;
    if (string_count(argument1, argument0) == 0) {
        explode[0] = 0;
        explode[1] = 0;
    }
    for (var i = 0; i < string_count(argument1, argument0); i++) {
        pos = string_pos(argument1, string1);
        explode[i] = string_copy(string1, 0, pos - 1);
        string1 = string_delete(string1, 1, pos);
    }

    /*

	Use example:

	string(x)+"|"+string(y)+"|"

	explode_script(mplay_message_value(),"|");//make like a banana string
	      inst=instance_create(x,y,ghost_brbullet);//create ghost bullet
	      inst.x=real(explode[0]);
	      inst.y=real(explode[1]);
	      inst.direction=real(explode[2]);
      
	*/
}
