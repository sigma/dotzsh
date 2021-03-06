# local GPG_ENV=$HOME/.gnupg/gpg-agent.env

# function start_agent_nossh {
#     eval $(/usr/bin/env gpg-agent --quiet --daemon --write-env-file ${GPG_ENV} 2> /dev/null)
#     chmod 600 ${GPG_ENV}
#     export GPG_AGENT_INFO
# }

# function start_agent_withssh {
#     eval $(/usr/bin/env gpg-agent --quiet --daemon --enable-ssh-support --write-env-file ${GPG_ENV} 2> /dev/null)
#     chmod 600 ${GPG_ENV}
#     export GPG_AGENT_INFO
#     export SSH_AUTH_SOCK
#     export SSH_AGENT_PID
# }

# # check if another agent is running
# if ! gpg-connect-agent --quiet /bye > /dev/null 2> /dev/null; then
#     # source settings of old agent, if applicable
#     if [ -f "${GPG_ENV}" ]; then
#         . ${GPG_ENV} > /dev/null
#         export GPG_AGENT_INFO
#         export SSH_AUTH_SOCK
#         export SSH_AGENT_PID
#     fi

#     # check again if another agent is running using the newly sourced settings
#     if ! gpg-connect-agent --quiet /bye > /dev/null 2> /dev/null; then
#         # check for existing ssh-agent
#         if ssh-add -l > /dev/null 2> /dev/null; then
#             # ssh-agent running, start gpg-agent without ssh support
#             start_agent_nossh;
#         else
#             # otherwise start gpg-agent with ssh support
#             start_agent_withssh;
#         fi
#     fi
# fi

# GPG_TTY=$(tty)
# export GPG_TTY

if [ -e "$HOME/.gpg-agent-info" ]; then
    source "$HOME/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
fi

if [ -S "$HOME/.ssh/ssh_auth_sock_$HOSTNAME" ]; then
    export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock_$HOSTNAME"
fi

eval `keychain -q --nogui --eval --agents ssh,gpg --inherit any-once --stop others --ignore-missing $HOME/.ssh/*.pub(:t:r) $GPG_ID`
