function scr_trade_add(argument0) {

	// argument0: item

	var tomp1,thinz;
	tomp1=0;thinz=0;
	if (trade_take[4]="") then thinz=4;if (trade_take[3]="") then thinz=3;if (trade_take[2]="") then thinz=2;if (trade_take[1]="") then thinz=1;


	

	if (thinz!=0){
	    trade_take[thinz]=argument0;
    
	    if (argument0="Requisition"){get_diag_integer("Requisition wanted?",100000,"t"+string(thinz),"Requisition");}
	    if (argument0="Terminator Armour"){get_diag_integer("Terminator Armour wanted?",5,"t"+string(thinz),"Terminator Armour");}
	    if (argument0="Tartaros"){trade_tnum[thinz]=1;tomp1=1;}
	    if (argument0="Land Raider"){trade_tnum[thinz]=1;tomp1=1;}
	    if (argument0="Castellax Battle Automata"){trade_tnum[thinz]=1;tomp1=1;}
    
	    if (argument0="Minor Artifact"){trade_tnum[thinz]=1;tomp1=1;}
	    if (argument0="Skitarii"){get_diag_integer("Skitarii wanted?",1000,"t"+string(thinz),"Skitarii");}
	    if (argument0="Techpriest"){trade_tnum[thinz]=3;tomp1=3;}
    
	    // if (argument0="Storm Trooper"){trade_tnum[thinz]=get_integr("Number of Storm Troopers?",10);tomp1=100;}
	    if (argument0="Recruiting Planet"){trade_tnum[thinz]=1;tomp1=1;}
	    if (argument0="License: Repair"){trade_tnum[thinz]=1;tomp1=1;}
	    if (argument0="License: Crusade"){trade_tnum[thinz]=1;tomp1=1;}
    
	    if (argument0="Eldar Power Sword"){get_diag_integer("Eldar Power Swords wanted?",5,"t"+string(thinz),"Eldar Power Sword");}
	    if (argument0="Archeotech Laspistol"){trade_tnum[thinz]=1;tomp1=1;}
	    if (argument0="Ranger"){get_diag_integer("Eldar Rangers wanted?",5,"t"+string(thinz),"Ranger");}
	    if (argument0="Useful Information"){
	        var woj;woj=trade_take[1]+trade_take[2]+trade_take[3]+trade_take[4];
	        if (string_count("Useful Info",woj)=1){trade_tnum[thinz]=1;tomp1=1;}
	        if (string_count("Useful Info",woj)>1){trade_tnum[thinz]=0;tomp1=0;trade_take[thinz]="";}
	    }
    
        // TODO: Condemnor Boltgun trade dialog disabled due to weapon being temporarily removed.
        // Re-enable when the weapon is properly implemented.
        // if (argument0="Condemnor Boltgun"){get_diag_integer("Condemnor Boltguns wanted?",20,"t"+string(thinz),"Condemnor Boltgun");}
	    if (argument0="Hellrifle"){get_diag_integer("Hellrifles wanted?",3,"t"+string(thinz),"Hellrifle");}
	    if (argument0="Incinerator"){get_diag_integer("Incinerators wanted?",10,"t"+string(thinz),"Incinerator");}
	    if (argument0="Crusader"){get_diag_integer("Crusaders wanted?",5,"t"+string(thinz),"Crusader");}
	    if (argument0="Exterminatus"){trade_tnum[thinz]=1;tomp1=1;}
	    if (argument0="Cyclonic Torpedo"){trade_tnum[thinz]=1;tomp1=1;}
	    if (argument0="Eviscerator"){get_diag_integer("Eviscerators wanted?",10,"t"+string(thinz),"Eviscerator");}
	    if (argument0="Heavy Flamer"){get_diag_integer("Heavy Flamers wanted?",10,"t"+string(thinz),"Heavy Flamer");}
	    if (argument0="Inferno Bolts"){trade_tnum[thinz]=20;tomp1=20;}
	    if (argument0="Sister of Battle"){get_diag_integer("Sisters of Battle wanted?",3,"t"+string(thinz),"Sister of Battle");}
	    if (argument0="Sister Hospitaler"){trade_tnum[thinz]=1;tomp1=1;}
    
	    if (argument0="Power Klaw"){get_diag_integer("Power Klaws wanted?",5,"t"+string(thinz),"Power Klaw");}
	    if (argument0="Ork Sniper"){get_diag_integer("Ork Snipers wanted?",20,"t"+string(thinz),"Ork Sniper");}
	    if (argument0="Flash Git"){get_diag_integer("Flash Gitz wanted?",6,"t"+string(thinz),"Flash Git");}
    
	    if (argument0="Test"){trade_tnum[thinz]=1;tomp1=1;}
    
	    // if (trade_tnum[thinz]=0){trade_tnum[thinz]=0;trade_take[thinz]="";}
	    // if (trade_tnum[thinz]>tomp1) then trade_tnum[thinz]=tomp1;
	}

	cooldown=8;
	scr_trade(false);


}
