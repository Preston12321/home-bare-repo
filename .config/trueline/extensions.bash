_trueline_time_segment() {
  local prompt_time="$(date +%X)"
    if [[ -n "$prompt_time" ]]; then
        local fg_color="$1"
        local bg_color="$2"
        local font_style="$3"
        local segment="$(_trueline_separator)"
        segment+="$(_trueline_content "$fg_color" "$bg_color" "$font_style" " $prompt_time ")"
        PS1+="$segment"
        _last_color=$bg_color
    fi
}

_trueline_git_behind() {
    branch="$1"
    upstream="$(git config --get branch."$branch".merge)"
    if [[ -n $upstream ]]; then
        nr_behind_ahead="$(git rev-list --count --left-right '@{upstream}...HEAD' 2> /dev/null)" || nr_behind_ahead=''
        nr_behind="${nr_behind_ahead%	*}"
        git_behind=''
        if [[ ! "$nr_behind" -eq 0 ]]; then
            git_behind+="${TRUELINE_SYMBOLS[git_behind]} "
            if [[ "$TRUELINE_GIT_SHOW_STATUS_NUMBERS" = true ]]; then
                git_behind+="$nr_behind "
            fi
        fi
        echo "$git_behind"
    fi
}

_trueline_git_ahead() {
    branch="$1"
    upstream="$(git config --get branch."$branch".merge)"
    if [[ -n $upstream ]]; then
        nr_behind_ahead="$(git rev-list --count --left-right '@{upstream}...HEAD' 2> /dev/null)" || nr_behind_ahead=''
        nr_ahead="${nr_behind_ahead#*	}"
        git_ahead=''
        if [[ ! "$nr_ahead" -eq 0 ]]; then
            git_ahead+="${TRUELINE_SYMBOLS[git_ahead]} "
            if [[ "$TRUELINE_GIT_SHOW_STATUS_NUMBERS" = true ]]; then
                git_ahead+="$nr_ahead "
            fi
        fi
        echo "$git_ahead"
    fi
}

_trueline_git_patched_segment() {
    local branch="$(_trueline_has_git_branch)"
    if [[ -n $branch ]]; then
        local fg_color="$1"
        local bg_color="$2"
        local font_style="$3"
        local segment="$(_trueline_separator)"

        local branch_icon="$(_trueline_git_remote_icon)"
        segment+="$(_trueline_content "$fg_color" "$bg_color" "$font_style" "$branch_icon$branch ")"
        local mod_files="$(_trueline_git_mod_files)"
        if [[ -n "$mod_files" ]]; then
            segment+="$(_trueline_content "$TRUELINE_GIT_MODIFIED_COLOR" "$bg_color" "$font_style" "$mod_files")"
        fi
        local behind="$(_trueline_git_behind "$branch")"
        if [[ -n "$behind" ]]; then
            segment+="$(_trueline_content "$TRUELINE_GIT_BEHIND_COLOR" "$bg_color" "$font_style" "$behind")"
        fi
        local ahead="$(_trueline_git_ahead "$branch")"
        if [[ -n "$ahead" ]]; then
            segment+="$(_trueline_content "$TRUELINE_GIT_AHEAD_COLOR" "$bg_color" "$font_style" "$ahead")"
        fi
        PS1+="$segment"
        _last_color=$bg_color
    fi
}

_trueline_current_dir_segment() {
    local fg_color="$1"
    local bg_color="$2"
    local font_style="$3"
    local segment="$(_trueline_separator)"
    local wd_sep=" ${TRUELINE_SYMBOLS[working_dir_separator]} "

    local p="${PWD/$HOME/${TRUELINE_SYMBOLS[working_dir_home]}}"
    local arr=
    IFS='/' read -r -a arr <<< "$p"
    local path_size="${#arr[@]}"
    if [[ "$path_size" -eq 1 ]]; then
        local path_="\[\033[1m\]${arr[0]:=/}"
    elif [[ "$path_size" -eq 2 ]]; then
        local path_="${arr[0]:=/}$wd_sep\[\033[1m\]${arr[+1]}"
    else
        if [[ "$path_size" -gt 3 ]]; then
            p="${arr[0]}/…/"$(echo "$p" | rev | cut -d '/' -f1 | rev)
        fi
        local curr=$(basename "$p")
        p=$(dirname "$p")
        local path_="${p//\//$wd_sep}$wd_sep\[\033[1m\]$curr"
        if [[ "${p:0:1}" = '/' ]]; then
            path_="/$path_"
        fi
    fi
    segment+="$(_trueline_content "$fg_color" "$bg_color" "$font_style" " $path_ ")"
    PS1+="$segment"
    _last_color=$bg_color
}
