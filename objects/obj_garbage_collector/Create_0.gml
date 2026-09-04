// Custom GC was created and is used because of a GameMaker bug that
// corrupted arrays mid-game, causing element index crashes. We don't
// know if the bug was fixed or not, so keep it for safety. Native GC
// is re-enabled on macOS to avoid EXC_BAD_ACCESS / SIGSEGV during
// MarkAndSweepGen (DoGenerationalGC / GCArrayThing).
gc_timer = 0;

if (os_type == os_macosx) {
    gc_enable(true);
} else {
    gc_enable(false);
}
gc_target_frame_time(50); // Default is 100; in microseconds;
