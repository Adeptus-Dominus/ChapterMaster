// Defer boot to next frame so the room is fully constructed.
call_later(1, time_source_units_frames, boot_sequence);
