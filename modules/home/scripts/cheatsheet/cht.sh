#! /usr/bin/env sh

LANGUAGES=`echo "golang lua c csharp rust nix" | tr ' ' '\n'`
CORE_UTILS=`echo "xargs find mv sed awk" | tr ' ' '\n'`

SELECTED=`printf "$LANGUAGES\n$CORE_UTILS" | fzf`

read -p "query: " QUERY

if printf $LANGUAGES | grep -qs $SELECTED; then
    tmux neww sh -c "curl cht.sh/$SELECTED/`echo $QUERY | tr ' ' '+'` & while [ : ]; do sleep 1; done"
else
    tmux neww sh -c "curl cht.sh/$SELECTED~$QUERY & while [ : ]; do sleep 1; done"
fi
