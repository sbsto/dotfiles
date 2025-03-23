#!/usr/bin/env -S usage bash

#USAGE arg "<command>" help="Command to run (add, remove, list, get)"
#USAGE arg "[value]" help="Value: KEY:VALUE format for add command, or KEY for remove command"

set -eo pipefail
ENV_FILE="$HOME/.config/mise/.env.json"
OP_ITEM_NAME="secrets"

function ensure_env_file {
  if [ ! -f "$ENV_FILE" ]; then
    mkdir -p "$(dirname "$ENV_FILE")"
    echo "{}" > "$ENV_FILE"
  fi
}

function add_secret {
  local pair=$1
  
  if [[ ! "$pair" =~ ^[^:]+:.+$ ]]; then
    echo "Error: Invalid format. Use KEY:VALUE format"
    exit 1
  fi
  
  local key="${pair%%:*}"
  local value="${pair#*:}"
  
  ensure_env_file
  
  if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Please install it first."
    exit 1
  fi
  
  jq ".$key = \"$value\"" "$ENV_FILE" > "$ENV_FILE.tmp" && mv "$ENV_FILE.tmp" "$ENV_FILE"
  
  update_1password
  
  echo "✅ Added/updated secret: $key in global file: $ENV_FILE"
}

function remove_secret {
  local key=$1
  
  ensure_env_file
  
  if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Please install it first."
    exit 1
  fi
  
  jq "del(.$key)" "$ENV_FILE" > "$ENV_FILE.tmp" && mv "$ENV_FILE.tmp" "$ENV_FILE"
  
  update_1password
  
  echo "✅ Removed secret: $key from global file: $ENV_FILE"
}

function get_secret {
  local key=$1
  
  ensure_env_file
  
  if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Please install it first."
    exit 1
  fi
  
  echo "$(jq -r ".$key" "$ENV_FILE")"
}

function list_secrets {
  ensure_env_file
  
  if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Please install it first."
    exit 1
  fi
  
  echo "🔑 Secrets from global file: $ENV_FILE"
  jq -r 'keys[]' "$ENV_FILE" | sort | sed 's/^/  /'
}

function update_1password {
  if ! command -v op &> /dev/null; then
    echo "Warning: 1Password CLI (op) not found. Skipping 1Password update."
    return
  fi
  
  if op document get "$OP_ITEM_NAME" > /dev/null 2>&1; then
    op document edit "$OP_ITEM_NAME" "$ENV_FILE"
  else
    op document create "$ENV_FILE" --title "$OP_ITEM_NAME"
  fi
  
  echo "🔒 Updated 1Password document '$OP_ITEM_NAME'"
}

case "$usage_command" in
  "add")
    if [ -z "$usage_value" ]; then
      echo "Error: No KEY:VALUE pair provided"
      exit 1
    fi
    add_secret "$usage_value"
    ;;
    
  "remove")
    if [ -z "$usage_value" ]; then
      echo "Error: No KEY provided"
      exit 1
    fi
    remove_secret "$usage_value"
    ;;

  "get")
    if [ -z "$usage_value" ]; then
      echo "Error: No KEY provided"
      exit 1
    fi
    get_secret "$usage_value"
    ;;
    
  "list")
    list_secrets
    ;;
    
  *)
    echo "Error: Unknown command '$usage_command'"
    exit 1
    ;;
esac
