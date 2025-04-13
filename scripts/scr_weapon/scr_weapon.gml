global.weapons = {
	"Storm Shield": {
		"description": "Protects twice as well when boarding. A powered shield that must be held with a hand.  While powered by the marines armour it shimmers with blue energy.",
		"abbreviation": "StrmShld",
		"attack": {
			"standard": 5,
			"master_crafted": 5,
			"artifact": 10
		},
		"armour_value": {
			"standard": 8,
			"master_crafted": 10,
			"artifact": 12
		},
		"melee_hands": 0.75,
		"ranged_hands": 1,
		"tags": ["shield"],
		"hp_mod": {
			"standard": 30,
			"master_crafted": 35,
			"artifact": 40
		},
	},
	"Boarding Shield": {
		"description": "Protects twice as well when boarding. Used in siege or boarding operations, this shield offers additional protection.  It may be used with a 2-handed ranged weapon.",
		"abbreviation": "BrdShld",
		"armour_value": {
			"standard": 4,
			"master_crafted": 5,
			"artifact": 6
		},
		"melee_hands": 0.75,
		"tags": ["shield","boarding"],
		"hp_mod": {
			"standard": 15,
			"master_crafted": 17.5,
			"artifact": 20
		},
	},
	"Archeotech Laspistol": {
		"attack": {
			"standard": 40,
			"master_crafted": 60,
			"artifact": 80
		},
		"description": "Known as a Lasrod or Gelt Gun, this pistol is an ancient design of Laspistol with much greater power.",
		"abbreviation": "ArchLpstl",
		"melee_hands": 0,
		"ranged_hands": 0.5,
		"ammo": 30,
		"range": 3.1,
		"spli": 1,
		"arp": 0,
		"tags": ["pistol", "ancient", "las", "energy"],
	},
	"Combat Knife": {
		"abbreviation": "CbKnf",
		"attack": {
			"standard": 25,
			"master_crafted": 30,
			"artifact": 35
		},
		"description": "More of a sword than a knife, this tough and thick blade becomes a deadly weapon in the hand of an Astartes.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 1,
		"arp": 0,
		"tags": ["knife"],
	},
	"Chainsword": {
		"abbreviation": "ChSwrd",
		"attack": {
			"standard": 50,
			"master_crafted": 60,
			"artifact": 70
		},
		"description": "A standard Chainsword. It is popular among Assault Marines due to their raw power while maintaining speed.",
		"melee_hands": 1,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 4,
		"arp": 0,
		"tags": ["chain", "sword"],
	},
	"Chainaxe": {
		"abbreviation": "ChAxe",
		"attack": {
			"standard": 90,
			"master_crafted": 100,
			"artifact": 110
		},
		"melee_mod": {
			"standard": 5,
			"master_crafted": 10,
			"artifact": 15
		},
		"description": "A weapon most frequently seen in the hands of Traitor Astartes, the Chainaxe uses motorized chainsaw teeth to maim and tear. Astartes often duel-wield them to increase frequency of attacks.",
		"melee_hands": 1,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 6,
		"arp": 0,
		"tags": ["chain", "axe", "dual"],
	},
	"Company Standard": {
		"abbreviation": "CmpStnd",
		"special_properties": ["Morale Boost"],
		"description": "A banner that represents the honor of a particular company and will bolster the morale of nearby Astartes.",
		"attack": {
			"standard": 45,
			"master_crafted": 60,
			"artifact": 100
		},
		"hp_mod": {
			"standard": 20,
			"master_crafted": 20,
			"artifact": 20
		},
		"melee_hands": 1,
		"ranged_hands": 1,
		"range": 1,
		"spli": 1,
		"tags": ["banner"],
	},
	"Eviscerator": {
		"abbreviation": "Evisc",
		"attack": {
			"standard": 180,
			"master_crafted": 190,
			"artifact": 200
		},
		"melee_mod": {
			"standard": 2,
			"master_crafted": 2,
			"artifact": 2
		},
		"description": "An obscenely large Chainsword, this two-handed weapon can carve through flesh and plasteel with equal ease.",
		"melee_hands": 2,
		"ranged_hands": 1,
		"ammo": 0,
		"range": 1,
		"spli": 3,
		"arp": 1,
		"tags": ["chain", "sword"],
	},
	"Power Sword": {
		"abbreviation": "PwrSwrd",
		"attack": {
			"standard": 180,
			"master_crafted": 200,
			"artifact": 240
		},
		"melee_mod": {
			"standard": 1,
			"master_crafted": 1.1,
			"artifact": 1.2
		},
		"description": "The most common kind of Power Weapon. When active, the blade becomes sheathed in a lethal haze of disruptive energy that seamlessly cuts through ceramite and flesh.",
		"melee_hands": 1,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 4,
		"arp": 1,
		"special_properties": ["Parry"],
		"tags": ["power", "sword"],
	},
	"Power Spear": {
		"abbreviation": "PwrSpear",
		"attack": {
			"standard": 200,
			"master_crafted": 220,
			"artifact": 260
		},
		"melee_mod": {
			"standard": 1,
			"master_crafted": 1.1,
			"artifact": 1.2
		},
		"description": "A rare kind of Power Weapon, a power blade mounted on the end of a long shaft, requires great skill to wield. When active, the blade becomes sheathed in a lethal haze of disruptive energy and can tear through all manners of material with ease.",
		"melee_hands": 1,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 6,
		"arp": 1,
		"special_properties": ["Parry"],
		"tags": ["power", "spear"],
	},
	"Xenophase Blade": {
		"abbreviation": "XenoPhs",
		"attack": {
			"standard": 190,
			"master_crafted": 210,
			"artifact": 250
		},
		"melee_mod": {
			"standard": 1,
			"master_crafted": 1.1,
			"artifact": 1.2
		},
		"description": "A Xenophase Blade is a potent, Power Sword-like melee weapon derived from xenos technology used by select warriors of the Deathwatch Chapter who have earned by their deeds and time of service in the Long Vigil the special trust of their watch fortress' watch commander.",
		"melee_hands": 1.1,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 4,
		"arp": 1,
		"special_properties": ["Parry"],
		"tags": ["power", "sword", "xenos"],
	},
	"Chainfist": {
		"abbreviation": "ChFst",
		"attack": {
			"standard": 550,
			"master_crafted": 600,
			"artifact": 700
		},
		"description": "Created by mounting a chainsword to a power fist, this weapon is easily able to carve through armoured bulkheads.",
		"melee_hands": 1.25,
		"ranged_hands": 1,
		"range": 1,
		"spli": 2,
		"arp": 1,
		"tags": ["power","boarding", "chain", "fist", "dual", "siege"],
	},
	"Lascutter": {
		"abbreviation": "Lasct",
		"attack": {
			"standard": 100,
			"master_crafted": 150,
			"artifact": 200
		},
		"description": "Origonally industrial tools used for breaking through bulkheads, this laser weapon is devastating in close combat.",
		"melee_hands": 1,
		"range": 1,
		"arp": 1,
		"tags": ["las","boarding", "siege"],
	},
	"Power Weapon": {
		"abbreviation": "PwrWpn",
		"attack": {
			"standard": 135,
			"master_crafted": 145,
			"artifact": 155
		},
		"melee_mod": {
			"standard": 1.1,
			"master_crafted": 1.1,
			"artifact": 1.1
		},
		// "description": "An makeshift power weapon made by Astartes during long term deployment behind enemy lines or when cut from supply lines for long periods of time.",
		"melee_hands": 1.1,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 3,
		"arp": 1,
		"tags": ["power"],
	},
	"Power Axe": {
		"abbreviation": "PwrAxe",
		"attack": {
			"standard": 190,
			"master_crafted": 220,
			"artifact": 260
		},
		"melee_mod": {
			"standard": 1,
			"master_crafted": 1.1,
			"artifact": 1.2
		},
		"description": "This weapon's power systems can be activated with the press of a button to sheathe the axe-head in a lethal haze of disruptive energy. Those fortunate enough to get their hands on two tend to duel-wield them.",
		"melee_hands": 1,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 5,
		"arp": 1,
		"tags": ["power", "axe", "dual"],
	},
	"Executioner Power Axe": {
		"abbreviation": "ExPwrAxe",
		"attack": {
			"standard": 300,
			"master_crafted": 350,
			"artifact": 400
		},
		"melee_mod": {
			"standard": 10,
			"master_crafted": 15,
			"artifact": 20
		},
		"description": "A heavy two-handed power axe used to rend armor and tear through multiple infantry at once.",
		"melee_hands": 2.5,
		"ranged_hands": 2,
		"ammo": 0,
		"range": 1,
		"spli": 2,
		"arp": 1,
		"tags": ["power", "axe"],
	},
	"Power Fist": {
		"abbreviation": "PwrFst",
		"attack": {
			"standard": 450,
			"master_crafted": 500,
			"artifact": 600
		},
		"melee_mod": {
			"standard": 1,
			"master_crafted": 1,
			"artifact": 1
		},
		"description": "A large, ceramite clad gauntlet surrounded by an power energy field. Though cumbersome to use, it dishes out tremendous damage to enemies, leaving very little behind.",
		"melee_hands": 1,
		"ranged_hands": 1,
		"ammo": 0,
		"range": 1,
		"spli": 2,
		"arp": 1,
		"tags": ["power", "dual", "fist"],
	},
	"Power Fists": {
		"abbreviation": "PwrFsts",
		"attack": {
			"standard": 900,
			"master_crafted": 1000,
			"artifact": 1200
		},
		"description": "A large, ceramite clad gauntlets surrounded by power energy fields. Though cumbersome to use, they dish out tremendous damage to enemies, leaving very little behind.",
		"melee_hands": 2,
		"ranged_hands": 2,
		"ammo": 0,
		"range": 1,
		"spli": 4,
		"arp": 1,
		"tags": ["power", "fist", "pair"],
	},
	"Servo-arm(M)": {
		"abbreviation": "MchArm",
		"attack": {
			"standard": 220,
			"master_crafted": 330,
			"artifact": 500
		},
		"description": "",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 2,
		"arp": 1,
		"tags": ["siege"],
	},
	"Boltstorm Gauntlet": {
		"abbreviation": "BlstGnt",
		"attack": {
			"standard": 450,
			"master_crafted": 500,
			"artifact": 600
		},
		"description": "The Boltstorm Gauntlet is a Power Fists with an Integrated Bolter, so aside from being reinforced with a crackling power field and able to crush armour, bone and even thick vehicle plating, it is also capable of firing bolts at an astonishing rate",
		"melee_hands": 2,
		"ranged_hands": 2,
		"ammo": 0,
		"range": 1,
		"spli": 2,
		"arp": 1,
		"second_profiles": ["Integrated Bolter"],
		"tags": ["power", "fist"],
	},
	"Assault Chainfist": {
		"abbreviation": "AssltChFst",
		"attack": {
			"standard": 550,
			"master_crafted": 600,
			"artifact": 700
		},
		"description": "Created by mounting a chainsword to a power fist, this weapon is easily able to carve through armoured bulkheads. Contains an integrated Assault Cannon",
		"melee_hands": 1.25,
		"ranged_hands": 1,
		"range": 1,
		"spli": 2,
		"arp": 1,
		"second_profiles": ["Assault Cannon"],
		"tags": ["power","boarding", "chain", "fist", "dual", "siege"],
	},
	"Lightning Claw": {
		"abbreviation": "LghtClw",
		"attack": {
			"standard": 450,
			"master_crafted": 500,
			"artifact": 600
		},
		"description": "Lightning claws are specialized close combat weapons with built-in disruptor fields. These lethal claws rip into infantry like butter, bringing terror to the foe.",
		"melee_hands": 1.1,
		"ranged_hands": 1,
		"ammo": 0,
		"range": 1,
		"spli": 5,
		"arp": 1,
		"tags": ["power", "dual", "fist"],
	},
	"Dreadnought Lightning Claw": {
		"abbreviation": "LghtClw",
		"attack": {
			"standard": 300,
			"master_crafted": 400,
			"artifact": 600
		},
		"melee_mod": {
			"standard": 1.2,
			"master_crafted": 1.2,
			"artifact": 1.2
		},
		"description": "A specialized Lightning Claw variant designed for Dreadnoughts, these claws are capable of ripping through enemy vehicles and infantry with ease.",
		"melee_hands": 5,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 15,
		"arp": 1,
		"maintenance" : 0.1,
		"tags": ["power", "vehicle", "dual", "dreadnought", "fist"],
	},
	"Thunder Hammer": {
		"abbreviation": "ThndHmr",
		"attack": {
			"standard": 650,
			"master_crafted": 750,
			"artifact": 900
		},
		"melee_mod": {
			"standard": 1.3,
			"master_crafted": 1.3,
			"artifact": 1.3
		},
		"description": "A Thunder hammer is a weapon with a long pole and a double headed hammer on the top. This weapon unleashes a massive, devastating disruption field on impact. Only experienced Astartes can use Thunder Hammers, typically Terminators.",
		"melee_hands": 1.1,
		"ranged_hands": 1,
		"ammo": 0,
		"range": 1,
		"spli": 10,
		"arp": 1,
		"tags": ["power", "hammer", "siege"],
		"maintenance" : 0.1,
		"req_exp": 100,
	},
	"Heavy Thunder Hammer": {
		"abbreviation": "HvyThndHmr",
		"attack": {
			"standard": 975,
			"master_crafted": 1125,
			"artifact": 1350,
		},
		"melee_mod": {
			"standard": 1.3,
			"master_crafted": 1.3,
			"artifact": 1.3,
		},
		"description": "The Heavy Thunder Hammer is the largest man-portable Thunder Hammer that is used by the Adeptus Astartes - a giant, crushing tool of destruction so heavy even a Space Marine cannot use it one-handed.",
		"melee_hands": 2,
		"ranged_hands": 2,
		"ammo": 0,
		"range": 1,
		"spli": 15,
		"arp": 1,
		"tags": ["heavy_melee", "power", "hammer", "siege"],
		"maintenance" : 0.1,
		"req_exp": 100,
	},
	"Power Mace": {
		"abbreviation": "PwrMace",
		"attack": {
			"standard": 600,
			"master_crafted": 700,
			"artifact": 800
		},
		"melee_mod": {
			"standard": 1.3,
			"master_crafted": 1.3,
			"artifact": 1.3
		},
		"description": "Commonly referred to as Power Maul, is a blunt weapon surrounded by a power field. It's quite different from the less lethal Shock Maul, which is a similar type of close combat weapon. In the hands of a skilled warrior, the Power Mace is not just a weapon, it's a statement of power and authority in the grim darkness of far future.",
		"melee_hands": 2.25,
		"ranged_hands": 2,
		"ammo": 0,
		"range": 1,
		"spli": 10,
		"arp": 1,
		"tags": ["power", "mace", "siege"],
		"req_exp": 100,
	},
	"Mace of Absolution": {
		"abbreviation": "AbsltMace",
		"attack": {
			"standard": 600,
			"master_crafted": 700,
			"artifact": 800
		},
		"melee_mod": {
			"standard": 1.3,
			"master_crafted": 1.3,
			"artifact": 1.3,
		},
		"description": "Wreathed in glowing smoke, these massive weapons are as sinister in aspect as they are lethal in application, and are capable of obliterating even the mightiest heretics in a blaze of killing light.",
		"special_description": "Dark Angels exclusive",
		"melee_hands": 2.25,
		"ranged_hands": 2,
		"ammo": 0,
		"range": 1,
		"spli": 10,
		"arp": 1,
		"tags": ["power", "mace", "siege", "pious"],
		"req_exp": 100,
	},
	"Tome": {
		"abbreviation": "Tome",
		"attack": {
			"standard": 0,
			"master_crafted": 0,
			"artifact": 0
		},
		"melee_mod": {
			"standard": 1.0,
			"master_crafted": 1.0,
			"artifact": 1.0
		},
		"description": "Ancient Blades of various origins smited through arcane forging or lost techniques, these blades are deadly beyond belief. These peerless blades slice through ceramite and flesh with ease.",
		"melee_hands": 1,
		"ranged_hands": 1,
		"ammo": 0,
		"range": 1,
		"spli": 1,
		"arp": 0,
		"tags": ["arcane"],
	},
	"Crozius Arcanum": {
		"abbreviation": "Crzus",
		"attack": {
			"standard": 220,
			"master_crafted": 250,
			"artifact": 300
		},
		"melee_mod": {
			"standard": 1,
			"master_crafted": 1,
			"artifact": 1
		},
		"description": "The Crozius Arcanum serves as both a sacred staff of office and a close combat weapon for Astartes Chaplains.",
		"melee_hands": 1,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 4,
		"arp": 1,
		"tags": ["power", "mace", "pious"],
	},
	"Relic Blade": {
		"abbreviation": "RlcBld",
		"attack": {
			"standard": 700,
			"master_crafted": 850,
			"artifact": 1000
		},
		"melee_mod": {
			"standard": 1,
			"master_crafted": 1.1,
			"artifact": 1.2
		},
		"description": "Ancient Blades of various origins smithed through arcane forging or lost techniques, these blades are deadly beyond belief. These peerless blades slice through ceramite and flesh with ease.",
		"melee_hands": 2,
		"ranged_hands": 1,
		"ammo": 0,
		"range": 1,
		"spli": 8,
		"arp": 1,
		"special_properties": ["Parry"],
		"maintenance" : 0.1,
		"tags": ["power", "sword"],
	},
	"Bolt Pistol": {
		"abbreviation": "BltPstl",
		"attack": {
			"standard": 30,
			"master_crafted": 35,
			"artifact": 40
		},
		"description": "A smaller, more compact version of the venerable Boltgun. This model is produced in the standard Godwyn pattern.",
		"melee_hands": 0,
		"ranged_hands": 1,
		"ammo": 18,
		"range": 3.1,
		"spli": 1,
		"arp": 0,
		"tags": ["bolt", "pistol"],
	},
	"Webber": {
		"abbreviation": "Webbr",
		"attack": {
			"standard": 35,
			"master_crafted": 40,
			"artifact": 45
		},
		"description": "The Webber is a close-range weapon that fires strands of sticky web-like substance. It is designed to ensnare and immobilize enemies, restricting their movement and rendering them vulnerable to further attacks.",
		"melee_hands": 0,
		"ranged_hands": 2,
		"ammo": 5,
		"range": 4.1,
		"spli": 1,
		"arp": 0,
		"tags": ["immobolise"]
	},
	"Grav-Pistol": {
		"abbreviation": "GrvPstl",
		"attack": {
			"standard": 150,
			"master_crafted": 200,
			"artifact": 250
		},
		"description": "A smaller version of the Grav-Gun which utilises the gravitic reaction principle most commonly seen powering grav-vehicles such as the Land Speeder.",
		"melee_hands": 0,
		"ranged_hands": 1,
		"ammo": 4,
		"range": 2.1,
		"spli": 1,
		"arp": 1,
		"tags": ["grav", "pistol"],
		"maintenance" : 0.8,
	},
	"Grav-Gun": {
		"abbreviation": "GrvGn",
		"attack": {
			"standard": 450,
			"master_crafted": 475,
			"artifact": 500
		},
		"description": "A medium-sized weapon which utilises the gravitic reaction principle most commonly seen powering grav-vehicles such as the Land Speeder.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 4,
		"range": 4,
		"spli": 3,
		"arp": 1,
		"tags": ["grav"],
		"maintenance" : 0.1,
	},
	"Grav-Cannon": {
		"abbreviation": "GrvCan",
		"attack": {
			"standard": 800,
			"master_crafted": 850,
			"artifact": 900
		},
		"description": "A bigger version of the Grav-Gun which utilises the gravitic reaction principle most commonly seen powering grav-vehicles such as the Land Speeder.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 8,
		"range": 8,
		"spli": 6,
		"arp": 1,
		"tags": ["grav", "heavy_weapon"],
		"maintenance" : 0.2,
	},
	"Underslung Bolter": {
		"abbreviation": "UndBltr",
		"attack": {
			"standard": 60,
			"master_crafted": 70,
			"artifact": 80
		},
		"description": "A compact, secondary Bolter weapon often attached under the barrel of a larger firearm. It allows for rapid fire in close quarters combat.",
		"melee_hands": 0,
		"ranged_hands": 1,
		"ammo": 0,
		"range": 10,
		"spli": 2,
		"arp": 0,
		"tags": ["bolt", "attached"]
	},
	"Stalker Pattern Bolter": {
		"abbreviation": "StlkBltr",
		"attack": {
			"standard": 100,
			"master_crafted": 110,
			"artifact": 120
		},
		"description": "The Stalker Bolter is a scoped long-range variant of the standard Bolter. Depending on the specific modifications made by the wielder, the Stalker Bolter can serve as a precision battle rifle or a high-powered sniper weapon.",
		"melee_hands": 0,
		"ranged_hands": 2,
		"ammo": 20,
		"range": 15,
		"spli": 1,
		"arp": 1,
		"tags": ["bolt", "precision"]
	},
	"Bolter": {
		"abbreviation": "Bltr",
		"attack": {
			"standard": 50,
			"master_crafted": 55,
			"artifact": 60
		},
		"description": "A standard Bolter, a two-handed firearm that launches rocket propelled projectiles that detonate after penetrating the target. It is a versatile and iconic weapon of Adeptus Astartes, their resounding detonations carry the Emperor's Wrath.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 16,
		"range": 12,
		"spli": 3,
		"arp": 0,
		"tags": ["bolt"]
	},
	"Heavy Flamer": {
		"abbreviation": "HvyFlmr",
		"attack": {
			"standard": 500,
			"master_crafted": 550,
			"artifact": 600
		},
		"description": "A significantly heavier flamer typically utilized on vehicle mounts. To carry them on foot requires Power Armor.",
		"melee_hands": 1,
		"ranged_hands": 2.25,
		"ammo": 8,
		"range": 2,
		"spli": 5,
		"arp": -1,
		"tags": ["flame", "heavy_ranged"]
	},
	"CCW Heavy Flamer": {
		"abbreviation": "CCWHvyFlmr",
		"attack": {
			"standard": 250,
			"master_crafted": 275,
			"artifact": 300
		},
		"description": "A powerful close combat weapon integrated with a flamer. Enemeies rarely expect a dreadnough claw to spew promethium.",
		"melee_hands": 1,
		"ranged_hands": 0,
		"ammo": 6,
		"range": 2.1,
		"spli": 5,
		"arp": -1,
		"tags": ["dreadnought","heavy_ranged", "flame"]
	},
	"Dreadnought Power Claw": {
		"abbreviation": "PwrClw",
		"attack": {
			"standard": 400,
			"master_crafted": 600,
			"artifact": 800
		},
		"description": "A brutal crushing claw capable of tearing open armor and flesh with ease utilizing disruptor fields.",
		"melee_hands": 5,
		"range": 1,
		"spli": 10,
		"arp": 1,
		"tags": ["power", "vehicle", "dual", "dreadnought", "fist"],
		"maintenance" : 0.1,
	},
	"Close Combat Weapon": {
		"abbreviation": "CCW",
		"attack": {
			"standard": 350,
			"master_crafted": 450,
			"artifact": 550
		},
		"description": "While a variety of melee weapons are used by dreadnoughts, this power fist with an integrated flamer is the most common.",
		"melee_hands": 5,
		"range": 1,
		"spli": 10,
		"arp": 1,
		"tags": ["vehicle", "dreadnought", "fist"],
		"maintenance" : 0.1,
	},
	"Inferno Cannon": {
		"abbreviation": "InfCann",
		"attack": {
			"standard": 400,
			"master_crafted": 440,
			"artifact": 480
		},
		"description": "A huge vehicle-mounted flame weapon that fires with explosive force. The reservoir is liable to explode.",
		"melee_hands": 0,
		"ranged_hands": 3,
		"ammo": 0,
		"range": 3.1,
		"spli": 20,
		"arp": -1,
		"tags": ["vehicle","heavy_ranged", "flame", "dreadnought"]
	},
	"Meltagun": {
		"abbreviation": "Mltgn",
		"attack": {
			"standard": 450,
			"master_crafted": 475,
			"artifact": 500
		},
		"description": "A loud weapon that roars with fury, this gun vaporizes flesh and armor alike. Due to heat dissipation, it has only a short range.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 4,
		"range": 2.1,
		"spli": 1,
		"arp": 1,
		"tags": ["melta","boarding"]
	},
	"Multi-Melta": {
		"abbreviation": "MltMelt",
		"attack": {
			"standard": 800,
			"master_crafted": 850,
			"artifact": 900
		},
		"description": "Though bearing longer range than the Meltagun, this weapon's great size usually restricts it to vehicles though those with Power Armor can carry this cumbersome weapon into battle.",
		"melee_hands": 1,
		"ranged_hands": 2.25,
		"ammo": 8,
		"range": 4.1,
		"spli": 1,
		"arp": 1,
		"tags": ["melta", "heavy_ranged", "dreadnought"]
	},
	"Plasma Pistol": {
		"abbreviation": "PlsmPstl",
		"attack": {
			"standard": 115,
			"master_crafted": 130,
			"artifact": 150
		},
		"description": "A pistol variant of the plasma gun, this dangerous-to-use weapon has exceptional armor-piercing capabilities.",
		"melee_hands": 0,
		"ranged_hands": 1,
		"ammo": 0,
		"range": 3.1,
		"spli": 1,
		"arp": 1,
		"tags": ["plasma", "energy", "pistol"]
	},
	"Plasma Cutter": { // Basically a dual-linked plasma pistol
		"abbreviation": "PlsmCt",
		"attack": {
			"standard": 230,
			"master_crafted": 260,
			"artifact": 300
		},
		"description": "While actually intended to be used on the battlefield as a tool to repair damaged war machines, the Plasma Cutter is equally adept at slicing through even terminator armour with its intense, constant beam of superheated plasma.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 3.1,
		"spli": 1,
		"arp": 1,
		"tags": ["plasma", "energy", "pistol"]
	},
	"Infernus Pistol": {
		"abbreviation": "InfPstl",
		"attack": {
			"standard": 100,
			"master_crafted": 110,
			"artifact": 120
		},
		"description": "The Infernus Pistol is a compact pistol varient of the melta gun. A brutal blast of heat to burn away the The Emperor's foes.",
		"melee_hands": 0,
		"ranged_hands": 1,
		"ammo": 4,
		"range": 2.1,
		"spli": 3,
		"arp": 1,
		"tags": ["melta", "pistol"]
	},
	"Plasma Gun": {
		"abbreviation": "PlsmGn",
		"attack": {
			"standard": 250,
			"master_crafted": 275,
			"artifact": 300
		},
		"description": "A two-handed weapon that launches blobs of plasma at the target. They are considered both sacred and dangerous, overheating through rapid firing of the weapon. Overheating can result in detonation of the weapon, killing the wielder.",
		"melee_hands": 0,
		"ranged_hands": 2,
		"ammo": 16,
		"range": 12,
		"spli": 3,
		"arp": 1,
		"tags": ["plasma", "energy"]
	},
	"Plasma Cannon": {
		"abbreviation": "PlsmCan",
		"attack": {
			"standard": 500,
			"master_crafted": 600,
			"artifact": 750
		},
		"description": "A heavy variant of the plasma gun, its power output is significantly higher and its damage capability shows. However, it maintains the overheating risk of the Plasma Gun",
		"melee_hands": 1,
		"ranged_hands": 3,
		"ammo": 16,
		"range": 14,
		"spli": 2,
		"arp": 1,
		"tags": ["plasma","energy","heavy_ranged", "dreadnought"]
	},
	"Sniper Rifle": {
		"abbreviation": "SnprRfl",
		"attack": {
			"standard": 80,
			"master_crafted": 88,
			"artifact": 96
		},
		"description": "The Sniper Rifle fires a solid shell over long range and boasts powerful telescopic sights to assist, allowing the user to target enemy weak points and distant foes.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 20,
		"range": 18,
		"spli": 1,
		"arp": 0,
		"tags": ["precision", "rifle"]
	},
	"Assault Cannon": {
		"abbreviation": "AssCann",
		"attack": {
			"standard": 240,
			"master_crafted": 264,
			"artifact": 288
		},
		"description": "A heavy rotary autocannon with a devastating fire rate that can be counted in the hundreds per minute. It is incredibly effective against infantry and light armored targets.",
		"melee_hands": 2.1,
		"ranged_hands": 3,
		"ammo": 5,
		"range": 12,
		"spli": 20,
		"arp": 1,
		"tags": ["heavy_ranged", "dreadnought"]
	},
	"Autocannon": {
		"abbreviation": "Autocnn",
		"attack": {
			"standard": 380,
			"master_crafted": 400,
			"artifact": 430
		},
		"description": "A rapid-firing weapon able to use a wide variety of ammunition, from mass-reactive explosive to solid shells. It has been found to be incredibly effective against large groups of targets and even Traitor Astartes to an extent.",
		"melee_hands": 0,
		"ranged_hands": 2.25,
		"ammo": 25,
		"range": 18,
		"spli": 15,
		"arp": 1,
		"tags": ["heavy_ranged", "dreadnought"]
	},
	"Missile Launcher": {
		"abbreviation": "MsslLnch",
		"attack": {
			"standard": 250,
			"master_crafted": 275,
			"artifact": 300
		},
		"description": "This shoulder mounted weapon is capable of firing either armor-piercing or fragmentation rockets. It's ammunition is limited by what the bearer has carried with them.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 6,
		"range": 24,
		"spli": 3,
		"arp": 0,
		"tags": ["heavy_ranged", "dreadnought"]
	},
	"Lascannon": {
		"abbreviation": "Lascnn",
		"attack": {
			"standard": 600,
			"master_crafted": 700,
			"artifact": 900
		},
		"description": "A formidable laser weapon, the lascannon can pierce most vehicles or power armored targets from a tremendous range. The weapon is known for its reliability in combat.",
		"melee_hands": 1,
		"ranged_hands": 2.25,
		"ammo": 8,
		"range": 24,
		"spli": 1,
		"arp": 1,
		"tags": ["heavy_ranged", "las", "energy"]
	},
	"Conversion Beam Projector": {
		"abbreviation": "CnvBmPrj",
		"attack": {
			"standard": 500,
			"master_crafted": 550,
			"artifact": 600
		},
		"description": "The Conversion Beam Projector is a heavy energy weapon that harnesses advanced technology to project a concentrated beam of destructive energy. Armor detonates as the matter that comproises it is transformed into pure energy.",
		"melee_hands": 0,
		"ranged_hands": 1,
		"ammo": 1,
		"range": 20,
		"spli": 3,
		"arp": 1,
		"tags": ["heavy_ranged", "ancient"]
	},
	"Integrated Bolter": {
		"abbreviation": "IntgBltr",
		"attack": {
			"standard": 50,
			"master_crafted": 55,
			"artifact": 60
		},
		"description": "A Bolter that can be built directly into the structure of the vehicle, armor, another weapon or Dreadnought. When used as a weapon, it leaves both hands free, allowing to use any, even a twohanded weapon, efficiently.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 20,
		"range": 12,
		"spli": 4,
		"arp": 0,
		"tags": ["bolt"]
	},
	"Twin Linked Heavy Bolter": {
		"abbreviation": "TwnHvyBltr",
		"attack": {
			"standard": 320,
			"master_crafted": 352,
			"artifact": 384
		},
		"description": "Twin-linked Heavy Bolters are an upgraded version of the standard Heavy Bolter weapon, which is known for its high rate of fire and effectiveness against infantry and light vehicles.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 20,
		"range": 16,
		"spli": 9,
		"arp": 1,
		"tags": ["bolt", "heavy_ranged", "vehicle", "dreadnought"]
	},
	"Twin Linked Lascannon": {
		"abbreviation": "TwnLascnn",
		"attack": {
			"standard": 600,
			"master_crafted": 700,
			"artifact": 900
		},
		"description": "The Twin-Linked Lascannons is a powerful anti-armour weapons that fire highly focused and devastating duel energy beams capable of penetrating even the toughest armor.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 8,
		"range": 24,
		"spli": 2,
		"arp": 1,
		"tags": ["las", "energy", "heavy_ranged", "vehicle", "dreadnought"]
	},
	"Heavy Bolter": {
		"abbreviation": "HvyBltr",
		"attack": {
			"standard": 320,
			"master_crafted": 352,
			"artifact": 384
		},
		"description": "The Heavy Bolter is a heavy weapon that fires larger and more powerful bolt shells compared to the standard Bolter.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 10,
		"range": 16,
		"spli": 6,
		"arp": 1,
		"tags": ["heavy_ranged", "bolt"]
	},
	"Infernus Heavy Bolter": {
		"abbreviation": "InfrHvyBltr",
		"attack": {
			"standard": 320,
			"master_crafted": 352,
			"artifact": 384
		},
		"description": "The Deathwatch mag-clamp rare suspensor discs onto their infernus heavy bolters that reduce the weapon’s effective weight considerably. Such weapons are further bolstered by underslung heavy flamers that can incinerate those enemies that make it through the hail of explosive bolts.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 10,
		"range": 16,
		"spli": 6,
		"arp": 1,
		"second_profiles": ["Flamer"],
		"tags": ["heavy_ranged", "combi", "bolt"]
	},
	"Whirlwind Missiles": {
		"attack": {
			"standard": 400,
			"master_crafted": 440,
			"artifact": 480
		},
		"description": "The Whirlwind Missile Launcher is a vehicle-mounted artillery weapon that launches a barrage of powerful missiles at the enemy.",
		"abbreviation": "WhrlMssl",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 6,
		"range": 20,
		"spli": 25,
		"arp": 1,
		"tags": ["vehicle","heavy_ranged", "indirect"]
	},
	"HK Missile": {
		"abbreviation": "HKMssl",
		"description": "A single shot hunter killer	missile that serves as a powerful anti armour/aircraft deterent.",
		"tags": ["HK"]
	},
	"Twin Linked Heavy Bolter Mount": {
		"attack": {
			"standard": 240,
			"master_crafted": 264,
			"artifact": 288
		},
		"description": "The Twin-linked Heavy Bolters are an upgraded version of the standard Heavy Bolter weapon. They are mounted onto vehicles to create effective fire support platforms.",
		"abbreviation": "TwnHvyBltr",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 20,
		"range": 16,
		"spli": 3,
		"arp": 1,
		"tags": ["vehicle", "dreadnought", "heavy_ranged", "bolt"]
	},
	"Twin Linked Lascannon Mount": {
		"attack": {
			"standard": 250,
			"master_crafted": 275,
			"artifact": 300
		},
		"description": "The Twin-Lascannons are powerful anti-armour weapons that fire highly focused and devastating energy beams capable of penetrating even the toughest armour. This version is mounted onto vehicles to incease anti-armor capabilities.",
		"abbreviation": "TwnLascnn",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 10,
		"range": 20,
		"spli": 3,
		"arp": 1,
		"tags": ["las", "energy", "vehicle", "heavy_ranged", "dreadnought"]
	},
	"Twin Linked Assault Cannon Mount": {
		"attack": {
			"standard": 240,
			"master_crafted": 264,
			"artifact": 288
		},
		"description": "A twin mount of rotary autocannons, boasting an incredible rate of fire numbering in the hundreds of shots fired per second.",
		"abbreviation": "TwnAssCnn",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 6,
		"range": 12,
		"spli": 30,
		"arp": 1,
		"tags": ["vehicle","heavy_ranged", "pintle", "dreadnought"]
	},
	"Reaper Autocannon Mount": {
		"attack": {
			"standard": 500,
			"master_crafted": 550,
			"artifact": 600
		},
		"description": "An archaic twin-linked autocannon design dating back to the Great Crusade. The Reaper Autocannon is effective against infantry and armored targets. This version is mounted onto vehicles.",
		"abbreviation": "RprAtcnn",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 25,
		"range": 15,
		"spli": 6,
		"arp": 1,
		"tags": ["vehicle","heavy_ranged", "pintle"]
	},
	"Quad Linked Heavy Bolter Sponsons": {
		"attack": {
			"standard": 320,
			"master_crafted": 352,
			"artifact": 384
		},
		"description": "Quad-linked Heavy Bolters are a significantly upgraded version of the standard Heavy Bolter mount; already punishing in a single mount, this quad mount is devastating against a variety of targets.",
		"abbreviation": "QdHvyBltrs",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 15,
		"range": 16,
		"spli": 5,
		"arp": 1,
		"tags": ["bolt","heavy_ranged", "vehicle", "sponson"]
	},
	"Twin Linked Lascannon Sponsons": {
		"attack": {
			"standard": 600,
			"master_crafted": 700,
			"artifact": 900
		},
		"description": "The Twin-Linked Lascannons are powerful anti-armour weapons that fire highly focused and devastating energy beams capable of penetrating even the toughest armour. This version is mounted onto the sides of vehicles.",
		"abbreviation": "TwnLascnns",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 5,
		"range": 20,
		"spli": 3,
		"arp": 1,
		"tags": ["las", "energy", "vehicle", "heavy_ranged", "sponson", "twin_linked"]
	},
	"Lascannon Sponsons": {
		"attack": {
			"standard": 500,
			"master_crafted": 600,
			"artifact": 750
		},
		"description": "Lascannons are powerful anti-armour weapons that fire highly focused and devastating energy beams capable of penetrating even the toughest armour. This version is mounted onto the sides of vehicles.",
		"abbreviation": "Lscnns",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 8,
		"range": 20,
		"spli": 1,
		"arp": 1,
		"tags": ["las", "energy","heavy_ranged", "vehicle", "sponson"]
	},
	"Hurricane Bolter Sponsons": {
		"attack": {
			"standard": 50,
			"master_crafted": 55,
			"artifact": 60
		},
		"description": "Hurricane Bolters are large hex-mount bolter arrays that are able to deliver a withering hail of anti-infantry fire at short ranges. This version is mounted onto the sides of vehicles.",
		"abbreviation": "HrcBltrs",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 10,
		"range": 10,
		"spli": 60,
		"arp": 0,
		"tags": ["bolt","heavy_ranged", "vehicle", "sponson"]
	},
	"Flamestorm Cannon Sponsons": {
		"attack": {
			"standard": 600,
			"master_crafted": 660,
			"artifact": 720
		},
		"description": "A huge vehicle-mounted flamethrower cannon, the heat produced by this terrifying weapon can melt armoured ceramite.",
		"abbreviation": "FlmstCnns",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 6,
		"range": 2,
		"spli": 3,
		"arp": 1,
		"tags": ["flame","heavy_ranged", "vehicle", "sponson"]
	},
	"Twin Linked Heavy Flamer Sponsons": {
		"attack": {
			"standard": 500,
			"master_crafted": 550,
			"artifact": 600
		},
		"description": "A twin-linked significantly heavier flamer attached to the sponsons on a vehicle.",
		"abbreviation": "TwnHvyFlmrs",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 8,
		"range": 2.1,
		"spli": 8,
		"arp": -1,
		"tags": ["flame","heavy_ranged", "vehicle", "dreadnought", "sponson"]
	},
	"Twin Linked Bolters": {
		"attack": {
			"standard": 80,
			"master_crafted": 140,
			"artifact": 180
		},
		"description": "A Twin-linked Bolter consists of two Bolter weapons mounted side by side, typically on a vehicle or a dedicated weapons platform.",
		"abbreviation": "TwnBltrs",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 30,
		"range": 12,
		"spli": 6,
		"arp": 0,
		"tags": ["bolt", "vehicle"]
	},
	"Twin Linked Multi-Melta Sponsons": {
		"abbreviation": "TwnMltMelts",
		"attack": {
			"standard": 800,
			"master_crafted": 850,
			"artifact": 900
		},
		"description": "Though bearing longer range than the Meltagun, this weapon's great size usually restricts it to vehicles. In this case it is mounted to the sponsons on a vehicle.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 8,
		"range": 4.1,
		"spli": 2,
		"arp": 1,
		"tags": ["vehicle","heavy_ranged", "Sponson", "melta"],
		"maintenance" : 0.05,
	},
	"Twin Linked Volkite Culverin Sponsons": {
		"abbreviation": "TwnVlkCulvs",
		"attack": {
			"standard": 480,
			"master_crafted": 510,
			"artifact": 540
		},
		"description": "An advanced thermal weapon from a bygone era, Volkite Culverins are able to ignite entire formations of enemy forces. In this case it is mounted to the sponsons on a vehicle.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 25,
		"range": 18,
		"spli": 9,
		"arp": 0,
		"tags": ["vehicle","heavy_ranged", "Sponson", "volkite", "ancient"]
	},
	"Heavy Bolter Sponsons": {
		"abbreviation": "HvyBltrs",
		"attack": {
			"standard": 240,
			"master_crafted": 264,
			"artifact": 288
		},
		"description": "Heavy Bolters are mounted in sponsons. They are known for high rates of fire and effectiveness against infantry and light vehicles.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 20,
		"range": 16,
		"spli": 4,
		"arp": 1,
		"tags": ["heavy_ranged", "vehicle", "sponson", "bolt"],
	},
	"Heavy Flamer Sponsons": {
		"abbreviation": "HvyFlmrs",
		"attack": {
			"standard": 500,
			"master_crafted": 550,
			"artifact": 600
		},
		"description": "A significantly heavier flamer attached to the sponsons on a vehicle.",
		"abbreviation": "SpnHvyFlmrs",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 8,
		"range": 2.1,
		"spli": 4,
		"arp": -1,
		"tags": ["flame","heavy_ranged", "vehicle", "sponson"],
		"maintenance" : 0.05,
	},
	"Volkite Culverin Sponsons": {
		"abbreviation": "VlkClvs",
		"attack": {
			"standard": 480,
			"master_crafted": 528,
			"artifact": 576
		},
		"description": "An advanced thermal weapon from a bygone era, Volkite Culverins are able to ignite entire formations of enemy forces. In this case it is mounted to the sponsons on a vehicle.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 25,
		"range": 18,
		"spli": 5,
		"arp": 1,
		"tags": ["vehicle","heavy_ranged", "Sponson", "volkite", "ancient"]
	},
	"Autocannon Turret": {
		"abbreviation": "Autocnn",
		"attack": {
			"standard": 380,
			"master_crafted": 528,
			"artifact": 576
		},
		"description": "A Predator-compatible turret mounting a reliable all-purpose autocannon capable of doing effective damage to infantry and lightly armored targets.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 25,
		"range": 18,
		"spli": 15,
		"arp": 0,
		"tags": ["vehicle","heavy_ranged", "turret"]
	},
	"Storm Bolter": {
		"abbreviation": "StrmBltr",
		"attack": {
			"standard": 80,
			"master_crafted": 88,
			"artifact": 96
		},
		"description": "Compact and double-barreled, this bolt weapon is inaccurate but grants an enormous amount of firepower. Its psychological effect on the enemy should not be understated.",
		"melee_hands": 1.1,
		"ranged_hands": 1.1,
		"ammo": 10,
		"range": 10,
		"spli": 6,
		"arp": 0,
		"tags": ["bolt"],
		"maintenance" : 0.03,
	},
	"Hand Flamer": {
		"abbreviation": "HndFlmr",
		"attack": {
			"standard": 125,
			"master_crafted": 190,
			"artifact": 210
		},
		"description": "Along with using a lower-capacity fuel tank it has much reduced range, which makes it suited for assault and close-combat purposes, incinerating foes at short range. The weapon is often used by assault squads.",
		"melee_hands": 0,
		"ranged_hands": 1,
		"ammo": 2,
		"range": 2.1, // Infernus pistol has 2 range, so
		"spli": 2, // This should probably be increased to at least 3, but maybe even 5 or 10
		"arp": -1,
		"tags": ["pistol", "flame"] //,
		// "maintenance" : 0.01, - decide on the value you prefer
	},
	"Flamer": {
		"abbreviation": "Flmr",
		"attack": {
			"standard": 350,
			"master_crafted": 385,
			"artifact": 420
		},
		"melee_mod": {
			"standard": 0,
			"master_crafted": 0,
			"artifact": 0
		},
		"description": "Blackened at the tip, this weapon unleashes a torrent of burning promethium - all the better to cleanse sin and impurity with.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 4,
		"range": 2.1,
		"spli": 4,
		"arp": -1,
		"tags": ["flame"],
		"maintenance" : 0.01,
	},
	"Underslung Flamer": {
		"attack": {
			"standard": 200,
			"master_crafted": 220,
			"artifact": 240
		},
		"description": "",
		"abbreviation": "UndrFlmr",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 4,
		"range": 2.1,
		"spli": 3,
		"arp": -1,
		"tags": ["flame", "attached"]
	},
	"Combiflamer": {
		"abbreviation": "CmbFlmr",
		"attack": {
			"standard": 100,
			"master_crafted": 130,
			"artifact": 160
		},
		"description": "A standard Bolter with an underbarrel Flamer for expanded tactical utility.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 15,
		"range": 10,
		"spli": 3,
		"arp": 0,
		"second_profiles": ["Flamer"],
		"tags": ["combi", "bolt"]
	},
	"Combiplasma": {
		"abbreviation": "CmbPlsm",
		"attack": {
			"standard": 100,
			"master_crafted": 130,
			"artifact": 160
		},
		"description": "A standard Bolter with an underbarrel Plasma Gun for expanded tactical utility.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 15,
		"range": 10,
		"spli": 3,
		"arp": 0,
		"second_profiles": ["Plasma Gun"],
		"tags": ["combi", "bolt"]
	},
	"Combigrav": {
		"abbreviation": "CmbGrv",
		"attack": {
			"standard": 100,
			"master_crafted": 130,
			"artifact": 160
		},
		"description": "A standard Bolter with an underbarrel Grav-Gun for expanded tactical utility.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 15,
		"range": 10,
		"spli": 3,
		"arp": 0,
		"second_profiles": ["Grav-Gun"],
		"tags": ["combi", "bolt"]
	},
	"Combimelta": {
		"abbreviation": "CmbMlt",
		"attack": {
			"standard": 100,
			"master_crafted": 130,
			"artifact": 160
		},
		"description": "A standard Bolter with an underbarrel Meltagun for expanded tactical utility.",
		"melee_hands": 1,
		"ranged_hands": 2,
		"ammo": 15,
		"range": 10,
		"spli": 3,
		"arp": 0,
		"second_profiles": ["Meltagun"],
		"tags": ["combi", "bolt"]
	},
	"Incinerator": {
		"attack": {
			"standard": 200,
			"master_crafted": 220,
			"artifact": 240
		},
		"description": "This flamer weapon utilizes psychically-charged promethium and blessed oils concoction to create an azure flame that bypasses psychich protections. It is particularly effective against Daemons and their ilk.",
		"abbreviation": "Incnrtr",
		"melee_hands": 1,
		"ranged_hands": 1,
		"ammo": 4,
		"range": 2.1,
		"spli": 3,
		"arp": -1,
		"tags": ["flame"]
	},
	"Force Staff": {
		"attack": {
			"standard": 200,
			"master_crafted": 230,
			"artifact": 270
		},
		"melee_mod": {
			"standard": 1,
			"master_crafted": 1.1,
			"artifact": 1.2
		},
		"abbreviation": "FrcStff",
		"description": "An advanced, psychically-attuned close combat weapon that is only fully effective in the hands of a psyker.",
		"melee_hands": 1,
		"ranged_hands": 1,
		"range": 1,
		"spli": 5,
		"arp": 1,
		"tags": ["force" ],
		"specials": {
			"psychic_amplification": 25
		},
		"maintenance" : 0.1,
	},
	"Force Sword": {
		"abbreviation": "FrcSwrd",
		"attack": {
			"standard": 180,
			"master_crafted": 200,
			"artifact": 240
		},
		"melee_mod": {
			"standard": 1,
			"master_crafted": 1.1,
			"artifact": 1.2
		},
		"description": "The Force Sword is a psychically-attuned close combat weapon that is only fully effective in the hands of a psyker.",
		"melee_hands": 1,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 4,
		"arp": 1,
		"special_properties": ["Parry"],
		"tags": ["force", "sword"],
		"maintenance" : 0.1,
	},
	"Force Axe": {
		"abbreviation": "FrcAxe",
		"attack": {
			"standard": 190,
			"master_crafted": 220,
			"artifact": 260
		},
		"melee_mod": {
			"standard": 1,
			"master_crafted": 1.1,
			"artifact": 1.2
		},
		"description": "The Force Axe is a psychically-attuned close combat weapon that is only fully effective in the hands of a psyker.",
		"melee_hands": 1,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 5,
		"arp": 1,
		"special_description": "Able to be dual-wielded",
		"tags": ["force", "axe", "dual"],
	},
	"Twin Linked Lascannon Turret": {
		"attack": {
			"standard": 600,
			"master_crafted": 700,
			"artifact": 900
		},
		"abbreviation": "TwnLscnn",
		"description": "A Predator-compatible turret mounting a twin-linked lascannon.",
		"arp": 1,
		"range": 24,
		"ammo": 5,
		"spli": 2,
		"tags": ["las", "energy", "twin_linked","heavy_ranged", "vehicle", "turret"]
	},
	"Twin Linked Assault Cannon Turret": {
		"abbreviation": "TwnAssCnn",
		"attack": {
			"standard": 240,
			"master_crafted": 264,
			"artifact": 288
		},
		"description": "A heavy rotary autocannon with a devastating fire rate that can be counted in the hundreds per minute, in a twin mount. It is incredibly effective against infantry and lightly armored targets.",
		"melee_hands": 2.1,
		"ranged_hands": 2.25,
		"ammo": 5,
		"range": 12,
		"spli": 30,
		"arp": 1,
		"tags": ["heavy_ranged", "twin_linked", "vehicle", "turret"]
	},
	"Flamestorm Cannon Turret": {
		"abbreviation": "FlmstCnn",
		"attack": {
			"standard": 600,
			"master_crafted": 660,
			"artifact": 720
		},
		"description": "A huge vehicle-mounted flamethrower cannon, the heat produced by this terrifying weapon can melt armoured ceramite.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 12,
		"range": 2,
		"spli": 3,
		"arp": 1,
		"tags": ["flame","heavy_ranged", "vehicle", "turret"]
	},
	"Magna-Melta Turret": {
		"abbreviation": "MgnMlt",
		"attack": {
			"standard": 800,
			"master_crafted": 900,
			"artifact": 1000
		},
		"description": "Though bearing longer range than the Meltagun, this weapon's great size usually restricts it to vehicles. In this case it is mounted to the turret on a vehicle.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 6,
		"range": 5.1,
		"spli": 2,
		"arp": 1,
		"tags": ["vehicle","heavy_ranged", "turret", "melta"]
	},
	"Plasma Destroyer Turret": {
		"abbreviation": "PlsmDestr",
		"attack": {
			"standard": 500,
			"master_crafted": 600,
			"artifact": 750
		},
		"description": "A heavy variant of the plasma gun, its power output is significantly higher and its damage capability shows. However, it is mounted in a tank turret.",
		"melee_hands": 1,
		"ranged_hands": 3,
		"ammo": 16,
		"range": 14,
		"spli": 3,
		"arp": 1,
		"tags": ["plasma", "energy","heavy_ranged", "vehicle", "turret"]
	},
	"Heavy Conversion Beam Projector": {
		"abbreviation": "HvyCnvBmr",
		"attack": {
			"standard": 800,
			"master_crafted": 900,
			"artifact": 1000
		},
		"description": "The Conversion Beam Projector is a heavy energy weapon that harnesses advanced technology to project a concentrated beam of destructive energy. Armor detonates as the matter that comproises it is transformed into pure energy. This is the heavy version for mounting in vehicles.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 6,
		"range": 20,
		"spli": 1,
		"arp": 1,
		"tags": ["vehicle","heavy_ranged", "dreadnought", "turret", "ancient"]
	},
	"Neutron Blaster Turret": {
		"abbreviation": "NtrnBlstr",
		"attack": {
			"standard": 800,
			"master_crafted": 900,
			"artifact": 1000
		},
		"description": "This is a Neutron blaster, typically found in Sabre Strike Tanks, this one has been mounted for use in a space marine tank.",
		"melee_hands": 0,
		"ranged_hands": 1,
		"ammo": 6,
		"range": 20,
		"spli": 2,
		"arp": 1,
		"tags": ["vehicle","heavy_ranged", "turret"]
	},
	"Volkite Saker Turret": {
		"abbreviation": "VlkSkr",
		"attack": {
			"standard": 300,
			"master_crafted": 333,
			"artifact": 375
		},
		"description": "An advanced thermal weapon from a bygone era, Volkite sakers are optimized for spreading damage across swaths of enemy troops.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 25,
		"range": 18,
		"spli": 30,
		"arp": 0,
		"tags": ["vehicle","heavy_ranged", "turret", "volkite", "ancient"]
	},
	
// Hireling weapons
	// Admech
	"Hellgun": {
		"abbreviation": "HllGun",
		"attack": {
			"standard": 30,
			"master_crafted": 35,
			"artifact": 40
		},
		"description": "Known as a Hellgun or Hot-shot Lasgun, these high-energy weapons are more potent and destructive than common Lasguns, drawing more power for a more penetrative shot, but also more complex, requiring reinforced barrels, thermal-cooling cells and gyro-stabilized power packs.",
		"ammo": 20,
		"range": 12,
		"spli": 3,
		"arp": 0,
		"tags": ["las"],
		"melee_hands": 0,
		"ranged_hands": 1,
	},
	"Laspistol": {
		"attack": {
			"standard": 20,
			"master_crafted": 30,
			"artifact": 40
		},
		"description": "The Laspistol is the pistol version of the Lasgun and like that weapon fires a coherent beam of energetic photons that can burn through most materials. The Laspistol is powered by a miniature power pack that is usually placed within the grip.",
		"abbreviation": "Lpstl",
		"melee_hands": 0,
		"ranged_hands": 0.25,
		"ammo": 30,
		"range": 3.1,
		"spli": 1,
		"arp": 0,
		"tags": ["pistol", "las"],
	},
	// Other imperials
	"Light Bolter": {
		"abbreviation": "LghtBltr",
		"attack": {
			"standard": 35,
			"master_crafted": 40,
			"artifact": 45
		},
		"description": "A smaller variant of Bolter, intended to be useable by unaugmented humans.",
		"melee_hands": 1,
		"ranged_hands": 1,
		"ammo": 16,
		"range": 10,
		"spli": 2,
		"arp": 0,
		"tags": ["bolt"],
		"second_profiles": ["Sarissa"]
	},
	"Sarissa": {
		"abbreviation": "Saris",
		"attack": {
			"standard": 25,
			"master_crafted": 30,
			"artifact": 35
		},
		"description": "A vicious combat attachment that is attached to Bolters, in order to allow them to be used in melee combat.",
		"melee_hands": 0,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 1,
		"arp": 0,
		"tags": ["axe"],
	},
	"Hellrifle": {
		"description": "Extremely effective and intricate weapons frowned upon by more Puritanical Inquisitors. Fire shards of an unknown material. Speculated to be daemonic in origin.",
		"abbreviation": "HllRifle",
		"attack": {
			"standard": 200,
			"master_crafted": 250,
			"artifact": 300
		},
		"ammo": 10,
		"range": 20,
		"spli": 1,
		"arp": 0,
		"tags": ["rifle", "arcane"],
		"ranged_hands": 1,
	},
	// Eldar weapons
	"Ranger Long Rifle": {
		"abbreviation": "RangeLoRife",
		"description": "Advanced and accurate rifles from mars given to skitarii sharpshooters",
		"attack": {
			"standard": 60,
			"master_crafted": 70,
			"artifact": 90
		},
		"ranged_hands": 1,
		"range": 25,
		"tags": ["las", "rifle", "precision"],
	},
	"Shuriken Pistol": {
		"abbreviation": "ShurikP",
		"attack": {
			"standard": 25,
			"master_crafted": 28,
			"artifact": 31
		},
		"melee_hands": 1,
		"ranged_hands": 0,
		"ammo": 6,
		"range": 2.1,
		"spli": 3,
		"arp": 0,
		"tags": ["pistol"]
	},
	"Eldar Power Sword": {
		"abbreviation": "EldPwrSwrd",
		"attack": {
			"standard": 170,
			"master_crafted": 180,
			"artifact": 190
		},
		"melee_mod": {
			"standard": 1.1,
			"master_crafted": 1.1,
			"artifact": 1.1
		},
		"description": "Power weapons, infused with arcane energy, are used by Howling Banshees and Dire Avenger Exarchs. Swords such as these are as much an artistic statement as a weapon and are effective against even heavily armored troops.",
		"melee_hands": 1.1,
		"ranged_hands": 0,
		"ammo": 0,
		"range": 1,
		"spli": 3,
		"arp": 1,
		"special_properties": ["Parry"],
		"tags": ["power", "sword", "elder", "xenos"],
	},
	// Ork weapons
	"Choppa": {
		"abbreviation": "Chop",
		"attack": {
			"standard": 28,
			"master_crafted": 32,
			"artifact": 36
		},
		"melee_hands": 1,
		"range": 1,
		"spli": 3,
		"tags": ["axe"]
	},
	"Snazzgun": {
		"abbreviation": "Snazz",
		"attack": {
			"standard": 80,
			"master_crafted": 92,
			"artifact": 104
		},
		"ranged_hands": 1,
		"ammo": 20,
		"range": 3.1,
		"spli": 3,
		"arp": 0,
		"tags": ["rifle"]
	},
}
global.gear = {
	"armour": {
		"Power Armour": {
			"abbreviation": "PwrArm",
			"armour_value": {
				"standard": 19,
				"master_crafted": 25,
				"artifact": 30
			},
			"ranged_mod": {
				"standard": 0,
				"master_crafted": 5,
				"artifact": 10
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5,
				"artifact": 10
			},
			"description": "A suit of Adeptus Astartes power armour. The Mark can no longer be determined- it appears to be a combination of several types.",
			"tags": ["power_armour"],
		},
		"Artificer Armour": {
			"abbreviation": "Artfcr",
			"armour_value": {
				"standard": 30,
				"master_crafted": 34,
				"artifact": 38
			},
			"ranged_mod": {
				"standard": 5,
				"master_crafted": 10,
				"artifact": 15
			},
			"melee_mod": {
				"standard": 10,
				"master_crafted": 15,
				"artifact": 20
			},
			"description": "A custom suit of power armored created by master artificiers and decorated without compare, this ancient Power Armour is beyond priceless. This suit's history is ancient and its users many.",
			"tags": ["power_armour"],
		},
		"Terminator Armour": {
			"abbreviation": "Indmts",
			"armour_value": {
				"standard": 42,
				"master_crafted": 46,
				"artifact": 50
			},
			"ranged_mod": {
				"standard": -10,
				"master_crafted": -5,
				"artifact": 0
			},
			"melee_mod": {
				"standard": 20,
				"master_crafted": 25,
				"artifact": 30
			},
			"melee_hands": 2,
			"ranged_hands": 2,
			"description": "Terminator Armour is the strongest and most powerful armour designed by humanity, available only to the veterans of the Adeptus Astartes. The Indomitus Pattern is the most widespread and versatile pattern as of M41.",
			"tags": ["terminator"],
			"req_exp": 100,
			"maintenance" : 0.3,
		},
		"Dreadnought": {
			"abbreviation": "Drdnght",
			"armour_value": {
				"standard": 50,
				"master_crafted": 55,
				"artifact": 60
			},
			"ranged_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"melee_hands": 8,
			"ranged_hands": 8,
			"description": "A massive war-machine that can be piloted by an honored Astarte, who otherwise would have fallen in combat. Some of the Astartes consider this a fate worse than death",
			"tags": ["dreadnought"],
			"maintenance" : 1,
		},
		"Tartaros": {
			"abbreviation": "Tartrs",
			"armour_value": {
				"standard": 42,
				"master_crafted": 46,
				"artifact": 50
			},
			"ranged_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"melee_mod": {
				"standard": 20,
				"master_crafted": 25,
				"artifact": 30
			},
			"melee_hands": 2,
			"ranged_hands": 2,
			"description": "This pattern is possibly considered the most advanced form of Terminator Armour, providing greater mobility for the wearer compared to the Indomitus with no loss in durability. In the M41 considered to be incredibly rare with wars being fought to secure more suits.",
			"tags": ["terminator"],
			"req_exp": 100,
			"maintenance" : 0.5,
		},
		"Cataphractii Pattern Terminator": {
			"abbreviation": "Catphr",
			"armour_value": {
				"standard": 42,
				"master_crafted": 46,
				"artifact": 50
			},
			"ranged_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"melee_mod": {
				"standard": 20,
				"master_crafted": 25,
				"artifact": 30,
			},
			"melee_hands": 2,
			"ranged_hands": 2,
			"description": "Among the first issued to the Space Marine Legions. Having additional plating and shield generators installed within the shoulder pads resulted in severe straining of the suit's exoskeleton and reduced the wearer's maneuverability, leading to its decline among some legions.",
			"tags": ["terminator"],
			"req_exp": 100,
			"maintenance" : 0.75,
		},
		"Scout Armour": {
			"abbreviation": "SctArm",
			"armour_value": {
				"standard": 11,
				"master_crafted": 12,
				"artifact": 14
			},
			"ranged_mod": {
				"standard": 15,
				"master_crafted": 20, // Augmented
				"artifact": 25 // Augmented
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"description": "A non-powered suit made up of carapace armour and ballistic nylon. Includes biohazard shielding, nutrient feed, and camouflage."
		},
		"MK3 Iron Armour": {
			"abbreviation": "MK3",
			"armour_value": {
				"standard": 26,
				"master_crafted": 29,
				"artifact": 32
			},
			"ranged_mod": {
				"standard": -10,
				"master_crafted": -5,
				"artifact": 0
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"description": "An ancient set of Power Armor dating back to the early Great Crusade. The Mark III has heavier armor plating but is far heavier then its contemporaries.",
			"tags": ["power_armour"],
			"maintenance" : 0.1,
		},
		"MK4 Maximus": {
			"abbreviation": "MK4",
			"armour_value": {
				"standard": 22,
				"master_crafted": 25,
				"artifact": 28
			},
			"ranged_mod": {
				"standard": 5,
				"master_crafted": 10,
				"artifact": 15
			},
			"melee_mod": {
				"standard": 5,
				"master_crafted": 10, // Augmented
				"artifact": 15 // Augmented
			},
			"description": "Power Armor dating back to the end of the Great Crusade. It is considered the pinnacle of Power Armor by some Astartes. However, the components are no longer reproducible, the knowledge having been lost to time.",
			"tags": ["power_armour"],
			"maintenance" : 0.2,
		},
		"MK5 Heresy": {
			"abbreviation": "MK5",
			"armour_value": {
				"standard": 15,
				"master_crafted": 17,
				"artifact": 21
			},
			"ranged_mod": {
				"standard": -5,
				"master_crafted": 0,
				"artifact": 0
			},
			"melee_mod": {
				"standard": 20,
				"master_crafted": 25,
				"artifact": 30
			},
			"description": "A hastily assembled Power Armor that first started appearing during the Horus Heresy to act as a stopgap while new suits were produced and sent to loyalist legions. It excels in close combat but it has limited sensors for ranged combat.",
			"tags": ["power_armour"],
			"maintenance" : 0.05,
		},
		"MK6 Corvus": {
			"abbreviation": "MK6",
			"armour_value": {
				"standard": 15,
				"master_crafted": 17,
				"artifact": 19
			},
			"ranged_mod": {
				"standard": 15,
				"master_crafted": 20, // Augmented
				"artifact": 25 // Augmented
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"description": "A suit dating back to the Horus Heresy, first tested by the Raven Guard. It contains boosted olfactory and auditory sensors that increase the ranged accuracy of the wearer. This however makes it more fragile to an extent.",
			"tags": ["power_armour"],
			"maintenance" : 0.05,
		},
		"MK7 Aquila": {
			"abbreviation": "MK7",
			"armour_value": {
				"standard": 17,
				"master_crafted": 19,
				"artifact": 21
			},
			"ranged_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"description": "The most common power armour of the Adeptus Astartes and the only power armour still widely manufactured by the Imperium.",
			"tags": ["power_armour"],
			"maintenance" : 0.01,
		},
		"MK8 Errant": {
			"abbreviation": "MK8",
			"armour_value": {
				"standard": 22,
				"master_crafted": 24,
				"artifact": 26
			},
			"ranged_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"description": "The newest and most advanced of the standard mark power armours as such production has not yet reached maximum capacity creating a supply shortage while chapters rush to get access to them.",
			"tags": ["power_armour"],
			"maintenance" : 0.02,
		},
		"MK10 Tacticus": {
			"abbreviation": "MK10",
			"armour_value": {
				"standard": 24,
				"master_crafted": 26, // Augmented
				"artifact": 28 // Augmented
			},
			"ranged_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"description": "The MKX Tacticus is the most advanced pattern of power armour available to the Adeptus Astartes, featuring advanced armor composites and systems. It was developed by Belisarius Cawl during the development of the Primaris Astartes program.",
			"tags": ["power_armour"],
		},
		"Armoured Ceramite": {
			"abbreviation": "ArmCrmt",
			"description": "Supplemental ceramite armour packages provide protection far beyond stock configurations while also adding significant weight to the chassis.",
			"armour_value": {
				"standard": 20,
				"master_crafted": 24,
				"artifact": 28
			},
			"tags": ["vehicle", "armour"],
		},
		"Heavy Armour": {
			"abbreviation": "HvyArm",
			"description": "Simple but effective, extra armour plates can be attached to most vehicles to provide extra protection.",
			"armour_value": {
				"standard": 10,
				"master_crafted": 12,
				"artifact": 14
			},
			"tags": ["vehicle", "armour"],
		},
		"Void Shield": {
			"abbreviation": "V Shld",
			"description": "An advanced shield capable of providing extreme protection to heavy vehicles.",
			"armour_value": {
				"standard": 40,
				"master_crafted": 52,
				"artifact": 64
			},
			"damage_resistance_mod": {
				"standard": 30,
				"master_crafted": 35,
				"artifact": 40
			},
			"tags": ["vehicle", "armour", "voidshield"],
		},
		"Lucifer Pattern Engine": {
			"abbreviation": "Luc Eng",
			"description": "An advanced engine that increases tactical flexibility by enabling more options for movement and faster repositioning.",
			"damage_resistance_mod": {
				"standard": 10,
				"master_crafted": 15,
				"artifact": 20
			},
			"ranged_mod": {
				"standard": 10,
				"master_crafted": 15,
				"artifact": 20
			},
			"tags": ["vehicle", "armour", "Upgrade"],
		},
		"Artificer Hull": {
			"abbreviation": "ArtHll",
			"description": "Replacing numerous structural components and armour plates with thrice-blessed replacements, the vehicle’s hull is upgraded to be a rare work of mechanical art by master artificers.",
			"armour_value": {
				"standard": 10,
				"master_crafted": 12,
				"artifact": 14
			},
			"damage_resistance_mod": {
				"standard": 15,
				"master_crafted": 20,
				"artifact": 25
			},
			"tags": ["vehicle", "Upgrade"],
		},
// Hireling Armour
	// Admech
		"Skitarii Armour": {
			"abbreviation": "SkitArm",
			"description": "Skitarii Armour is something of a misnomer as most Skitarii are in fact bonded more or less permenantly to their advanced mars armour",
			"armour_value": {
				"standard": 10, // Might as well buff this
				"master_crafted": 12, // Augmented
				"artifact": 15 // Augmented
			},
		},
		"Dragon Scales": {
			"abbreviation": "DrgnScl",
			"description": "Dragon Scales are an advanced armour utilized by tech priests, it is remarkably lightweight for the protection it affords and is often greatly modified by it's wearer while also being designed to directly interface with the user's cybernetic body.",
			"armour_value": {
				"standard": 16,
				"master_crafted": 18,
				"artifact": 20
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5,
				"artifact": 10
			},
		},
	// Sororitas and other imperials
		"Light Power Armour": {
			"abbreviation": "LPwrArm",
			"armour_value": {
				"standard": 13,
				"master_crafted": 15,
				"artifact": 17
			},
			"ranged_mod": {
				"standard": 0,
				"master_crafted": 5,
				"artifact": 10
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5,
				"artifact": 10
			},
			"description": "A suit of light power armour, intended to be useable by the regular humans.",
		},
		"Sororitas Power Armour": {
			"abbreviation": "SrPwrArm",
			"armour_value": {
				"standard": 14,
				"master_crafted": 16,
				"artifact": 18
			},
			"ranged_mod": {
				"standard": 5,
				"master_crafted": 10,
				"artifact": 15
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5,
				"artifact": 10
			},
			"description": "Lighter than most suits, thanks to plug ports that link the Sister's musculature directly to the enhanced fibre bundle network, while providing excellent protection. Helmet has an integrated targeter."
		},
	// Eldar
		"Ranger Armour":{
			"abbreviation": "RngrArm",
			"description": "This armour is used by eldar rangers.",
			"armour_value": {
				"standard": 25,
				"master_crafted": 27,
				"artifact": 30
			},
		},
	// Orks
		"Ork Armour": {
			"abbreviation": "OrkArm",
			"armour_value": {
				"standard": 7,
				"master_crafted": 8,
				"artifact": 9
			},
			"ranged_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"melee_mod": {
				"standard": 0,
				"master_crafted": 5, // Augmented
				"artifact": 10 // Augmented
			},
			"description": "Mismatched basic armour used by ork forces"
		},
	// T'au
		"Fire Warrior Armour": {
			"abbreviation": "FWarArm",
			"description": "This armour is used by T'au fire warriors.",
			"armour_value": { // TODO - needs rebalancing
				"standard": 20,
				"master_crafted": 22,
				"artifact": 25
			},
		}
	},
	"gear": {
		"Sororitas Medkit": {
			"abbreviation": "SorMed",
			"description": "A multi-purpose medkit designed to deal with basic battlefield ailments until further medical assistance can be sought.",
		},
		"Bionics": {
			"abbreviation": "Bncs",
			"description": "Bionics may be given to wounded Astartes to quickly get them back into a combat-ready state, replacing damaged flesh. This is utilized when a Astarte enters a critical state.",
			"hp_mod": {
				"standard": 30, // Adjusted
				"master_crafted": 50, // Adjusted
				"artifact": 50 // Adjusted
			}
		},
		"Narthecium": {
			"abbreviation": "Nrthcm",
			"special_properties": ["Medkit"],
			"description": "An advanced medical field kit these allow Apothecaries to heal wounds or recover Gene-Seed from fallen Astartes.",
			"melee_hands": -0.5,
			"ranged_hands": -0.5,
			"damage_resistance_mod": {
				"standard": 0, // Adjusted
				"master_crafted": 5, // Adjusted
				"artifact": 10 // Adjusted
			}, // I also had an idea to make Nartheciums and Servo Arms give bonuses to melee and ranged, when master-crafted or artifact, indicating measuring devices that help to find weakpoints and deal more damage, but I'm not sure if You're okay with that
		},
		"Psychic Hood": {
			"abbreviation": "PsyHd",
			"description": "An arcane hood that protects Psykers from enemy psychic powers and enhances control of their psychic abilities.",
			"specials": {
				"psychic_focus": 15
			},
		},
		"Rosarius": {
			"abbreviation": "Rsrius",
			"description": "Also called the 'Soul's Armour', this amulet has a powerful built-in shield generator. They are an icon of the Imperial Creed and the Emperor's Protection.",
			"damage_resistance_mod": {
				"standard": 15, // Adjusted
				"master_crafted": 20, // Adjusted
				"artifact": 25 // Adjusted
			},
			"hp_mod": {
				"standard": 5,
				"master_crafted": 10,
				"artifact": 10
			}
		},
		"Iron Halo": {
			"abbreviation": "IrnHalo",
			"description": "An ancient artifact, these powerful conversion field generators are granted to high ranking battle brothers or heroes of the chapter. Bearers are often looked to for guidance by their fellow Astartes.",
			"damage_resistance_mod": {
				"standard": 35, // Adjusted
				"master_crafted": 40, // Adjusted
				"artifact": 45 // Adjusted
			},
		},
		"Combat Shield": {
			"description": "A lighter, more maneuverable version of a Storm Shield. Due to its flexibility, Combat Shields leave other hand of a Space Marine free to use other hand-to-hand weaponry.",
			"abbreviation": "CmbtShld",
			"armour_value": {
				"standard": 4,
				"master_crafted": 6,
				"artifact": 8
			},
			"weight": 3,
			"tags": ["shield"],
			"hp_mod": {
				"standard": 10,
				"master_crafted": 15,
				"artifact": 20
			},
		},
		"Plasma Bomb": {
			"abbreviation": "PlBomb",
			"special_properties": ["Structure Destroyer"],
			"description": "A special plasma charge, this bomb can be used to seal underground caves or destroy enemy structures.",
		},
		"Exterminatus": {
			"abbreviation": "Extrmnts",
			"special_properties": ["Planet Destroyer"],
			"description": "A weapon of the Emperor, and His divine judgment, this weapon can be placed upon a planet to obliterate it entirely.",
		},
		"Smoke Launchers": {
			"description": "Useful for providing concealment in open terrain, these launchers project wide-spectrum concealing smoke to prevent accurate targeting of the vehicle.",
			"abbreviation": "SmkLnchrs",
			"damage_resistance_mod": {
				"standard": 5,
				"master_crafted": 10,
				"artifact": 15
			},
			"tags": ["smoke", "conceal", "vehicle", "dreadnought"]
		},
		"Dozer Blades": {
			"description": "An attachment for the front of vehicles, useful for clearing difficult terrain and can be used as an improvised weapon. ",
			"abbreviation": "DzrBlds",
			"attack": {
				"standard": 30,
				"master_crafted": 35,
				"artifact": 50
			},
			"ammo": 0,
			"range": 1,
			"spli": 1,
			"arp": 0,
			"tags": ["vehicle"],
		},
		"Searchlight": {
			"description": "A simple solution for fighting in dark environments, searchlights serve to illuminate enemies for ease of targeting.",
			"abbreviation": "SrchLght",
			"ranged_mod": {
				"standard": 5,
				"master_crafted": 10,
				"artifact": 15
			},
			"tags": ["vehicle", "dreadnought"],
		},
		"Frag Assault Launchers": {
			"abbreviation": "FrgAssLnchrs",
			"description": "These launchers enable a vehicle to clear an area for its loaded troops, or prevent boarding by an enemy at close range.",
			"damage_resistance_mod": {
				"standard": 10,
				"master_crafted": 15,
				"artifact": 20
			},
			"tags": ["vehicle"],
		},
		"Gene Pod Incubator" : {
			"abbreviation": "GenePod",
			"description": "Required to house gene slaves in order to generate new gene seed for the chapter.",
		}
	},
	"mobility": {
		"Bike": {
			"abbreviation": "Bike",
			"second_profiles": ["Twin Linked Bolters"],
			"description": "A robust bike that can propel an Astartes at very high speeds. Boasts highly responsive controls that allow for fluid movement on the battlefield and and respectable Twin-Linked Bolters for offensive action.",
			"hp_mod": {
				"standard": 25,
				"master_crafted": 25,
				"artifact": 35
			},
			"damage_resistance_mod": {
				"standard": 5,
				"master_crafted": 10,
				"artifact": 10
			},
		},
		"Jump Pack": {
			"abbreviation": "JmpPck",
			"special_properties": ["Hammer of Wrath"],
			"description": "A back-mounted device containing jets powerful enough to lift an Astartes in Power Armor over great distances. Utilizing these, Assault Marines bring devastation to the foe.",
			"damage_resistance_mod": {
				"standard": 25,
				"master_crafted": 30,
				"artifact": 35
			},
			"tags": ["jump"],
		},
		"Heavy Weapons Pack": {
			"abbreviation": "HvyWpPck",
			"description": "A heavy ammunition backpack commonly used by devastators in conjunction with a heavy support weapon.",
			"ranged_mod": {
				"standard": 5,
				"master_crafted": 10,
				"artifact": 15
			},
			"melee_hands": -1,
			"ranged_hands": 1,
		},
		"Servo-arm": {
			"abbreviation": "SrvArm",
			"special_properties": ["Repairs Vehicles"],
			"second_profiles": ["Servo-arm(M)"],
			"description": "A manipulator mechandendrite, also known as a Servo-arm. This artificial limb is a great aid to help trained Techmarines repair damaged vehicles on the battlefield, yet may be used in melee combat, thanks to its considerable crushing power and weight.",
			"damage_resistance_mod": {
				"standard": 0, // Adjusted
				"master_crafted": 5, // Adjusted
				"artifact": 10 // Adjusted
			},
			"melee_hands": -0.25,
			"ranged_hands": -0.25,
		},
		"Servo-harness": {
			"abbreviation": "SrvHrns",
			"special_properties": ["Repairs Vehicles"],
			"second_profiles": ["Servo-arm(M)", "Servo-arm(M)", "Flamer", "Plasma Cutter"],
			"description": "A Servo-Harness is a special type of augmetic aid, often used by Chapter's Master of the Forge or his senior Techmarines. It consists of many blessed tools, two Servo-arms and a couple of deadly weapons. With it, one can make battlefield repairs on any vehicle, shore up defences, or even assist his battle-brothers in combat.",
			"damage_resistance_mod": {
				"standard": 5, // Adjusted
				"master_crafted": 10, // Adjusted
				"artifact": 15 // Adjusted
			},
			"melee_hands": -0.5,
			"ranged_hands": -0.5,
		},
		"Conversion Beamer Pack": {
			"abbreviation": "CnvBmr",
			"second_profiles": ["Conversion Beam Projector"],
			"description": "The Conversion Beam Projector is a heavy energy weapon that harnesses advanced technology to project a concentrated beam of destructive energy. Armor detonates as the matter that comproises it is transformed into pure energy.",
			"melee_hands": -0.5,
			"ranged_hands": -0.5,
		},
		
		// Add more mobility items as needed...
	}
}


