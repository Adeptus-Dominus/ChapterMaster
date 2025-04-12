 /**
 * * obj_creation is used as part of the main menu new game and chapter creation logic
 * It contains data and logic for setting up custom chapters as well as populating the new game menu with data for pre-existing chapters.
 */
keyboard_string="";
try{
    load_visual_sets();
} catch(_exception){
    handle_exception(_exception);
}

#region Global Settings: volume, fullscreen etc
ini_open("saves.ini");
master_volume=ini_read_real("Settings","master_volume",1);
effect_volume=ini_read_real("Settings","effect_volume",1);
music_volume=ini_read_real("Settings","music_volume",1);
large_text=ini_read_real("Settings","large_text",0);
settings_heresy=ini_read_real("Settings","settings_heresy",0);
settings_fullscreen=ini_read_real("Settings","fullscreen",1);
settings_window_data=ini_read_string("Settings","window_data","fullscreen");
ini_close();
#endregion

#region Icon Grid settings for chapter selection
icon_width = 48;
icon_height = 48;
/// distance between 2 rows of icons in the grid
icon_row_gap = 60;
/// distance between section heading and icon grid row
icon_gap_y = 34;
/// distance between columns in icon grid
icon_gap_x = 53;
/// x coord of left edge of the icon grid
icon_grid_left_edge = 441;
/// Max number of columns of icons until a new row is made
max_cols = 10;
/// x coord of the right edge of the icon grid
icon_grid_right_edge = function() {return icon_grid_left_edge + (icon_gap_x * max_cols -1)}; // icon_gap_x * max number of desired columns - 1
/// y coord of Founding section heading
founding_y = 133;
/// y coord of Successor section heading
successor_y = 250;
/// y coord of Custom section heading
custom_y = 463;
/// y coord of Other section heading
other_y = 593;
marine_surface = surface_create(600, 600);
var show_debug = false;
if(show_debug){
    show_debug_overlay(true);
    dbg_view("obj_creation_dbg", true);
    dbg_section("Icon Grid");
    ref_to_max_cols = ref_create(self, "max_cols");
    ref_to_icon_width = ref_create(self, "icon_width");
    ref_to_icon_height = ref_create(self, "icon_height");
    ref_to_icon_grid_left_edge = ref_create(self, "icon_grid_left_edge");
    ref_to_icon_gap_y = ref_create(self, "icon_gap_y");
    ref_to_icon_gap_x = ref_create(self, "icon_gap_x");
    ref_to_icon_row_gap = ref_create(self, "icon_row_gap");
    dbg_slider_int(ref_to_max_cols,1,15);
    dbg_slider_int(ref_to_icon_width,1,100);
    dbg_slider_int(ref_to_icon_height,1,100);
    dbg_slider_int(ref_to_icon_grid_left_edge,1,1000);
    dbg_slider_int(ref_to_icon_gap_y,1,300);
    dbg_slider_int(ref_to_icon_gap_x,1,300);
    dbg_slider_int(ref_to_icon_row_gap,1,300);

    dbg_section("Heading Positions")
    ref_to_founding_y = ref_create(self, "founding_y");
    ref_to_successor_y = ref_create(self, "successor_y");
    ref_to_custom_y = ref_create(self, "custom_y");
    ref_to_other_y = ref_create(self, "other_y");
    dbg_slider_int(ref_to_founding_y,1,1000);
    dbg_slider_int(ref_to_successor_y,1,1000);
    dbg_slider_int(ref_to_custom_y,1,1000);
    dbg_slider_int(ref_to_other_y,1,1000);
}
#endregion

window_data=string(window_get_x())+"|"+string(window_get_y())+"|"+string(window_get_width())+"|"+string(window_get_height())+"|";
window_old=window_data;
if (window_get_fullscreen()=1){
	window_old="fullscreen";
	window_data="fullscreen";
}
restarted=0;
custom_icon=0;

/// Stores the chapter icon in one spot so we dont have to keep checking whether we're using a custom image or not every time we wanna display it somewhere
global.chapter_icon_sprite = spr_icon_chapters;
global.chapter_icon_frame = 0;
global.chapter_icon_path = "";
global.chapter_id = 0;


audio_stop_all();
audio_play_sound(snd_diboz,0,true);
audio_sound_gain(snd_diboz, 0, 0);
var nope=0;
if (master_volume=0) or (music_volume=0) then nope=1;
if (nope!=1){
	audio_sound_gain(snd_diboz,0.25*master_volume*music_volume,2000);
}

global.load=-1;
planet_types = ARR_planet_types;
skip=false;
premades=true;

/// Opt in/out of loading from json vs hardcoded for specific chapters, this way i dont have to do all in one go to test
use_chapter_object = false;

livery_picker = new ColourItem(100,230);
livery_picker.scr_unit_draw_data();
full_liveries = "";
company_liveries = "";
complex_livery=false;
complex_selection = "sgt";
complex_depth_selection = 0;
//TODO probably make this array based at some point ot match other unit data
complex_livery_data = complex_livery_default();
left_data_slate = new DataSlate();
right_data_slate = new DataSlate();
standard_livery_components = 0;
enum LiveryComponents{
	Body,
	Helm,
	Trim,
}
test_sprite = 0;
fade_in=50;
slate1=80;
slate2=0;
slate3=-2;
slate4=0;
slate5=0;
slate6=0;
mouse_left=0;
mouse_right=0;
change_slide=0;
goto_slide=1;
highlight=0;
highlighting=0;
old_highlight=0;
/// 1 = select chap, 2 = name, strength, adv/disadv, 3 = homeworld, discipline, 4 = livery, 5 = mutations, disposition, 6 = chapter master
slide=1;
slide_show=1;
cooldown=0;
name_bad=0;
heheh=0;
icons_top=1;
icons_max=0;
turn_selection_change=false;
draw_helms = true;

