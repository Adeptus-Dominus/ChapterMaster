
owner=0;
target=instance_nearest(x,y,obj_star);
loading=0;
loading_name="";
alarm[0]=1;
debug=0;
guard=0;
pdf=0;
fortification=0;
corruption=0;
ork=0;
tau=0;
chaos=0;
p_data = new PlanetData(0, target);
torpedo = scr_item_count("Cyclonic Torpedo");

feature= "";
garrison= "";
population = false;

garrison_data_slate = new DataSlate();
garrison_data_slate.title = "Garrison Report";
main_data_slate = new DataSlate();

colonist_button = new PurchaseButton(1000);
colonist_button.update({
	tooltip : "Planets with higher populations can provide more recruits both for your chapter and to keep a planets PDF bolstered, however colonists from other planets bring with them their home planets influences and evils /n REQ : 1000",
	label : "Request Colonists",
	target : target,
});
colonist_button.bind_method = function(){
    var doner = array_random_element(obj_star_select.potential_doners);
    new_colony_fleet(doner[0],doner[1],target.id,obj_controller.selecting_planet,"bolster_population");
};

buttons_selected = false;
button1="";
button2="";
button3="";
button4="";
button5="";
button_manager = new UnitButtonObject();
shutter_1 = new ShutterButton();
shutter_2 = new ShutterButton();
shutter_3 = new ShutterButton();
shutter_4 = new ShutterButton();
shutter_5 = new ShutterButton();
attack=0;
raid=0;
bombard=0;
purge=0;

player_fleet=0;
imperial_fleet=0;
mechanicus_fleet=0;
inquisitor_fleet=0;
eldar_fleet=0;
ork_fleet=0;
tau_fleet=0;
tyranid_fleet=0;
heretic_fleet=0;

en_fleet[0]=0;
var i;i=-1;
repeat(15){i+=1;en_fleet[i]=0;}

if (obj_controller.menu=0) then alarm[1]=1;

