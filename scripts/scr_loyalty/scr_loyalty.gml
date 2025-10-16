function scr_loyalty(argument0, argument1) {
	// argument0 = name
	// argument1 = todo

	// This adds the crime to the chapter history

	if (argument1="+"){
	    var noplus=0;
		for(var i=0; i<30; i++){
	        noplus=0;
			var amount=0;
        
	        if (obj_controller.loyal[i]=argument0){// Increases detection chance by a variable amount
	            
	            if (obj_controller.loyal_num[i]<1) then amount=0.03;
				
				switch(argument0){
					case "Xeno Associate":
		                if (obj_controller.loyal_num[i]=0) then amount=0.09;
		                if (obj_controller.loyal_num[i]!=0) then amount=0;
						break;
		            case "Lack of Apothecary": case "Upset Machine Spirits": case "Undevout":
		                if (obj_controller.loyal_num[i]=0) then amount=0.075;
		                if (obj_controller.loyal_num[i]!=0) then amount=0;
						break;
					case "Xeno Trade": amount=0.05; break;
					case "Irreverance for His Servants": amount=0.005; break;
					case "Heretic Contact": amount=0.099; break; // amount=0.01;
					case "Non-Codex Size": 
		                if (obj_controller.loyal_num[i]=0) then amount=0.06;
		                if (obj_controller.loyal_num[i]!=0) then amount=0;
						break;
					case "Mutant Gene-Seed":
		                if (obj_controller.loyal_num[i]=0) then amount=0.01;
		                if (obj_controller.loyal_num[i]!=0) then amount=0;
						break;
					case "Heretical Homeworld":
		                if (obj_controller.loyal_num[i]=0) then amount=0.07;
		                if (obj_controller.loyal_num[i]!=0) then amount=0;
						break;
					case "Inquisitor Killer":
		                if (obj_controller.loyal_num[i]=0) then amount=0.005;
		                if (obj_controller.loyal_num[i]!=0) then amount=0;
						break;
					case "Avoiding Inspections":
		                obj_controller.loyalty-=5;
		                obj_controller.loyalty_hidden-=5;
		                obj_controller.loyal_num[i]+=5;
		                obj_controller.loyal_time[i]=120;
		                amount=0;
						noplus=1;
						break;
					case "Lost Standard":
		                obj_controller.loyalty-=2;
		                obj_controller.loyalty_hidden-=2;
		                obj_controller.loyal_num[i]+=5;
		                obj_controller.loyal_time[i]=9999;
		                amount=0;
		                noplus=1;
		                break;
					case "Refusing to Crusade":
		                obj_controller.loyalty-=20;
		                obj_controller.loyalty_hidden-=20;
		                obj_controller.loyal_num[i]+=20;
		                obj_controller.loyal_time[i]=9999;
		                amount=0;
						noplus=1;
						break;
					case "Crossing the Inquisition":
		                obj_controller.loyalty-=40;
		                obj_controller.loyalty_hidden-=40;
		                obj_controller.loyal_num[i]+=40;
		                obj_controller.loyal_time[i]=9999;
		                amount=0;
						noplus=1;
						break;
					case "Use of Sorcery":
		                if (string_count("|SC|",obj_controller.useful_info)=0){
		                    obj_controller.loyalty-=30;
		                    obj_controller.loyalty_hidden-=30;
		                    obj_controller.loyal_num[i]+=30;
		                    obj_controller.loyal_time[i]=9999;
		                }
		                amount=0;noplus=1;var one;one=0;
		                obj_controller.useful_info+="|SC|";
						
                
		                if (obj_controller.disposition[4]>=50) and (one=0) and (string_count("|SC|",obj_controller.useful_info)=1){obj_controller.disposition[4]=20;one=1;}
		                if (obj_controller.disposition[4]<50)  and (string_count("|SC|",obj_controller.useful_info)=1) and (obj_controller.disposition[4]>10) and (one=0){obj_controller.disposition[4]=0;one=2;}
		                if (string_count("|SC|",obj_controller.useful_info)>1){obj_controller.disposition[4]=0;one=2;}
                
		                if (obj_controller.loyalty<=0) and (one<2) then one=2;
		                if (one=1) then with(obj_controller){scr_audience(4,"sorcery1",0,"",0,0);}
		                if (one>=2) and (obj_controller.penitent=0){repeat(2){obj_controller.useful_info+="|SC|";}scr_audience(4,"loyalty_zero",0,"",0,0);}
		                if (one>=2) and (obj_controller.penitent=1){repeat(2){obj_controller.useful_info+="|SC|";}obj_controller.alarm[8]=1;}
                
		                break;
				}
				
            
	            if (noplus=0) then obj_controller.loyal_num[i]+=amount;
	        }
	    }
	}

}
