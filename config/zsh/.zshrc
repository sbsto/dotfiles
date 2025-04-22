export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export STARSHIP_CONFIG=$HOME/.config/starship/config.toml
export EDITOR=nvim
export VISUAL=nvim
export SSH_AUTH_SOCK=$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

plugins_file="${ZDOTDIR:-$HOME}/dotfiles/config/zsh/plugins.txt"
static_file="${ZDOTDIR:-$HOME}/dotfiles/config/zsh/plugins.zsh"

[[ -f "$plugins_file" ]] || touch "$plugins_file"

fpath=(${ZDOTDIR:-$HOME}/dotfiles/config/zsh/antidote/functions $fpath)
autoload -Uz antidote

if [[ ! "$static_file" -nt "$plugins_file" ]]; then
  antidote bundle < "$plugins_file" >| "$static_file"
fi

source "$static_file"

for config_file in "${ZDOTDIR:-$HOME}/dotfiles/config/zsh/"*.zsh; do
  if [[ "$config_file" != "$plugins_file" && "$config_file" != "$static_file" ]]; then
    source "$config_file"
  fi
done

eval "$(~/.local/bin/mise activate zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"