buttons = {
    home_world_recruit_share : new ToggleButton(),
    complex_homeworld : new ToggleButton({
        x1 : 550,
        y1 :  422,
        active : false,
        str1 : "Spawn System Options",
        tooltip : "Click for Complex Spawn System Options",
        button_color : #009500,
    }),
    home_spawn_loc_options : new radio_set([
        {
            str1 : "Fringe",
            font : fnt_40k_30b,
            tooltip : "Your home system sits at the edge of the sector",
        },
        {
            str1 : "Central",
            font : fnt_40k_30b,
            tooltip : "Your home system is relativly central in the sector",
        },        
    ], "Home Spwan\nLocation"),

    recruit_home_relationship : new radio_set([
        {
            str1 : "Share Planet",
            font : fnt_40k_14b,
            tooltip : "Your recruit world will be the same planet as your home world",
        },
        {
            str1 : "Share System",
            font : fnt_40k_14b,
            tooltip : "Your recruit world will be in the the same system as your home world",
        },
        {
            str1 : "Seperate",
            font : fnt_40k_14b,
            tooltip : "Your recruit world will be in a different system to your homeworld",
        },            
    ], "Recruit world"),
    home_warp : new radio_set([
        {
            str1 : "Secluded",
            font : fnt_40k_14b,
            tooltip : "Your home system is logistically secluded with no major warp routes",
        },
        {
            str1 : "Connected",
            font : fnt_40k_14b,
            tooltip : "Your home system is connected to the larger imperium and system by warp routes",
        },
        {
            str1 : "Warp Hub",
            font : fnt_40k_14b,
            tooltip : "Your home system is in a very stable warp area, accessible by several warp lanes",
        },            
    ], "Home warp access"),
    home_planets : new radio_set([
        {
            str1 : "one",
            font : fnt_40k_14b,
        },
        {
            str1 : "two",
            font : fnt_40k_14b
        },
        {
            str1 : "three",
            font : fnt_40k_14b
        }, 
        {
            str1 : "four",
            font : fnt_40k_14b
        },                    
    ], "Home System Planets"), 

    culture_styles : new multi_select([
        {
            str1 : "Greek",
            font : fnt_40k_14b,
        },
        {
            str1 : "Roman",
            font : fnt_40k_14b
        },
        {
            str1 : "Knightly",
            font : fnt_40k_14b
        },
        {
            str1 : "Gladiator",
            font : fnt_40k_14b
        },         
        {
            str1 : "Mongol",
            font : fnt_40k_14b
        },
        {
            str1 : "Feral",
            font : fnt_40k_14b
        },
        {
            str1 : "Flame Cult",
            font : fnt_40k_14b
        },
        {
            str1 : "Mechanical Cult",
            font : fnt_40k_14b
        },
        {
            str1 : "Prussian",
            font : fnt_40k_14b
        },
        {
            str1 : "Ganger (cthonian)",
            font : fnt_40k_14b
        },
        {
            str1 : "Alpha",
            font : fnt_40k_14b
        },
        {
            str1 : "Ultra",
            font : fnt_40k_14b
        },
        {   
            str1 : "Renaissance",
            font : fnt_40k_14b,
        },
        {   
            str1 : "Blood",
            font : fnt_40k_14b,
        },
        {   
            str1 : "Angelic",
            font : fnt_40k_14b,
        },
        {   
            str1 : "Crusader",
            font : fnt_40k_14b,
        },
        {   
            str1 : "Gothic",
            font : fnt_40k_14b,
        },
        {   
            str1 : "Wolf Cult",
            font : fnt_40k_14b,
        },
        {   
            str1 : "Runic",
            font : fnt_40k_14b,
        },                                                                                      
    ], "Chapter Visual Styles"),
    company_options_toggle : new UnitButtonObject({
        tooltip : "toggle between chapter or role settings",
        label : "Company Settings",
        company_view : false,
    }),
    company_liveries_choice : new radio_set([
        {
            str1 : "HQ",
            font : fnt_40k_14b
        },
        {
            str1 : "I",
            font : fnt_40k_14b,
        },
        {
            str1 : "II",
            font : fnt_40k_14b
        },
        {
            str1 : "III",
            font : fnt_40k_14b
        }, 
        {
            str1 : "IV",
            font : fnt_40k_14b
        },
        {
            str1 : "V",
            font : fnt_40k_14b
        },
        {
            str1 : "VI",
            font : fnt_40k_14b
        },
        {
            str1 : "VII",
            font : fnt_40k_14b
        },
        {
            str1 : "VIII",
            font : fnt_40k_14b
        },
        {
            str1 : "IX",
            font : fnt_40k_14b
        },
        {
            str1 : "X",
            font : fnt_40k_14b
        },                    
    ], "Companies"),
}

with (buttons){
    home_spawn_loc_options.current_selection = 1;
    home_planets.current_selection = 1;
    home_warp.current_selection = 1;
    recruit_home_relationship.current_selection = 1;
    company_liveries_choice.current_selection = 1;
}

text_bars = {
    battle_cry : new TextBarArea(920,118, 450),
    admiral : new TextBarArea(890,685, 580,true),
}

scrollbar_engaged=0;

text_selected="none";
text_bar=0;
tooltip="";
tooltip2="";
popup="";
temp=0;
target_gear=0;
tab=0;
role_names_all="";

// 
chapter_name="Unnamed";
chapter_string="Unnamed";
chapter_year=0;
icon=1;
icon_name="da";
/// @instancevar {Real} custom 0 if premade, 1 if random, 2 if custom
custom=0;
/// @instancevar {Enum.ePROGENITOR} founding 
founding=1;
chapter_tooltip="";
points=0;
maxpoints=100;
/// @instancevar {Enum.eFLEET_TYPES} fleet_type 
fleet_type=1;
strength=5;
cooperation=5;
purity=5;
stability=90;


var i = 9;

homeworld="Temperate";
homeworld_name=global.name_generator.generate_star_name();
recruiting="Death";
recruiting_name=global.name_generator.generate_star_name();
flagship_name=global.name_generator.generate_imperial_ship_name();
recruiting_exists=1;
homeworld_exists=1;
homeworld_rule=1;
aspirant_trial=eTrials.BLOODDUEL;
discipline="librarius";

battle_cry="For the Emperor";

main_color=1;secondary_color=1;main_trim=1;
left_pauldron=1;right_pauldron=1;// Left/Right pauldron
lens_color=1;weapon_color=1;col_special=0;trim=1;
skin_color=0;

color_to_main="";
color_to_secondary="";
color_to_trim="";
color_to_pauldron="";
color_to_pauldron2="";
color_to_lens="";
color_to_weapon="";

hapothecary=global.name_generator.generate_space_marine_name();
hchaplain=global.name_generator.generate_space_marine_name();
clibrarian=global.name_generator.generate_space_marine_name();
fmaster=global.name_generator.generate_space_marine_name();
honorcapt=global.name_generator.generate_space_marine_name();		//1st
watchmaster=global.name_generator.generate_space_marine_name();		//2nd
arsenalmaster=global.name_generator.generate_space_marine_name();	//3rd
admiral=global.name_generator.generate_space_marine_name();			//4th
marchmaster=global.name_generator.generate_space_marine_name();		//5th
ritesmaster=global.name_generator.generate_space_marine_name();		//6th
victualler=global.name_generator.generate_space_marine_name();		//7th
lordexec=global.name_generator.generate_space_marine_name();		//8th
relmaster=global.name_generator.generate_space_marine_name();		//9th
recruiter=global.name_generator.generate_space_marine_name();		//10th




