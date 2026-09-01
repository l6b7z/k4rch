#include "config.h"
#include "block.h"
#include "util.h"

Block blocks[] = {
    //script, refresh_s, signal_#
    {"cat /tmp/recordingicon 2>/dev/null",	0,	9},
    {"sb-traffic",     3,    7},
    {"sb-memory",      5,    5},
    {"sb-disk",      600,    6},
    {"sb-bluetooth",  20,    4},
    {"sb-touchpad",    0,   10},
    {"sb-keyboard",    0,    8},
    {"sb-kbd_lang",    0,   11},
    {"sb-internet",   20,    3},
    {"sb-battery",    30,    5},
    {"sb-volume",      0,    1},
    {"sb-date",        1,    2},
};

const unsigned short blockCount = LEN(blocks);
