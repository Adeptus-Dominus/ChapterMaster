function set_up_tag_manager() {
    instance_destroy(obj_popup);
    var pip = instance_create(0, 0, obj_popup);
    pip.type = ePOPUP_TYPE.ADD_TAGS;
    pip.subtype = eTAG_MANAGER.SELECTION;

    with (pip) {
        var _tag_options = [];
        for (var i = 0; i < array_length(obj_controller.management_tags); i++) {
            array_push(_tag_options, {str1: obj_controller.management_tags[i], font: fnt_40k_14b});
        }
        tag_selects = new MultiSelect(_tag_options, "Tags", {max_width: 500, x1: 1040, y1: 210});

        tag_selects.set(obj_controller.manage_tags);
        exit_button = new UnitButtonObject({x1: 1061, y1: 491, style: "pixel", label: "Exit", tooltip: "All tag filters will remain in place re-open the tag manager to add oor remove filters"});
        main_slate = new DataSlate({style: "decorated", XX: 1006, YY: 143, set_width: true, width: 571, height: 350});

        create_tag_button = new UnitButtonObject({x1: 1056, y1: 325, label: "Create Tag", tooltip: "Create more tags"});
        delete_tag_button = new UnitButtonObject({x1: create_tag_button.x2, y1: 325, label: "Delete Tags", tooltip: "Delete tags permenantly"});
        add_tag_button = new UnitButtonObject({x1: delete_tag_button.x2, y1: 325, label: "Add Tags", tooltip: "Add tags to current Marine selection"});
        remove_tag_button = new UnitButtonObject({x1: add_tag_button.x2, y1: 325, label: "Remove Tags", tooltip: "Remove Tags from current Marine selection"});

        cancel_button = new UnitButtonObject({x1: create_tag_button.x2, y1: 350, label: "Cancel"});

        delete_tags = new UnitButtonObject({x1: delete_tag_button.x2, y1: 350, label: "Delete"});
        create_tags = new UnitButtonObject({x1: delete_tag_button.x2, y1: 350, label: "Create"});

        add_tags = new UnitButtonObject({x1: delete_tag_button.x2, y1: 350, label: "Add", tooltip: "The selected tags will be added to the current selection"});
        remove_tags = new UnitButtonObject({x1: delete_tag_button.x2, y1: 325, label: "Remove", tooltip: "The selected tags will be removed from the current selection"});
        new_tag_name = new TextBarArea(1285, 275, 530, true);
    }
}

enum eTAG_MANAGER {
    SELECTION,
    CREATE,
    DELETE,
    ADD,
    REMOVE,
}