equal_specialists=0;
load_to_ships=[2,0,0];

successors=0;

mutations=0;mutations_selected=0;
preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;

disposition[0]=0;
disposition[1]=0;// Prog
disposition[2]=0;// Imp
disposition[3]=0;// Mech
disposition[4]=0;// Inq
disposition[5]=0;// Ecclesiarchy
disposition[6]=0;// Astartes
disposition[7]=0;// Reserved

chapter_master_name=global.name_generator.generate_space_marine_name();
chapter_master_melee=1;
chapter_master_ranged=1;
chapter_master_specialty=2;

chapter_made = false;


enum eCHAPTERS {
    UNKNOWN = 0,
    DARK_ANGELS = 1,
    WHITE_SCARS,
    SPACE_WOLVES,
    IMPERIAL_FISTS,
    BLOOD_ANGELS,
    IRON_HANDS,
    ULTRAMARINES,
    SALAMANDERS,
    RAVEN_GUARD,

    BLACK_TEMPLARS = 10,
    MINOTAURS,
    BLOOD_RAVENS,
    CRIMSON_FISTS,
    LAMENTERS,
    CARCHARODONS,
    SOUL_DRINKERS,

    ANGRY_MARINES = 17,
    EMPERORS_NIGHTMARE,
    STAR_KRAKENS,
    CONSERVATORS,

    CUSTOM_1 = 21,
    CUSTOM_2 = 22,
    CUSTOM_3 = 23,
    CUSTOM_4 = 24,
    CUSTOM_5 = 25,
    CUSTOM_6 = 26,
    CUSTOM_7 = 27,
    CUSTOM_8 = 28,
    CUSTOM_9 = 29,
    CUSTOM_10 = 30
}
enum eCHAPTER_ORIGINS {
    NONE,
    FOUNDING,
    SUCCESSOR,
    NON_CANON,
    CUSTOM
}

/**
 * @description chapter constructor. This is just for the main menu bit, the full data comes in scr_chapter_new
 * @param {Enum.eCHAPTERS} _id e.g. CHAPTERS.DARK_ANGELS
 * @param {Enum.eCHAPTER_ORIGINS} _origin e.g. CHAPTER_ORIGIN.FOUNDING 
 * @param {Enum.eCHAPTERS} _progenitor This chapter's founding chapter, if one exits. Use 0 if none.
 * @param {String} _name e.g. "Dark Angels" 
 * @param {String} _tooltip e.g. "Some extremely lore friendly backstory"
 */
function ChapterDataLite(_id, _origin,_progenitor, _name , _tooltip) constructor {
    id = _id;
    origin = _origin;
    name = _name;
    progenitor = _progenitor;
    tooltip = _tooltip;
    disabled = false;
    json = false;
    loaded = true;
    icon = _id;
    splash = _id;
}

