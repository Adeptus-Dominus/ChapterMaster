if (num > 0) {
    // Hmmmmmmm
    var stah;
    stah = instance_nearest(x, y, obj_star);
    obj_controller.menu = 0;

    if (planet_feature_bool(stah.p_feature[num], P_features.STC_Fragment) == 1) {
        // STC is present
        if ((tch > 0) && (mch == 0)) {
            var pop, own;
            pop = instance_create(0, 0, obj_popup);
            pop.image = "stc";
            pop.title = "STC Fragment Located";

            if (stah.p_owner[num] != 3) {
                pop.text = "An STC Fragment has been located upon " + string(stah.name) + " " + string(num) + "; what it might contain is unknown.  Your " + string(obj_ini.role[100][16]) + "s wish to reclaim, identify, and put it to use immediately.  What is thy will?";
            }
            if (stah.p_owner[num] == 3) {
                pop.text = "An STC Fragment has been located upon " + string(stah.name) + " " + string(num) + "; what it might contain is unknown.  It appears to be located deep within a Mechanicus Vault.  Taking it may be seen as an act of war.  What is thy will?";
            }

            own = stah.p_owner[num];
            pop.option1 = "Swiftly take the STC Fragment.";
            pop.option2 = "Leave it.";
        }
        if ((tch > 0) && (mch > 0)) {
            if (stah.p_owner[num] != 3) {
                var pop, own;
                pop = instance_create(0, 0, obj_popup);
                pop.image = "stc";
                pop.title = "STC Fragment Located";
                // pop.text="An STC Fragment has been located upon "+string(stah.name)+" "+string(num)+".  Your "+string(obj_ini.role[100][16])+"s and present Mechanicus Techpriests are bickering over what should be done with it.  What is thy will?";

                pop.text = "An STC Fragment has been located upon " + string(stah.name) + " " + string(num) + ".  Your " + string(obj_ini.role[100][16]) + "s wish to reclaim, identify, and put it to use immediately, and the Tech Priests wish to send it to the closest forge world.  What is thy will?";
                // if (stah.p_owner[num]=3) then pop.text="An STC Fragment has been located upon "+string(stah.name)+" "+string(num)+".  It appears to be located deep within a Mechanicus Vault.  The present Tech Priests warn that taking it will be seen as an act of war.  What is thy will?";

                own = stah.p_owner[num];
                pop.option1 = "Swiftly take the STC Fragment.";
                pop.option2 = "Leave it.";
                pop.option3 = "Send it to the Adeptus Mechanicus.";
            }
        }
        if ((tch == 0) && (mch > 0)) {
            if (stah.p_owner[num] != 3) {
                var pop, own;
                pop = instance_create(0, 0, obj_popup);
                pop.image = "stc";
                pop.title = "STC Fragment Located";
                pop.text = "An STC Fragment has been located upon " + string(stah.name) + " " + string(num) + "; what it might contain is unknown.  The present Tech Priests wish to send it to Mars, and refuse to take the device off-world otherwise.";

                own = stah.p_owner[num];
                pop.option1 = "Leave it.";
                pop.option2 = "Send it to the Adeptus Mechanicus.";
            }
        }
        if ((mch > 0) && (stah.p_owner[num] == 3)) {
            var pop, own;
            pop = instance_create(0, 0, obj_popup);
            pop.image = "stc";
            pop.title = "STC Fragment Located";
            pop.text = "An STC Fragment has been located upon " + string(stah.name) + " " + string(num) + ".  It appears to be located deep within a Mechanicus Vault.  The present Tech Priests stress they will not condone a mission to steal the STC Fragment.";

            own = stah.p_owner[num];

            scr_return_ship(loc, id, num);
            var man_size, ship_id, comp, plan, i;
            i = 0;
            ship_id = 0;
            man_size = 0;
            comp = 0;
            plan = 0;
            repeat (30) {
                i += 1;
                if (obj_ini.ship[i] == loc) {
                    ship_id = i;
                }
            }
            i = 0;
            obj_controller.menu = 0;
            obj_controller.managing = 0;
            obj_controller.cooldown = 10;
            instance_destroy();
            exit;

            // pop.option1="Leave it.";
            // get bitched at by the mechanicus
        }

        pop.ma_co = tch;
        pop.ma_id = mch;
        pop.target_comp = stah.p_owner[num];
    }

    if (planet_feature_bool(stah.p_feature[num], P_features.Artifact) == 1) {
        // Artifact is present
        if ((stah.p_type[num] == "Dead") || (stah.p_owner[num] == 1)) {
            alarm[4] = 1;
            exit;
        }

        var pop, own;
        pop = instance_create(0, 0, obj_popup);
        pop.image = "artifact";
        pop.title = "Artifact Located";
        pop.text = "The Artifact has been located upon " + string(stah.name) + " " + string(num) + "; its condition and class are unlikely to be determined until returned to the ship.  What is thy will?";

        own = stah.p_owner[num];

        // show_message(own);

        if ((stah.p_first[num] == 3) && (stah.p_owner[num] > 5)) {
            if (stah.p_pdf[num] > 0) {
                own = 3;
            }
        }

        pop.option1 = "Request audience with the ";
        if (own == 1) {
            pop.option1 += "Planetary Governor";
            pop.option3 = "Gift the Artifact to the Sector Commander.";
        }
        if (own == 2) {
            pop.option1 += "Planetary Governor";
            pop.option3 = "Gift the Artifact to the Sector Commander.";
        }
        if (own == 3) {
            pop.option1 += "Mechanicus";
            pop.option3 = "Let it be.  The Mechanicus' wrath is not lightly provoked.";
        }
        if (own == 4) {
            pop.option1 += "Inquisition";
            pop.option3 = "Let it be.  The Inquisition's wrath is not lightly provoked.";
        }
        if (own == 5) {
            pop.option1 += "Ecclesiarchy";
            pop.option3 = "Gift the Artifact to the Ecclesiarchy.";
        }
        if (own == 6) {
            pop.option1 += "Eldar";
            pop.option3 = "Gift the Artifact to the Eldar.";
        }
        if (own == 8) {
            pop.option1 += "Tau";
            pop.option3 = "Gift the Artifact to the Tau Empire.";
        }

        pop.option1 += " regarding the Artifact.";
        pop.option2 = "Swiftly take the Artifact.";
        pop.target_comp = stah.p_owner[num];

        if ((own >= 9) || ((own == 7) && (stah.p_pdf[num] <= 0))) {
            pop.option1 = "Swiftly take the Artifact.";
            pop.option2 = "Let it be.";
            pop.option3 = "";
        }

        // show_message(string(pop.option1)+"/"+string(pop.option2)+"/"+string(pop.option3));

        /*if (pop.option1=""){
            pop.option1="Swiftly take the Artifact.";
            pop.option2="Let it be.";
            pop.option3="";
        }*/
    }
}

/* */
/*  */
