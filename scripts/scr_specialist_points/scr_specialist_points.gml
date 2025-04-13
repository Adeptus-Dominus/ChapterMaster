


function unit_apothecary_points_gen(turn_end=false){
    var _trained_person = IsSpecialist(SPECIALISTS_APOTHECARIES);
    var reasons = {};
    var points = 0;
    if (_trained_person){
        var points = ((technology/2)+(wisdom/2)+intelligence)/8;
        reasons.points = points
    }
    return [points,reasons];
}

function unit_forge_point_generation(turn_end=false){
    var _trained_person = IsSpecialist(SPECIALISTS_TECHS);
    var crafter = has_trait("crafter");
    var reasons = {};
    var points = 0;
    if (_trained_person){
        var points = technology / 5;
        reasons.trained = points;
    }
    if (job!="none"){
        if (job.type == "forge"){
            
            if (crafter){
                points*=3;
                reasons.at_forge = "x3 (Crafter)";
            } else {
                points*=2;
                reasons.at_forge = "x2";
            }
            points+=6;
            if (turn_end){
                add_exp(0.2);
            }
        }
    }
    if (crafter){
        points+=6;
        reasons.crafter = 6;
    }
    if (role()=="Forge Master"){
        points+=10;
        reasons.master = 10;
    }
    var maintenance = equipment_maintenance_burden();
    points -= maintenance;
    reasons.maintenance = $"-{maintenance}";
    if (has_trait("tinkerer")){
        reasons.maintenance += "\n    X0.5";
    }    
    return [points,reasons];
}



function scr_advance_research(research){
    if (research.name[0]=="research"){
        var tier_depth = array_length(research.name[2]);
        var tier_names=research.name[2];
        var player_research = obj_controller.production_research;
        if (tier_depth==1){
            player_research[$ tier_names[0]][0]++;
        } else if (tier_depth==2){
            player_research[$ tier_names[0]][1][$ tier_names[1]][0]++;
        } else if (tier_depth == 3){
            player_research[$ tier_names[0]][1][$ tier_names[1]][1][$ tier_names[2]][0]++;
        }
        scr_popup("Research Completed", $"Research of {research.name[1]} complete","","");
    }    
}

function research_end(){
    specialist_point_handler.calculate_research_points(true);
    stc_research[$ stc_research.research_focus] += specialist_point_handler.research_points;
    var research_area_limit;
    if (stc_research.research_focus=="vehicles"){
        research_area_limit = stc_vehicles;
    } else if (stc_research.research_focus=="wargear"){
        research_area_limit = stc_wargear;
    }else if (stc_research.research_focus=="ships"){
        research_area_limit = stc_ships;
    }    
    if (stc_research[$ stc_research.research_focus]>5000*(research_area_limit+1)){
       identify_stc(stc_research.research_focus);  
    }
}

