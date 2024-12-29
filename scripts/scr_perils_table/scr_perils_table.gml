
function scr_perils_table(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
	 var combat_perils = [
		[15, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
				unit.add_or_sub_health(choose(-8,-12,1-6,-20));
		    	var flavour_text2="He begins to gibber as psychic backlash overtakes him.";
		    	unit.corruption+=choose(2,4,6,8);
		    	return flavour_text2;
		}],
		[23, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
			unit.add_or_sub_health(choose(-30,-35,-40,-45));
		   	var flavour_text2="His mind is burned fiercly by the warp.";
		   	return flavour_text2;
		}],
		[31, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
			//TODO figure out a better way of making a marine unconcious/incapacitated
			//unit.add_or_sub_health(-5000);
		    var flavour_text2="Psychic backlash knocks him out entirely, incapacitating the marine.";
		    return flavour_text2;
		}],
		[39, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
	    	var flavour_text2="His mind is seared by the warp, now unable to cast more powers this battle.";
	    	unit.corruption+=choose(7,10,13,15);
	    	return flavour_text2;
		}],
		[47, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
			unit.add_or_sub_health(choose(-30,-35,-40,-45));
	        switch(psy_discipline){
	        	case "biomancy":
	        		flavour_text2="The psychic blast he had prepared runs loose, boiling his own blood!"
	        		break;
	        	case "pyromancy":
	        		flavour_text2="He lights on fire from the inside out, incapacitated in agony!"
	        		break;
	        	case "telekinesis":
	        		flavour_text2="The blast he had prepared runs loose, smashing himself into the ground!"
	        		break;
	        	default:
	        		flavour_text2="The psychic blast he had prepared runs loose, striking himself!";
	        		break

	        }
	        return flavour_text2;
		}],
		[55, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
		        var flavour_text2="Capricious voices eminate from the surrounding area, whispering poisonous lies and horrible truths.";
		        unit.corruption+=choose(10,15,20);
		        repeat(6){
		            var t=floor(random(men));
		            if (marine_type[t]!="") then unit.corruption+=choose(6,9,12,15);
		        }
		        return flavour_text2;
		}],
		[63, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
		       var  flavour_text2="Dark, shifting lights form into several ";
		        var d1=0,d2=0,d3=0;
		        var dem=choose("Pink Horror","Daemonette","Bloodletter","Plaguebearer");
		        flavour_text2+=string(dem)+"s.";
		        d1=instance_nearest(x,y,obj_enunit);
		        var exist;exist=0;
		        repeat(30)
		        	{
		        		if (d3=0){
		        			d2+=1;
			        		if (d1.dudes[d2]=dem){
			        			exist=d2;
			        			d3=5;
			        		}
			        	}
			        }
		        if (exist>0){
		        	d2=choose(3,4,5,6);
			        d1.dudes_num[exist]+=d2;
			        obj_ncombat.enemy_forces+=d2;obj_ncombat.enemy_max+=d2;d1.men+=d2;
			    }
		        d2=0;
		        if (exist=0){
		            repeat(30){
		            	if (d3=0){
		            		d2+=1;
		            		if (d1.dudes[d2]=""){
		            		d3=d2;
		            	}
		            }
		            }
		            d2=choose(3,4,5,6);
		            d1.dudes[d3]=dem;
		            d1.dudes_special[d3]="";
		            d1.dudes_num[d3]=d2;
		            d1.dudes_ac[d3]=15;
		            d1.dudes_hp[d3]=150;
		            d1.dudes_dr[d3]=0.7;
		            d1.dudes_vehicle[d3]=0;d1.dudes_damage[d3]=0;
		            d1.men+=d2;
		            obj_ncombat.enemy_forces+=d2;
		            obj_ncombat.enemy_max+=d2;
		        }
		        return flavour_text2;
		}],	
		[71, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
		        var flavour_text2="There is a massive explosion of warp energy which incapacitates him and injures several other marines!";
		        unit.add_or_sub_health(-65);
		       unit.add_or_sub_health(-5000);
		        repeat(7){
		            var t=floor(random(men));
		            if (marine_type[t]!="") then marine_hp[t]-=choose(10,20,30);
		        }
		        return flavour_text2;
		}],	
		[79, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
			obj_ncombat.global_perils+=25;
			var flavour_text2="Wind shrieks and blood pours from the sky!  The warp feels unstable.";
			return flavour_text2;
		}],	
		[87, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
		        marine_casting[unit_id]=-999;
		        unit.add_or_sub_health(-70);
		        var flavour_text2="A massive shockwave eminates from the marine, who is knocked out cold!  All of his equipment is destroyed!";
		        unit.alter_equipment({wep1:"",wep2:"",armour:"",gear:"",mobi:""},false,false);
		        return flavour_text2;
		}],	
		[95, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
				var flavour_text2;
				unit.update_health(0);
				marine_dead[unit_id]=2;
		        flavour_text2=choose(
		        	"There is a snap, and pop, and he disappears entirely.",
		        	"He explodes into a cloud of gore, splattering guts and ceramite across the battlefield."
		        )
		        if (unit.role()="Chapter Master") then global.defeat=3;
		        return flavour_text2;
		}],	
		[200, function(peril_roll, unit, psy_discipline, power_name, unit_id, book_powers){
				var flavour_text2;
				unit.update_health(0);
				marine_dead[unit_id]=2;
		        if (unit.role()="Chapter Master") then global.defeat=3;
		        flavour_text2="The marine's flesh begins to twist and rip, seemingly turning inside out.  His form looms up, and up, and up.  Within seconds a Greater Daemon of ";
		        //if (obj_ini.age[marine_co[unit_id],marine_id[unit_id]]<=((obj_controller.millenium*1000)+obj_controller.year)-10) and (obj_ini.zygote=0) and (string_count("Doom",obj_ini.strin2)=0) then obj_ncombat.gene_penalty+=1;
		        //if (obj_ini.age[marine_co[unit_id],marine_id[unit_id]]<=((obj_controller.millenium*1000)+obj_controller.year)-5) and (string_count("Doom",obj_ini.strin2)=0) then obj_ncombat.gene_penalty+=1;
	        
		        var dem=choose("Slaanesh","Nurgle","Tzeentch");
		        if (book_powers!=""){
			        if (string_count("Dae",marine_gear[unit_id])>0){
			            if (string_count("2",marine_gear[unit_id])>0) then dem="Slaanesh";
			            if (string_count("3",marine_gear[unit_id])>0) then dem="Nurgle";
			            if (string_count("4",marine_gear[unit_id])>0) then dem="Tzeentch";
			        }
			    }
	        
		        flavour_text2+=string(dem)+" has taken form.";
		        var d1=0,d2=0,d3=0,d1=instance_nearest(x,y,obj_enunit);
		        repeat(30){
		        	if (d3=0){
			        	d2+=1;
			        	if (d1.dudes[d2]=""){
			        		d3=d2;
			        	}
			        }
			    }
		        d1.dudes[d3]="Greater Daemon of "+string(dem);
		        d1.dudes_special[d3]="";
		        d1.dudes_num[d3]=1;
		        d1.dudes_ac[d3]=30;
		        d1.dudes_hp[d3]=700;
		        d1.dudes_dr[d3]=0.5;
		        d1.dudes_vehicle[d3]=0;
		        d1.dudes_damage[d3]=0;
		        d1.medi+=1;
		        obj_ncombat.enemy_forces+=1;obj_ncombat.enemy_max+=1;
		        d1.neww=1;
		        d1.alarm[1]=1;
		        return flavour_text2;
		}],    					
	]

	for (var i =0; i <array_length(combat_perils);i++){
		if (peril_roll<combat_perils[i][0]){
			return combat_perils[i][1](peril_roll, unit, psy_discipline, power_name, unit_id, book_powers);
		}
	}

}
