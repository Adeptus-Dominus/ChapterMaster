function scr_crusade() {

	// Executed to kill the fuck out of the player's marines
	// Think it is ran in the obj_p_fleet object when arriving back from crusade

	var unit;
	var co=0,i=0,apoth=0,death_determination=0,death_determination_2=0,roll3=0,type="",artifacts=0,clean=0;good=0;seed=0;marines_lost=0;
	var heroics_strings=[];
	
	//index 1: death_determine 1 //index 2: death_determine 2 /index 3: apoth_recovery
	//index 3 exp_gains irandom + static
    var death_sets = {
    	normal:[80,90,40,[5,10]],
    	hard:[60,80,30,[20,20]],
    	brutal:[20,65,20,[40,20]]
    };

	death_determination=floor(random(100))+1;
	roll3=irandom(99)+1

	if (death_determination<=50){
		type="normal";artifacts=choose(0,0,0,0,0,1);
	}else if (death_determination>50){
		type="hard";artifacts=choose(0,0,1);
	}else if (death_determination>80){
		type="brutal";
		artifacts=choose(1,2,3);
	}

    var  death_data = death_sets[$ type]

	for (co=0;co<=10;co++){
		clean[co]=0;
	}
	var total_ship_id=array_concat(capital_num,frigate_num,escort_num);

	for (co=0;co<=10;co++){
	    for (i=0;i<=500;i++){
        	good=0;dead=false;
        	if (obj_ini.name[co][i]=="") then continue;
        		unit=fetch_unit([co, i]);
        		if (unit.ship_location==-1) then continue;
            if (array_contains(total_ship_id,unit.ship_location)){
            	unit=obj_ini.TTRPG[co][i];
                death_determination=floor(random(100))+1;
                //specialist trait greatly reduces death risk
                //TODO figure out how to quantify and present these risks so the player knows to protect dudes with trait
                if (unit.has_trait("very_hard_to_kill")) then death_determination-=20;
                death_determination_2=death_determination;
                death_determination-=(unit.experience/2);

                //more generalised trait bonus mainly linked to chapter advantage of same name
                if (unit.has_trait("slow_and_purposeful")) then death_determination-=10;
            
                var dead=false;
                if (death_determination>death_data[0] || death_determination_2>death_data[1]){
                	dead=true;
	                if (unit.role()==obj_ini.role[100][5]){
	                	if (irandom(20)<unit.luck){
	                		dead=false;
	                	} else {
	                		if (irandom(100)<unit.weapon_skill){
	                			var heroic_deed = choose(
	                					"holding a breach in imperial defenses allowing allied forces to regroup,",
	                					"slaying the enemy leader in glorious combat, while victorious he ultimately succumbed to his wounds,",
	                					"leading an imortant boarding mission,",
	                				);
	                			//TODO figure out a blance in reward for captains or high rnaking death on crusade
	                			//adds dynamacism as itt creates reward for the potential loss of men and talent during crusades 
	                			//var consolations = ["ship", "req",""]
	                			//var consolation_prize = irandom(2)
	                			var heroic_death = $"{unit.full_title()} died {heroic_deed} {unit.name()} dies a hero of the {global.chapter_name}";
	                			array_push(heroics_strings, heroic_death);
	                		}
	                	}
	                }else if (unit.role()==obj_ini.role[100][11] || unit.role()=="Chapter Master") then dead=false;
	           	}
                if (dead){               	
                    var man_size=0;
                    obj_ini.ship_carrying[unit.ship_location]-=unit.get_unit_size();
                	if (unit.IsSpecialist("standard",true)){
                		obj_controller.command--;
                	} else {
                		obj_controller.marines--;
                	}
                
                    clean[co]=1;
                    marines_lost++;
                    scr_kill_unit(co,i);
                    seed+=2;
                } else {
                	if (unit.IsSpecialist("apoth")) and (obj_ini.gear[co][i]="Narthecium") then apoth++;
                	unit.add_exp(irandom(death_data[3][0])+death_data[3][1]);
                
                    if (irandom(99)==1 && irandom(20)<unit.luck){
                    	var heroic_deed=choose("still_standing","lone_survivor","beast_slayer");
                    	unit.add_trait(heroic_deed);
                    	array_push(heroics_strings, string(global.trait_list[$ heroic_deed].flavour_text,unit.full_title()));
                    }             	
                }
            }
    
        }        
    }

	if (obj_ini.doomed=0){
	    if (apoth>0){
	    	seed=min(seed,apoth*death_data[2]);
	    }
	    if (apoth=0) then seed=floor(seed*0.2);
	    obj_controller.gene_seed+=seed;
	}

	// i=-1;
	// repeat(11){
	    // i+=1;
	with(obj_ini){
		for (i=0;i<=10;i++){
			scr_company_order(i);
		}
	}
	// }

	if (roll3<=10) then artifacts+=1;
	if (artifacts>0) then repeat(artifacts){
	    if (obj_ini.fleet_type=ePlayerBase.home_world) then scr_add_artifact("random","",4,obj_ini.home_name,2);
	    if (obj_ini.fleet_type != ePlayerBase.home_world) then scr_add_artifact("random","",4,obj_ini.ship[0],501);
	}


	var tixt="Your ships have returned from the Crusade.  ";
	if (type="normal") then tixt+="The combat was as could be expected- ";
	if (type="hard") then tixt+="The combat was fairly grueling- ";
	if (type="brutal") then tixt+="The combat was absolutely brutal- your marines were the first into the fray, and as a result ";

	tixt+=string(marines_lost)+" of your battle brothers fell in combat.";

	if (obj_ini.doomed=0){
	    if (apoth>0) and (seed>0) then tixt+="  The "+string(apoth)+" surviving "+string(obj_ini.role[100][15])+" were able to recover "+string(seed)+" Gene-Seed.";
	    if (apoth=0) and (seed>0) then tixt+="  You had no able-bodied "+string(obj_ini.role[100][15])+", or all of them perished in the Crusade.  Foreign Apothecaries were able to recover "+string(seed)+" of your Gene-Seed.";
	}
	if (obj_ini.doomed==1){
	    tixt+="  Due to fatal mutations in your marines none of the fallen Gene-Seed was recoverable.";
	}

	if (artifacts>0) then tixt+="  "+string(artifacts)+" Artifacts were granted to your Chapter or looted.";
	if (roll3<=10) and (artifacts>1) then tixt+="  One of them were given as a bonus for exceptional valor.";

	if (array_length(heroics_strings)==1){
		tixt += " A heroic deed was recorded"
	} else if (array_length(heroics_strings)>1){
		tixt += " Several deeds were recorded"
	}
// title / text / image / speshul
	scr_popup("Crusade Results",tixt,"crusade","");
	for (i=0;i<array_length(heroics_strings);i++){
		scr_popup("Heroic Deed",heroics_strings[i],"crusade","");
	}

}