// For new additions, as long as the order in the array is the same as the enum order,
//you will be able to index the array by using syntax like so: `var dark_angels = all_chapters[CHAPTERS.DARK_ANGELS]`
all_chapters = [
    new ChapterDataLite(eCHAPTERS.UNKNOWN, eCHAPTER_ORIGINS.NONE, 0, "Unknown", "Error: The tooltip is missing"),
    new ChapterDataLite(eCHAPTERS.DARK_ANGELS, eCHAPTER_ORIGINS.FOUNDING, 0, "Dark Angels", 
    "The Dark Angels claim complete allegiance and service to the Emperor of Mankind, though their actions and secret goals seem to run counter to this- above all other things they strive to atone for an ancient crime of betrayal."),
    new ChapterDataLite(eCHAPTERS.WHITE_SCARS, eCHAPTER_ORIGINS.FOUNDING, 0, "White Scars", "Known and feared for their highly mobile way of war, the White Scars are the masters of lightning strikes and hit-and-run tactics.  They are particularly adept in the use of Attack Bikes and field large numbers of them."),
    new ChapterDataLite(eCHAPTERS.SPACE_WOLVES, eCHAPTER_ORIGINS.FOUNDING, 0, "Space Wolves", "Brave sky warriors hailing from the icy deathworld of Fenris, the Space Wolves are a non-Codex compliant chapter, and deadly in close combat.  They fight on their own terms and damn any who wish otherwise." ),
    new ChapterDataLite(eCHAPTERS.IMPERIAL_FISTS, eCHAPTER_ORIGINS.FOUNDING, 0, "Imperial Fists", "Siege-masters of utmost excellence, the Imperial Fists stoicism has lead them to great victories and horrifying defeats. To them, the idea of a tactical retreat is utterly inconsiderable. They hold ground on Inwit vigilantly, refusing to back down from any fight."),
    new ChapterDataLite(eCHAPTERS.BLOOD_ANGELS, eCHAPTER_ORIGINS.FOUNDING, 0,"Blood Angels", "One of the most noble and renowned chapters, their combat record belies a dark flaw in their gene-seed caused by the death of their primarch. Their primarch had wings and a propensity for close combat, and this shows in their extensive use of jump packs and close quarters weapons."),
    new ChapterDataLite(eCHAPTERS.IRON_HANDS, eCHAPTER_ORIGINS.FOUNDING, 0,"Iron Hands","The flesh is weak, and the weak shall perish. Such is the creed of these mercilessly efficient cyborg warriors. A chapter with strong ties to the Mechanicum, they crush the foes of the Emperor and Machine God alike with a plethora of exotic technology and ancient weaponry."),
    new ChapterDataLite(eCHAPTERS.ULTRAMARINES, eCHAPTER_ORIGINS.FOUNDING, 0,"Ultramarines","An honourable and venerated chapter, the Ultramarines are considered to be amongst the best of the best. Their Primarch was the author of the great tome of the “Codex Astartes”, and they are considered exemplars of what a perfect Space Marine Chapter should be like."),
    new ChapterDataLite(eCHAPTERS.SALAMANDERS, eCHAPTER_ORIGINS.FOUNDING, 0,"Salamanders", "Followers of the Promethean Cult, the jet-black skinned Salamanders are forgemasters of legend. They are armed with the best wargear available and prefer flame based weaponry. Their only drawback is their low numbers and slow recruiting."),
    new ChapterDataLite(eCHAPTERS.RAVEN_GUARD, eCHAPTER_ORIGINS.FOUNDING, 0,"Raven Guard","Clinging to the shadows and riding the edge of lightning the Raven Guard strike out at the hated enemy with stealth and speed. Using lightning strikes, hit and run tactics, and guerrilla warfare, they are known for being there one second and gone the next."),
    new ChapterDataLite(eCHAPTERS.BLACK_TEMPLARS, eCHAPTER_ORIGINS.SUCCESSOR, eCHAPTERS.IMPERIAL_FISTS, "Black Templars","Not adhering to the Codex Astartes, Black Templars are a Chapter on an Eternal Crusade with unique organization and high numbers. Masters of assault, they charge at the enemy with zeal unmatched. They hate psykers, and as such, have no Librarians."),
    new ChapterDataLite(eCHAPTERS.MINOTAURS, eCHAPTER_ORIGINS.SUCCESSOR, eCHAPTERS.IMPERIAL_FISTS, "Minotaurs","Bronze-clad Astartes of unknown Founding, the Minotaurs prefer to channel their righteous fury in a massive storm of fire, with tanks and artillery. They could be considered the Inquisition’s attack dog, since they often attack fellow chapters suspected of heresy."),
    new ChapterDataLite(eCHAPTERS.BLOOD_RAVENS, eCHAPTER_ORIGINS.SUCCESSOR,0, "Blood Ravens","Of unknown origins and Founding, the origins of the Blood Ravens are shrouded in mystery and are believed to be tied to a dark truth. This elusive Chapter is drawn to the pursuit of knowledge and ancient lore and produces an unusually high number of Librarians."),
    new ChapterDataLite(eCHAPTERS.CRIMSON_FISTS, eCHAPTER_ORIGINS.SUCCESSOR, eCHAPTERS.IMPERIAL_FISTS ,"Crimson Fists","An Imperial Fists descendant, the Crimson Fists are more level-minded than their Progenitor and brother chapters.  They suffer the same lacking zygotes as their ancestors, and more resemble the Ultramarines in their balanced approach to combat. After surviving a devastating Ork WAAAGH! the chapter clings dearly to its future."),
    new ChapterDataLite(eCHAPTERS.LAMENTERS, eCHAPTER_ORIGINS.SUCCESSOR, eCHAPTERS.BLOOD_ANGELS,"Lamenters","The Lamenter's accursed and haunted legacy seems to taint much of what they have achieved; their victories often become bitter ashes in their hands.  Nearly extinct, they fight their last days on behalf of the common folk in a crusade of endless penitence."),
    new ChapterDataLite(eCHAPTERS.CARCHARODONS, eCHAPTER_ORIGINS.SUCCESSOR, eCHAPTERS.RAVEN_GUARD, "Carcharodons","Rumored to be Successors of the Raven Guard, these Astartes are known for their sudden attacks and shock assaults. Travelling through the Imperium via self-sufficient Nomad-Predation based fleets, no enemy is safe from the fury of these bloodthirsty Space Marines."),
    new ChapterDataLite(eCHAPTERS.SOUL_DRINKERS, eCHAPTER_ORIGINS.SUCCESSOR,eCHAPTERS.IMPERIAL_FISTS, "Soul Drinkers","Sharing ancestry of the Black Templars or Crimson fists. As proud sons of Dorn they share the strong void combat traditions, fielding a large amount of Battle Barges. As well as being fearsome in close combat. Whispers of the Ruinous Powers are however quite enticing."),
    new ChapterDataLite(eCHAPTERS.ANGRY_MARINES, eCHAPTER_ORIGINS.NON_CANON,0, "Angry Marines","Frothing with pathological rage since the day their Primarch emerged from his pod with naught but a dented copy of battletoads.  Every last Angry Marine is a homicidal, suicidal berserker with a voice that projects, and are always angry, all the time.  A /tg/ classic."),
    new ChapterDataLite(eCHAPTERS.EMPERORS_NIGHTMARE, eCHAPTER_ORIGINS.NON_CANON,0, "Emperor’s Nightmare","The Emperor's Nightmare bear the curse of a bizarre mutation within their gene-seed. The Catalepsean Node is in a state of decay and thus do not sleep for months at a time until falling asleep suddenly. They prefer shock and awe tactics with stealth."),
    new ChapterDataLite(eCHAPTERS.STAR_KRAKENS, eCHAPTER_ORIGINS.NON_CANON,0, "Star Krakens","In darkness, they dwell in The Deep. The Star Krakens stand divided in individual companies but united in the form of the Ten-Flag Council. They utilize boarding tactics and are the sole guardians of the ancient sensor array called “The Lighthouse”."),
    new ChapterDataLite(eCHAPTERS.CONSERVATORS, eCHAPTER_ORIGINS.NON_CANON,0, "Conservators","Hailing from the Asharn Marches and having established their homeworld on the planet Dekara, these proud sons of Dorn suffer from an extreme lack of supplies, Ork raids, and more. Though under strength and lacking equipment, they managed to forge an interstellar kingdom loyal to both Emperor and Imperium."),
    new ChapterDataLite(eCHAPTERS.CUSTOM_1, eCHAPTER_ORIGINS.CUSTOM,0,"Custom","Your Chapter"),
    new ChapterDataLite(eCHAPTERS.CUSTOM_2, eCHAPTER_ORIGINS.CUSTOM,0,"Custom","Your Chapter"),
    new ChapterDataLite(eCHAPTERS.CUSTOM_3, eCHAPTER_ORIGINS.CUSTOM,0,"Custom","Your Chapter"),
    new ChapterDataLite(eCHAPTERS.CUSTOM_4, eCHAPTER_ORIGINS.CUSTOM,0,"Custom","Your Chapter"),
    new ChapterDataLite(eCHAPTERS.CUSTOM_5, eCHAPTER_ORIGINS.CUSTOM,0,"Custom","Your Chapter"),
    new ChapterDataLite(eCHAPTERS.CUSTOM_6, eCHAPTER_ORIGINS.CUSTOM,0,"Custom","Your Chapter"),
    new ChapterDataLite(eCHAPTERS.CUSTOM_7, eCHAPTER_ORIGINS.CUSTOM,0,"Custom","Your Chapter"),
    new ChapterDataLite(eCHAPTERS.CUSTOM_8, eCHAPTER_ORIGINS.CUSTOM,0,"Custom","Your Chapter"),
    new ChapterDataLite(eCHAPTERS.CUSTOM_9, eCHAPTER_ORIGINS.CUSTOM,0,"Custom","Your Chapter"),
    new ChapterDataLite(eCHAPTERS.CUSTOM_10, eCHAPTER_ORIGINS.CUSTOM,0,"Custom","Your Chapter"),
]

