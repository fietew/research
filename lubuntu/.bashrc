# add git branch to prompt
GIT_PS1_SHOWDIRTYSTATE=1
PS1="${PS1%'\$ '}"'$(__git_ps1 " (%s)")'"\$ "
