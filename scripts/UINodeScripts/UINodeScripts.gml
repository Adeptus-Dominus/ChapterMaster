// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//enums in GML are global regardless of where they are declared, but declaring it here for clarity

enum UINODE_STATUS {
    //First three map to same return codes as rect in rect test
    OUTSIDE_OF_RECT,
    SUCCESS,
    EDGE_OVERLAPS,
    SAME_SIZE_AS_CHILD,
    ENCOMPASES_CHILD,
    CRITICAL_ERROR,
}

function UIElement(width, height, align_x, align_y) constructor {
    self.width = width;
    self.height = height;
    self.align_x = align_x;
    self.align_y = align_y;

    enum eUI_ALIGN_X {
        x_left,
        x_right,
        x_center,
    }
    enum eUI_ALIGN_Y {
        y_top,
        y_bottom,
        y_center,
    }
}

function UINode(elem, gui_x, gui_y, padding = 0, margin = 0, parent = undefined) constructor {
    self.gui_x = gui_x;
    self.gui_y = gui_y;
    self.width = elem.width;
    self.height = elem.height;
    self.padding = padding; //currently unused
    self.margin = margin; //currently unused
    self.align_x = elem.align_x;
    self.align_y = elem.align_y;
    self.parent = parent;

    components = [];
    ev_components = [];
    render_components = [];
    children = [];
    creator = other;
    is_active = true;

    static make_id = function() {
        static base = 0;
        return "UINode" + string(base++);
    };

    gid = make_id();

    static is_in_bounding_rect = function(px, py) {
        return point_in_rectangle(px, py, gui_x, gui_y, width + gui_x, height + gui_y);
    };

    static set_name = function(name) {
        gid = name;
        return self;
    };

    static get_component_type = function(component) {
        static reduction = function(prev, curr) {
            if (is_instanceof(prev, NullComponent)) {
                return is_instanceof(curr, component) ? curr : prev;
            }
            return prev;
        };

        if (is_callable(component)) {
            return array_reduce(components, method({component}, reduction), new NullComponent());
        }
        throw "UI: get_component method requires passing in a constructor function to find the component";
    };

    /**
	 * Function Description
	 * @param {function.UIComponent} component Description
	 */
    static add_component = function(component, name = undefined) {
        if (is_callable(component)) {
            var comp = new component(self, name);
            array_push(components, comp);
            if (is_instanceof(comp, UIEventComponent)) {
                array_push(ev_components, comp);
            } else if (is_instanceof(comp, UIRenderComponent)) {
                array_push(render_components, comp);
            }
        }
        return array_last(components);
    };

    static remove_component = function(component) {
        static filter = function(elem) {
            return elem != component;
        };

        //need to add stuff to remove it from the specific component stores
        components = array_filter(components, method({component}, filter));
    };

    /**
	 *  Adds an existing UI node to this node in the UI graph. Can automatically be added to a child node if it would fit within that child element
	 * @param {struct.uinode} ui_node  An existing UI node to add to this UI graph
	 * @param {bool} [allow_child_insertion]=true  default true: Whether the added node should be added to a child node or only the root
	 * @param {array} [callstack]=[] internal use only...
	 * @returns {struct.UINode}  blah
	 */
    static add_child_from_existing = function(ui_node, allow_child_insertion = true) {
        array_push(children, ui_node);
        return self;
    };

    static add_child = function(elem, gx, gy, allow_child_insertion = true) {
        var new_node = new UINode(elem, gx + gui_x + padding, gy + gui_y + padding);
        add_child_from_existing(new_node, allow_child_insertion);
        return new_node;
    };

    static add_element = function(elem, gx, gy, padding, margin) {
        var new_node = new UINode(elem, gui_x + gx, gui_y + gy, padding, margin, self);
        with (new_node) {
            var offsets = self.get_offset_values();
            gui_x += offsets.xoffset;
            gui_y += offsets.yoffset;
        }
        add_child_from_existing(new_node, false);
        return new_node;
    };

    static get_offset_values = function() {
        var xoffset = 0;
        var yoffset = 0;
        if (parent) {
            if (align_x == eUI_ALIGN_X.x_left) {
                xoffset += parent.padding + margin;
            } else if (align_x == eUI_ALIGN_X.x_center) {
                xoffset += parent.width / 2 - width / 2 + margin + parent.padding;
            } else {
                xoffset += parent.width - width - margin - parent.padding;
            }

            if (align_y == eUI_ALIGN_Y.y_top) {
                yoffset += parent.padding + margin;
            } else if (align_y == eUI_ALIGN_Y.y_center) {
                yoffset += parent.height / 2 - height / 2 + margin + parent.padding;
            } else {
                yoffset += parent.height - height - margin - parent.padding;
            }
        }
        return {xoffset, yoffset};
    };

    static recalc = function() {
        if (parent) {
            var offsets = get_offset_values();
            gui_x = offsets.xoffset + parent.gui_x;
            gui_y = offsets.yoffset + parent.gui_y;
            array_foreach(children, function(elem) {
                elem.recalc();
            });
        }
    };

    static reposition = function(gx, gy) {
        gui_x += gx;
        gui_y += gy;
        array_foreach(children, method({gx, gy}, function(elem) {
            elem.reposition(gx, gy);
        }));
    };

    static resize = function(w, h) {
        if (width == w && height == h) {
            return;
        }
        width = w;
        height = h;
        recalc();
        array_foreach(children, function(elem) {
            elem.recalc();
        });
    };

    static set_padding = function(val) {
        padding = val;
        return self;
    };

    static set_margin = function(val) {
        margin = val;
        return self;
    };

    /// @desc Function Description
    /// @returns {Id.Instance|struct.UINode}
    static finalize = function() {
        if (is_struct(creator)) {
            if (is_instanceof(creator, UINode)) {
                return creator;
            }
        }
        return self;
    };

    static render = function(_x = 0, _y = 0) {
        if (!is_active) {
            return;
        }
        array_foreach(render_components, function(elem) {
            elem.render(gui_x, gui_y);
        });
        array_foreach(children, function(elem) {
            elem.render();
        });
    };

    static remove_child_by_name = function(name) {
        var new_array = array_filter(children, method({name}, function(elem) {
            return elem.gid != name;
        }));
        children = new_array;
    };

    static remove_child = function(val) {
        var new_array = array_filter(children, method({val}, function(elem, idx) {
            return idx != val;
        }));
        children = new_array;
    };

    static destroy_components = function() {
        array_foreach(components, function(elem) {
            if (is_instanceof(elem, UIEventComponent)) {
                elem.cleanup();
            }
        });
        array_resize(components, 0);
    };

    static activate = function() {
        if (is_active) {
            return;
        }
        is_active = true;
        array_foreach(children, function(child) {
            child.activate();
        });
    };

    static deactivate = function() {
        if (!is_active) {
            return;
        }
        is_active = false;
        array_foreach(children, function(child) {
            child.deactivate();
        });
    };

    static clear = function() {
        destroy_components();
        array_resize(children, 0);
    };
}
