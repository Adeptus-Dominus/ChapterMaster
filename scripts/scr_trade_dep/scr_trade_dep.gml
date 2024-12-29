function scr_trade_dep() {


	if (trade_goods="none") then exit;


	var g, n, r, temp1, temp2;
	r=-1;repeat(100){r+=1;g[r]="";n[r]=0;}

	temp1=0;temp2=string_count("|",trade_goods);

	explode_script(trade_goods,"|");
	r=0;repeat(temp2){r+=1;
	    g[r]=string(explode[r-1]);// show_message(string(g[r]));
	}
	r=0;repeat(temp2){r+=1;
	    explode_script(g[r],"!");g[r]=string(explode[0]);n[r]=real(explode[1]);
	    // show_message(string(g[r])+" x"+string(n[r]));
	}



	/*if (string_count("|",trade_goods)=4){
	    explode_script(trade_goods,"|");
	    g[1]=string(explode[0]);
	    g[2]=string(explode[1]);
	    g[3]=string(explode[2]);
	    g[4]=string(explode[3]);
    
	    explode_script(g[1],"!");g[1]=string(explode[0]);n[1]=real(explode[1]);
	    explode_script(g[2],"!");g[2]=string(explode[0]);n[2]=real(explode[1]);
	    explode_script(g[3],"!");g[3]=string(explode[0]);n[3]=real(explode[1]);
	    explode_script(g[4],"!");g[4]=string(explode[0]);n[4]=real(explode[1]);
	}*/




	/*if (string_count("|",trade_goods)=1){
	    explode_script(trade_goods,"|");
	    g[1]=string(explode[0]);
	    explode_script(g[1],"!");
	    g[1]=string(explode[0]);
	    n[1]=real(explode[1]);
	}
	if (string_count("|",trade_goods)=2){
	    explode_script(trade_goods,"|");
	    g[1]=string(explode[0]);
	    g[2]=string(explode[1]);
    
	    explode_script(g[1],"!");g[1]=string(explode[0]);n[1]=real(explode[1]);
	    explode_script(g[2],"!");g[2]=string(explode[0]);n[2]=real(explode[1]);
	}
	if (string_count("|",trade_goods)=3){
	    explode_script(trade_goods,"|");
	    g[1]=string(explode[0]);
	    g[2]=string(explode[1]);
	    g[3]=string(explode[2]);
    
	    explode_script(g[1],"!");g[1]=string(explode[0]);n[1]=real(explode[1]);
	    explode_script(g[2],"!");g[2]=string(explode[0]);n[2]=real(explode[1]);
	    explode_script(g[3],"!");g[3]=string(explode[0]);n[3]=real(explode[1]);
	}
	if (string_count("|",trade_goods)=4){
	    explode_script(trade_goods,"|");
	    g[1]=string(explode[0]);
	    g[2]=string(explode[1]);
	    g[3]=string(explode[2]);
	    g[4]=string(explode[3]);
    
	    explode_script(g[1],"!");g[1]=string(explode[0]);n[1]=real(explode[1]);
	    explode_script(g[2],"!");g[2]=string(explode[0]);n[2]=real(explode[1]);
	    explode_script(g[3],"!");g[3]=string(explode[0]);n[3]=real(explode[1]);
	    explode_script(g[4],"!");g[4]=string(explode[0]);n[4]=real(explode[1]);
	}
	if (string_count("|",trade_goods)=5){
	    explode_script(trade_goods,"|");
	    g[1]=string(explode[0]);
	    g[2]=string(explode[1]);
	    g[3]=string(explode[2]);
	    g[4]=string(explode[3]);
	    g[5]=string(explode[4]);
    
	    explode_script(g[1],"!");g[1]=string(explode[0]);n[1]=real(explode[1]);
	    explode_script(g[2],"!");g[2]=string(explode[0]);n[2]=real(explode[1]);
	    explode_script(g[3],"!");g[3]=string(explode[0]);n[3]=real(explode[1]);
	    explode_script(g[4],"!");g[4]=string(explode[0]);n[4]=real(explode[1]);
	    explode_script(g[5],"!");g[5]=string(explode[0]);n[5]=real(explode[1]);
	}
	if (string_count("|",trade_goods)=6){
	    explode_script(trade_goods,"|");
	    g[1]=string(explode[0]);
	    g[2]=string(explode[1]);
	    g[3]=string(explode[2]);
	    g[4]=string(explode[3]);
	    g[5]=string(explode[4]);
	    g[6]=string(explode[5]);
    
	    explode_script(g[1],"!");g[1]=string(explode[0]);n[1]=real(explode[1]);
	    explode_script(g[2],"!");g[2]=string(explode[0]);n[2]=real(explode[1]);
	    explode_script(g[3],"!");g[3]=string(explode[0]);n[3]=real(explode[1]);
	    explode_script(g[4],"!");g[4]=string(explode[0]);n[4]=real(explode[1]);
	    explode_script(g[5],"!");g[5]=string(explode[0]);n[5]=real(explode[1]);
	    explode_script(g[6],"!");g[6]=string(explode[0]);n[6]=real(explode[1]);
	}
	if (string_count("|",trade_goods)=7){
	    explode_script(trade_goods,"|");
	    g[1]=string(explode[0]);
	    g[2]=string(explode[1]);
	    g[3]=string(explode[2]);
	    g[4]=string(explode[3]);
	    g[5]=string(explode[4]);
	    g[6]=string(explode[5]);
	    g[7]=string(explode[6]);
    
	    explode_script(g[1],"!");g[1]=string(explode[0]);n[1]=real(explode[1]);
	    explode_script(g[2],"!");g[2]=string(explode[0]);n[2]=real(explode[1]);
	    explode_script(g[3],"!");g[3]=string(explode[0]);n[3]=real(explode[1]);
	    explode_script(g[4],"!");g[4]=string(explode[0]);n[4]=real(explode[1]);
	    explode_script(g[5],"!");g[5]=string(explode[0]);n[5]=real(explode[1]);
	    explode_script(g[6],"!");g[6]=string(explode[0]);n[6]=real(explode[1]);
	    explode_script(g[7],"!");g[7]=string(explode[0]);n[7]=real(explode[1]);
	}
	if (string_count("|",trade_goods)=8){
	    explode_script(trade_goods,"|");
	    g[1]=string(explode[0]);
	    g[2]=string(explode[1]);
	    g[3]=string(explode[2]);
	    g[4]=string(explode[3]);
	    g[5]=string(explode[4]);
	    g[6]=string(explode[5]);
	    g[7]=string(explode[6]);
	    g[8]=string(explode[7]);
    
	    explode_script(g[1],"!");g[1]=string(explode[0]);n[1]=real(explode[1]);
	    explode_script(g[2],"!");g[2]=string(explode[0]);n[2]=real(explode[1]);
	    explode_script(g[3],"!");g[3]=string(explode[0]);n[3]=real(explode[1]);
	    explode_script(g[4],"!");g[4]=string(explode[0]);n[4]=real(explode[1]);
	    explode_script(g[5],"!");g[5]=string(explode[0]);n[5]=real(explode[1]);
	    explode_script(g[6],"!");g[6]=string(explode[0]);n[6]=real(explode[1]);
	    explode_script(g[7],"!");g[7]=string(explode[0]);n[7]=real(explode[1]);
	    explode_script(g[8],"!");g[8]=string(explode[0]);n[8]=real(explode[1]);
	}*/


	// show_message(string(n[1])+"x "+string(g[1])+"#"+string(n[2])+"x "+string(g[2])+"#"+string(n[3])+"x "+string(g[3])+"#"+string(n[4])+"x "+string(g[4]));


	var i;i=0;
	repeat(temp2){
	    i+=1;temp1=0;
	    if (g[i]="Skitarii") or (g[i]="Techpriest") then temp1=1;
	    if (g[i]="Crusader") or (g[i]="Ranger") then temp1=1;
	    if (g[i]="Sister of Battle") or (g[i]="Sister Hospitaler") then temp1=1;
	    if (g[i]="Ork Sniper") or (g[i]="Flash Git") then temp1=1;
	    if (temp1=1){
	        repeat(n[i]){
	            scr_add_man(string(g[i]),0,"","",0,true,"default");
	        }
	    }
	    if (temp1=0) and (g[i]!="Requisition") and (g[i]!="Minor Artifact") then scr_add_item(string(g[i]),n[i]);
	    if (temp1=0) and (g[i]="Requisition") then obj_controller.requisition+=n[i];
	    if (temp1=0) and (g[i]="Minor Artifact"){
	        /*var rar;rar=floor(random(10))+1;
	        if (rar=1) then scr_add_item("Terminator Armour",1);
	        if (rar=2) then scr_add_item("Dreadnought",1);
	        if (rar=3) then scr_add_item(choose("Master Crafted Heavy Bolter","Master Crafted Plasma Pistol"),1);
	        if (rar=4) then scr_add_item("Iron Halo",1);
	        */
        
	        if (obj_ini.fleet_type=ePlayerBase.home_world) then scr_add_artifact("random_nodemon","minor",0,obj_ini.home_name,2);
	        if (obj_ini.fleet_type != ePlayerBase.home_world) then scr_add_artifact("random_nodemon","minor",0,obj_ini.ship[0],501);
	    }
	}


}
