
if (cooldown>=0) then cooldown-=1;
reset+=1;
if (reset>=50){
    slow=0;reset=0;
}

if (trickle>-1){
    var save_parts = 6;


    trickle-=1;
    if (trickle>0) then bar+= min(100, round(100/save_parts));
    if (trickle=0) then alarm[0]=1;
    
    if (bar>=100){trickle=-1;bar=100;alarm[0]=-1;alarm[1]=5;}
}

