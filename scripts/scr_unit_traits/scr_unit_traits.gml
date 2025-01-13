//TODO Jsonify

global.trait_list = {
	"champion":{
		weapon_skill : [10,5,"max"],      
		ballistic_skill:[10,5, "max"],
		display_name : "Champion",
		flavour_text : "Because of either natural talent, or obsessive training they are a master of arms",
		effect:"increase Melee Burden Cap"
	},
	"lightning_warriors":{
		constitution: -6,
		dexterity :6,
		weapon_skill : 5,
		flavour_text : "A master of speed covering distances quickly to enter the fray",
		display_name : "Lightning Warrior",
	},
	"slow_and_purposeful":{
		constitution:6,
		dexterity : -3,
		weapon_skill : -3,
		strength : 2,
		flavour_text : "Implacable, advancing in combat with methodical reason",
		display_name : "Slow and Purposeful",

	},
	"melee_enthusiast":{
		weapon_skill : 5,
		ballistic_skill: -5,
		strength : 3,		
		flavour_text : "Nothing can keep them from the fury of melee combat",	
		display_name : "Melee Enthusiast",

	},
	"shitty_luck":{
		luck:-4,
		flavour_text : "For all their talent they are dogged by poor luck",
		display_name : "Shitty Luck",
	},
	"very_hard_to_kill":{
		constitution:15,
		luck:2,
		flavour_text : "Posses toughness and luck unsurpassed by most",
		display_name : "Very Hard To Kill",
		
	},
	"paragon":{
		constitution:12,
		luck:2,
		strength:10,
		dexterity:10,
		intelligence:6,
		charisma:6,
		weapon_skill:10,
		ballistic_skill:10,
		flavour_text : "Walks in the footsteps of the Primarchs of old",
		display_name : "Paragon",

	},
	"warp_touched":{
		intelligence:4,
		flavour_text : "Interacted with the warp in a way that has forever marked them",
		display_name : "Warp Touched",		
	},
	"lucky":{
		luck : 4,
		flavour_text : "Inexplicably lucky",
		display_name : "Lucky"
	},
	"old_guard":{
		luck : 1,
		constitution : 1,
		strength :1,
		weapon_skill : [2, 2, "max"],
		ballistic_skill :[2, 2, "max"],
		flavour_text : "Seen many young warriors rise and die before them but they themselves still remain",
		display_name : "Old Guard"
	},
	"seasoned":{
		luck : 1,
		constitution : 1,
		strength :1,
		weapon_skill : 1,
		ballistic_skill :1,
		flavour_text : "A seasoned warrior, having fought for many years",
		display_name : "Seasoned",		
	},
	"ancient":{
		luck : 1,
		constitution : -1,
		strength :-1,
		weapon_skill : 3,
		ballistic_skill :4,
		wisdom : 5,
		flavour_text : "Truly Ancient. While their body may ache - skills and wisdom are to be respected",
		display_name : "Ancient",		
	},
	"tinkerer":{
		technology:[5,2,"max"],
		display_name:"Tinkerer",
		flavour_text:"They have a knack for tinkering around with various technological devices and apparatuses, often augmenting and improving their own equipment",
	},
	"lead_example":{
		weapon_skill:[2,1,"max"],
		ballistic_skill :[2,1,"max"],
		constitution :[2,1, "max"],
		dexterity:2,
		strength:1,
		luck:1,
		intelligence:1,
		wisdom:1,
		charisma:3,
		display_name:"Lead by Example",
		flavour_text :"In their many years of service, they have risen through the ranks and have always led by example from the front. They have earned the respect of all their brothers",
	},
	"still_standing":{
		weapon_skill:[6,2,"max"],
		ballistic_skill :[6,2,"max"],
		constitution :[3,1, "max"],
		dexterity:5,
		luck:3,
		wisdom:[3,3,1],
		charisma:1,
		display_name:"Still Standing",
		flavour_text :"Survived the unthinkable. Whether it was slaying a Warboss, vanquishing a Norn-Queen, or accomplishing another incredible feat, they stood last while their comrades fell",
	},
	"lone_survivor":{
		weapon_skill:[8,2,"max"],
		ballistic_skill :[8,2,"max"],
		constitution :[8,1, "max"],
		dexterity:[4,2, "max"],
		strength:[4,2, "max"],
		luck:5,
		wisdom:[2,1,"max"],
		intelligence:[3,3,"max"],
		charisma:[-3, 1, "min"],
		display_name:"Lone Survivor",
		flavour_text :"Survived a battle where all their comrades died. They became more reclusive, but gained immeasurable combat capabilities and are harder to kill.",
	},
	"beast_slayer":{
		weapon_skill:[3,2,"max"],
		ballistic_skill :[4,2,"max"],
		constitution :[2,1, "max"],
		dexterity:1,
		strength:4,
		wisdom:3,
		charisma:1,
		display_name:"Beast Slayer",
		flavour_text :"Defeated a huge beast in single combat, this proves their toughness and their great ability to overcome powerful enemies of the imperium",

	},	
	"mars_trained":{
		technology:[10,5,"max"],
		intelligence:[5,5,"max"],
		display_name:"Trained On Mars",
		flavour_text:"Had the best instruction in the imperium on technology from the Tech Priests of Mars"
	},
	"flesh_is_weak":{
		technology:[2,1,"max"],
		constitution:[1,1,"max"],
		piety:[3,1,"max"],
		display_name:"Weakness of Flesh",
		flavour_text:"Perceive living flesh as a weakness and try to cast it aside whatever possible",
		effect:"faith boosts from bionic replacements, better at dealing with Mechanicus"
	},
	"zealous_faith":{
		strength:[1,1,"max"],
		texhnology:-2,
		wisdom:3,
		intelligence:-2,
		piety:[5,2,"max"],
		display_name:"Zealous Faith",
		flavour_text:"Put great emphasis on their faith, able to draw strength from it in crisis"
	},
	"feet_floor":{
		wisdom:1,
		dexterity:-2,
		display_name:"Feet On the Ground",
		flavour_text:"Prefer to keep both feet on the ground",
		effect:"reduction in combat effectiveness when using Bikes or Jump Packs"
	},
	"tyrannic_vet":{
		wisdom :[2,3,"max"],
		dexterity:1,
		weapon_skill:1,
		ballistic_skill:1,
		constitution:1,
		display_name:"Tyrannic War Veteran",
		flavour_text:"A veteran of the many wars against the the Tyranid swarms",
		effect:"Increased lethality against tyranids"
	},
	"blood_for_blood":{
		strength:[3,2,"max"],
		weapon_skill:1,
		piety:2,
		display_name:"Blood For the Blood God",
		flavour_text:"Spilled blood in the name of the blood god",
		effect:"Has the attention of Khorne"
	},
	"blunt":{
		strength:[2,2,"max"],
		wisdom:2,
		charisma:-2,
		intelligence:-4,
		weapon_skill:1,
		display_name:"Blunt",
		flavour_text:"Tend towards simplistic approaches to achieve goals",
	},
	"skeptic":{
		piety:[-6,4,"min"],
		wisdom:1,
		display_name:"Skeptic",
		flavour_text:"Skeptical outlook and put little thought in trivial matters like religion and faith",
	},
	"scholar":{
		intelligence:[4,2,"max"],
		wisdom:1,
		technology:2,
		strength:-1,
		display_name:"Scholar",
		flavour_text:"Keen mind and enjoys reading and training it whenever possible",
	},
	"brute":{
		strength:[4,2,"max"],
		weapon_skill:[2,2,"max"],
		ballistic_skill:[-2,1,"min"],
		wisdom:-5,
		intelligence:-5,
		charisma:-2,
		display_name:"Brute",
		flavour_text:"A brutal character, often solving problems with intimidation or violence",
	},
	"charismatic":{
		charisma:[10,4,"max"],
		display_name:"Charismatic",
		flavour_text:"Liked by most without even trying",
	},
	"recluse":{
		charisma:[-3,2,"min"],
		dexterity:1,
		wisdom:1,
		display_name:"Reclusive",
		flavour_text:"Generally withdrawn and reclusive, avoiding social engagements where possible",
	}	,
	"nimble":{
		display_name:"Nimble",
		flavour_text:"Naturally nimble and light on their feet",
		dexterity:[4,3,"max"],
		weapon_skill:1,
		constitution:-3,
	},
	"jaded":{
		display_name:"Jaded",
		flavour_text:"Their past has led them to form a deep distrust and cynical outlook on most parts of their life",
		charisma:-2,
		wisdom:-1,
	},
	"observant":{
		display_name:"Observant",
		flavour_text:"Tend to notice things that most don't",
		wisdom:[5,2,"max"],
		dexterity:2
	},
	"perfectionist":{
		display_name:"Perfectionist",
		flavour_text:"Obsessed with doing things correctly",
		wisdom:[2,2,"max"],
		weapon_skill:[2,2,"max"],
		ballistic_skill:[2,2,"max"],
		intelligence:[2,1],
		piety:[2,1],
	},
	"guardian":{
		display_name:"Guardian",
		weapon_skill:[2,2,"max"],
		ballistic_skill:[2,2,"max"],
		charisma:2,
		flavour_text:"Born with a guardian's heart, they vow to shield their charges, defending them unto death",
		effect:"Are a better guardian or bodyguard",
	},
	"cunning":{
		display_name:"Cunning",
		weapon_skill:[1,1,"max"],
		ballistic_skill:[2,2,"max"],
		dexterity:[2,2,"max"],
		charisma:2,
		wisdom:1,
		flavour_text:"Possessed of a fine cunning",
	},
	"strong":{
		display_name:"Strong",
		strength:[6,2,"max"],
		flavour_text:"Endowed with strength from birth",
	},	
	"slow":{
		display_name:"slow",
		dexterity:[-3,3,"min"],
		flavour_text:"Have many talents but being fast ain't one of them",
	},			
	"harshborn":{
		display_name:"Harsh Beginnings",
		strength:[2,2,"max"],
		constitution:[2,2,],
		dexterity:[2,2,"max"],
		weapon_skill:[2,2,"max"],
		ballistic_skill:[2,-2],
		wisdom:[2,2,"max"],
		flavour_text:"Started life on a deathworld Prison environment or other desolate start point. While this has greatly improved their strength and survival abilities, their skills in technology and other advanced fields are reduced",
		intelligence:-3,
		technology:[-3,2],
		piety:[3,1],
	},
	"technophobe":{
		display_name:"Technophobe",
		technology:[-7,2,"min"],
		flavour_text:"Have a deep mistrust and loathing of technology",
	},
	"fast_learner":{
		display_name:"Quick Learner",
		wisdom:[2,2,"max"],
		intelligence:[2,2,"max"],
		technology:[2,2,"max"],
		flavour_text:"Fast learner, picking up new skills with ease",
		effect:"learns new skills more easily",
	},
	"brawler":{
		display_name:"Brawler",
		strength:[2,2,"max"],
		constitution:[2,2,"max"],
		flavour_text:"Compelled towards the thrill of combat, they revel in the raw, primal dance of battle, often relying on nothing more than the crushing power of their fists",
		effect:"bonus to fist type weaponry",
	},
	"tech_heretic":{
		display_name:"Tech Heretic",
		technology:[3,1,"max"],
		intelligence:1,
		flavour_text:"Engage in study and beliefs considered heretical in the eyes of Mars and the Imperium",
		//effect:"bonus to fist type weaponry",
	},
	"crafter":{
		display_name:"Crafter",
		technology:[6,1,"max"],
		intelligence:1,
		flavour_text:"Particularly skilled at building and making things, often improving their quality along the way",
		effect:"provides more total forge points especially when assigned to a forge",
	},	
	"natural_leader":{
		display_name:"Natural Leader",
		flavour_text:"Excels in all areas of command be that rallying his men, planning logistics or drawing up plans for engagements",
		wisdom : [4, 2, "max"],
		charisma : [4, 2, "max"],
		effect:"Bonus when commanding",		
	},
	"feral" : {
		display_name:"Feral",
		flavour_text:"Plain Feral, viewed as more akin to an animal than a human, with this comes a savage ferocity most often asscociated with those from Deathworlds",
		wisdom : [2, 2],
		charisma : [-6, 2, "max"],
		technology : [-3, 2, "max"],	
		strength : [5, 1, "max"],
		weapon_skill : [4, 1, "max"],
		ballistic_skill : [-3, 1, "min"],
	},
	"honorable" : {
		display_name : "Honorable",
		wisdom : [2, 2],
		charisma : [2, 2],
		weapon_skill : [1,1],
		flavour_text:"Is known for their impeccable honor even in the heat of battle",
		effect:"If commanding garrison will prevent disposition loss",		
	},
	"duelist" : {
		weapon_skill : [2,2],
		display_name : "Duelist",
		flavour_text:"a superlative duelist favoring traditional dueling weaponry",
		effect:"Bonus to using powered weapons and advantages in duels",

	},
	"siege_master" : {

		display_name : "Siege Master",
		wisdom : [2,2,"max"],
		constitution : [2,2],
		flavour_text:"Understands the ins and outs of defences both in building them and in taking them appart",
		effect:"Bonus when commanding defences and extra boosts when leading a garrison",
	},
	"students_of_war":{
		wisdom:[3,2,"max"],
		charisma:[3,2,"max"],
		intelligence:[1,1],
		strength:[-2, 2,"min"],
		display_name:"Student of war",
		flavour_text:"The sons of Guilliman are equally elite warriors and learned statesman",
	},
	"secretive_knights":{
		constitution:[3,2,"max"],
		dexterity:[3,2,"max"],
		weapon_skill:[1,1],
		charisma:[-2, 2,"min"],
		display_name:"Secretive Knight",
		flavour_text:"This Warrior speaks precious few words to those outside his chapter but his mastery of arms is apparent",
	},
	"warriors_of_the_Wind":{
		dexterity:[3,2,"max"],
		weapon_skill:[3,2,"max"],
		wisdom:[1,1],
		strength:[-2, 2,"min"],
		display_name:"Warrior of the Wind",
		flavour_text:"Like the Khagan this marine is a tempest in combat flowing through enemies with finesse not common for astartes",
	},
	"wolf_prince":{
		strength:[3,2,"max"],
		dexterity:[3,2,"max"],
		wisdom:[1,1],
		technology:[-2, 2,"min"],
		display_name:"Wolf Prince",
		flavour_text:"The Canis Helix of this marine raises him to acts of savage ferocity  matched only by other sons of the Wolf Lord",
	},
	"shadow_masters":{
		dexterity:[3,2,"max"],
		ballistic_skill:[3,2,"max"],
		wisdom:[1,1],
		constitution:[-2, 2,"min"],
		display_name:"Shadow Born",
		flavour_text:"The progeny of the Raven lord are exceptionally nimble stealth operatives this Marine is one such example ",
	},
	"keepers_of_the_flame":{
		strength:[3,2,"max"],
		constitution:[3,2,"max"],
		technology:[1,1],
		dexterity:[-2, 2,"min"],
		display_name:"Keeper of the Flame",
		flavour_text:"The sons Vulkan are blessed with strong and durable bodies they use to safeguard humanity's flame",
	},
	"will_of_iron":{
		wisdom:[3,2,"max"],
		constitution:[3,2,"max"],
		strength:[1,1],
		charisma:[-2, 2,"min"],
		display_name:"Will of Iron",
		flavour_text:"Honed and tempered in the flames of war this marine has chained the emotions that killed his genesire",
	},
	"host_of_angels":{
		charisma:[3,2,"max"],
		intelligence:[3,2,"max"],
		weapon_skill:[1,1],
		constitution:[-2, 2,"min"],
		display_name:"Angelic Host",
		flavour_text:"Comparable to the angels of legend this marine wields a paintbrush with the same grace he does a blade",
	},
	"obstinate_defenders":{
		constitution:[3,2,"max"],
		intelligence:[3,2,"max"],
		ballistic_skill:[1,1],
		dexterity:[-2, 2,"min"],
		display_name:"Obstinate Defender",
		flavour_text:"Even in the face of unsurmountable odds this marine will hold defiantly as befitting a son of Dorn",
	},
	"lobotomized" : {
		wisdom : -50,
		intelligence : -50,
		charisma : -5,
		constitution : 1, // Slight buff to health, as clear mind helps to stay healthy in some cases
		technology : 1, // Also helps with some boring tasks, I think?
		display_name : "Lobotomized",
		flavour_text : "received treatment or damage, which resulted in portion of brain missing, akin to servitors",
	},
	"psychotic" : { // IT IS THE BANEBLAAADE!!! - Captain Diomedes, DoW 2 Retribution
		wisdom : 10,
		intelligence : -5,
		constitution : -1, // Being bonkers can sometimes be damaging to one's health, I think..?
		display_name : "Psychotic",
		flavour_text : "whether due to experience or some other cause, acquired access to hidden knowledge...",
	}
	// "crazy" : {
		// wisdom : [5, 2],
		// intelligence : [-2, 2],
		// constitution : -1,
		// display_name : "Crazy",
		// flavor_text : "lost sense of reason"
	// },
	// "eccentric" : {
		// wisdom : [3, 2],
		// intelligence : [3, 2],
		// charisma : [3, 2],
		// technology : [3, 2],
		// display_name : "Eccentric",
		// flavor_text : "has a tendency to do things in original way"
	// }
}

