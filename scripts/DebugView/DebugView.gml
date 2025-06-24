
/// Slightly nicer syntax for working with dbg_views. 
/// Functions can be chained for simpler construction. 
/// Parameters passed into the "add_" functions should always match instance variable names. Local variables don't work with dbg_views.
/// Creating a debug view opens the overlay automatically, finish construction with .hide() to prevent it from open automatically during regular play.
/// @param {String} view_name the title of the view
/// @param {Id.Instance|Struct} obj The object being debugged. Can be a regular struct, an instance or a full object
function DebugView(view_name, obj) constructor {


    
    

    obj_ref = obj;
    /// should stop adding duplicate controls if the view already exists
    update = false;

    if(struct_exists(obj_ref, view_name)){
        if(dbg_view_exists(obj_ref[$view_name])){
            view_ptr = obj_ref[$view_name];
            update = true;
        }
    } else {
        view_ptr = dbg_view(view_name, false); // calling dbg_view opens the overlay automatically 
        variable_struct_set(obj_ref, view_name, view_ptr);
    }

    

    name = view_name;
    
    static add_watch = function (_name, _label = _name){
        if(update) return self;
        dbg_watch(ref_create(self.obj_ref, _name), _label);
        return self;
    }

    static add_slider_int = function(_name, min, max, label = _name, step = 1){
        if(update) return self;
        dbg_slider_int(ref_create(self.obj_ref, _name), min, max, label, step);
        return self;
    }

    static add_slider = function(_name, min, max, label = _name, step = 0.01){
        if(update) return self;
        dbg_slider(ref_create(self.obj_ref, _name), min, max, label = name, step);
        return self;
    }

    static add_checkbox = function(_name, _label = _name){
        if(update) return self;
        dbg_checkbox(ref_create(self.obj_ref, _name), _label);
        return self;
    }

    static add_button = function(_label, fn){
        if(update) return self;
        dbg_button(_label, fn);
        return self;
    }

    static add_section = function(_name, _open = true) {
        if(update) return self;
        dbg_section(_name, true);
        return self;
    }

    static show = function(){
        if(update) return self;
        show_debug_overlay(true);
        if(struct_exists(self, "view_ptr")){
            dbg_set_view(self.view_ptr)
        }
        return self;
    }

    static hide = function(){
        if(update) return self;
        show_debug_overlay(false);
        return self;
    }

    static delete_view = function(){
        dbg_view_delete(self.view_ptr);
        return self;
    }

    static add_text = function(input, label){
        
        dbg_text($"{label}: {input}");
        return self;
    }

    /// quick and dirty way to display all variables of the given obj in a dbg section
    static dump_props = function(){
        if(update) return self;
        dbg_section("Dump Props");
        var names = struct_get_names(self.obj_ref);
        for(var i = 0; i < array_length(names); i++){
            dbg_watch(ref_create(self.obj_ref, names[i]));
        }

        return self;
    }
}