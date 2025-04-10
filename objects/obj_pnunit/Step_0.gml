
// These arrays are the losses on any one frame.
// Instead of resetting in a bunch of places, we reset here.
array_resize(lost, 0);
array_resize(lost_num, 0);


update_block_size();
update_block_unit_count();
