/* dwm 6.2 */
#include "exitdwm.c"
#include "unfloat.c"
#include "tile_centre.c"
#include "tile_grid.c"
#include "tile_wide.c"

#define TERMINAL  "st"
#define BROWSER   "librewolf"
#define STATUSBAR "dwmblocks"

static const int wrapCursor          = 1; /* wraps cursor to selected window */
static const int scrollsensetivity   = 30; /* 1 means resize window by 1 pixel for each scroll event */

static const int topbar              = 1;    /* bar position */
static const int showbar             = 1;
static const int center_title        = 0;    /* window title */
static const int user_bh             = 16.2; /* bar height */

static const int swallowfloating    = 1; /* 1 means swallow floating windows by default */
static const unsigned int snap      = 3; /* snap windows to edge of the screen or windows */
static const unsigned int borderpx  = 1;
static const unsigned int gappih    = 2;
static const unsigned int gappiv    = 2;
static const unsigned int gappoh    = 2;
static const unsigned int gappov    = 2;

static const char barBG[]           = "#000000";
static const char client[]          = "#000000";
static const char activeClient[]    = "#5F00FF";
static const char floatClient[]     = "#4D007D";
static const char barText[]         = "#5F00FF";

static const char *fonts[]           = { "IosevkaNerdFont:size=14.2",
                                         "noto-fonts-emoji:size=10"};
#include "util_cleanup.c" 

/*f  = float | float coordinates | t  = tag | n  = no swallow | t  = term | m  = mon*/
static const Rule rules[] = { 
//f, x___, y___, w___, h___, t, n, t, m, win, class________, title________},
 {0,  200,  300,  400,  500, 0, 0, 1,-1,NULL, "st"         , NULL         },
 {1,  200,  300,  400,  500, 0, 1, 1,-1,NULL, "st"         , "zz"         },
};

static const Layout layouts[] = {
  { "T",   tile }, 	
  { "G",   grid },	
  { "W",   tilewide },
  { "C",   tcl },
  { NULL,  NULL },
}; 

