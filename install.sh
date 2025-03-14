#!/bin/bash

dotfiles_dir=~/dotfiles
config_dir="$dotfiles_dir/config"
files_dir="$dotfiles_dir/files"

if ! command -v mise &> /dev/null; then
    curl https://mise.run | sh
fi
mise install

if [[ ! -d "$dotfiles_dir" ]]; then
    echo "Dotfiles directory not found at $dotfiles_dir"
    exit 1
fi

mkdir -p ~/.config

if [[ ! -d "$config_dir/zsh/antidote" ]]; then
    echo "Installing antidote plugin manager..."
    mkdir -p "$config_dir/zsh"
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$config_dir/zsh/antidote"
fi

if [[ -d "$files_dir" ]]; then
    for file in "$files_dir"/*; do
        filename=$(basename "$file")
        ln -sf "$file" ~/".$filename"
    done
fi

if [[ -d "$config_dir" ]]; then
    for dir in "$config_dir"/*; do
        if [[ -d "$dir" ]]; then
            dirname=$(basename "$dir")
            if [[ "$dirname" == "zsh" ]]; then
                ln -sf "$dir/.zshrc" ~/.zshrc
            else
                if [[ ! -L ~/.config/"$dirname" ]]; then
                    ln -sf "$dir" ~/.config/"$dirname"
                fi
            fi
        fi
    done
fi

echo "Dotfiles installation successful :)"