var missing_splash = 99;
var custom_splash = 97;
all_chapters[eCHAPTERS.EMPERORS_NIGHTMARE].splash = missing_splash;
all_chapters[eCHAPTERS.CONSERVATORS].splash = missing_splash;
all_chapters[eCHAPTERS.CUSTOM_1].splash = custom_splash;
all_chapters[eCHAPTERS.CUSTOM_1].loaded = false;
all_chapters[eCHAPTERS.CUSTOM_2].loaded = false;
all_chapters[eCHAPTERS.CUSTOM_3].loaded = false;
all_chapters[eCHAPTERS.CUSTOM_4].loaded = false;
all_chapters[eCHAPTERS.CUSTOM_5].loaded = false;
all_chapters[eCHAPTERS.CUSTOM_6].loaded = false;
all_chapters[eCHAPTERS.CUSTOM_7].loaded = false;
all_chapters[eCHAPTERS.CUSTOM_8].loaded = false;
all_chapters[eCHAPTERS.CUSTOM_9].loaded = false;
all_chapters[eCHAPTERS.CUSTOM_10].loaded = false;
all_chapters[eCHAPTERS.CUSTOM_2].splash = custom_splash;
all_chapters[eCHAPTERS.CUSTOM_3].splash = custom_splash;
all_chapters[eCHAPTERS.CUSTOM_4].splash = custom_splash;
all_chapters[eCHAPTERS.CUSTOM_5].splash = custom_splash;
all_chapters[eCHAPTERS.CUSTOM_6].splash = custom_splash;
all_chapters[eCHAPTERS.CUSTOM_7].splash = custom_splash;
all_chapters[eCHAPTERS.CUSTOM_8].splash = custom_splash;
all_chapters[eCHAPTERS.CUSTOM_9].splash = custom_splash;
all_chapters[eCHAPTERS.CUSTOM_10].splash = custom_splash;



global.normal_icons_count = 0;
// Load from files to overwrite hardcoded ones
for(var c = 1; c < 40; c++){
    var use_app_data = false;
    if(c < array_length(all_chapters) && all_chapters[c].origin == eCHAPTER_ORIGINS.CUSTOM){
        use_app_data = true;
    }
    var json_chapter = new ChapterData();
    var success = json_chapter.load_from_json(c, use_app_data); 
    if(success){
        all_chapters[c] = new ChapterDataLite(
            json_chapter.id,
            json_chapter.origin,
            json_chapter.founding,
            json_chapter.name,
            json_chapter.flavor,
        );
        all_chapters[c].json = true;
        all_chapters[c].icon = json_chapter.icon;
        all_chapters[c].icon_name = json_chapter.icon_name;
        all_chapters[c].splash = json_chapter.splash;
        all_chapters[c].loaded = true;
        all_chapters[c].disabled = false;
    }
    
    var icon = file_exists($"{working_directory}\\images\\creation\\chapters\\icons\\{c}.png");
    if(icon) {
        // show_debug_message($"icon {c}.png exists");
        global.normal_icons_count += 1;
    }
}

global.chapters_count = array_length(all_chapters);

/** 
 * * Not all Chapters are implemented yet, disable the ones that arent, remove a line if the chapter gets made
 */
all_chapters[eCHAPTERS.UNKNOWN].disabled = true; //this should always be disabled, it exists for array indexing purposes for now
all_chapters[eCHAPTERS.EMPERORS_NIGHTMARE].disabled = true;
all_chapters[eCHAPTERS.STAR_KRAKENS].disabled = true;
all_chapters[eCHAPTERS.CONSERVATORS].disabled = true;

founding_chapters = array_filter(all_chapters, function(item){ return item.origin == eCHAPTER_ORIGINS.FOUNDING});
successor_chapters = array_filter(all_chapters, function(item){ return item.origin == eCHAPTER_ORIGINS.SUCCESSOR});
custom_chapters = array_filter(all_chapters, function(item){ return item.origin == eCHAPTER_ORIGINS.CUSTOM});
other_chapters = array_filter(all_chapters, function(item){ return item.origin == eCHAPTER_ORIGINS.NON_CANON});
// show_debug_message($"founding: {founding_chapters}");
// show_debug_message($"successor: {successor_chapters}");
// show_debug_message($"custom: {custom_chapters}");
// show_debug_message($"other: {other_chapters}");


// TODO refactor into struct constructors stored in which are struct arrays 

// meta provides a universal way to control not having contradictory advatages and disadvantages
// the player can not have any two advantages or disadvatages taht have the same piece of meta thus removing clunky checks in the draw sequence
chapter_trait_meta = [];
function ChapterTrait(_id, _name, _description, _points_cost, _meta = []) constructor{

    id = _id;
    name = _name;
    description = _description;
    points = _points_cost;
    disabled = false;
    meta = _meta;

    static add_meta = function(){
        for (var i=0;i<array_length(meta);i++){
            array_push(obj_creation.chapter_trait_meta, meta[i]);
        }
        show_debug_message($"Meta updated, added: {meta}, all meta: {obj_creation.chapter_trait_meta}");

    }
    static remove_meta = function(){
        for (var i=0;i<array_length(meta);i++){
            var len = array_length(obj_creation.chapter_trait_meta);
            for (var s=0;s<len;s++){
                if (obj_creation.chapter_trait_meta[s]==meta[i]){
                    array_delete(obj_creation.chapter_trait_meta, s, 1);
                    s--;
                    len--;
                }
            }
        }
        show_debug_message($"Meta updated, removed: {meta}, all meta: {obj_creation.chapter_trait_meta}");
    }

    static print_meta = function(){
        if(array_length(meta) ==0){
            return "None";
        } else {
            return string_join_ext(", ", meta);
        }
    }

}

