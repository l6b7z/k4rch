#include <X11/XF86keysym.h>

#define CTRL         ControlMask
#define SHIFT        ShiftMask
#define ALT          Mod1Mask
#define HYPER        Mod3Mask
#define SUPER        Mod4Mask 

#define BRCKTL       XK_bracketleft
#define BRCKTR       XK_bracketright

#define M_LEFT       Button1
#define M_MID        Button2
#define M_RIGHT      Button3
#define SCROLL_UP    Button4
#define SCROLL_DOWN  Button5
#define SCROLL_LEFT  Button6
#define SCROLL_RIGHT Button7

#define VOL_UP       XF86XK_AudioRaiseVolume
#define VOL_DOWN     XF86XK_AudioLowerVolume
#define VOL_MUTE     XF86XK_AudioMute
#define BRGHT_UP     XF86XK_MonBrightnessUp
#define BRGHT_DOWN   XF86XK_MonBrightnessDown


static char dmenumon[2] = "0"; 
static const char *dmenucmd[] = { "dmenu_run", NULL };   

static char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const float mfact = 0.50; 
static const int nmaster = 1; 

static const int resizehints = 0; 
static const int lockfullscreen = 0; /* 1 will force focus on the fullscreen window */ 
static const int smartgaps = 1; /* 1 means no outer gap when there is only one window */

static const char black[]  = "#000000"; 
static const char *colors[][4]  = {[SchemeNorm] = { barText, barBG,  client,   black },[SchemeSel]  = { barText, barBG,  activeClient,  floatClient },}; 

#define TAGKEYS(KEY,TAG) \
{ SUPER,                       KEY,      view,           {.ui = 1 << TAG} }, \
{ SUPER|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
{ SUPER|SHIFT,                 KEY,      tag,            {.ui = 1 << TAG} }, \
{ SUPER|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },


#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* resizemousescroll direction argument list */
static const int scrollargs[][2] = {
	/* width change  height change */
	{ +scrollsensetivity,	0 },
	{ -scrollsensetivity,	0 },
	{ 0, +scrollsensetivity },
	{ 0, -scrollsensetivity },
};