//TODO never place the star out of reach of a player fleet, eiter increase allowed response time or find nearer planet
function launch_crusade(){
	var star_id = scr_random_find(2,true,"","");
	if(star_id == undefined){
		debugl("RE: Crusade, couldn't find a star for the crusade");
		return false;
	}
	else{
		var assigned_crusade = false;
		for(var i = 1; i <= star_id.planets;i++){
			assigned_crusade = add_new_problem(i, "great_crusade", 36,star_id);
			if (assigned_crusade>0) then break;
		}
		if(!assigned_crusade){
			debugl("RE: Crusade, couldn't assign a crusade at the system");
			return false;
		}
		else{
			//TODO decide the target/purpose of the crusade to create more variety and to help with post crusade rewards
			scr_popup("Crusade","Fellow Astartes legions are preparing to embark on a Crusade to a nearby sector.  Your forces are expected at "+string(star_id.name)+"; 36 turns from now your ships there shall begin their journey.","crusade","");
			var star_alert = instance_create(star_id.x+16,star_id.y-24,obj_star_event);
			star_alert.image_alpha=1;
			star_alert.image_speed=1;
			scr_event_log("","A Crusade is called; our forces are expected at "+string(star_id.name)+" in 36 months.", star_id.name);
			return true;	
		}
	}
}
