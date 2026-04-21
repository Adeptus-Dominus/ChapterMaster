function scr_lines_increase(argument0) {
    // argument0 = how many times the lines should be moved within the combat object

    repeat (argument0) {
        lines[50] = "";
        lin = 0;
        repeat (50) {
            lin += 1;
            lines[lin] = lines[lin + 1];
            lines_color[lin] = lines_color[lin + 1];

            if (string_count("Defeated", lines[lin]) == 1) {
                lines_color[lin] = "yellow";
            }
            // lines[lin-1]=lines[lin];
        }
    }

    /*
	repeat(argument0){
	    lines[30]="";lin=0;
	    repeat(30){lin+=1;
	        lines[lin]=lines[lin+1];
	        // lines[lin-1]=lines[lin];
	    }
	}
	*/

    /*if (liness<30){
	    repeat(argument0){
	        var j;j=29;
	        repeat(29){j-=1;
	            lines[j]=lines[j-1];
	        }
	    }
	    var lin;lin=0;
	    repeat(30){lin+=1;
	        if (string_length(lines[lin])<2) then lines[lin]="     ";
	    }
	}*/

    /*var lin, num;lin=0;num=argument0;
	repeat(30){
	    lin+=1;num+=1;
	    if (num<30){
	        lines[lin]=lines[lin+1];
	    }
	}

	var lin;lin=0;
	repeat(30){lin+=1;
	    if (string_length(lines[lin])<2) then lines[lin]="     ";
	}
	*/

    /*
	var lin, num;lin=30;num=argument0;
	repeat(30){
	    lin-=1;num-=1;if (num<0) then exit;
	    lines[lin]=lines[lin-1];
	}

	var lin;lin=0;
	repeat(30){
	    lin+=1;
	    if (string_length(lines[lin])<2) then lines[lin]="     ";
	}*/
}
