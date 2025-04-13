
// 
var unit;
var skill_level;
for (var i=0;i<array_length(unit_struct);i++){
    unit = unit_struct[i];
    if (!is_struct(unit))then continue;
    if (marine_type[i]!="") and (unit.hp()<-3000) and (obj_ncombat.defeat=0){
        marine_dead[i]=0;
        //unit.add_or_sub_health(5000);
    }// For incapitated
    
    if (ally[i]=false){
        if (obj_ncombat.dropping=1) and (obj_ncombat.defeat=1) and (marine_dead[i]<2) then marine_dead[i]=1;
        if (obj_ncombat.dropping=0) and (obj_ncombat.defeat=1) and (marine_dead[i]<2){
            marine_dead[i]=2;
            marine_hp[i]=-50;
        }
        
    
        if (marine_type[i]!="") and (obj_ncombat.defeat=1) and (marine_dead[i]<2){
            marine_dead[i]=1;
            marine_hp[i]=-50;
        }
        if (veh_type[i]!="") and (obj_ncombat.defeat=1){
            veh_dead[i]=1;
            veh_hp[i]=-200;
        }
        
        if (!marine_dead[i]){
            if (unit.IsSpecialist("apoth", true)) {
                skill_level = unit.intelligence * 0.0125;
                if (marine_gear[i]=="Narthecium"){
                    skill_level*=2;
                    obj_ncombat.apothecaries_alive++;
                } 
                skill_level += random(unit.luck*0.05);
                obj_ncombat.unit_recovery_score += skill_level;
            }
            else if (unit.IsSpecialist("forge", true)) {
                skill_level = unit.technology * 0.01;
                if (marine_mobi[i]=="Servo-arm") {
                    skill_level*=2; 
                } else if (marine_mobi[i]=="Servo-harness") {
                    skill_level*=4;
                }
                skill_level += random(unit.luck*0.05);
                obj_ncombat.vehicle_recovery_score += skill_level;
                obj_ncombat.techmarines_alive++;
            }
        } else if (marine_dead[i]>0) and (marine_dead[i]<2) and (unit.hp()>-25) and (marine_type[i]!="") and ((obj_ncombat.dropping+obj_ncombat.defeat)!=2){
            var rand1, survival;
            onceh=0;
            survival=40;
            if (obj_ncombat.membrane=1) then survival-=20;
            rand1=floor(random(100))+1;
            skill_level = irandom(unit.luck);
            rand1-=skill_level;
            if (rand1<=survival) and (marine_dead[i]!=2){
                // show_message(string(marine_type[i])+" mans up#Roll: "+string(rand1)+"#Needed: "+string(survival)+"-");
                marine_dead[i]=0;
                //unit.update_health(2);
                obj_ncombat.injured+=1;
            }
        }
    }
    
}




