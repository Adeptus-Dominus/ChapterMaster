
enum ePREFERENCE{
	HATES = 0,
	DISLIKES,
	NEUTRAL,
	LIKES,
	LOVES
}

function GovernorProfile() constructor{
	born = obj_controller.turn - irandom_range(240,4800);

	uid = scr_uuid_generate();

	static age = function(){
		var _age = born - obj_controller.turn;
		if (_age < 0){
			_age =  (born * -1) + obj_controller.turn;
		}

		_age/=12;

		return age;
	}

	gender = set_gender();

	name = global.name_generator.GenerateFromSet($"imperial_{string_gender(gender)}");

	astartes_view  = irandom(4);//0 hates astartes 4 likes astartes

	sector_commander_view = irandom(4);//likes commmander hates commander

	personal_security = irandom(4); // 0 no security , 4 high secirity

    known_to_cm = false;

    known_to_chapter = false;

	constitution = 10;
    strength = 10;
    luck = 10;
    dexterity = 10;
    wisdom = irandom_range(20, 50);
    piety = irandom_range(20, 60);
    charisma = irandom_range(20, 60);
    technology = irandom_range(10, 40);
    intelligence = irandom_range(20, 50);
    weapon_skill = 5;
    ballistic_skill = 5;

}