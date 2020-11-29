declare -A TRUELINE_COLORS=(
    [darker_red]='224;89;100'
    [darker_special_grey]='48;52;58'
    [pure_white]='255;255;255'
    [pure_black]='0;0;0'
)

declare -a TRUELINE_SEGMENTS=(
    'time,light_blue,pure_black,normal'
    'current_dir,white,black,normal'
    'git_patched,white,darker_special_grey,normal'
    'exit_status,pure_white,darker_red,normal'
)

TRUELINE_GIT_MODIFIED_COLOR='orange'
TRUELINE_GIT_BEHIND_COLOR='red'
TRUELINE_GIT_AHEAD_COLOR='green'
