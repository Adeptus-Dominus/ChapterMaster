hover = 0;
shop = "";
click = 0;
click2 = 0;
discount = 0;
construction_started = 0;
eta = 0;
target_comp = obj_controller.new_vehicles;

slate_panel =  new DataSlate();
scroll_point=0;
tooltip_show = 0;
tooltip = "";
tooltip_stat1 = 0;
tooltip_stat2 = 0;
tooltip_stat3 = 0;
tooltip_stat4 = 0;
tooltip_other = "";
last_item = "";
forge_master = scr_role_count("Forge Master", "", "units");
if (array_length(forge_master)>0){
    forge_master=forge_master[0];
} else {
    forge_master="none";
}
mechanicus_modifier = (((obj_controller.disposition[eFACTION.Mechanicus]-50)/200)*-1)+1
var research = obj_controller.production_research;
shop = "equipment";
/*if (obj_controller.menu=55) then shop="equipment";
if (obj_controller.menu=56) then shop="vehicles";
if (obj_controller.menu=57) then shop="warships";
if (obj_controller.menu=58) then shop="equipment2";*/
if (instance_number(obj_shop) > 1) {
    var war;
    war = instance_nearest(0, 0, obj_shop);
    shop = war.shop;
    with(war) {
        instance_destroy();
    }
    x = 0;
    y = 0;
}

var research = obj_controller.production_research;
var research_pathways = obj_controller.production_research_pathways;
var i, rene;
i = -1;
rene = 0;
repeat(80) {
    i += 1;
    item[i] = "";
    x_mod[i] = 0;
    item_stocked[i] = 0;
    mc_stocked[i] = 0;
    item_cost[i] = 0;
    nobuy[i] = 0;
    forge_cost[i]=0;
    tooltip_overide[i]=0;
}
if (obj_controller.faction_status[eFACTION.Imperium] = "War") {
    rene = 1;
    with(obj_temp6) {
        instance_destroy();
    }
    with(obj_star) {
        var u;
        u = 0;
        repeat(4) {
            u += 1;
            if (p_type[u] = "Forge") and(p_owner[u] = 1) then instance_create(x, y, obj_temp6);
        }
    }
    if (instance_exists(obj_temp6)) then rene = 0;
    with(obj_temp6) {
        instance_destroy();
    }
}

