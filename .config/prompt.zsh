# Two-line prompt, resize-safe.
#
#   ymn in ~/git/dotfiles on main · sharedsvcs dev eu-west-1
#    󰜴 some command
#
# Everything is left-aligned -- no space padding, which gets computed for one
# width and leaves orphaned rows in the scrollback on resize. A prompt line that
# wraps orphans a row too, so the badge is dropped when it would not fit.
# Based on https://gist.github.com/romkatv/2a107ef9314f0d5f76563725b42f7cab

# Collapse finished prompts to just the arrow. 0 keeps them whole.
: ${PROMPT_TRANSIENT:=1}

typeset -g PROMPT_ARROW='%B%F{green} 󰜴%f%b '
typeset -g _prompt_base='' _prompt_badge=''

# Visible width of TEXT into REPLY.
#
# Deliberately does not touch COLUMNS. The gist's prompt-length measures via the
# %(Nl.) test and so needs a huge COLUMNS, but COLUMNS is a special parameter
# wired to zle's terminal width -- assigning it even as a `local` corrupts it, and
# the value left behind on scope exit drifts. That made the width test below fire
# against garbage during a resize, keeping the badge on a pane too narrow for it.
function _prompt_width() {
  emulate -L zsh -o extended_glob
  local s=${(%)1}                 # expand %~, %F{...}, %B ...
  s=${s//$'\e'\[[0-9;]##m/}       # drop the SGR colour sequences that leaves
  typeset -g REPLY=${#s}
}

# Branch, or short SHA when detached. Empty outside a repo.
function _prompt_git_ref() {
  local ref
  ref=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) ||
    ref=$(git rev-parse --short HEAD 2>/dev/null) ||
    return 0
  print -rn -- ${ref//\%/%%}  # escape '%' for prompt_percent
}

# 'sharedsvcs dev eu-west-1' for the active AWS_PROFILE, else empty.
function _prompt_aws() {
  [[ -n $AWS_PROFILE ]] || return 0
  local label=${AWS_PROFILE%-devops}   # 'sharedsvcs_dev-devops' -> 'sharedsvcs dev'
  label=${label//_/ }
  local region=${AWS_REGION:-$AWS_DEFAULT_REGION}
  if [[ -z $region ]]; then            # fall back to ~/.aws/config
    region=$(awk -v want="$AWS_PROFILE" '
      /^\[/ { insec = ($0 == "[profile " want "]" || $0 == "[" want "]") }
      insec && /^[[:space:]]*region[[:space:]]*=/ {
        sub(/^[^=]*=[[:space:]]*/, ""); gsub(/[[:space:]]/, ""); print; exit
      }' ~/.aws/config 2>/dev/null)
  fi
  [[ -n $region ]] && label="$label $region"
  print -rn -- ${label//\%/%%}
}

# The half that forks git/awk. Width plays no part, so WINCH need not redo it.
function _prompt_segments() {
  emulate -L zsh

  _prompt_base="%F{blue}ymn%f in %B%F{green}%~%f%b"
  local ref=$(_prompt_git_ref)
  [[ -n $ref ]] && _prompt_base+=" on %F{magenta}${ref}%f"

  local aws=$(_prompt_aws)
  if [[ -n $aws ]]; then
    _prompt_badge=" %F{8}·%f %F{yellow}${aws}%f"
  else
    _prompt_badge=''
  fi
}

# The cheap, width-dependent half -- safe to run on every WINCH of a drag.
function _prompt_layout() {
  emulate -L zsh

  local top=$_prompt_base
  if [[ -n $_prompt_badge ]]; then
    local REPLY
    _prompt_width "$_prompt_base$_prompt_badge"
    # strictly less, so a spare column is always left at the right edge
    (( REPLY < COLUMNS )) && top+=$_prompt_badge
  fi

  PROMPT=$top$'\n'$PROMPT_ARROW
  RPROMPT=''
}

function set-prompt() {
  _prompt_segments
  _prompt_layout
}

setopt no_prompt_{bang,subst} prompt_{cr,percent,sp}
autoload -Uz add-zsh-hook
add-zsh-hook precmd set-prompt

# Resizing does not re-run precmd. Only the layout is redone, so a resize drag
# does not fork git once per WINCH.
function TRAPWINCH() {
  _prompt_layout
  zle && zle .reset-prompt
}

if (( PROMPT_TRANSIENT )); then
  zmodload -i zsh/zleparameter  # for $widgets

  # Chain onto an existing zle-line-finish rather than replacing it.
  if [[ -n ${widgets[zle-line-finish]} ]]; then
    zle -A zle-line-finish _prompt_prev_line_finish
  fi

  function _prompt_transient() {
    (( ${+widgets[_prompt_prev_line_finish]} )) && zle _prompt_prev_line_finish
    PROMPT=$PROMPT_ARROW
    RPROMPT=''
    zle .reset-prompt  # builtin; zsh-vi-mode's override can postpone the redraw
  }

  # Must be installed before zsh-vi-mode's deferred init, so zvm wraps this
  # widget. Installing after zvm makes zvm wrap a widget that dispatches back
  # into it, recursing until FUNCNEST trips.
  zle -N zle-line-finish _prompt_transient
fi
