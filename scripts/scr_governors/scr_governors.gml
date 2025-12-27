function GovernorProfile(){
	born = obj_controlller.turn - irandom_range(240,4800);

	uid = scr_uuid_generate();

	static age = function(){
		var _age = born - obj_controlller.turn;
		if (_age < 0){
			_age =  (born * -1) + obj_controlller.turn;
		}

		_age/=12;

		return age;
	}

	gender = set_gender();

	name = global.name_generator.generate_imperial_name();

	astartes_view  = irandom(4);//0 hates astartes 4 likes astartes

	sector_commander_view = irandom(4);

	personal_security = irandom(4);

	constitution = 10;
    strength = 10;
    luck = 10;
    dexterity = 10;
    wisdom = irandom_range(25, 50);
    piety = irandom_range(25, 60);
    charisma = irandom_range(25, 60);
    technology = irandom_range(10, 40);
    intelligence = irandom_range(25, 50);
    weapon_skill = 5;
    ballistic_skill = 5;
}