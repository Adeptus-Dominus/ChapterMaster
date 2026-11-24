target = noone;
planet = noone;
/// @type {Struct.PlanetData|undefined}
p_data = undefined;

lair = false;
arsenal = false;
gene_vault = false;

isnew = false;
forge = false;
hippo = false;
beastarium = false;
torture = false;
narcotics = false;
relic = 0;
cookery = false;
vox = false;
librarium = false;
throne = false;
stasis = false;
stasis_occupants = "";
swimming = false;

static set_planet_data = function(_p_data){
	self.p_data = _p_data;
	var planet_upgrades = p_data.upgrades;
	secret_base = planet_feature_bool(planet_upgrades, eP_FEATURES.SECRET_BASE));
	arsenal = planet_feature_bool(planet_upgrades, eP_FEATURES.ARSENAL));
	gene_vault = planet_feature_bool(planet_upgrades, eP_FEATURES.GENE_VAULT));
	lair_exists = gene_vault || arsenal || secret_base;
    if (!lair_exists) {
        title = localize("Build");
    } else {
        if (secret_base) {
            title = localize("Secret Lair");
        } else if (arsenal) {
            title = localize("Secret Arsenal");
        } else if (gene_vault) {
            title = localize("Secret Gene-Vault");
        }
        title += " {_p_data.name()}"
    }
}