global.astartes_trait_dist = [
		[
			"beast_slayer", 
			[500,499],
			{
				recruit_world_type: [
					["Ice", -2],
					["Lava", -1],
					["Death", -10],
					["Forge",1],
					["Shrine",2]					
				],
				recruit_trial : [
					[eTrials.EXPOSURE, -1],
					[eTrials.HUNTING, -3],
					[eTrials.APPRENTICESHIP, 1],
					[eTrials.KNOWLEDGE, 1]
				]				
			}				

		],
		[	
			"very_hard_to_kill", 
			[400,397],
			{
				recruit_world_type: [
					["Ice", -1],
					["Lava", -4],
					["Death", -4],
				],
				recruit_trial : [
					[eTrials.EXPOSURE, -3],
					[eTrials.SURVIVAL, -2],
					[eTrials.APPRENTICESHIP, 1]
				]
			}					
		],
		[
			"harshborn",
			[149,147],
			{
				recruit_world_type: [
					["Ice", -2],
					["Lava", -1],
					["Death", -3],
					["Forge",1],
					["Shrine",2]					
				],
				recruit_trial : [
					[eTrials.EXPOSURE, -1],
				]				
			}				
		],
		[
			"scholar", 
			[150,148],
			{
				recruit_world_type: [
					["Feudal", -1],
					["Shrine", -4],
				],
				recruit_trial : [
					[eTrials.KNOWLEDGE, -2],
					[eTrials.APPRENTICESHIP, -1],
					[eTrials.BLOODDUEL, 1],					
				]
			}					
		],
		[
			"feral", 
			[299,296],
			{
				recruit_world_type: [
					["Ice", -2],
					["Lava", -1],
					["Death", -3],
					["Forge",50],
					["Shrine",2]					
				],
				recruit_trial : [
					[eTrials.KNOWLEDGE, 3],
					[eTrials.APPRENTICESHIP, 10],
					[eTrials.BLOODDUEL, -1],	
					[eTrials.SURVIVAL, -1],					
				]				
			}
		],
		[
			"brawler",
			[99,98],
			{
				chapter_name:[
					"Space Wolves",[200,190]
				],
				recruit_trial : [
					[eTrials.BLOODDUEL, -2],
				]			
			}
		],
		[
			"brute", 
			[200,198],
			{
				recruit_world_type: [
					["Ice", -1],
					["Lava", -1],
					["Death", -1],				
				],
				recruit_trial : [
					[eTrials.BLOODDUEL, -1],
					[eTrials.APPRENTICESHIP, 1],
				]				
			}					
		],
		[
			"charismatic", 
			[99,98],
			{
				recruit_world_type: [
					["Shrine", -3],
					["Temperate", -2],
					["Agri", -2]
				],
				recruit_trial : [
					[eTrials.KNOWLEDGE, -1],
				]				
			}
		],
		["skeptic", [99,98]],
		[
			"blunt", 
			[99,98]
		],
		[
			"nimble", 
			[99,98],
			{
				recruit_trial : [
					[eTrials.HUNTING, -1],
				]
			}
		],
		[
			"recluse", 
			[199,198],
			{
				recruit_trial : [
					[eTrials.HUNTING, -1],
					[eTrials.EXPOSURE, -1],
				]
			}

		],
		[	
			"perfectionist", 
			[99,98],
			{
				recruit_trial : [
					[eTrials.KNOWLEDGE, -3],
					[eTrials.HUNTING, -1],
				]	
			}				
		],
		[
			"observant", 
			[99,98],
			{
				recruit_trial : [
					[eTrials.KNOWLEDGE, -1],
					[eTrials.HUNTING, -1],
				]	
			}			
		],
		[
			"cunning", 
			[99,98],
			{
				recruit_world_type: [
					["Hive", -4],				
				],
				recruit_trial : [
					[eTrials.HUNTING, -3],
				]						
			}					
		],
		["guardian", [99,98]],
		[
			"observant",
			[99,98],
			{
				recruit_trial : [
					[eTrials.HUNTING, -1],
				],
			}
		],
		[
			"technophobe", 
			[99,98],
			{
				"progenitor":[
					ePROGENITOR.IRON_HANDS,[1000,999]
				],
				recruit_world_type : [
					["Ice", -5],
					["Death", -2],
					["Forge",50],
				],
			}
		],
		[
			"jaded",
			[99,98],
		],
		[
			"strong", 
			[99,98],
			{
				recruit_trial : [
					[eTrials.CHALLENGE, -1],
				],		
			}
		],
		[
			"fast_learner", 
			[149,148],
		],
		["feet_floor", 
			[199,198],
			{
				chapter_name:[
					"Space Wolves",[100,70]
				],
			}
		],
		["paragon", [999,998]],
		[
			"warp_touched",[299,298]
		],
		["shitty_luck",
			[99,98],
			{
				"disadvantage":[
					"Shitty Luck",[3,2]
				]
			}
		],
		[
			"lucky",
			[99,98]
		],
		["natural_leader",
			[199,198],
			{
				recruit_world_type: [
					["Temperate", -2],
					["Shrine", -4],
				],					
			}
		],
		[
			"slow_and_purposeful",
			[99,98],
			{
				"advantage":[
					"Devastator Doctrine",[300,100]
				]
			}
		],
		[
			"melee_enthusiast",
			[99,98],
			{
				"advantage":[
					"Assault Doctrine",[300,100]
				],
				recruit_trial : [
					[eTrials.BLOODDUEL, -1],
					[eTrials.CHALLENGE, -1],
				]				
			}, 
		],
		[
			"lightning_warriors",
			[99,98],
			{
				"advantage":[
					"Lightning Warriors",[300,100]
				]
			}
		],
		[
			"zealous_faith",
			[99,98],
			{
				"chapter_name":[
					"Black Templars",
					[300,200]
				],
				recruit_world_type: [
					["Shrine", -15]
				],
				recruit_trial : [
					[eTrials.KNOWLEDGE, -2],
				]										
			}
		],
		["flesh_is_weak",[1000,999],{
				chapter_name:["Iron Hands",[1000,600],"required"],
				progenitor:[ePROGENITOR.IRON_HANDS,[1000,800],"required"],
				recruit_world_type: [
					["Forge", -300],
					["Lava", -15],
				],						
			}
		],
		[
			"tinkerer",
			[199,198],
			{
				chapter_name:["Iron Hands",[49,47]],
				recruit_world_type: [
					["Forge", -15],
					["Hive", -7],
				],
			}
		],
		[
			"crafter",
			[299,298],
			{
				advantage:["Crafters",[299,297]],
				recruit_world_type: [
					["Forge", -2],
					["Lava", -2],
				],
				recruit_trial : [
					[eTrials.APPRENTICESHIP, -1],
				]												
			}					
		],
		[
			"honorable",
			[299,297],
			{
				recruit_world_type: [
					["Feudal", -9],
					["Temperate", -3],
					["Desert", -9],
				],
				recruit_trial : [
					[eTrials.BLOODDUEL, 1],
				],
				recruit_trial : [
					[eTrials.CHALLENGE, -1],
				]
			}
		],
		[
			"duelist",
			[299,298],
			{
				chapter_name:[
					"Black Templars",[199,197]
				],
				recruit_world_type: [
					["Feudal", -9],
				],
				recruit_trial : [
					[eTrials.CHALLENGE, -2],
				]										
			}
		],	
		[
			"siege_master",
			[299,297],
			{
				recruit_world_type: [
					["Feudal", -6],
					["hive", -2],
					["ice", 1],
				],
				recruit_trial : [
					[eTrials.APPRENTICESHIP, -2],
				]				
			}
		],		
		[
			"secretive_knights",
			[1,1],
			{
				chapter_name:[
					"Dark Angels",[500,0]
				],			
			}
		],		
		[
			"warriors_of_the_wind",
			[1,1],
			{
				chapter_name:[
					"White Scars",[500,0]
				],			
			}
		],		
		[
			"wolf_prince",
			[1,1],
			{
				chapter_name:[
					"Space Wolves",[500,0]
				],			
			}
		],		
		[
			"obstinate_defenders",
			[1,1],
			{
				chapter_name:[
					"Imperial Fists",[500,0]
				],			
			}
		],		
		[
			"host_of_angels",
			[1,1],
			{
				chapter_name:[
					"Blood Angels",[500,0]
				],			
			}
		],		
		[
			"will_of_iron",
			[1,1],
			{
				chapter_name:[
					"Iron Hands",[500,0]
				],			
			}
		],		
		[
			"students_of_war",
			[1,1],
			{
				chapter_name:[
					"Ultramarines",[500,0]
				],			
			}
		],		
		[
			"keepers_of_the_flame",
			[1,1],
			{
				chapter_name:[
					"Salamanders",[500,0]
				],			
			}
		],		
		[
			"shadow_masters",
			[1,1],
			{
				chapter_name:[
					"Raven Guard",[500,0]
				],			
			}
		],		
		
	];