function Advantage(_id, _name, _description, _points_cost) : ChapterTrait(_id, _name, _description, _points_cost) constructor {

    static add = function(slot){
        show_debug_message($"Adding adv {name} to slot {slot} for points {points}");
        obj_creation.adv[slot] = name;
        obj_creation.adv_num[slot] = id;
        obj_creation.points+=points;
        add_meta();
    }
    static remove = function(slot){
        show_debug_message($"removing adv {name} from slot {slot} for points {points}");
        obj_creation.adv[slot] = "";
        obj_creation.points-=points;
        obj_creation.adv_num[slot]=0;
        remove_meta();
    }

    static disable = function(){
        var is_disabled= false;
        for (var i=0;i<array_length(meta);i++){
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])){
                is_disabled = true;
            }
        }
        if(obj_creation.points + points > obj_creation.maxpoints){
            is_disabled = true;
        }
        return is_disabled;
    }

}
function Disadvantage(_id, _name, _description, _points_cost) : ChapterTrait(_id, _name, _description, _points_cost) constructor {

    static add = function(slot){
        show_debug_message($"Adding disadv {name} to slot {slot} for points {points}");
        obj_creation.dis[slot] = name;
        obj_creation.dis_num[slot] = id;
        obj_creation.points-=points;
        add_meta();
    }

    static remove = function(slot){
        show_debug_message($"Removing disadv {name} from slot {slot} for points {points}");
        obj_creation.dis[slot] = "";
        obj_creation.points+=points;
        obj_creation.dis_num[slot]=0;
        remove_meta();
    }

    static disable = function(){
        var is_disabled= false;
        for (var i=0;i<array_length(meta);i++){
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])){
                is_disabled = true;
            }
        }
        return is_disabled;
    }
}

//later we can use json maybe
/// @type {Array<Struct.Advantage>}
obj_creation.all_advantages = [];
var all_advantages = [
        {
            name : "",
            description : "",
            value : 0,
        },
        {
            name : "Ambushers",
            description : "Your chapter is especially trained with ambushing foes; they have a bonus to attack during the start of a battle.",
            value : 30,
        },
        {
            name : "Boarders",
            description : "Boarding other ships is the specialty of your chapter.  Your chapter is more lethal when boarding ships, have dedicated boarding squads, and two extra strike cruisers.",
            value : 30,
        },
        {
            name : "Bolter Drilling",
            description : "Bolter drills are sacred to your chapter; all marines have increased attack with Bolter weaponry.",
            value : 40,
            meta : ["Weapon Specialty"]
        },
        {
            name : "Retinue of Renown",
            description : "Your chapter master is guarded by renown heroes of the chapter.  You start with a larger well-equipped Honour Guard.",
            value : 20,
        },
        {
            name : "Crafters",
            description : "Your chapter views artifacts as sacred; you start with better gear and maintain all equipment with more ease.",
            value : 40,
            meta : ["Gear Quality"]
        },
        {
            name : "Enemy: Eldar",
            description : "Eldar are particularly hated by your chapter.  When fighting Eldar damage is increased.",
            value : 20,
            meta : ["Main Enemy"],
        },
        {
            name : "Enemy: Fallen",
            description : "Chaos Marines are particularly hated by your chapter.  When fighting the traitors damage is increased.",
            value : 20,
            meta : ["Main Enemy"],
        },
        {
            name : "Enemy: Necrons",
            description : "Necrons are particularly hated by your chapter.  When fighting Necrons damage is increased.",
            value : 20,
            meta : ["Main Enemy"],
        },  
        {
            name : "Enemy: Orks",
            description : "Orks are particularly hated by your chapter.  When fighting Orks damage is increased.",
            value : 20,
            meta : ["Main Enemy"]
        },
        {
            name : "Enemy: Tau",
            description : "Tau are particularly hated by your chapter.  When fighting Tau damage is increased.",
            value : 20,
            meta : ["Main Enemy"],
        },
        {
            name : "Enemy: Tyranids",
            description : "Tyranids are particularly hated by your chapter. A large number of your veterans and marines are tyrannic war veterans and when fighting Tyranids damage is increased.",
            value : 20,
            meta : ["Main Enemy"],
        },
        {
            name : "Kings of Space",
            description : "Veterans of naval combat, your chapter fleet has bonuses to offense, defence, an additional battle barge, and may always be controlled regardless of whether or not the Chapter Master is present.",
            value : 40,
            meta : ["Naval"],
        },
        {
            name : "Lightning Warriors",
            description : "Your chapter's style of warfare is built around the speedy execution of battle. Infantry have boosted attack at the cost of defense as well as two additional Land speeders and Biker squads.",
            value : 30,
            meta : ["Doctrine"],
        },
        {
            name : "Paragon",
            description : "You are a pale shadow of the primarchs.  Larger, stronger, faster, your Chapter Master is on a higher level than most, gaining additional health and combat effectiveness.",
            value : 10,
            meta : ["Chapter Master"],
        },
        {
            name : "Warp Touched", //TODO: This is probably can be better handled as a positive seed mutation;
            description : "Psychic mutations run rampant in your chapter. You have more marines with high psychic rating and aspirants are also more likely to be capable of harnessing powers of the warp.",
            value : 20,
            meta : ["Psyker Views","Librarians"],
        },
        {
            name : "Favoured By The Warp",
            description : "Many marines in your chapter are favoured by the powers of the warp, making perils of the warp happen less frequently for them.",
            value : 20,
        },
        {
            name : "Reverent Guardians",
            description : "Your chapter places great faith in the Imperial Cult; you start with more Chaplains and any Ecclesiarchy disposition increases are enhanced.",
            value : 20,
            meta : ["Faith","Imperium Trust"],
        },
        {
            name : "Tech-Brothers",
            description : "Your chapter has better ties to the mechanicus; you have more techmarines and higher mechanicus disposition.",
            value : 20,
            meta : ["Mechanicus Faith"],
        }, 
        {
            name : "Tech-Scavengers",
            description : "Your Astartes have a knack for finding what has been lost.  Items and wargear are periodically found and added to the Armamentarium.",
            value : 30,
        },
        {
            name : "Siege Masters",
            description : "Your chapter is familiar with the ins-and-outs of fortresses.  They are better at defending and attacking fortifications. And better at garrisoning",
            value : 20,
        },
        {
            name : "Devastator Doctrine",
            description : "The steady advance of overwhelming firepower is your chapters combat doctrine each company has an additional Devastator squad, all infantry have boosted defence, and heavy weapons have increased attack.",
            value : 40,
            meta : ["Doctrine"],
        },
        {
            name : "Assault Doctrine",
            description : "Your chapter prefers quick close quarter assaults on the enemy each Company has an additional Assault Squad and your marines are more skilled in melee.",
            value : 20,
            meta : ["Doctrine"],
        },
        {
            name : "Venerable Ancients",
            description : "Even in death they still serve. Your chapter places a staunch reverence for its forebears and has a number of additional venerable dreadnoughts in service.",
            value : 40,
            meta : ["Doctrine"],
        },
        {
            name : "Medicae Primacy",
            description : "Your chapter reveres its Apothecarion above all of it's specialist; You start with more Apothecaries.",
            value : 20,
            meta : ["Apothecaries"]
        },
        {
            name : "Ryzan Patronage",
            description : "Your chapter has strong ties to the Forgeworld of Ryza as a result your Techmarines are privy to the secrets of their Techpriests enhancing your Plasma and Las weaponry.",
            value : 40,
            meta : ["Weapon Specialty"] 
        },
        {
            name: "Elite Guard",
            description: "Your chapter is an elite fighting force comprised almost exclusively of Veterans. All Tactical Marines are replaced by Veterans.",
            value: 150,
            meta: ["Specialists"]
        }                                                                                                                                                                   
    ]


