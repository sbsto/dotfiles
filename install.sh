#!/bin/bash

dotfiles_dir=~/dotfiles
config_dir="$dotfiles_dir/config"
files_dir="$dotfiles_dir/files"

if [[ ! -d "$dotfiles_dir" ]]; then
    echo "Dotfiles directory not found at $dotfiles_dir"
    exit 1
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
            ln -sf "$dir" ~/.config/"$dirname"
        fi
    done
fi

echo "success :)" 