//MODKEYS,            KEY,         function,          args, */
static Key keys[] = {
// testing
{ SUPER|SHIFT,        XK_period,  spawn,             {.v = (const char*[]){ "sys_clipmenu", NULL } } },
 // Actions
{ SUPER,              XK_q,       killclient,        {0} },
{ SUPER,              XK_b,       togglebar,         {0} },
{ SUPER|SHIFT,        XK_q,       exitdwm,           {0} },
// Terminal 
{ ALT,	              XK_space,   spawn,		         SHCMD("st -d $ZK_DIR_MAIN") },
// Browser
{ SUPER,              XK_space,   spawn,             {.v = (const char*[]){ BROWSER, NULL } } },
// File Browser
{ SUPER,              XK_e,       spawn,             {.v = (const char*[]){ "lf_main-dir", NULL } } }, /* lf file manager*/
{ SUPER|SHIFT,        XK_e,       spawn,             {.v = (const char*[]){ "lf_root", NULL } } },     /* lf file manager with root access*/
// Scripts (Sys Functionality)
{ SUPER,              XK_F8,      spawn,             {.v = (const char*[]){ "mon_select", NULL } } },  /* display settings*/
{ SUPER|SHIFT,        XK_comma,   spawn,             {.v = (const char*[]){ "emoji_select", NULL } } },
{ 0,                  XK_Print,   spawn,             {.v = (const char*[]){ "screenshot", NULL } } },
{ SHIFT,              XK_Print,   spawn,             {.v = (const char*[]){ "record_screen", NULL } } },
{ SUPER|SHIFT,        XK_p,       spawn,             {.v = (const char*[]){ "colorpicker_to_clipboard", NULL } } },
{ SUPER|SHIFT,        XK_y,       spawn,             {.v = (const char*[]){ "ytfzf_dmenu", NULL } } },
{ SUPER|SHIFT,        XK_k,       spawn,             {.v = (const char*[]){ "kbd_select", NULL } } },
//layouts
{ SUPER|SHIFT,        XK_t,       cyclelayout,       {.i = +1 } },
{ SUPER,              XK_t,       unfloatvisible,    {.v = &layouts[0]} },
{ SUPER,              XK_f,       togglefullscreen,  {0} },
/* { SUPER,            XK_t,      setlayout,      {.v = &layouts[0]} }, */
/* { SUPER,            XK_g,      setlayout,      {.v = &layouts[1]} }, */
/* { SUPER|SHIFT,      XK_g,      setlayout,      {.v = &layouts[2]} }, */
// Window  actions
{ SUPER,              XK_Return,  zoom,              {0} },
{ SUPER|SHIFT,        XK_space,   togglefloating,    {0} },
{ SUPER|SHIFT,        XK_b,       toggleborder,      {0} },
{ SUPER|SHIFT,		    BRCKTL,	    spawn,	           SHCMD("transset-df -a --dec .0025") }, /* let's you change the..  */
{ SUPER|SHIFT,		    BRCKTR,	    spawn,	           SHCMD("transset-df -a --inc .0025") }, /* ..opacity of the window */
// resize master slave ratio
{ SUPER|SHIFT,        XK_Left,    setmfact,          {.f = -0.05} },
{ SUPER|SHIFT,        XK_Right,   setmfact,          {.f = +0.05} },
// increase master number
{ SUPER|SHIFT,        XK_Up,      incnmaster,        {.i = +1 } }, 
{ SUPER|SHIFT,        XK_Down,    incnmaster,        {.i = -1 } },
//Focusing Tags
{ SUPER,              XK_Tab,     view,              {0} }, //cycle last
{ SUPER,              BRCKTL,     viewprev,          {0} },
{ SUPER,              BRCKTR,     viewnext,          {0} },
//Focusing Windows
{ SUPER,              XK_r,       previewallwin,     {0} },/* windows preview (click to focus) */
/* { SUPER,              XK_Left,    focusdir,          {.i = 0 } },  */
/* { SUPER,              XK_Right,   focusdir,          {.i = 1 } },  */
/* { SUPER,              XK_Up,      focusdir,          {.i = 2 } },  */
/* { SUPER,              XK_Down,    focusdir,          {.i = 3 } },  */
{ SUPER,              XK_h,       focusdir,          {.i = 0 } }, 
{ SUPER,              XK_l,       focusdir,          {.i = 1 } }, 
{ SUPER,              XK_k,       focusdir,          {.i = 2 } }, 
{ SUPER,              XK_j,       focusdir,          {.i = 3 } }, 
//Window Pos
{ SUPER|ALT,          XK_Down,    moveresize,        {.v = "  0x  25y   0w   0h" } },
{ SUPER|ALT,          XK_Up,      moveresize,        {.v = "  0x -25y   0w   0h" } },
{ SUPER|ALT,          XK_Right,   moveresize,        {.v = " 25x   0y   0w   0h" } },
{ SUPER|ALT,          XK_Left,    moveresize,        {.v = "-25x   0y   0w   0h" } },
//Window Size
{ SUPER|ALT|SHIFT,    XK_Down,    moveresize,        {.v = "  0x   0y   0w  25h" } },
{ SUPER|ALT|SHIFT,    XK_Up,      moveresize,        {.v = "  0x   0y   0w -25h" } },
{ SUPER|ALT|SHIFT,    XK_Right,   moveresize,        {.v = "  0x   0y  25w   0h" } },
{ SUPER|ALT|SHIFT,    XK_Left,    moveresize,        {.v = "  0x   0y -25w   0h" } },
  // Volume
{ SUPER,              XK_F1,		  spawn,		         SHCMD("changevolume mute; kill -35 $(pidof dwmblocks)") },
{ SUPER,              XK_F3,  	  spawn,		         SHCMD("changevolume up;   kill -35 $(pidof dwmblocks)") },
{ SUPER,              XK_F2,  	  spawn,		         SHCMD("changevolume down; kill -35 $(pidof dwmblocks)") },
{ 0,                  VOL_MUTE,	  spawn,		         SHCMD("changevolume mute; kill -35 $(pidof dwmblocks)") },
{ 0,                  VOL_UP,	    spawn,	           SHCMD("changevolume up;   kill -35 $(pidof dwmblocks)") },
{ 0,                  VOL_DOWN,	  spawn,		         SHCMD("changevolume down; kill -35 $(pidof dwmblocks)") },
// Screen Brightness
{ 0,                  BRGHT_UP,   spawn,		         SHCMD("xbacklight +10") },
{ 0,                  BRGHT_DOWN, spawn,	  	       SHCMD("xbacklight -10") },
// Tags | 0 -> all tags
{ SUPER,              XK_0,       view,              {.ui = ~0 } },
{ SUPER|SHIFT,        XK_0,       tag,               {.ui = ~0 } },
TAGKEYS(              XK_1,       0)
TAGKEYS(              XK_2,       1)
TAGKEYS(              XK_3,       2)
TAGKEYS(              XK_4,       3)
TAGKEYS(              XK_5,       4)
TAGKEYS(              XK_6,       5)
TAGKEYS(              XK_7,       6)
TAGKEYS(              XK_8,       7)
TAGKEYS(              XK_9,       8)
};

// Mouse Bindings (for status bar scripts)
static Button buttons[] = {
  /* click            event mask  button        function         argument */
// windows
	{ ClkClientWin,     SUPER,      M_LEFT,       moveorplace,         {.i = 1} },
	{ ClkClientWin,     SUPER,      M_MID,        togglefloating,      {0} },
// resizing 
	{ ClkClientWin,     SUPER,      M_RIGHT,      resizemouse,         {0} },
// tag bar
	{ ClkTagBar,        0,          M_LEFT,       view,                {0} },
// clickable status bar
  { ClkStatusText,    0,          M_LEFT,       sigstatusbar,        {.i = 1} },
  { ClkStatusText,    0,          M_MID,        sigstatusbar,        {.i = 2} },
  { ClkStatusText,    0,          M_RIGHT,      sigstatusbar,        {.i = 3} },
  { ClkStatusText,    0,          SCROLL_DOWN,  sigstatusbar,        {.i = 4} },
  { ClkStatusText,    0,          SCROLL_UP,    sigstatusbar,        {.i = 5} },
  { ClkStatusText,    SHIFT,      M_LEFT,       sigstatusbar,        {.i = 6} },
//Tap Window Resize 
  { ClkClientWin,       SUPER,    SCROLL_UP,    resizemousescroll, {.v = &scrollargs[0]} },
  { ClkClientWin,       SUPER,    SCROLL_DOWN,  resizemousescroll, {.v = &scrollargs[1]} },
  { ClkClientWin,       SUPER,    SCROLL_LEFT,  resizemousescroll, {.v = &scrollargs[2]} },
  { ClkClientWin,       SUPER,    SCROLL_RIGHT, resizemousescroll, {.v = &scrollargs[3]} },
};