var new_adv,cur_adv;
for (var i=0;i<array_length(all_advantages);i++){
    cur_adv = all_advantages[i];
    new_adv = new Advantage(i, cur_adv.name, cur_adv.description, cur_adv.value);
    if (struct_exists(cur_adv, "meta")){
        new_adv.meta = cur_adv.meta;
    }
    array_push(obj_creation.all_advantages, new_adv);
}


//advantage[i]="Battle Cousins";
//advantage_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;
//advantage[i]="Comrades in Arms";
//advantage_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;

/// @type {Array<Struct.Disadvantage>}
var all_disadvantages = [
    {
        name : "",
        description : "",
        value : 0,
    },
    {
        name : "Black Rage",
        description : "Your marines are susceptible to Black Rage, having a chance each battle to become Death Company.  These units are locked as Assault Marines and are fairly suicidal.",
        value : 30,
    },
    {
        name : "Blood Debt",
        description : "Prevents your Chapter from recruiting new Astartes until enough of your marines, or enemies, have been killed.  Incompatible with Penitent chapter types.",
        value : 50,
    },
    {
        name : "Depleted Gene-seed Stocks",
        description : "Your chapter has lost its gene-seed stocks in recent engagement. You start with no gene-seed.",
        value : 20,
    },
    {
        name : "Fresh Blood",
        description : "Due to being newly created your chapter has little special wargear or psykers.",
        value : 20,
        meta : ["Status"],
    }, 
    {
        name : "Never Forgive",
        description : "In the past traitors broke off from your chapter.  They harbor incriminating secrets or heritical beliefs, and as thus, must be hunted down whenever possible.",
        value : 20,
    },
    {
        name : "Shitty Luck",
        description: "This is actually really helpful and beneficial for your chapter.  Trust me.",
        value: 20,
    },
    {
        name : "Sieged",
        description : "A recent siege has reduced the number of your marines greatly.  You retain a normal amount of equipment but some is damaged.",
        value : 40,
        meta : ["Status"],
    },
    {
        name : "Splintered",
        description : "Your marines are unorganized and splintered.  You require greater time to respond to threats en masse.",
        value : 10,
        meta : ["Location"],
    },
    {
        name : "Suspicious",
        description : "Some of your chapter's past actions or current practices make the inquisition suspicious.  Their disposition is lowered.",
        value : 10,
        meta : ["Imperium Trust"],
    },
    {
        name : "Tech-Heresy",
        description : "Your chapter does things that makes the Mechanicus upset.  Mechanicus disposition is lowered and you have less Tech Marines. You start as a tech heretic tolerant chapter",
        value : 20,
        meta : ["Mechanicus Faith"],
    },
    {
        name : "Tolerant",
        description : "Your chapter is more lenient with xenos.  All xeno disposition is slightly increased and all Imperial disposition is lowered.",
        value : 10,
    },
    {
        name : "Warp Tainted",
        description : "Your chapter is tainted by the warp. Many of your marines are afflicted with it, making getting caught in perils of the warp less likely, but when caught - the results are devastating.",
        value : 20,
    },
    {
        name : "Psyker Intolerant",
        description : "Witches are hated by your chapter.  You cannot create Librarians but gain a little bonus attack against psykers.",
        value : 30,
        meta : ["Psyker Views"],
    },
    {
        name : "Obliterated",
        description : "A recent string of unfortunate events has left your chapter decimated. You have very little left, will your story continue?",
        value : 80,
        meta : ["Status"],
    },
    {
        name : "Poor Equipment",
        description : "Whether due to being cut off from forge worlds or bad luck, your chapter no longer has enough high quality gear to go around. Your elite troops will have to make do with standard armour.",
        value: 10,
        meta : ["Gear Quality"]
    },
    {
        name : "Enduring Angels",
        description : "The Chapter's journey thus far has been arduous & unforgiving leaving them severely understrength yet not out of the fight. You begin with 5 fewer company's",
        value : 30,
        meta : ["Status"],
    },
    {
        name : "Serpents Delight",
        description : "Sleeper cells infiltrated your chapter. When they rose up for the decapitation strike,they slew the 5 most experienced company's and many of the HQ staff before being defeated",
        value : 50,
        meta : ["Status"],
    },
    {
        name : "Weakened Apothecarion",
        description : "Many of your chapter's Apothecaries have fallen in recent battles whether due to their incompetence or deliberate targetting.",
        value : 20,
        meta : ["Apothecaries"],
    },
    {
        name : "Small Reclusiam",
        description : "Your chapter cares little for its reclusiam compared to other chapters fewer marines have shown the desire to be chaplains.",
        value : 20, 
        meta : ["Faith"],
    },
    {
        name : "Barren Librarius",
        description : "Your chapter has a smaller Librarius compared to other chapters due to having fewer potent psykers.",
        value : 20,
        meta : ["Psyker Views","Librarians"],
    },
]

obj_creation.all_disadvantages = []
var new_dis,cur_dis;
for (var i=0;i<array_length(all_disadvantages);i++){
    cur_dis = all_disadvantages[i];
    new_dis = new Disadvantage(i, cur_dis.name, cur_dis.description, cur_dis.value);
    if (struct_exists(cur_dis, "meta")){
        new_dis.meta = cur_dis.meta;
    }
    array_push(obj_creation.all_disadvantages, new_dis);
}

adv = array_create(9, "");
dis = array_create(9, "");
adv_num = array_create(9, 0);
dis_num = array_create(9, 0);

// disadvantage[i]="Embargo";dis_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;// Greatly increases the cost of common wargear and disallows advanced items.
// disadvantage[i]="First In, Last Out";dis_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;
// disadvantage[i]="Rival Brotherhood";dis_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;

// Default Marine Loadouts
for(var slot = 99; slot <= 103; slot++){
    for(var i = 0; i <= 50; i++){
        race[slot,i]=1;
        loc[slot,i]="";
        role[slot,i]="";
        wep1[slot,i]="";
        wep2[slot,i]="";
        armour[slot,i]="";
        gear[slot,i]="";
        mobi[slot,i]="";
    }
}

