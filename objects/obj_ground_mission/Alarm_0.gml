if (num > 0) {
    // Hmmmmmmm
    var stah;
    stah = instance_nearest(x, y, obj_star);
    obj_controller.menu = 0;

    if (planet_feature_bool(stah.p_feature[num], P_features.STCFragment) == 1) { // STC is present
        var pop, own;
        own = stah.p_owner[num];
        pop = instance_create(0, 0, obj_popup);
        pop.image = "stc";
        pop.title = "STC Fragment Located";

        if (own == eFACTION.Mechanicus) {
            if (mch > 0) {
                pop.text = $"An STC Fragment upon {stah.name} {num} appears to be located deep within a Mechanicus Vault. The present Tech Priests stress they will not condone a mission to steal the STC Fragment.";
                pop.option1 = "Leave it.";
            } else if (tch > 0) {
                pop.text = $"An STC Fragment upon {stah.name} {num} appears to be located deep within a Mechanicus Vault. Taking it may be seen as an act of war. What is thy will?";
                // pop.option1 = "Attempt to steal the STC Fragment."; // TODO: Fix this option, as it crashes the game when the battle starts;
                pop.option1 = "Leave it.";
            } else {
                pop.text = $"An STC Fragment upon {stah.name} {num} appears to be located deep within a Mechanicus Vault. Taking it may be seen as an act of war. The ground team has no Techmarines, so you have no choice but to leave it be.";
                pop.option1 = "Leave it.";
            }
        } else {
            if ((tch > 0) && (mch == 0)) {
                pop.text = $"An STC Fragment has been located upon {stah.name} {num}; what it might contain is unknown. Your {obj_ini.role[100][16]}s wish to reclaim, identify, and put it to use immediately. What is thy will?";
                pop.option1 = "Swiftly take the STC Fragment.";
                pop.option2 = "Leave it.";
                pop.option3 = "Send it to the Adeptus Mechanicus.";
            } else if (tch > 0 && mch > 0) {
                pop.text = $"An STC Fragment has been located upon {stah.name} {num}. Your {obj_ini.role[100][16]}s wish to reclaim, identify, and put it to use immediately, and the Tech Priests wish to send it to the closest forge world. What is thy will?";
                pop.option1 = "Swiftly take the STC Fragment.";
                pop.option2 = "Leave it.";
                pop.option3 = "Send it to the Adeptus Mechanicus.";
            } else if (tch == 0 && mch > 0) {
                pop.text = $"An STC Fragment has been located upon {stah.name} {num}; what it might contain is unknown. The present Tech Priests wish to send it to Mars, and refuse to take the device off-world otherwise.";
                pop.option1 = "Leave it.";
                pop.option2 = "Send it to the Adeptus Mechanicus.";
            } else {
                pop.text = $"An STC Fragment has been located upon {stah.name} {num}; what it might contain is unknown. The ground team has no {obj_ini.role[100][16]}s or Tech Priests, so you have no choice but to leave it be or notify the Mechanicus about its location.";
                pop.option1 = "Leave it.";
                pop.option2 = "Send it to the Adeptus Mechanicus.";
            }
        }
    }

    if (planet_feature_bool(stah.p_feature[num], P_features.Artifact) == 1) { // Artifact is present
        var own = stah.p_owner[num];

        if ((stah.p_type[num] == "Dead") || (own == eFACTION.Player)) {
            alarm[4] = 1;
            exit;
        }

        var pop = instance_create(0, 0, obj_popup);
        pop.image = "artifact";
        pop.title = "Artifact Located";
        pop.text = $"The Artifact has been located upon {stah.name} {num}; its condition and class are unlikely to be determined until returned to the ship. What is thy will?";
        pop.target_comp = stah.p_owner[num];

        if ((stah.p_first[num] == 3) && (stah.p_owner[num] > 5)) {
            if (stah.p_pdf[num] > 0) {
                own = eFACTION.Mechanicus;
            }
        }

        pop.option1 = "Request audience with the ";
        switch (own) {
            case eFACTION.Player:
            case eFACTION.Imperium:
                pop.option1 += "Planetary Governor";
                pop.option3 = "Gift the Artifact to the Sector Commander.";
                break;
            case eFACTION.Mechanicus:
                pop.option1 += "Mechanicus";
                pop.option3 = "Let it be.  The Mechanicus' wrath is not lightly provoked.";
                break;
            case eFACTION.Inquisition:
                pop.option1 += "Inquisition";
                pop.option3 = "Let it be.  The Inquisition's wrath is not lightly provoked.";
                break;
            case eFACTION.Ecclesiarchy:
                pop.option1 += "Ecclesiarchy";
                pop.option3 = "Gift the Artifact to the Ecclesiarchy.";
                break;
            case eFACTION.Eldar:
                pop.option1 += "Eldar";
                pop.option3 = "Gift the Artifact to the Eldar.";
                break;
            case eFACTION.Tau:
                pop.option1 += "Tau";
                pop.option3 = "Gift the Artifact to the Tau Empire.";
                break;
        }

        if ((own >= eFACTION.Tyranids) || ((own == eFACTION.Ork) && (stah.p_pdf[num] <= 0))) {
            pop.option1 = "Swiftly take the Artifact.";
            pop.option2 = "Let it be.";
            pop.option3 = "";
        } else {
            pop.option1 += " regarding the Artifact.";
            pop.option2 = "Swiftly take the Artifact.";
        }
    }
}
