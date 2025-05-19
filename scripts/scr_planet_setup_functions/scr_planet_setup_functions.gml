


function setup_forge_world(star, planet, dock = 0){
	with(star){
        planet[forge_planet]=1;
        p_type[forge_planet]="Forge";
        owner = eFACTION.Mechanicus;
        p_owner[forge_planet] = owner;
        p_first[forge_planet] = owner;

	}
}

function setup_tau_world(star, planet){
    p_owner[planet] = eFACTION.Tau;
    owner = eFACTION.Tau;
    p_influence[planet][eFACTION.Tau]=70;
    owner = eFACTION.Tau;
}