function scr_marine_trait_spawning(distribution_set){

	function is_state_required(mod_area){
		is_required = false;
		if (array_length(mod_area)>2){
			if (mod_area[2] == "require"){
				is_required =true;
			}
		}
		return is_required;
	}		
	for (var i=0;i<array_length(distribution_set);i++){//standard distribution for trait
		if (array_length(distribution_set[i])==2){
			if (irandom(distribution_set[i][1][0])>distribution_set[i][1][1]){
				add_trait(distribution_set[i][0])
			}
		} else if (array_length(distribution_set[i])==3){  //trait has conditions
			var dist_modifiers = DeepCloneStruct(distribution_set[i][2]);
			var dist_rate=[];
			array_copy(dist_rate, 0, distribution_set[i][1], 0, array_length(distribution_set[i][1]));
			if (struct_exists(dist_modifiers, "disadvantage")){
				if (scr_has_disadv(dist_modifiers[$"disadvantage"][0])){
					dist_rate = dist_modifiers[$"disadvantage"][1];  //apply new modifier rate
				} else if (is_state_required(dist_modifiers[$"disadvantage"])){
					dist_rate=[0,0];
				}
			}
			if (struct_exists(dist_modifiers, "advantage")){
				if (scr_has_adv(dist_modifiers[$"advantage"][0])){
					dist_rate = dist_modifiers[$"advantage"][1];  //apply new modifier rate
				} else if (is_state_required(dist_modifiers[$"advantage"])){
					dist_rate=[0,0];
				}
			}
			if (struct_exists(dist_modifiers, "progenitor")){
				if (obj_ini.progenitor == dist_modifiers[$ "progenitor"][0]){
					dist_rate = dist_modifiers[$"progenitor"][1]; 
				}else if (is_state_required(dist_modifiers[$ "progenitor"])){
					dist_rate=[0,0];
				}
			}
			if (struct_exists(dist_modifiers, "chapter_name")){
				if (global.chapter_name == dist_modifiers[$ "chapter_name"][0]){
					dist_rate = dist_modifiers[$"chapter_name"][1]; 
				}else if (is_state_required(dist_modifiers[$ "chapter_name"])){
					dist_rate=[0,0];
				}
			}
			if (struct_exists(spawn_data, "recruit_data")){
				var recruit_world_data = spawn_data.recruit_data;
				if (struct_exists(dist_modifiers, "recruit_world_type")){
					var type_data = dist_modifiers.recruit_world_type;
					for (var t=0;t<array_length(type_data);t++){
						if (type_data[t][0] == recruit_world_data.recruit_world){
							dist_rate[1] += type_data[t][1];
						}
					}
				}
				if (struct_exists(dist_modifiers,"trial_type")){
					if (struct_exists(dist_modifiers, "recruit_trial")){
						trial_data = dist_modifiers.recruit_trial;
						for (var t=0;t<array_length(trial_data);t++){
							if (type_data[t][0] == recruit_world_data.aspirant_trial){
								dist_rate[1] += type_data[t][1];
							}
						}						
					}
				}
			}						
			if (irandom(dist_rate[0])>dist_rate[1]){
				add_trait(distribution_set[i][0]);
			}
		}
	}	
}
