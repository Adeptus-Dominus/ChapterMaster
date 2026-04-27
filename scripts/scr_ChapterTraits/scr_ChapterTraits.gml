function ChapterTrait(trait) constructor {
    effects = "";
    meta = [];
    move_data_to_current_scope(trait);
    disabled = false;


    static add_meta = function() {
        for (var i = 0; i < array_length(meta); i++) {
            array_push(obj_creation.chapter_trait_meta, meta[i]);
        }
    };

    static remove_meta = function() {
        for (var i = 0; i < array_length(meta); i++) {
            var len = array_length(obj_creation.chapter_trait_meta);
            for (var s = 0; s < len; s++) {
                if (obj_creation.chapter_trait_meta[s] == meta[i]) {
                    array_delete(obj_creation.chapter_trait_meta, s, 1);
                    s--;
                    len--;
                }
            }
        }
    };

    static print_meta = function() {
        if (array_length(meta) == 0) {
            return "None";
        } else {
            return string_join_ext(", ", meta);
        }
    };
}

function Advantage(trait) : ChapterTrait(trait) constructor {
    static id_start = 1
    LOGGER.info(id_start);
    id = id_start;
    id_start++;
    static add = function(slot) {
        obj_creation.adv[slot] = name;
        obj_creation.adv_num[slot] = id;
        obj_creation.points += points;
        add_meta();
    };

    static remove = function(slot) {
        obj_creation.adv[slot] = "";
        obj_creation.points -= points;
        obj_creation.adv_num[slot] = 0;
        remove_meta();
    };

    static disable = function() {
        var is_disabled = false;
        for (var i = 0; i < array_length(meta); i++) {
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])) {
                is_disabled = true;
            }
        }
        if (obj_creation.points + points > obj_creation.maxpoints) {
            is_disabled = true;
        }
        return is_disabled;
    };
}

function Disadvantage(trait) : ChapterTrait(trait) constructor {
    static id_start = 1
    LOGGER.info(id_start);
    id = id_start;
    id_start++;
    static add = function(slot) {
        obj_creation.dis[slot] = name;
        obj_creation.dis_num[slot] = id;
        obj_creation.points -= points;
        add_meta();
    };

    static remove = function(slot) {
        obj_creation.dis[slot] = "";
        obj_creation.points += points;
        obj_creation.dis_num[slot] = 0;
        remove_meta();
    };

    static disable = function() {
        var is_disabled = false;
        for (var i = 0; i < array_length(meta); i++) {
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])) {
                is_disabled = true;
            }
        }
        return is_disabled;
    };
}

function generate_disadvantages(){
    return [
        {
            name: "Black Rage",
            description: "Your marines are susceptible to Black Rage, having a chance each battle to become Death Company.  These units are locked as Assault Marines and are fairly suicidal.",
            points: 30,
        },
        {
            name: "Blood Debt",
            description: "Prevents your Chapter from recruiting new Astartes until enough of your marines, or enemies, have been killed.  Incompatible with Penitent chapter types.",
            points: 50,
        },
        {
            name: "Depleted Gene-seed Stocks",
            description: "Your chapter has lost its gene-seed stocks in recent engagement. You start with no gene-seed.",
            points: 20,
        },
        {
            name: "Fresh Blood",
            description: "Due to being newly created your chapter has little special wargear or psykers.",
            points: 20,
            meta: ["Status"],
        },
        {
            name: "Never Forgive",
            description: "In the past traitors broke off from your chapter.  They harbor incriminating secrets or heritical beliefs, and as thus, must be hunted down whenever possible.",
            points: 20,
        },
        {
            name: "Shitty Luck",
            description: "This is actually really bad for your chapter. Trust me.",
            points: 20,
            meta: ["Luck"],
        },
        {
            name: "Sieged",
            description: "A recent siege has reduced the number of your marines greatly.  You retain a normal amount of equipment but some is damaged.",
            points: 40,
            meta: ["Status"],
        },
        {
            name: "Splintered",
            description: "Your marines are unorganized and splintered.  You require greater time to respond to threats en masse.",
            points: 10,
            meta: ["Location"],
        },
        {
            name: "Suspicious",
            description: "Some of your chapter's past actions or current practices make the inquisition suspicious.  Their disposition is lowered.",
            points: 10,
            meta: ["Imperium Trust"],
        },
        {
            name: "Tech-Heresy",
            description: "Your chapter does things that makes the Mechanicus upset.  Mechanicus disposition is lowered and you have less Tech Marines. You start as a tech heretic tolerant chapter",
            points: 20,
            meta: ["Mechanicus Faith"],
        },
        {
            name: "Tolerant",
            description: "Your chapter is more lenient with xenos.  All xeno disposition is slightly increased and all Imperial disposition is lowered.",
            points: 10,
        },
        {
            name: "Warp Tainted",
            description: "Your chapter is tainted by the warp. Many of your marines are afflicted with it, making getting caught in perils of the warp less likely, but when caught - the results are devastating.",
            points: 20,
        },
        {
            name: "Psyker Intolerant",
            description: "Witches are hated by your chapter.  You cannot create Librarians but gain a little bonus attack against psykers.",
            points: 30,
            meta: ["Psyker Views"],
        },
        {
            name: "Obliterated",
            description: "A recent string of unfortunate events has left your chapter decimated. You have very little left, will your story continue?",
            points: 80,
            meta: ["Status"],
        },
        {
            name: "Poor Equipment",
            description: "Whether due to being cut off from forge worlds or bad luck, your chapter no longer has enough high quality gear to go around. Your elite troops will have to make do with standard armour.",
            points: 10,
            meta: ["Gear Quality"],
        },
        {
            name: "Enduring Angels",
            description: "The Chapter's journey thus far has been arduous & unforgiving leaving them severely understrength yet not out of the fight. You begin with 5 fewer company's",
            points: 30,
            meta: ["Status"],
        },
        {
            name: "Serpents Delight",
            description: "Sleeper cells infiltrated your chapter. When they rose up for the decapitation strike,they slew the 5 most experienced company's and many of the HQ staff before being defeated",
            points: 50,
            meta: ["Status"],
        },
        {
            name: "Weakened Apothecarion",
            description: "Many of your chapter's Apothecaries have fallen in recent battles whether due to their incompetence or deliberate targetting.",
            points: 20,
            meta: ["Apothecaries"],
        },
        {
            name: "Small Reclusiam",
            description: "Your chapter cares little for its reclusiam compared to other chapters fewer marines have shown the desire to be chaplains.",
            points: 20,
            meta: ["Faith"],
        },
        {
            name: "Barren Librarius",
            description: "Your chapter has a smaller Librarius compared to other chapters due to having fewer potent psykers.",
            points: 20,
            meta: [
                "Psyker Views",
                "Librarians"
            ],
        }
    ];
}