defaults_slot = 100;

function load_default_gear(_role_id, _role_name, _wep1, _wep2, _armour, _mobi, _gear){
    role[defaults_slot, _role_id] = _role_name;
    wep1[defaults_slot, _role_id] = _wep1;
    wep2[defaults_slot, _role_id] = _wep2;
    armour[defaults_slot, _role_id] = _armour;
    mobi[defaults_slot, _role_id] = _mobi;
    gear[defaults_slot, _role_id] = _gear;
    race[defaults_slot, _role_id] = 1;
}
load_default_gear(eROLE.HonourGuard, "Honour Guard", "Power Sword", "Bolter", "Artificer Armour", "", "");
load_default_gear(eROLE.Veteran, "Veteran", "Combiflamer", "Combat Knife", "Power Armour", "", "");
load_default_gear(eROLE.Terminator, "Terminator", "Power Fist", "Storm Bolter", "Terminator Armour", "", "");
load_default_gear(eROLE.Captain, "Captain", "Power Sword", "Bolt Pistol", "Power Armour", "", "Iron Halo");
load_default_gear(eROLE.Dreadnought, "Dreadnought", "Dreadnought Lightning Claw", "Lascannon", "Dreadnought", "", "");
load_default_gear(eROLE.Champion, "Champion", "Power Sword", "Bolt Pistol", "Power Armour", "", "Combat Shield");
load_default_gear(eROLE.Tactical, "Tactical", "Bolter", "Combat Knife", "Power Armour", "", "");
load_default_gear(eROLE.Devastator, "Devastator", "", "Combat Knife", "Power Armour", "", "");
load_default_gear(eROLE.Assault, "Assault", "Chainsword", "Bolt Pistol", "Power Armour", "Jump Pack", "");
load_default_gear(eROLE.Ancient, "Ancient", "Company Standard", "Bolt Pistol", "Power Armour", "", "");
load_default_gear(eROLE.Scout, "Scout", "Bolter", "Combat Knife", "Scout Armour", "", "");
load_default_gear(eROLE.Chaplain, "Chaplain", "Crozius Arcanum", "Bolt Pistol", "Power Armour", "", "Rosarius");
load_default_gear(eROLE.Apothecary, "Apothecary", "Chainsword", "Bolt Pistol", "Power Armour", "", "Narthecium");
load_default_gear(eROLE.Techmarine, "Techmarine", "Power Axe", "Bolt Pistol", "Artificer Armour", "Servo-arm", "");
load_default_gear(eROLE.Librarian, "Librarian", "Force Staff", "Bolt Pistol", "Power Armour", "", "Psychic Hood");
load_default_gear(eROLE.Sergeant, "Sergeant", "Chainsword", "Bolt Pistol", "Power Armour", "", "");
load_default_gear(eROLE.VeteranSergeant, "Veteran Sergeant", "Chainsword", "Plasma Pistol", "Power Armour", "", "");

builtin_icons = array_length(sprite_get_info(spr_icon_chapters).frames);
normal_and_builtin = global.normal_icons_count + builtin_icons;
total_icons = global.normal_icons_count + builtin_icons + global.custom_icons;



if (global.restart>0){
    fade_in=-1;
    slate1=-1;
    slate=22;
    slate3=22;
    slate4=50;
    
    change_slide=0;
    slide=2;
    slide_show=2;
    
    reset_creation_variables();
    //with(obj_restart_vars){instance_destroy();}
    global.restart=0;
}

/* */
col = [];
col_r = [];
col_g = [];
col_b = [];

scr_colors_initialize();

/// todo turn this into an array of structs with dynamic access
/// todo change references to colours by number to use the Colours enum

	colour_to_find1 = shader_get_uniform(sReplaceColor, "f_Colour1");
	colour_to_set1 = shader_get_uniform(sReplaceColor, "f_Replace1");
	body_colour_find=[0/255,0/255,255/255];
	body_colour_replace=[
		col_r[main_color]/255,
		col_g[main_color]/255,
		col_b[main_color]/255,

	]

	colour_to_find2 = shader_get_uniform(sReplaceColor, "f_Colour2");
	colour_to_set2 = shader_get_uniform(sReplaceColor, "f_Replace2");
	secondary_colour_find=[255/255,0/255,0/255];
	secondary_colour_replace=[
		col_r[secondary_color]/255,
		col_g[secondary_color]/255,
		col_b[secondary_color]/255,

	];

	colour_to_find3 = shader_get_uniform(sReplaceColor, "f_Colour3");
	colour_to_set3 = shader_get_uniform(sReplaceColor, "f_Replace3");

	pauldron_colour_find=[255/255,255/255,0/255];
	pauldron_colour_replace=[
		col_r[right_pauldron]/255,
		col_g[right_pauldron]/255,
		col_b[right_pauldron]/255,

	];

	colour_to_find4 = shader_get_uniform(sReplaceColor, "f_Colour4");
	colour_to_set4 = shader_get_uniform(sReplaceColor, "f_Replace4");
	lens_colour_find=[0/255,255/255,0/255];
	lens_colour_replace=[
		col_r[lens_color]/255,
		col_g[lens_color]/255,
		col_b[lens_color]/255,

	];

	colour_to_find5 = shader_get_uniform(sReplaceColor, "f_Colour5");
	colour_to_set5 = shader_get_uniform(sReplaceColor, "f_Replace5");
	trim_colour_find=[255/255,0/255,255/255];
	trim_colour_replace=[
		col_r[main_trim]/255,
		col_g[main_trim]/255,
		col_b[main_trim]/255,
	];

	colour_to_find6 = shader_get_uniform(sReplaceColor, "f_Colour6");
	colour_to_set6 = shader_get_uniform(sReplaceColor, "f_Replace6");
	pauldron2_colour_find=[250/255,250/255,250/255];
	pauldron2_colour_replace=[
		col_r[left_pauldron]/255,
		col_g[left_pauldron]/255,
		col_b[left_pauldron]/255,

	];

	colour_to_find7 = shader_get_uniform(sReplaceColor, "f_Colour7");
	colour_to_set7 = shader_get_uniform(sReplaceColor, "f_Replace7");

	weapon_colour_find=[0/255,255/255,255/255];
	weapon_colour_replace=[
		col_r[weapon_color]/255,
		col_g[weapon_color]/255,
		col_b[weapon_color]/255,
	];
/* */
action_set_alarm(30, 1);
/*  */

