
set -U FZF_LEGACY_KEYBINDINGS 0
set -Ux EDITOR nvim

## env setting
set -x GOPATH $HOME/.go
set -x GOROOT /usr/local/go
set -x PATH $PATH $GOROOT/bin
set -x PATH $PATH $GOPATH/bin
set -x PATH $PATH $HOME/.cargo/bin

# pgsql
set -x PATH $PATH /usr/local/pgsql/bin
# apache
set -x PATH $PATH /usr/local/apache/bin

function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end
    fish_vi_key_bindings --no-erase
end

set -g fish_key_bindings hybrid_bindings

alias pbcopy='xsel --clipboard --input'
alias ssh='env TERM=xterm ssh'

starship init fish | source

