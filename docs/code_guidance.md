Coders guidance
add to as you see fit, but try to keep doc easy to use

Useful functions:
TTRPG_stats(faction, comp, mar, class = "marine")
		creates a new unit struct see scr_marine_struct.gml for more info


		unit_Struct.name_role()
			provides a string representation of the unit name combined with the unit role 
			taking into account the unit role display name as provided by the units squad type

scr_random_marine(argument0, argument1)
		selects a random player unit within the parameters given
		if no marine is available with give parameters returns "none"


keys and data:
faction key:
	imperium:2
	mechanics:3
	inquisition:4
	sororities:5


Visual and draw functions

tooltip_draw(x,y,tooltip_text)
	creates a hover over tool tip at the given coordinate where:
		x is the left most point of the tooltip box
		y is the topmost point of the tooltip box,
		tooltip_text is the text to display (text should be preformatted e.g string_hash_to_newline() to create lines)

scr_convert_company_to_string(marine company)
	returns a sting representation of a marines compant
How does combat work?????

-  First obj_ncombat is creates.
- second scr_battle_Roster is run with the location planet and star as arguments to collect player forces in battle

- within obj_ncombat create the obj_pnunit.alarm[3] is set to run for next step
	- this tallies up the total player forces in obj_encombat

- obj_ncombat.alarm[0] is set to run the turn after
	-	 this populates the enemy forces
	- it also bizzarly seems to set up some of the player defences

- obj_ncombat.alarm[1] runs a turn after alarm[0] this sets up teh opening text for the confrontation, most of which it seems is there but the player never sees

- obj_ncombat.alarm[2] runs this sets ally forces curiously setting them up after their existane has been announced to the player by alarm[1]

- once the game has finished it's fade in the player can then click to start the game as defined in obj_ncombat.keypress_13 line 57-66

- this sets obj_ncombat.timer_stage to 1

- once obj_ncombat.timer_stage == 1 the following happens obj_ncombat.keypress_13 line 81-113

	- a bunch of alarms are set to run over the next 4 frames in this order

	- obj_pnunit.alarm[1]=1;
    - obj_enunit.alarm[1]=2;
    - obj_enunit.alarm[0]=3;

  - obj_pnunit.alarm[1] sets the player weapons stacks why this is done shere is beyond me

 - obj_enunit.alarm[1] collects the various data about the dudes in each row

 - obj_enunit.alarm[1] is the enemy physically attacking
 -  kicks of scr shoot and scr flavour by extension


- then the timer_stage goes to 2 

- while the timer stage is 2 it is waiting for a kerpress defined in obj_ncombat.keypress_13 which kicks of obj_ncombat.alarm[8]

- obj_ncombat.alarm[8] is a timer that kicks the timer_stage up to 3

- now timer_stage is 3

- fllowing alarms are set to run in this order again in obj_ncombat.keypress_13
	- obj_pnunit.alarm[3]
	- obj_pnunit.alarm[1]
	- obj_pnunit.alarm[0]

- obj_pnunit.alarm[3] runs to make new death company and also to determine if there is no point the player attacking because they dont have the armour piercing to cause damage
	- this is probably a problem file


- obj_pnunit.alarm[1] will now run after a key has been pressed officially beggining the battle this runs the scr_player_combat_weapon_stacks() for each obj_pnunit instance (e.g each red line on teh battle map)

- obj_pnunit.alarm[0] utilises the data from obj_pnunit.alarm[1] to acctually set player

- timer_stage = 4 

- this is functionally the same as timer_stage being 2 it's just a wating point to go to timer stage 1/5 (i giess sometimes the enmey can go twice?)

- this malarky continues unil there are either no active enunit or pnunit objects remaining

- at this point the obj_ncombat variable started i set to either 2 or 4 

- this then sets up another timer in obj_ncombat.keypress_13 whch runs 
	obj_pnunit.alarm[4]
     obj_pnunit.alarm[5]

- basically these are the summery collection of the battle scripts

- also runs obj_enunit.alarm[1] if the player lost

-  obj_ncombat.alarm[5] then runs to display the data collected by running the above

- onec the player has clicked through this  the started variable goes to 3 and

	- obj_pnunit.alarm[6]
	- obj_ncombat.alarm[7]

are run in that order

- battle is now complete


