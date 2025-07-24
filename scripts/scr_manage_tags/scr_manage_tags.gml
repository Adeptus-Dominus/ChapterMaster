function set_up_tag_manager(){
    var pip = instance_create(0, 0, obj_popup);
    pip.type = POPUP_TYPE.ADD_TAGS;
	pip.subtype = TAGMANAGER.SELECTION;


	with (pip){
		var _tag_options = [];
	    for (var i=0;i < array_length(obj_controller.management_tags);i++){

			array_push(_tag_options,{
				str1 : obj_controller.management_tags[i],
				font : fnt_40k_14b,
				val : i
			});
	    }
		tag_selects = new multi_select(_tag_options, "Tags", {max_width : 500, x1:1040, y1:210});
	    exit_button = new UnitButtonObject(
	    	{
	    		x1: 1061, 
		        y1: 491, 
		        style : "pixel",
		        label : "Exit"
	    	}
	    );
	    main_slate = new DataSlate({
	    	style : "decorated",
	    	XX : 1006,
	    	YY : 143,
	    	set_width : true,
	    	width : 571,
	    	height : 350,
	    });

	    create_tag_button = new UnitButtonObject(
	    	{
	    		x1: 1006, 
		        y1: 275, 
		        label : "Create Tag"
	    	}
	    );
	    delete_tag_button = new UnitButtonObject(
	    	{
	    		x1: create_tag_button.x2, 
		        y1: 275, 
		        label : "Delete Tags"
	    	}
	    );
	    add_tag_button = new UnitButtonObject(
	    	{
	    		x1: delete_tag_button.x2, 
		        y1: 275, 
		        label : "Add Tags"
	    	}
	    );	
	    remove_tag_button = new UnitButtonObject(
	    	{
	    		x1: add_tag_button.x2, 
		        y1: 275, 
		        label : "Remove Tags"
	    	}
	    );

	    cancel_button = new UnitButtonObject(
	    	{
	    		x1: create_tag_button.x2, 
		        y1: 275, 
		        label : "Cancel"
	    	}
	    );	

	    delete_tags = new UnitButtonObject(
	    	{
	    		x1: delete_tag_button.x2, 
		        y1: 275, 
		        label : "Delete"
	    	}
	    ); 
	    create_tags = new UnitButtonObject(
	    	{
	    		x1: delete_tag_button.x2, 
		        y1: 275, 
		        label : "Create"
	    	}
	    );    
	    new_tag_name = new TextBarArea(1285, 275, 530, true);
	}
}

enum TAGMANAGER{
	SELECTION, 
	CREATE,
	DELETE,
	ADD,
	REMOVE
}
function draw_tag_manager(){

	main_slate.draw();
	tag_selects.draw(subtype == 0);
	if (subtype == TAGMANAGER.SELECTION){
		if (create_tag_button.draw()){
			subtype = TAGMANAGER.CREATE;
			new_tag = "";
		}
		if (delete_tag_button.draw()){
			subtype = TAGMANAGER.DELETE;
			//new_tag = "";
		}
		if (add_tag_button.draw()){
			subtype = TAGMANAGER.ADD;
			//new_tag = "";
		}
		if (remove_tag_button.draw()){
			subtype = TAGMANAGER.REMOVE;
			//new_tag = "";
		}
	}

	if (subtype > TAGMANAGER.SELECTION){
		cancel_button.draw();
	}

	if (subtype == TAGMANAGER.CREATE){
		new_tag = new_tag_name.draw(new_tag);

		if (new_tag != ""){
			if (create_tags.draw()){
				array_push(obj_controller.management_tags, new_tag);
				instance_destroy();
				set_up_tag_manager();
			}
		}
	} else if (subtype == TAGMANAGER.DELETE){

	}
}