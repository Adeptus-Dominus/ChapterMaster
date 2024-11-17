

if (num>0){// Hmmmmmmm
    var stah;stah=instance_nearest(x,y,obj_star);

    if (planet_feature_bool(stah.p_feature[num], P_features.Artifact)==1){// Artifact is present
        var pop;
        pop=instance_create(0,0,obj_popup);
        pop.image="artifact2";
        pop.title="Artifact Located";
        pop.text="Trading for the the Artifact on "+string(stah.name)+" "+string(num)+" has not been fruitful.  What is thy will?";
        
        if (stah.p_owner[num]=2){pop.option2="Gift the Artifact to the Sector Commander.";}
        if (stah.p_owner[num]=3){pop.option2="Let it be.  The Mechanicus' wrath is not lightly provoked.";}
        if (stah.p_owner[num]=4){pop.option2="Let it be.  The Inquisition's wrath is not lightly provoked.";}
        
        if (stah.p_owner[num]>4) then pop.option2="Let it be.";
        
        if (stah.p_owner[num]=5){pop.option2="Gift the Artifact to the Ecclesiarchy.";}
        if (stah.p_owner[num]=6){pop.option2="Gift the Artifact to the Eldar.";}
        if (stah.p_owner[num]=8){pop.option2="Gift the Artifact to the Tau Empire.";}
        
        pop.option1="Swiftly take the Artifact.";
        pop.target_comp=stah.p_owner[num];
        
        if (stah.p_owner[num]>=9) or (stah.p_owner[num]=7){
            pop.option1="Swiftly take the Artifact.";
            pop.option2="Let it be.";
        }
        
    }
    

}

