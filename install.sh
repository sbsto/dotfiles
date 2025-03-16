#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

dotfiles_dir=~/dotfiles
config_dir="$dotfiles_dir/config"

if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    
    if [[ "$(uname)" == "Darwin" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        if [[ "$(uname -m)" == "arm64" ]]; then
            echo -e "${BLUE}Setting up Homebrew for Apple Silicon...${NC}"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    
    echo -e "${GREEN}Homebrew installed successfully!${NC}"
fi


if command -v brew &> /dev/null; then
    if [[ -f "$config_dir/brew/Brewfile" ]]; then
        echo -e "${YELLOW}Installing packages from Brewfile...${NC}"
        brew bundle --file="$config_dir/brew/Brewfile"
        echo -e "${GREEN}Brewfile packages installed successfully!${NC}"
    else
        echo -e "${BLUE}No Brewfile found at $config_dir/brew/Brewfile${NC}"
    fi
fi

if ! command -v mise &> /dev/null; then
    echo -e "${YELLOW}Installing mise...${NC}"
    curl https://mise.run | sh
fi
mise install

if [[ ! -d "$dotfiles_dir" ]]; then
    echo -e "${RED}Dotfiles directory not found at $dotfiles_dir${NC}"
    exit 1
fi

mkdir -p ~/.config

if [[ ! -d "$config_dir/zsh/antidote" ]]; then
    echo -e "${YELLOW}Installing antidote plugin manager...${NC}"
    mkdir -p "$config_dir/zsh"
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$config_dir/zsh/antidote"
fi

if [[ -d "$config_dir" ]]; then
    echo -e "${BLUE}Processing configuration directories...${NC}"
    for dir in "$config_dir"/*; do
        if [[ -d "$dir" ]]; then
            dirname=$(basename "$dir")
            echo -e "${BLUE}Setting up ${YELLOW}$dirname${BLUE} configuration...${NC}"
            
            if [[ -f "$dir/links" ]]; then
                echo -e "  ${GREEN}Found links configuration, using custom linking...${NC}"
                while IFS= read -r line || [[ -n "$line" ]]; do
                    if [[ -z "$line" || "$line" =~ ^# ]]; then
                        continue
                    fi
                    
                    source_file=$(echo "$line" | cut -d: -f1)
                    target_file=$(echo "$line" | cut -d: -f2)
                    
                    source_file=$(eval echo "$source_file")
                    target_file=$(eval echo "$target_file")
                    
                    parent_dir=$(dirname "$target_file")
                    mkdir -p "$parent_dir"
                    
                    echo -e "  ${GREEN}Linking ${YELLOW}$source_file${GREEN} to ${YELLOW}$target_file${NC}"
                    ln -sf "$source_file" "$target_file"
                done < "$dir/links"
            else
                if [[ ! -L ~/.config/"$dirname" ]]; then
                    echo -e "  ${GREEN}Using default link: ${YELLOW}$dir${GREEN} → ${YELLOW}~/.config/$dirname${NC}"
                    ln -sf "$dir" ~/.config/"$dirname"
                fi
            fi
        fi
    done
fi

echo -e "${GREEN}Dotfiles installation successful!${NC}"
