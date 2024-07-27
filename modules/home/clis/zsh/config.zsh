setopt nocaseglob
#setopt autocd extendedglob nomatch menucomplete
setopt autocd extendedglob nomatch
setopt interactive_comments
stty stop undef # disable ctrl-s freezing terminal
zle_highlight=('paste:none')

unsetopt BEEP

#setopt MENU_COMPLETE

#zstyle ':completion:*' menu select
autoload -Uz compinit
# typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
# if [ $(date +'%j') != $updated_at ]; then
#   compinit -i
# else
#   compinit -C -i
# fi

zmodload -i zsh/complist

setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
