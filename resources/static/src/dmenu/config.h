static const unsigned int alpha = 0xE3;     /* Amount of opacity. 0xff is opaque             */
static int inputWidth = 12;
static unsigned int border_width = 1;

static const char *fonts[] = {
  "IosevkaNerdFont:pixelsize=24:antialias=true:autohint=true"
    /* "NotoColorEmoji:pixelsize=24:antialias=true:autohint=true" */
};


static const char barText[]       = "#88DD1D";
static const char barBGM[]        = "#000000";
static const char selectedBarBGM[]= "#1F0055";
static const char outline[]       = "#5500FF";


static const char *colors[SchemeLast][2] = {
	/*                         fg         bg       */
	[SchemeNorm] =          { barText, barBGM },
	[SchemeSel] =           { barText, selectedBarBGM },
	[SchemeOut] =           { outline, "#00ff00" },
};


static const unsigned int alphas[SchemeLast][2] = {
	[SchemeNorm] = { OPAQUE, alpha },
	[SchemeSel] =  { OPAQUE, alpha },
	[SchemeOut] =  { OPAQUE, alpha },
};


static int fuzzy = 1;                      /* -F  option; if 0, dmenu doesn't use fuzzy matching     */
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char worddelimiters[] = " ";
static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
static unsigned int lines    = 0;
static unsigned int columns  = 0;
