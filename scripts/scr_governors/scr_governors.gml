function GovernorProfile(){
	born = obj_controlller.turn - irandom_range(240,2400);

	static age = function(){
		born - obj_controlller.turn;
	}

	gender = choose(GENDER.Female,GENDER.Male);

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