function generate_advantages(){
    return [
        {
            name: "Ambushers",
            description: "Your chapter is especially trained with ambushing foes; they have a bonus to attack during the start of a battle.",
            points: 30,
        },
        {
            name: "Boarders",
            description: "Boarding other ships is the specialty of your chapter.  Your chapter is more lethal when boarding ships, have dedicated boarding squads, and two extra strike cruisers.",
            points: 30,
        },
        {
            name: "Bolter Drilling",
            description: "Bolter drills are sacred to your chapter; all marines have increased attack with Bolter weaponry.",
            points: 40,
            meta: ["Weapon Specialty"],
        },
        {
            name: "Retinue of Renown",
            description: "Your chapter master is guarded by renown heroes of the chapter.  You start with a larger well-equipped Honour Guard.",
            points: 20,
        },
        {
            name: "Crafters",
            description: "Your chapter views artifacts as sacred; you start with better gear and maintain all equipment with more ease.",
            points: 40,
            meta: ["Gear Quality"],
        },
        {
            name: "Ancient Armoury",
            description: "Your chapter is dedicated to preserving ancient wargear and as such have substantially higher amounts of rare Heresy-era armour and weapons than normal.",
            points: 20, //I'm not sure, but it could be higher since now this trait will bring much more benefits.
            meta: ["Gear Quality"],
        },
        {
            name: "Enemy: Eldar",
            description: "Eldar are particularly hated by your chapter.  When fighting Eldar damage is increased.",
            points: 20,
            meta: ["Main Enemy"],
        },
        {
            name: "Enemy: Fallen",
            description: "Chaos Marines are particularly hated by your chapter.  When fighting the traitors damage is increased.",
            points: 20,
            meta: ["Main Enemy"],
        },
        {
            name: "Enemy: Necrons",
            description: "Necrons are particularly hated by your chapter.  When fighting Necrons damage is increased.",
            points: 20,
            meta: ["Main Enemy"],
        },
        {
            name: "Enemy: Orks",
            description: "Orks are particularly hated by your chapter.  When fighting Orks damage is increased.",
            points: 20,
            meta: ["Main Enemy"],
        },
        {
            name: "Enemy: Tau",
            description: "Tau are particularly hated by your chapter.  When fighting Tau damage is increased.",
            points: 20,
            meta: ["Main Enemy"],
        },
        {
            name: "Enemy: Tyranids",
            description: "Tyranids are particularly hated by your chapter. A large number of your veterans and marines are tyrannic war veterans and when fighting Tyranids damage is increased.",
            points: 20,
            meta: ["Main Enemy"],
        },
        {
            name: "Kings of Space",
            description: "Veterans of naval combat, your chapter fleet has bonuses to offense, defence, an additional battle barge, and may always be controlled regardless of whether or not the Chapter Master is present.",
            points: 40,
            meta: ["Naval"],
        },
        {
            name: "Lightning Warriors",
            description: "Your chapter's style of warfare is built around the speedy execution of battle. Infantry have boosted attack at the cost of defense as well as two additional Land speeders and Biker squads.",
            perks: [
                "Reduced Chances of loosing equipment during raids by 15%",
                "Marines mmore likely spawn with lightning warrior trait",
                "3% increase to base boarding capabilities"
            ],
            points: 30,
            meta: ["Doctrine"],
        },
        {
            name: "Paragon",
            description: "You are a pale shadow of the primarchs.  Larger, stronger, faster, your Chapter Master is on a higher level than most, gaining additional health and combat effectiveness.",
            points: 10,
            meta: ["Chapter Master"],
        },
        {
            name: "Warp Touched", //TODO: This is probably can be better handled as a positive seed mutation;
            description: "Psychic mutations run rampant in your chapter. You have more marines with high psychic rating and aspirants are also more likely to be capable of harnessing powers of the warp.",
            points: 20,
            meta: [
                "Psyker Views",
                "Librarians"
            ],
        },
        {
            name: "Favoured By The Warp",
            description: "Many marines in your chapter are favoured by the powers of the warp, making perils of the warp happen less frequently for them.",
            points: 20,
        },
        {
            name: "Reverent Guardians",
            description: "Your chapter places great faith in the Imperial Cult; you start with more Chaplains and any Ecclesiarchy disposition increases are enhanced.",
            points: 20,
            meta: [
                "Faith",
                "Imperium Trust"
            ],
        },
        {
            name: "Tech-Brothers",
            description: "Your chapter has better ties to the mechanicus; you have more techmarines and higher mechanicus disposition.",
            points: 20,
            meta: ["Mechanicus Faith"],
        },
        {
            name: "Tech-Scavengers",
            description: "Your Astartes have a knack for finding what has been lost.  Items and wargear are periodically found and added to the Armamentarium.",
            points: 30,
        },
        {
            name: "Siege Masters",
            description: "Your chapter is familiar with the ins-and-outs of fortresses.  They are better at defending and attacking fortifications. And better at garrisoning",
            points: 20,
        },
        {
            name: "Devastator Doctrine",
            description: "The steady advance of overwhelming firepower is your chapters combat doctrine each company has an additional Devastator squad, all infantry have boosted defence, and heavy weapons have increased attack.",
            points: 40,
            meta: ["Doctrine"],
        },
        {
            name: "Assault Doctrine",
            description: "Your chapter prefers quick close quarter assaults on the enemy each Company has an additional Assault Squad and your marines are more skilled in melee.",
            points: 20,
            meta: ["Doctrine"],
        },
        {
            name: "Venerable Ancients",
            description: "Even in death they still serve. Your chapter places a staunch reverence for its forebears and has a number of additional venerable dreadnoughts in service.",
            points: 40,
            meta: ["Doctrine"],
        },
        {
            name: "Medicae Primacy",
            description: "Your chapter reveres its Apothecarion above all of it's specialist; You start with more Apothecaries.",
            points: 20,
            meta: ["Apothecaries"],
        },
        {
            name: "Ryzan Patronage",
            description: "Your chapter has strong ties to the Forgeworld of Ryza as a result your Techmarines are privy to the secrets of their Techpriests enhancing your Plasma and Las weaponry.",
            points: 40,
            meta: ["Weapon Specialty"],
        },
        {
            name: "Elite Guard",
            description: "Your chapter is an elite fighting force comprised almost exclusively of Veterans. All Tactical Marines are replaced by Veterans.",
            points: 150,
            meta: ["Specialists"],
        },
        {
            name: "Great Luck",
            description: "This is actually really helpful and beneficial for your chapter. Trust me.",
            points: 20,
            meta: ["Luck"],
        },
        {
            name: "Inquisitorial Mandate",
            description: "Your Chapter performs some service to the inquisition that is of some specific value or mandate of the inquisition",
            effects: "You will recieve less frequent inspections from the inquisition and actions that may not align with the inquisition will cause less aggressive losses of disposition with the Inquisition",
            meta: ["Imperium Trust"],
            points: 50
        }
    ];
}


function setup_chapter_traits(){
    obj_creation.all_advantages = [];
    var all_advantages = generate_advantages();

    var new_adv, cur_adv;
    for (var i = 0; i < array_length(all_advantages); i++) {
        cur_adv = all_advantages[i];
        new_adv = new Advantage(cur_adv);
        if (struct_exists(cur_adv, "meta")) {
            new_adv.meta = cur_adv.meta;
        }
        array_push(obj_creation.all_advantages, new_adv);
    }

    //advantage[i]="Battle Cousins";
    //advantage_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;
    //advantage[i]="Comrades in Arms";
    //advantage_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;

    /// @type {Array<Struct.Disadvantage>}
    var all_disadvantages = generate_disadvantages();

    obj_creation.all_disadvantages = [];
    var new_dis, cur_dis;
    for (var i = 0; i < array_length(all_disadvantages); i++) {
        cur_dis = all_disadvantages[i];
        new_dis = new Disadvantage(cur_dis);
        if (struct_exists(cur_dis, "meta")) {
            new_dis.meta = cur_dis.meta;
        }
        array_push(obj_creation.all_disadvantages, new_dis);
    }
}


function ChapterData(){
    faction_disp_mods = array_create(14, {});
}

