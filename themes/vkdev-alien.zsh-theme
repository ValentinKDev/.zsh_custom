# See https://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxbxbxbxbxbxbx"
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=31;40:cd=31;40:su=31;40:sg=31;40:tw=31;40:ow=31;40:"
#print 256 colors
#$for number in {000..255}; do print -P "$number %F{$number}COLOR%f"
#$specturm ls
red="009"
gray="008"
deepgray="238"
yellow="137"
yellow256="#af875f"

ZSH_THEME_GIT_PROMPT_PREFIX="$fg[blue]git : "
ZSH_THEME_GIT_PROMPT_SUFFIX="$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red] [+]$reset_color"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green] [v]$reset_color"

INSERT_FIRST_SYMBOL="%F{$yellow}<%f"
INSERT_SECOND_SYMBOL="%F{$deepgray}·%f"
INSERT_MID_SYMBOL="%(?.%F{$deepgray} %f.%F{red}x%f)"
INSERT_FOURTH_SYMBOL="%F{$deepgray}·%f"
INSERT_FIFTH_SYMBOL="%F{$yellow}>%f"
INSERT_PROMPT="%B$INSERT_FIRST_SYMBOL$INSERT_SECOND_SYMBOL$INSERT_MID_SYMBOL$INSERT_FOURTH_SYMBOL$INSERT_FIFTH_SYMBOL%b  "

CMD_FIRST_SYMBOL="%F{$yellow}<%f"
CMD_SECOND_SYMBOL="%F{$red}:%f"
CMD_MID_SYMBOL="%(?.%F{$yellow}0%f.%F{$yellow}x%f)"
CMD_FOURTH_SYMBOL="%F{$red}:%f"
CMD_FIFTH_SYMBOL="%F{$yellow}>%f"
CMD_PROMPT="%B$CMD_FIRST_SYMBOL$CMD_SECOND_SYMBOL$CMD_MID_SYMBOL$CMD_FOURTH_SYMBOL$CMD_FIFTH_SYMBOL%b  "

function get_pwd() { echo "${PWD/$HOME/~}" | xargs -n 1 basename }

function get_user_name() { echo "$USERNAME" }
username="$USERNAME"
hostname="$(hostname -f)"
username_lenght=${#usename}
hostname_lenght=${#hostname}


function put_spacing() {
	local git=$(git_prompt_info)
	if [ ${#git} != 0 ]; then
		((git=${#git} - 20))
	else
		git=0
	fi

	local termwidth
	(( termwidth = ${COLUMNS} - 8 - ${#$(get_pwd)} - ${git} - ${username_lenght} -1 - ${hostname_lenght} - 5 ))
#	(( termwidth = ${COLUMNS} - 8 - ${#$(get_pwd)} - ${git} - ${username_lenght} - 10))

	local spacing=""
	for i in {1..$termwidth}; do
		spacing="${spacing} "
	done
	echo $spacing
}

function deuxx(){ echo "ac"$(put_spacing)$(git_prompt_info) }

#Print a notification when text field entre vim's command mode
function zle-line-init zle-keymap-select {
	if [ $KEYMAP = vicmd ]
		then
			echo -ne "\033]12;$yellow256\007"
			#PROMPT="%B$FIRST_SYMBOL$SECOND_SYMBOL$FOURTH_SYMBOL$FIFTH_SYMBOL%b  "
			PROMPT=$CMD_PROMPT
		else
			echo -ne "\033]12;White\007"
			PROMPT=$INSERT_PROMPT
	fi

	#RPS1="%F{$yellow}${${KEYMAP/vicmd/-- VIM-MOTION --}/(main|viins)/}%f"
	#RPS2=$RPS1
	zle reset-prompt
}

function alignHour {
	local hour=$(date +%H)
	if [ "$hour" -ge 10 ]
		then 
			echo -ne ""
		else 
			echo -ne "0"
	fi
}

#Enable vim commande mode
zle -N zle-line-init
zle -N zle-keymap-select
#replace by jeffreytse/zsh-vi-mode
#bindkey -v

#if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="blue"; fi
autoload -U colors && colors


function print_user_and_machine {
	userColor="%{%F{023}%}"
	machineColor="%{%F{023}%}"
	atColor="%{%F{238}%}"
	echo "${userColor}%n${atColor}@${machineColor}%m%"
}

#First prompt line
precmd(){
	local preprompt_left="%{%F{238}%}$(alignHour)%T  $(print_user_and_machine)  %{%f%}%{%F{063}%}%c%{%f%}%$(put_spacing)$(git_prompt_info)"
	print -Pr "$preprompt_left"
}

#second prompt line
#PROMPT='%{$fg[cyan]%}%B|%{$fg[yellow]%}>%{$fg[cyan]%}%(?.:.%{$fg[magenta]%}X)%b%{$fg[yellow]%}%B<$fg[cyan]%}|  %b%{$reset_color%}'

PROMPT=$INSERT_PROMPT