function draw_tag_manager() {
    add_draw_return_values();
    main_slate.draw();
    tag_selects.draw();
    if (exit_button.draw()) {
        instance_destroy();
    }

    if (subtype == eTAG_MANAGER.SELECTION) {
        obj_controller.manage_tags = tag_selects.selections();
        if (create_tag_button.draw()) {
            subtype = eTAG_MANAGER.CREATE;
            new_tag = "";
        }
        if (delete_tag_button.draw()) {
            subtype = eTAG_MANAGER.DELETE;
            tag_selects.deselect_all();
            //new_tag = "";
        }

        var _addable = array_length(obj_controller.management_tags);
        var _tool = "Add tags to current Marine selection";
        add_tag_button.disabled = false;
        if (!_addable) {
            _tool = "Make some tags to add them to marines";
        } else {
            if (!array_contains(obj_controller.man_sel, 1)) {
                _tool = "Select some marine to be able to add tags to";
                _addable = false;
            }
        }
        add_tag_button.update({tooltip: _tool});
        if (!_addable) {
            add_tag_button.disabled = true;
        }
        if (add_tag_button.draw(_addable)) {
            subtype = eTAG_MANAGER.ADD;
            var _selecs = [];
            var _selec_keys = [];
            for (var i = 0; i < array_length(obj_controller.display_unit); i++) {
                if (obj_controller.man[i] != "man" || obj_controller.man_sel[i] != 1) {
                    continue;
                }
                var _unit = obj_controller.display_unit[i];

                for (var t = 0; t < array_length(obj_controller.management_tags); t++) {
                    var _tag = obj_controller.management_tags[t];
                    if (!array_contains(_selec_keys, _tag) && !array_contains(_unit.manage_tags, _tag)) {
                        array_push(_selecs, {str1: _tag, font: fnt_40k_14b});
                        array_push(_selec_keys, _tag);
                    }
                }
            }
            tag_selects = new MultiSelect(_selecs, "Tags", {max_width: 500, x1: 1040, y1: 210});
        }
        var _tool = "Remove Tags from current Marine selection";
        remove_tag_button.disabled = false;
        if (!_addable) {
            _tool = "Make some tags to Remove them from marines";
        } else {
            if (!array_contains(obj_controller.man_sel, 1)) {
                _tool = "Select some marine to remove from";
                _addable = false;
            }
        }
        remove_tag_button.update({tooltip: _tool});
        if (!_addable) {
            remove_tag_button.disabled = true;
        }
        if (remove_tag_button.draw(_addable)) {
            subtype = eTAG_MANAGER.REMOVE;
            tag_selects.deselect_all();
            var _selecs = [];
            var _selec_keys = [];
            for (var i = 0; i < array_length(obj_controller.display_unit); i++) {
                if (obj_controller.man[i] != "man" || obj_controller.man_sel[i] != 1) {
                    continue;
                }
                var _unit = obj_controller.display_unit[i];

                for (var t = 0; t < array_length(_unit.manage_tags); t++) {
                    var _tag = _unit.manage_tags[t];
                    if (!array_contains(_selec_keys, _tag)) {
                        array_push(_selecs, {str1: _tag, font: fnt_40k_14b});
                        array_push(_selec_keys, _tag);
                    }
                }
            }
            tag_selects = new MultiSelect(_selecs, "Tags", {max_width: 500, x1: 1040, y1: 210});
            //new_tag = "";
        }
    }

    if (subtype > eTAG_MANAGER.SELECTION) {
        if (cancel_button.draw()) {
            instance_destroy();
            set_up_tag_manager();
        }
    }

    if (subtype == eTAG_MANAGER.CREATE) {
        new_tag = new_tag_name.draw(new_tag);

        if (new_tag != "") {
            if (create_tags.draw()) {
                array_push(obj_controller.management_tags, new_tag);
                instance_destroy();
                set_up_tag_manager();
            }
        }
    } else if (subtype == eTAG_MANAGER.DELETE) {
        if (delete_tags.draw()) {
            var _deletes = tag_selects.selections();
            obj_controller.management_tags = array_delete_values(obj_controller.management_tags, _deletes);
            instance_destroy();
            set_up_tag_manager();
        }
    } else if (subtype == eTAG_MANAGER.ADD) {
        if (add_tags.draw()) {
            var _tags = tag_selects.selections();
            for (var i = 0; i < array_length(obj_controller.display_unit); i++) {
                if (obj_controller.man[i] != "man" || obj_controller.man_sel[i] != 1) {
                    continue;
                }

                var _unit = obj_controller.display_unit[i];

                for (var t = 0; t < array_length(_tags); t++) {
                    var _tag = _tags[t];
                    if (!array_contains(_unit.manage_tags, _tag)) {
                        array_push(_unit.manage_tags, _tag);
                    }
                }
            }
            instance_destroy();
            set_up_tag_manager();
        }
    } else if (subtype == eTAG_MANAGER.REMOVE) {
        var _removals = tag_selects.selections();
        if (array_length(_removals)) {
            if (remove_tags.draw) {
                for (var i = 0; i < array_length(obj_controller.display_unit); i++) {
                    if (obj_controller.man[i] != "man" || obj_controller.man_sel[i] != 1) {
                        continue;
                    }
                    var _unit = obj_controller.display_unit[i];

                    for (var t = array_length(_unit.manage_tags) - 1; t >= 0; t--) {
                        if (array_contains(_removals, _unit.manage_tags[t])) {
                            array_delete(_unit.manage_tags, t, 1);
                        }
                    }
                }
                instance_destroy();
                set_up_tag_manager();
            }
        }
    }
    pop_draw_return_values();
}