tab_buttons = {
    "equipment":new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    "armour":new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    "vehicles":new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
    "ships":new MainMenuButton(spr_ui_but_3, spr_ui_hov_3),
}  
var require_tool_tip = "requires: #"
if (shop = "equipment") {
    i = 0;
    i += 1;
    item[i] = "Combat Knife";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 1;
    forge_cost[i] = 10;
    i += 1;
    item[i] = "Chainsword";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 4;
    forge_cost[i] = 40;
    i += 1;
    x_mod[i] = 9;
    item[i] = "Eviscerator";
    if (research.chain[0]>0){
        forge_cost[i] = 150;
    } else {
        tooltip_overide[i] = $"{require_tool_tip} {research_pathways.chain[0][0]}"
    }   
    item_stocked[i] = scr_item_count(item[i]);
    nobuy[i] = 1;
    i += 1;
    item[i] = "Chainaxe";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 10;
    forge_cost[i] = 40;
    i += 1;
    item[i] = "Power Axe";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 40;
    if (research.power_fields[0]>1){
        forge_cost[i] = 100;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Power Sword";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 25;
    if (research.power_fields[0]>1){
        forge_cost[i] = 100;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
	i += 1;
    item[i] = "Power Spear";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 40;
    if (research.power_fields[0]>1){
        forge_cost[i] = 100;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
	i += 1;
    item[i] = "Crozius Arcanum";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 75;
    if (research.power_fields[0]>1){
        forge_cost[i] = 150;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Power Fist";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 60;
    if (research.power_fields[0]>1){
        forge_cost[i] = 150;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
	 i += 1;
    item[i] = "Boltstorm Gauntlet";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 90;
    if (research.power_fields[0]>1&& research.bolt[0]>=2){
        forge_cost[i] = 300;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
	/*i += 1;
	item[i] = "Executioner Power Axe";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 100;
    if (research.power_fields[0]>1){
        forge_cost[i] = 300;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }*/
    i += 1;
    item[i] = "Power Mace";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 50;
    if (research.power_fields[0]>1){
        forge_cost[i] = 140;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    if (global.chapter_name == "Dark Angels"){
        i += 1;
        item[i] = "Mace of Absolution";
        item_stocked[i] = scr_item_count(item[i]);
        item_cost[i] = 70;
        if (research.power_fields[0]>1){
            forge_cost[i] = 160;
        }
    }
    i += 1;
    item[i] = "Lightning Claw";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 90;
    if (research.power_fields[0]>1){
        forge_cost[i] = 150;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Chainfist";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 75;
    if (research.power_fields[0]>1 && research.chain[0]>0){
        forge_cost[i] = 150;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Force Staff";
    item_stocked[i] = scr_item_count(item[i]);
    if (research.psi[0]>0){
        forge_cost[i] = 500;
    }
    item_cost[i] = 70;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
	i += 1;
    item[i] = "Force Sword";
    item_stocked[i] = scr_item_count(item[i]);
    if (research.psi[0]>0){
        forge_cost[i] = 400;
    }
    item_cost[i] = 55;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
	i += 1;
    item[i] = "Force Axe";
    item_stocked[i] = scr_item_count(item[i]);
    if (research.psi[0]>0){
        forge_cost[i] = 450;
    }
    item_cost[i] = 60;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Thunder Hammer";
    if (research.power_fields[0]>1){
        forge_cost[i] = 500;
    }    
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 90;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Heavy Thunder Hammer";
    if (research.power_fields[0]>1){
        forge_cost[i] = 750;
    }    
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 135;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Lascutter";
    forge_cost[i] = 500;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 15;
    i += 1;
    x_mod[i] = 9;
    item[i] = "Boarding Shield";
    forge_cost[i] = 100;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 20;
    i += 1;
    x_mod[i] = 9;
    item[i] = "Storm Shield";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 50;
    if (research.power_fields[0]>1){
        forge_cost[i] = 500;
    }  
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Company Standard";
    forge_cost[i] = 2000;
    nobuy[i] = 1;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 0;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }


    i += 1;
    item[i] = "Bolt Pistol";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 5;
    forge_cost[i] = 50;
    i += 1;
    item[i] = "Bolter";
    forge_cost[i] = 100;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 10;
    i += 1;
    item[i] = "Stalker Pattern Bolter";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 80;
	forge_cost[i] = 230; 
    i += 1;
    x_mod[i] = 9;
    item[i] = "Combiflamer";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 200;
    if (research.bolt[0]<1 || research.flame[0]<1) then forge_cost[i] = 0;
    item_cost[i] = 35;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Combiplasma";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 450;
    if (research.bolt[0]<1 || research.plasma[0]<1) then forge_cost[i] = 0;
    item_cost[i] = 110;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Combimelta";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 350;
    if (research.bolt[0]<1 || research.melta[0]<1) then forge_cost[i] = 0;
    item_cost[i] = 40;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Combigrav";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 450;
    if (research.bolt[0]<1 || research.grav[0]<1) then forge_cost[i] = 0;
    item_cost[i] = 110;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Heavy Bolter";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 50;
    if (research.bolt[0]>=2) then forge_cost[i] = 300;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Storm Bolter";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 50;
	if (research.bolt[0]>=2) then forge_cost[i] = 300;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
	i += 1;
    item[i] = "Infernus Pistol";
    forge_cost[i] = 100;
    if (research.flame[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 12;
    i += 1;
    item[i] = "Wrist-Mounted Storm Bolter";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 80;
    forge_cost[i] = 300;
    if (research.bolt[0]<2) then forge_cost[i] = 0;
    nobuy[i] = 1;
    i += 1;
    item[i] = "Hand Flamer";
    forge_cost[i] = 75;
    if (research.flame[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 12;
    i += 1;
    item[i] = "Flamer";
    forge_cost[i] = 150;
    if (research.flame[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 25;
    i += 1;
    item[i] = "Heavy Flamer";
    forge_cost[i] = 350;
     if (research.flame[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 40;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }

    i += 1;
    item[i] = "Incinerator";
    item_stocked[i] = scr_item_count(item[i]);
    nobuy[i] = 1;
	forge_cost[i] = 350;
	if (research.flame[0]<1) then forge_cost[i] = 0;
    // i += 1;
    // item[i] = "Integrated Bolter";
    // item_stocked[i] = scr_item_count(item[i]);
    // item_cost[i] = 120;
    i += 1;
    item[i] = "Meltagun";
    forge_cost[i] = 250;
    if (research.melta[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 30;
    i += 1;
    item[i] = "Multi-Melta";
    forge_cost[i] = 350;
     if (research.melta[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 60;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Plasma Pistol";
    forge_cost[i] = 250;
     if (research.plasma[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 60;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Plasma Gun";
    forge_cost[i] = 350;
    if (research.plasma[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 100;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Plasma Cannon";
    forge_cost[i] = 600;
    if (research.plasma[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 300;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Grav-Pistol";
    forge_cost[i] = 250;
     if (research.grav[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 60;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Grav-Gun";
    forge_cost[i] = 350;
    if (research.grav[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 100;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Grav-Cannon";
    forge_cost[i] = 600;
    if (research.grav[0]<1) then forge_cost[i] = 0;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 300;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Archeotech Laspistol";
    item_stocked[i] = scr_item_count(item[i]);
    nobuy[i] = 1;
    i += 1;
    x_mod[i] = 9;
    item[i] = "Hellrifle";
    item_stocked[i] = scr_item_count(item[i]);
    nobuy[i] = 1;
    i += 1;
    item[i] = "Sniper Rifle";
    forge_cost[i] = 200;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 10;
    i += 1;
    item[i] = "Needle Sniper Rifle";
    forge_cost[i] = 500;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 200;
    i += 1;
    item[i] = "Missile Launcher";
    forge_cost[i] = 300;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 70;
    i += 1;
    item[i] = "Cyclone Missile Launcher";
    forge_cost[i] = 350;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 150;
    i += 1;
    item[i] = "Lascannon";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 500;
    if (research.las[0]<1) then forge_cost[i] = 0;
    item_cost[i] = 70;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    var mc = 0;
    repeat(i) {
        mc++;
        if (item[mc] != ""){
            mc_stocked[mc] = scr_item_count(item[mc], "master_crafted");
        }
    }
}
if (shop = "equipment2") {
    i = 0;
    i += 1;
    item[i] = "MK3 Iron Armour";
    item_stocked[i] = scr_item_count("MK3 Iron Armour");
    nobuy[i] = 1;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
     if (obj_controller.in_forge){
        if (research.armour[1].armour[0]>2){
            forge_cost[i] = 1250;
        } else {
            tooltip_overide[i] = "requires : #";
            for (var r = research.armour[1].armour[0]; r < 3;r++){
                tooltip_overide[i] += $"     {research_pathways.armour[1].armour[0][r]}#";
            }
        }            
    }

    i += 1;
    var mk_4_able = false;
    var mk_4_tool_tip = ""
    item[i] = "MK4 Maximus";
    item_stocked[i] = scr_item_count("MK4 Maximus");
    if (obj_controller.in_forge){
        if (research.armour[1].stealth[0] >0 && research.armour[1].armour[0] >1){
            forge_cost[i] = 1250;
            mk_4_able=true;
        } else {
            tooltip_overide[i] = "requires : #";
            if (research.armour[1].stealth[0] < 1){
                tooltip_overide[i] += $"     {research_pathways.armour[1].stealth[0][0]}#";
                for (var r = research.armour[1].armour[0]; r < 2;r++){
                    tooltip_overide[i] += $"     {research_pathways.armour[1].armour[0][r]}#";
                }
            }
            mk_4_tool_tip = tooltip_overide[i];
        }

    }
    nobuy[i] = 1;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "MK5 Heresy";
    item_stocked[i] = scr_item_count("MK5 Heresy");
    item_cost[i] = 45;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "MK6 Corvus";
    item_stocked[i] = scr_item_count("MK6 Corvus");
    item_cost[i] = 35;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    if (obj_controller.in_forge){
        if (research.armour[1].stealth[0] > 0){
            forge_cost[i] = 1400;
        } else {
            tooltip_overide[i] = "requires : #";
            if (research.armour[1].stealth[0] < 1){
                tooltip_overide[i] += $"     {research_pathways.armour[1].stealth[0][0]}#";
            }
        }
    }

    i += 1;
    item[i] = "MK7 Aquila";
    item_stocked[i] = scr_item_count("MK7 Aquila");
    item_cost[i] = 20;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    if (obj_controller.in_forge){
        if (research.armour[0] > 0){
            forge_cost[i] = 1000;
        } else {
            tooltip_overide[i] = "requires : #";
            if (research.armour[0] < 1){
                tooltip_overide[i] += $"     {research_pathways.armour[0][0]}#";
            }
        }
    }

    i += 1;
    item[i] = "MK8 Errant";
    item_stocked[i] = scr_item_count("MK8 Errant");
    nobuy[i] = 1;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    if (obj_controller.in_forge){
        if (research.armour[0] > 1){
            forge_cost[i] = 1000;
        } else {
            tooltip_overide[i] = "requires : #";
            if (research.armour[0] < 2 && mk_4_able){
                tooltip_overide[i] += $"     {research_pathways.armour[0][1]}#";
            } else {
				tooltip_overide[i] = mk_4_tool_tip;
            }
        }
    }    
    i += 1;
    item[i] = "Scout Armour";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 200;
    item_cost[i] = 5;
    i += 1;
    item[i] = "Artificer Armour";
    item_stocked[i] = scr_item_count("Artificer Armour");
    nobuy[i] = 1;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
if (research.armour[1].stealth[0] > 0 && research.armour[1].armour[0] > 1) {
    forge_cost[i] = 1500;
} else {
    tooltip_overide[i] = "requires : \n";
    if (research.armour[1].stealth[0] < 1) {
        tooltip_overide[i] += $"     {research_pathways.armour[1].stealth[0][0]}\n";
        for (var r = research.armour[1].armour[0]; r < 2; r++) {
            tooltip_overide[i] += $"     {research_pathways.armour[1].armour[0][r]}\n"; 
        }
    }
	mk_4_tool_tip = tooltip_overide[i];
 
}   
    i += 1;
    item[i] = "Terminator Armour";
    item_stocked[i] = scr_item_count("Terminator Armour");
    nobuy[i] = 1;
if (research.armour[1].stealth[0] > 0 && research.armour[1].armour[0] > 1 && obj_controller.stc_wargear >= 6) {
    forge_cost[i] = 2000;
} else {
    tooltip_overide[i] = "requires : \n"; 
    if (research.armour[1].stealth[0] < 1) {
        tooltip_overide[i] += $"     {research_pathways.armour[1].stealth[0][0]}\n"; 
        for (var r = research.armour[1].armour[0]; r < 2; r++) {
            tooltip_overide[i] += $"     {research_pathways.armour[1].armour[0][r]}\n"; 
        }
    }
    mk_4_tool_tip = tooltip_overide[i];
    tooltip_overide[i] += $"STC wargear component 6"; 
}
     // if (rene=1){nobuy[i]=1;item_cost[i]=0;}
i += 1;
item[i] = "Tartaros";
item_stocked[i] = scr_item_count("Tartaros");
nobuy[i] = 1;
if (research.armour[1].stealth[0] > 0 && research.armour[1].armour[0] > 1 && obj_controller.stc_wargear >= 6) {
    forge_cost[i] = 2500;
} else {
    tooltip_overide[i] = "requires : \n";
    if (research.armour[1].stealth[0] < 1) {
        tooltip_overide[i] += $"     {research_pathways.armour[1].stealth[0][0]}\n";
        for (var r = research.armour[1].armour[0]; r < 2; r++) {
            tooltip_overide[i] += $"     {research_pathways.armour[1].armour[0][r]}\n"; 
        }
    }
    mk_4_tool_tip = tooltip_overide[i];
    tooltip_overide[i] += $"STC wargear component 6"; 
}

    
    i += 1;
    x_mod[i] = 9;
    item[i] = "Jump Pack";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 250;
    item_cost[i] = 20;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }

    i += 1;
    x_mod[i] = 9;
    item[i] = "Heavy Weapons Pack";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 250;
    item_cost[i] = 25;    
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }

    i += 1;
    x_mod[i] = 9;
    item[i] = "Servo-harness";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 1500;
    item_cost[i] = 150;
	 if (obj_controller.stc_wargear >= 6) {
		forge_cost[i] = 400;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }

    i += 1;
    x_mod[i] = 9;
    item[i] = "Conversion Beamer Pack";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 180;
	if (research.grav[0]>=1 && research.flame[0]>=1 && research.las[0]>=1 && research.plasma[0]>=1 ) then forge_cost[i] = 450;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }

    i += 1;
    x_mod[i] = 9;
    item[i] = "Servo-arm";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 750;
    item_cost[i] = 30;
	forge_cost[i] = 150;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }

    i += 1;
    x_mod[i] = 9;
    item[i] = "Bionics";
    forge_cost[i] = 20;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 5;
    i += 1;
    x_mod[i] = 9;
    item[i] = "Narthecium";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 500;
    item_cost[i] = 10;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Psychic Hood";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 1000;
    item_cost[i] = 100;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Combat Shield";
    forge_cost[i] = 75;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 15;
    i += 1;
    x_mod[i] = 9;
    item[i] = "Rosarius";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 1500;
    item_cost[i] = 100;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Iron Halo";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 2000;
    item_cost[i] = 250;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Plasma Bomb";
    forge_cost[i] = 1500;
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 175;

    i += 1;
    x_mod[i] = 9;
    item[i] = "Exterminatus";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 2500;

    i += 1;
    x_mod[i] = 9;
    item[i] = "Gene Pod Incubator";
    item_stocked[i] = scr_item_count(item[i]);
    nobuy[i] = 1;
    item_cost[i] = 0;   
    forge_cost[i] = 80; 

    mc=0;
    repeat(i) {
        mc += 1;
        if (item[mc] != ""){
            mc_stocked[i] = scr_item_count(item[mc], "master_crafted");
        }
    }    

}

var player_hanger = min(array_length(obj_controller.player_forge_data.vehicle_hanger),1);
if (shop = "vehicles") {
    i = 0;
    i += 1;
    item[i] = "Rhino";
    item_stocked[i] = scr_vehicle_count(item[i], "");
    forge_cost[i] = 1500*player_hanger;
    item_cost[i] = 120;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Predator";
    item_stocked[i] = scr_vehicle_count(item[i], "");
    forge_cost[i] = 3000*player_hanger;
    item_cost[i] = 240;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Autocannon Turret";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 30;
	if (research.bolt[0]> 2) then forge_cost[i] = 150*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Twin Linked Lascannon Turret";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 60;
	if (research.las[0]>1) then 	forge_cost[i] = 400*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Heavy Bolter Sponsons";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 38;
	forge_cost[i] = 100*player_hanger;
	if (research.bolt[0]> 2) then forge_cost[i] = 100*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Heavy Flamer Sponsons";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 50;
	forge_cost[i] = 150*player_hanger;
    if (research.flame[0]<1) then forge_cost[i] = 0;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Lascannon Sponsons";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 60;
	if (research.las[0]>1) then forge_cost[i] = 300;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Land Raider";
    item_stocked[i] = scr_vehicle_count(item[i], "");
    nobuy[i] = 1;
    if (obj_controller.stc_vehicles >= 6) {
        nobuy[i] = 0;
        item_cost[i] = 500;
		forge_cost[i] = 4500*player_hanger;
    }
	if (rene=1){nobuy[i]=1;item_cost[i]=0; forge_cost[i] = 0;}
    i += 1;
    x_mod[i] = 9;
    item[i] = "Twin Linked Heavy Bolter Mount";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 28;
	if (research.bolt[0]> 2) then forge_cost[i] = 250*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Quad Linked Heavy Bolter Sponsons";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 60;
	if (research.bolt[0]> 3) then 	forge_cost[i] = 350*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Twin Linked Assault Cannon Mount";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 60;
	if (research.bolt[0]> 3) then 	forge_cost[i] = 400*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Flamestorm Cannon Sponsons";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 100;
	forge_cost[i] = 300*player_hanger;
    if (research.flame[0]<1) then forge_cost[i] = 0;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Hurricane Bolter Sponsons";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 70;
	if (research.bolt[0]> 3) then 	forge_cost[i] = 300*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Twin Linked Lascannon Sponsons";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 120;
	if (research.las[0]>1) then forge_cost[i] = 250*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Whirlwind";
    item_stocked[i] = scr_vehicle_count(item[i], "");
    item_cost[i] = 180;
	forge_cost[i] = 2000*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "HK Missile";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 10;
	forge_cost[i] = 250*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Land Speeder";
    item_stocked[i] = scr_vehicle_count(item[i], "");
    nobuy[i] = 1;
	if (obj_controller.stc_vehicles >= 6) {
    nobuy[i] = 0;
    item_cost[i] = 120;
	forge_cost[i] = 700*player_hanger;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Twin Linked Bolters";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 8;
	if (research.bolt[0]>= 2) then forge_cost[i] = 150*player_hanger;
    i += 1;
    item[i] = "Bike";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 35;
	forge_cost[i] = 150*player_hanger;
    i += 1;
    item[i] = "Dreadnought";
    item_stocked[i] = scr_item_count(item[i]);
    nobuy[i] = 1; // if (rene=1){nobuy[i]=1;item_cost[i]=0;}
if (research.armour[1].stealth[0] > 0 && research.armour[1].armour[0] > 1 && obj_controller.stc_wargear >= 6) {
    forge_cost[i] = 3000;
} else {
    tooltip_overide[i] = "requires : \n"; 
    if (research.armour[1].stealth[0] < 1) {
        tooltip_overide[i] += $"     {research_pathways.armour[1].stealth[0][0]}\n"; 
        for (var r = research.armour[1].armour[0]; r < 2; r++) {
            tooltip_overide[i] += $"     {research_pathways.armour[1].armour[0][r]}\n"; 
        }
    }
    mk_4_tool_tip = tooltip_overide[i];
    tooltip_overide[i] += $"STC wargear component 6"; 
}
    i += 1;
    x_mod[i] = 9;
    item[i] = "Close Combat Weapon";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 45;
	forge_cost[i] = 200*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Twin Linked Heavy Bolter";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 110;
	if (research.bolt[0]> 2) then 	forge_cost[i] = 150*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Twin Linked Lascannon";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 110;
	if (research.las[0]>1) then forge_cost[i] = 150*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Autocannon";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 80;
	if (research.bolt[0]> 2) then 	forge_cost[i] = 150;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Inferno Cannon";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 115;
	forge_cost[i] = 250*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Dreadnought Lightning Claw";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 185;
    forge_cost[i] = 250*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Assault Cannon";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 75;
	if (research.bolt[0]> 2) then 	forge_cost[i] = 350;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Dreadnought Power Claw";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 150;
	forge_cost[i] = 200*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Whirlwind Missiles";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 90;
	forge_cost[i] = 250*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Heavy Conversion Beam Projector";
    item_stocked[i] = scr_item_count(item[i]);
	forge_cost[i] = 350*player_hanger;
	nobuy[i] = 1;
    if (rene = 1) {
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
	i += 1;
    x_mod[i] = 9;
    item[i] = "Plasma Destroyer Turret";
    item_stocked[i] = scr_item_count(item[i]);
    forge_cost[i] = 400*player_hanger;
	nobuy[i] = 1;
    if (rene = 1) {
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Flamestorm Cannon Turret";
    item_stocked[i] = scr_item_count(item[i]);
	forge_cost[i] = 400*player_hanger;
	nobuy[i] = 1;
    if (rene = 1) {
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
	i += 1;
    x_mod[i] = 9;
    item[i] = "Magna-Melta Turret";
    item_stocked[i] = scr_item_count(item[i]);
	forge_cost[i] = 400*player_hanger;
	nobuy[i] = 1;
    if (rene = 1) {
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
	i += 1;
    x_mod[i] = 9;
    item[i] = "Neutron Blaster Turret";
    item_stocked[i] = scr_item_count(item[i]);
	forge_cost[i] = 450*player_hanger;
	nobuy[i] = 1;
    if (rene = 1) {
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
	i += 1;
    x_mod[i] = 9;
    item[i] = "Volkite Saker Turret";
    item_stocked[i] = scr_item_count(item[i]);
	forge_cost[i] = 400*player_hanger;
	nobuy[i] = 1;
    if (rene = 1) {
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
	i += 1;
    x_mod[i] = 9;
    item[i] = "Volkite Culverin Sponsons";
    item_stocked[i] = scr_item_count(item[i]);
	forge_cost[i] = 350*player_hanger;
	nobuy[i] = 1;
    if (rene = 1) {
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
	i += 1;
    x_mod[i] = 9;
    item[i] = "Twin Linked Volkite Culverin Sponsons";
    item_stocked[i] = scr_item_count(item[i]);
	forge_cost[i] = 400*player_hanger;
	nobuy[i] = 1;
    if (rene = 1) {
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
	i += 1;
    x_mod[i] = 9;
    item[i] = "Twin Linked Multi-Melta Sponsons";
    item_stocked[i] = scr_item_count(item[i]);
	item_cost[i] = 200;
	forge_cost[i] = 200*player_hanger;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
	i += 1;
    x_mod[i] = 9;
    item[i] = "Twin Linked Heavy Flamer Sponsons";
    item_stocked[i] = scr_item_count(item[i]);
	forge_cost[i] = 200*player_hanger;
	item_cost[i] = 150;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
	i += 1;
    x_mod[i] = 9;
    item[i] = "Reaper Autocannon Mount";
    item_stocked[i] = scr_item_count(item[i]);
	forge_cost[i] = 250*player_hanger;
	nobuy[i] = 1;
    if (rene = 1) {
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Void Shield";
    item_stocked[i] = scr_item_count(item[i]);
    nobuy[i] = 1;
    if (obj_controller.stc_vehicles >= 6) {
        nobuy[i] = 0;
        item_cost[i] = 500;
		forge_cost[i] = 2000*player_hanger;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Lucifer Pattern Engine";
    item_stocked[i] = scr_item_count(item[i]);
    nobuy[i] = 1;
    if (obj_controller.stc_vehicles >= 6) {
        nobuy[i] = 0;
        item_cost[i] = 90;
		forge_cost[i] = 1250*player_hanger;
    }
   if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Artificer Hull";
    item_stocked[i] = scr_item_count(item[i]);
    nobuy[i] = 1;
    if (obj_controller.stc_vehicles >= 3) {
        nobuy[i] = 0;
        item_cost[i] = 200;
		forge_cost[i] = 1000*player_hanger;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
		forge_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Armoured Ceramite";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 120;
	 if (obj_controller.stc_vehicles >= 3) {
        item_cost[i] = 200;
		forge_cost[i] = 500*player_hanger;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Heavy Armour";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 50;
	 if (obj_controller.stc_vehicles >= 3) {
        item_cost[i] = 200;
		forge_cost[i] = 250*player_hanger;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Smoke Launchers";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 10;
	 if (obj_controller.stc_vehicles >= 3) {
        item_cost[i] = 200;
		forge_cost[i] = 250*player_hanger;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Dozer Blades";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 10;
	 if (obj_controller.stc_vehicles >= 3) {
        item_cost[i] = 200;
		forge_cost[i] = 200*player_hanger;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Searchlight";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 15;
	 if (obj_controller.stc_vehicles >= 3) {
        item_cost[i] = 200;
		forge_cost[i] = 250*player_hanger;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Frag Assault Launchers";
    item_stocked[i] = scr_item_count(item[i]);
    item_cost[i] = 30;
	 if (obj_controller.stc_vehicles >= 3) {
        item_cost[i] = 200;
		forge_cost[i] = 250*player_hanger;
    }
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
}
if (shop = "warships") {
    i = 0;
    i += 1;
    item[i] = "Battle Barge";
    item_stocked[i] = scr_ship_count(item[i]);
    item_cost[i] = 20000;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Strike Cruiser";
    item_stocked[i] = scr_ship_count(item[i]);
    item_cost[i] = 8000;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Gladius";
    item_stocked[i] = scr_ship_count(item[i]);
    item_cost[i] = 2250;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    item[i] = "Hunter";
    item_stocked[i] = scr_ship_count(item[i]);
    item_cost[i] = 3000;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
    i += 1;
    x_mod[i] = 9;
    item[i] = "Cyclonic Torpedo";
    item_stocked[i] = scr_item_count(item[i]);
    nobuy[i] = 1;
    if (rene = 1) {
        nobuy[i] = 1;
        item_cost[i] = 0;
    }
}



with(obj_p_fleet) {
    if (capital_number > 0) and(action = "") {
        var you;
        you = instance_nearest(x, y, obj_star);
        if (you.trader > 0) then obj_shop.discount = 1;
    }
}
with(obj_star) {
    if (array_contains(p_owner, 1)) and(trader > 0) then obj_shop.discount = 1;
}


if (shop = "equipment") or(shop = "equipment2") {
    var disc;
    disc = 1;
    if (obj_controller.stc_wargear >= 1) then disc = 0.92;
    if (obj_controller.stc_wargear >= 3) then disc = 0.86;
    if (obj_controller.stc_wargear >= 5) then disc = 0.75;
    var mc = 0;
    repeat(i) {
        mc++;
        if (forge_cost[mc] > 1) then forge_cost[mc] = round(forge_cost[mc] * disc);
    }
}
if (shop = "vehicles") {
    var disc;
    disc = 1;
    if (obj_controller.stc_vehicles >= 1) then disc = 0.92;
    if (obj_controller.stc_vehicles >= 3) then disc = 0.86;
    if (obj_controller.stc_vehicles >= 5) then disc = 0.75;
   var mc = 0;
    repeat(31) {
        mc += 1;
        var ahuh;
        ahuh = 1;
        if (mc >= 7) and(mc <= 12) then ahuh = 0;
        if (ahuh = 1) {
            if (forge_cost[mc] > 1) then forge_cost[mc] = round(forge_cost[mc] * disc);
        }
    }
}
if (shop == "production"){
    i = 0;
    var research_item;
    if (research.flame[0] == 0){
        i++;
        item[i] = ["research", research_pathways.flame[0][research.flame[0]], ["flame"]];
        item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research grants the ability to fabricate and harness Promethium Tanks, allowing for the construction of flame-based weaponry. This technology taps into the potent destructive potential of Promethium, turning it into a terrifying tool of war, capable of reducing enemies to ash.\nUnlocks: Flamers, Heavy Flamers, Incinerator.\nRequired for: Heavy Flamer Sponsons, Flamestorm Cannon Sponsons, Inferno Cannon, Servo-harness, Combi-flamer.";

    }
    if (research.psi[0] == 0){
        i++;
        item[i] = ["research", research_pathways.psi[0][research.psi[0]], ["psi"]];
        item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research unlocks the arcane art of crafting Force Weapons, allowing our trained psykers to channel the raw, untamed power of the Warp into tangible forms. It transforms ordinary melee implements into conduits of psychic fury, each blow imbued with devastating energy This grants our psykers the ability to strike down the mightiest foes, turning the tide of battle with the very power of the immaterium.\n\nUnlocks: Force Staff, Force Sword, Force Axe.";
    }
    if (research.las[0] == 0){
        i++;
        item[i] = ["research", research_pathways.las[0][research.las[0]], ["las"]];
        item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research unveils the secrets of advanced Las Weaponry, a testament to the Imperium's mastery of directed energy. It allows the construction of more potent and reliable las weapons, each pulse of light capable of searing through armor and flesh alike. This empowers our forces with vastly enhanced range, penetration, and damage, ensuring the Emperor's light shines brighter against the encroaching darkness.\n\nUnlocks: Lascannon.\nRequired for: Twin Linked Lascannon Turret, Twin Linked Lascannon Sponsons, Twin Linked Lascannon.";
    }    
     if (research.chain[0] == 0){
        i++;
        item[i] = ["research", research_pathways.chain[0][research.chain[0]], ["chain"]];
        item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research unleashes the technology for Advanced Chain Weaponry, allowing us to produce tools of brutal, unrelenting destruction. It allows for the creation of weapons that tear and rend, leaving nothing but bloody ruin in their wake. Our warriors wield these instruments of carnage to devastating effect, carving through the ranks of our enemies with unstoppable fury. \n\nUnlocks: Eviscerator, Chainfist.";
    }         
    if (research.plasma[0] == 0){
        i++;
        item[i] = ["research", research_pathways.plasma[0][research.plasma[0]], ["plasma"]];
        item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research delves into the dangerous art of Plasma Weaponry, granting us the means to unleash the raw power of superheated plasma upon the enemy. This volatile technology produces weapons that can inflict devastating wounds, but its very nature demands a careful hand, lest its power consume the wielder. These weapons provide a high damage potential, capable of obliterating even heavily armored foes.\n\nUnlocks: Plasma Pistol, Plasma Gun, Plasma Cannon.\nRequired for: Combiplasma.";
    }
    if (research.bolt[0] == 1){
        i++;
        item[i] = ["research",research_pathways.bolt[0][research.bolt[0]], ["bolt"]];
		item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research reveals the secrets of Advanced Bolt Weapons, an expansion of the Emperor's favored projectile weapons into more specialized and lethal forms. It is the pinnacle of projectile technology, combining explosive force with devastating impact. This provides our forces with a significant increase in firepower, ensuring that each shot finds its mark and shatters the foe. \n\nUnlocks: Stalker Pattern Bolter, Heavy Bolter, Heavy bolter Sponsons.\nRequired for: Combiflamer, Combiplasma, Combimelta, Combigrav, Assault Cannon, Autocannon Turret, Hurricane Bolter, Quad Linked Heavy Bolter Sponsons, Twin Linked Bolters, Twin Linked Heavy Bolter mount, Twin Linked assault cannon.";
    }
	if (research.bolt[0] == 2){
        i++;
        item[i] = ["research","Advanced Weapon Integration and Targeting", ["bolt"]];
		item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research unlocks the divine secrets of Advanced Weapon Integration and Targeting, allowing for the creation of systems that connect the chapter’s weaponry with the Astartes in perfect harmony, enhancing their coordination and tactical prowess upon the Emperor's battlefields. It also allows for the construction of the devastating Assault Cannon and the mighty Autocannon for Predator tanks, making them instruments of divine vengeance, ensuring that the enemies of Mankind tremble before their might. This knowledge shall improve the efficiency of standard bolter weaponry, while also unleashing newer and more devastating tools of annihilation. \nUnlocks: Assault Cannon, Autocannon Turret, Twin Linked Heavy Bolter mount, Twin Linked bolter.\nRequired for: Hurricane Bolter, Quad Linked Heavy Bolter Sponsons, Twin linked assault cannon.";
    }
		if (research.bolt[0] == 3){
        i++;
        item[i] = ["research","Integrated Weapon Stabilization and Rate of Fire Enhancements", ["bolt"]];
		item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research unlocks the sacred technology of Integrated Weapon Stabilization and Rate of Fire Enhancements, allowing our warriors to unleash bolter fire with unprecedented might, creating a maelstrom of righteous destruction upon the heretic and the alien. This divine advancement focuses on the inner workings of the weaponry, turning them into the Emperor's own instruments of divine wrath, rivaled only by the most sacred creations of the Machine God. Their might shall tear down the very fortresses of our foes, and their righteous fury shall cleanse the battlefield from all that would oppose the Imperium. \nUnlocks: Hurricane Bolter, Quad Linked Heavy Bolter Sponsons, Twin linked assault cannon.";
    }
    if (research.power_fields[0] < 2){
        i++;
        item[i] = ["research",research_pathways.power_fields[0][research.power_fields[0]], ["power_fields"]];
        item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research unlocks the ancient science of Advanced Power Weapons, enhancing melee armaments with potent energy fields that disrupt the very bonds of matter. It is a testament to the power of technology, transforming ordinary weapons into instruments of righteous fury. This allows our warriors to devastate the most armored foes, cleaving through enemy ranks with the raw energy of the machine god.\n\nUnlocks: Power Axe, Power Sword, Power Spear, Crozius Arcanum, Power Fist, Power Mace, Lightning Claw, Chainfist, Thunder Hammer, Heavy Thunder Hammer, Storm Shield.";
    }
    if (research.melta[0] == 0){
        i++;
        item[i] = ["research",research_pathways.melta[0][research.melta[0]], ["melta"]];
        item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research unlocks the terrifying potential of Basic Melta Weaponry, granting us the ability to unleash the searing heat of miniature suns upon the enemy. These weapons melt through armor and fortifications with unparalleled ease. This enhances our anti-tank capabilities, allowing our forces to shatter enemy vehicles and fortifications, leaving only molten slag in their wake.\n\nUnlocks: Meltagun, Multi-Melta.\nRequired for: Combimelta";
    }
    if (research.grav[0] == 0){
        i++;
        item[i] = ["research", research_pathways.grav[0][research.grav[0]], ["grav"]];
        item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research unravels the enigmatic science of Grav Weapons, allowing us to manipulate the very fabric of gravity for destructive purposes. These weapons crush and pulverize their targets with the force of collapsing worlds. They become the bane of armored units, allowing our forces to annihilate heavy infantry and vehicles with the very force of celestial bodies. \n\nUnlocks: Grav-Pistol, Grav-Gun, Grav-Cannon.\nRequired for: Combigrav";
    }
    if (research.armour[0]>0){
        if (research.armour[1].stealth[0] == 0){
            i++;
            item[i] = ["research","Advanced Servo Motors", ["armour", "stealth"]];
            item_stocked[i] = 0;
            forge_cost[i] = 3000;
            tooltip_overide[i] = "This research unlocks the secrets of Advanced Servo Motors, allowing the fabrication of enhanced movement systems, greatly boosting the speed and agility of our warriors. The speed and maneuverability increase will provide our troops with a significant advantage. It also unlocks the construction of specialized armors and advanced items.\n\nUnlocks: Mk6 Corvus.\nRequired for: Artificer Armour, Terminator Armour, Tartaros.";
        }
        if (research.armour[1].armour[0] == 0){
            i++;
            item[i] = ["research","Advanced Ceramite Bonding", ["armour", "armour"]];
            item_stocked[i] = 0;
            forge_cost[i] = 3000;
            tooltip_overide[i] = "This research uncovers the lost techniques of Advanced Ceramite Bonding, allowing us to create superior armors. It fortifies our war plate, offering unparalleled protection against enemy fire. This dramatically enhances the survivability of our units as well as unlocking new armor capabilities.\n\nUnlocks: MK3 Iron Armour.\nRequired for: MK8 Errant, Artificer Armour, Terminator Armour, Tartaros.";
        } else if (research.armour[1].armour[0] == 2){
            i++;
            item[i] = ["research","Ceremite Void Hardening", ["armour", "armour"]];
            item_stocked[i] = 0;
            forge_cost[i] = 3000;
            tooltip_overide[i] = "This research grants the secrets of Ceramite Void Hardening techniques, reinforcing our armors to withstand the harshest conditions of the void. It is essential for warriors who brave the vacuum of space, ensuring they can perform their duties where others would falter. It increases the unit's resilience in harsh environments as well as providing a superior armor plating. \n\nUnlocks: MK3 Iron Armour.\nRequired for: MK8 Errant, Artificer Armour.";
        }
        if  (research.armour[0]==1){
            i++;
            item[i] = ["research",research_pathways.armour[0][1], ["armour"]];
            item_stocked[i] = 0;
            forge_cost[i] = 3000;
            tooltip_overide[i] = "This research unlocks the knowledge to fabricate the Mk VIII 'Errant' pattern Power Armour, a refinement of the ubiquitous Aquila armour, often favored by veteran Astartes and officers due to its unparalleled protection. It features improved plating around the torso and neck, enhancing its resilience against both ranged and melee attacks. This technology marks the pinnacle of power armour technology and a significant step in the path to becoming a battle-hardened Astartes.\n\nUnlocks: MK8 Errant.\nRequired for: Artificer Armour.";               
        }        
        if (research.armour[1].stealth[0] == 1 && research.armour[1].armour[0] == 1){
            i++;
            item[i] =  ["research","Enhanced Nerve Interfacing", ["armour", "armour"]];
            item_stocked[i] = 0;
            forge_cost[i] = 3000;
            tooltip_overide[i] = "This research allows the creation of Enhanced Nerve Interfacing systems, binding unit and armor in perfect harmony. It augments the link between warrior and war plate, unlocking new levels of effectiveness. This provides the user with better accuracy, damage output, and mobility, unlocking new levels of tactical potential. \n\nUnlocks: MK4 Maximus.";
        }
    } else if (research.armour[0]==0){
        i++;
        item[i] = ["research",research_pathways.armour[0][0], ["armour"]];
        item_stocked[i] = 0;
        forge_cost[i] = 3000;
        tooltip_overide[i] = "This research unlocks the knowledge to fabricate Mk VII 'Aquila' pattern Power Armour, the standard armour pattern for the Adeptus Astartes. It is a reliable and ubiquitous armour used by many Chapters that is also easy to construct and maintain, making it a stable base for the might of the Imperium's warriors.\n\nUnlocks: MK7 Aquila.\nRequired for: MK8 Errant, Artificer Armour, Terminator Armour, Tartaros.";        
    } 

}
legitimate_items = i;
if (shop = "warships") {
    var disc;
    disc = 1;
    if (obj_controller.stc_ships >= 1) then disc = 0.92;
    if (obj_controller.stc_ships >= 3) then disc = 0.86;
    if (obj_controller.stc_ships >= 5) then disc = 0.75;
    i = 0;
    repeat(31) {
        i += 1;
        if (item_cost[i] > 1) then item_cost[i] = round(item_cost[i] * disc);
    }
}
if (discount = 1) {
    discount = 2;
    i = 0;
    repeat(31) {
        i += 1;
        if (item_cost[i] >= 5) then item_cost[i] = round(item_cost[i] * 0.8);
        if (item_cost[i] > 1) and(item_cost[i] < 5) then item_cost[i] -= 1;
    }
}

if (rene = 1) {
    i = 0;
    repeat(31) {
        i += 1;
        item_cost[i] *= 2;
    }
}
forge_master_modifier=0;
if (forge_master!="none"){
    forge_master_modifier = 2500/((forge_master.charisma+10)*forge_master.technology);
    if (forge_master.has_trait("flesh_is_weak") && forge_master_modifier>0.75){
        forge_master_modifier-=0.1;
    };
} else {
    forge_master_modifier=1.7;
}
var tech_heretic_modifier =1
 i = 0;
  repeat(array_length(item_cost)-2){
    i += 1;
    if (shop != "warships"){
        item_cost[i] *= 2;
    }
    if (rene != 1){
		item_cost[i]*=mechanicus_modifier;
        if (obj_controller.tech_status=="heretics"){
            tech_heretic_modifier = 1.05;
            item_cost[i]*=tech_heretic_modifier
        }
	}
	item_cost[i] *= forge_master_modifier;
    item_cost[i] = ceil(item_cost[i]);
}

item_cost_tooltip_info = "";
item_cost_tooltip_info += $"Modifier from forge Master : X{forge_master_modifier}/n"
item_cost_tooltip_info += $"Mechanicus Relations : X{mechanicus_modifier}/n"
item_cost_tooltip_info += $"Chapter tech approach (obj_controller.tech_status) : X{tech_heretic_modifier}/n"


/* */
/*  */
