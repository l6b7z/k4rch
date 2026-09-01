# ── prompt ───────────────────────────────────────
PS1="%F{118}[%f%F{106}%1~%f%F{118}] > %f"
unsetopt PROMPT_SP                      # no stray % on partial-line output

# ── history ──────────────────────────────────────
HISTFILE=$ZDOTDIR/z_history
HISTSIZE=100000                         # kept in RAM this session
SAVEHIST=100000                         # written to disk
setopt EXTENDED_HISTORY                 # timestamps — needed for correct cross-shell order
setopt SHARE_HISTORY                    # live sync between open terminals
setopt HIST_IGNORE_ALL_DUPS             # new entry kills older identical one
setopt HIST_REDUCE_BLANKS               # strip redundant whitespace
setopt HIST_IGNORE_SPACE                # leading space = don't record

# ── mode ─────────────────────────────────────────
bindkey -e # emacs / vim shit

# ── completion ───────────────────────────────────
autoload -U compinit
zstyle ':completion:*' menu select      # arrow-key menu instead of a flat list
zmodload zsh/complist                   # provides menu (for completion)
[ "$(date +%j)" != "$(date +%j -r $ZDOTDIR/.zcompdump 2>/dev/null)" ] && compinit || compinit -C
_comp_options+=(globdots)               # complete dotfiles too
autoload -U colors && colors            # $fg/$bg colour arrays

stty stop undef                         # tty stops eating ctrl-S

# ── keybinds: basics ─────────────────────────────
bindkey "^M" accept-line                # enter
bindkey "^I" expand-or-complete         # tab
bindkey "^L" clear-screen               # ctrl-L
bindkey "^?" backward-delete-char       # backspace
bindkey "^H" backward-kill-word         # ctrl-backspace
bindkey "^[[P" delete-char              # Delete key

# ── keybinds: movement ───────────────────────────
bindkey "^[[A" up-line-or-history       # up: prev line in buffer, else history
bindkey "^[[B" down-line-or-history     # down
bindkey "^[[C" forward-char             # right, one char
bindkey "^[[D" backward-char            # left, one char
bindkey '^[[1;5D' beginning-of-line     # ctrl-left  (1;5 = ctrl modifier)
bindkey '^[[1;5C' end-of-line           # ctrl-right
bindkey "^A" backward-word              # ctrl-A: one word back
bindkey "^S" forward-word               # ctrl-S: one word fwd (freed by stty above)

# ── keybinds: custom ─────────────────────────────
copy-buffer() { print -rn -- "$BUFFER" | xsel --clipboard }
zle -N copy-buffer
bindkey "^Y" copy-buffer                # ctrl-Y: whole line -> clipboard

paste-buffer() { LBUFFER+="$(xsel --clipboard --output)" }
zle -N paste-buffer
bindkey "^V" paste-buffer               # ctrl-V: clipboard -> at cursor

# ── keybinds: unbinding  ──────────────────────
bindkey -ar "^["
bindkey -M emacs -r "^X^O"              # overwrite-mode — stop accidental toggles
bindkey -M emacs -r "^X^V"              # vi-cmd-mode

# ── plugins ──────────────────────────────────────
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/plugins/zsh-fzf-history-search/zsh-fzf-history-search.zsh"
source "$ZDOTDIR/plugins/zsh-sudo/zsh-sudo.zsh"
source "$ZDOTDIR/plugins/zsh-globalalias/globalalias.zsh"

source "$ZDOTDIR/aliases"

# syntax-highlighting wraps every ZLE widget existing at source time — must be last
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