/*

    repeat(2){
            // Artifact weapons
            if (arti_armour=false){

                if (string_count("DUB",thawep)>0){attack=floor(attack*1.5);melee_hands+=1;ranged_hands+=1;spli=1;}
                if (string_count("Dae",thawep)>0){attack=floor(attack*1.5);amm=-1;}
                if (string_count("VOI",thawep)>0){attack=floor(attack*1.2);}
                if (string_count("ADAMANTINE",thawep)>0){attack=floor(attack*1.1);}

                if (string_count("MINOR",thawep)>0){attack=floor(attack*0.85);}
                if (string_count("MNR",thawep)>0){attack=floor(attack*0.85);}
            }

        }
    // Vehicle Upgrades

            if (equipment_1="Lucifer Pattern Engine"){statt=5;special_description="";emor=1;
                descr="A significant upgrade over the more common patterns of Rhino-chassis engines, these engines provide greater output.";}

                    // Vehicle Utility Weapons
            if (thawep="HK Missile"){attack=350;arp=1;range=50;ranged_hands+=1;amm=1;spli=1;
                descr="A single-use long-range anti-tank missile, this weapon can surgically destroy armoured targets in the opening stages of a battle.";}

                    // Land Raider Sponsons
                // Predator Turrets

                if (thawep="Twin Linked Assault Cannon Turret"){attack=360;arp=0;range=12;amm=10;spli=1;
                    descr="A Predator-compatible turret mounting a pair of short range anti-infantry assault cannons. ";}
                if (thawep="Flamestorm Cannon Turret"){attack=400;arp=1;range=2.1;amm=12;spli=1;
                      descr="A Predator-compatible turret housing a huge flamethrower, the heat produced by this terrifying weapon can crack even armoured ceramite. ";}
                if (thawep="Magna-Melta Turret"){attack=400;arp=1;range=6;amm=12;
                      descr="A Predator-compatible turret housing a magna-melta, a devastating short-range anti-tank weapon. ";}
                if (thawep="Plasma Destroyer Turret"){attack=350;arp=1;range=15;spli=1;
                      descr="A Predator-compatible turret housing a plasma destroyer, sometimes called the plasma executioner after the vehicle variants that mount this terrifying anti-armour weapon. ";}
                if (thawep="Heavy Conversion Beamer Turret"){attack=750;arp=1;range=25;amm=3;spli=1;
                    descr="A Predator-compatible turret housing a Heavy Conversion Beam Projector, a heavy energy weapon that turns a target's own matter against it by converting it into destructive energy.";}
                if (thawep="Neutron Blaster Turret"){attack=400;arp=1;range=15;amm=10
                      descr="A Predator-compatible turret housing a neutron blaster; a weapon from the Dark Age of Technology, this weapon is capable of destroying enemy armour with impunity. ";}
                if (thawep="Volkite Saker Turret"){attack=400;arp=0;range=18;amm=50;spli=1;
                        descr="A Predator-compatible turret housing a Volkite Saker, capable of igniting entire formations of enemy forces with a single sweep. ";}
