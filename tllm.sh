#!/bin/bash

# TLLM - Terminal Language Learning Model
# Version: 0.0.1
# Copyright (C) 2023 @pax
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Function to display usage information
usage() {
    echo "Usage: tllm [-i <input_file>] [-o <output_file>] \"<prompt>\""
    echo "  -i <input_file>  Optional input file for context"
    echo "  -o <output_file> Optional file to save the output"
    echo "  \"<prompt>\"       The prompt to send to Claude API (must be in quotes)"
    exit 1
}

# Function to read config file
read_config() {
    local config_file="$HOME/.tllm_config"
    if [[ ! -f "$config_file" ]]; then
        echo "Error: Config file not found at $config_file"
        exit 1
    fi
    source "$config_file"
    if [[ -z "$API_KEY" || -z "$API_URL" || -z "$MODEL" || -z "$MAX_TOKENS" || -z "$TEMPERATURE" ]]; then
        echo "Error: Missing required configuration in $config_file"
        exit 1
    fi
}

# Function to make API call
call_api() {
    local prompt="$1"
    local input_content="$2"
    local full_prompt

    if [[ -n "$input_content" ]]; then
        full_prompt="Context:\n$input_content\n\nUser: $prompt"
    else
        full_prompt="User: $prompt"
    fi

    # Escape special characters in the full_prompt
    full_prompt=$(echo "$full_prompt" | sed 's/"/\\"/g; s/$/\\n/g' | tr -d '\n')

    local response=$(curl -s -H "x-api-key: $API_KEY" \
         -H "anthropic-version: 2023-06-01" \
         -H "content-type: application/json" \
         -d '{
            "model": "'"$MODEL"'",
            "max_tokens": '"$MAX_TOKENS"',
            "temperature": '"$TEMPERATURE"',
            "messages": [
                {"role": "user", "content": "'"${full_prompt//\"/\\\"}"'"}
            ]
         }' \
         "$API_URL")

    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to connect to the API"
        exit 1
    fi

    echo "$response"
}

# Main script execution
main() {
    local input_file=""
    local output_file=""
    local prompt=""

    # Parse command line arguments
    while getopts ":i:o:" opt; do
        case $opt in
            i) input_file="$OPTARG" ;;
            o) output_file="$OPTARG" ;;
            \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
            :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
        esac
    done

    # Shift the parsed options
    shift $((OPTIND-1))

    # Check if prompt is provided
    if [[ $# -eq 0 ]]; then
        echo "Error: Prompt is required"
        usage
    fi

    prompt="$1"

    # Read config
    read_config

    # Read input file if provided
    local input_content=""
    if [[ -n "$input_file" ]]; then
        if [[ ! -f "$input_file" ]]; then
            echo "Error: Input file not found: $input_file"
            exit 1
        fi
        input_content=$(cat "$input_file" 2>/dev/null)
        if [[ $? -ne 0 ]]; then
            echo "Error: Failed to read input file: $input_file"
            exit 1
        fi
    fi

    # Call API
    local api_response=$(call_api "$prompt" "$input_content")

    # Extract and process the response
    local response_text=$(echo "$api_response" | grep -o '"text":"[^"]*"' | sed 's/"text":"//;s/"$//')

    if [[ -z "$response_text" ]]; then
        echo "Error: Failed to get a valid response from the API"
        echo "API Response: $api_response"
        exit 1
    fi

    # Output the response
    if [[ -n "$output_file" ]]; then
        echo -e "$response_text" > "$output_file"
        echo "Response saved to $output_file"
    else
        echo -e "$response_text"
    fi
}

# Run the main function
main "$@"
