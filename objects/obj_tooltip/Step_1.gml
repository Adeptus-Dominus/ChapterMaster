for (var i=0;i<array_length(global.draw_return_stack);i++){
	gc_struct(global.draw_return_stack[i]);
}

global.draw_return_stack = [];
