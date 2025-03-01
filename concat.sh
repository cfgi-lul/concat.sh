#!/bin/bash

input_dir="."
skip_empty=false
exclude_list=()
exclude_regex=""
output_file=""

show_help() {
    echo "Usage: concat.sh [OPTIONS]"
    echo "Concatenate text files from a directory into a single output file."
    echo ""
    echo "Options:"
    echo "  -i, --input DIR         Specify input directory (default: current directory)"
    echo "  -o, --output FILE       Specify output file (default: res.txt in the current directory)"
    echo "  -s, --skipEmpty         Skip empty files after processing"
    echo "  -e, --exclude DIR       Exclude specified directories or files (can be used multiple times)"
    echo "  -er, --excludeRegex REGEX  Exclude lines matching the regex pattern"
    echo "  -h, --help              Show this help message and exit"
    echo ""
    echo "Examples:"
    echo "  concat.sh -i ./somePath -o output.txt -s -e ./dist ./node_modules -er '^import .*;'"
    echo "    Concatenates all files in 'somePath', excluding empty files, 'dist' and 'node_modules',"
    echo "    removes lines starting with 'import ', and writes output to 'output.txt'."
    echo ""
    echo "  concat.sh -i ./logs -s -er 'DEBUG'"
    echo "    Concatenates all files in 'logs', skips empty ones, and removes lines containing 'DEBUG'."
    exit 0
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --input|-i)
            input_dir="$2"
            shift 2
            ;;
        --output|-o)
            output_file="$2"
            shift 2
            ;;
        --skipEmpty|-s)
            skip_empty=true
            shift
            ;;
        --exclude|-e)
            shift
            while [[ "$#" -gt 0 && "$1" != --* ]]; do
                exclude_list+=("$1")
                shift
            done
            ;;
        --excludeRegex|-er)
            exclude_regex="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

if [[ ! -d "$input_dir" ]]; then
    echo "Error: Directory '$input_dir' does not exist."
    exit 1
fi

if [[ -z "$output_file" ]]; then
    output_file="$(pwd)/res.txt"
fi

> "$output_file"

is_excluded() {
    local file="$1"
    for excluded in "${exclude_list[@]}"; do
        if [[ "$file" == *"$excluded"* ]]; then
            return 0
        fi
    done
    return 1
}

process_file() {
    local file="$1"
    local temp_file=$(mktemp)
    
    if is_excluded "$file"; then
        echo "Skipping excluded file: $file"
        return
    fi
    
    if [[ -n "$exclude_regex" ]]; then
        grep -Ev "$exclude_regex" "$file" > "$temp_file"
        mv "$temp_file" "$file"
    fi
    
    if [[ "$skip_empty" == true && ! -s "$file" ]]; then
        echo "Skipping empty file: $file"
        return
    fi
    
    echo "Processing: $file"
    
    echo "===== File: $file =====" >> "$output_file"
    
    cat "$file" >> "$output_file"
    
    echo -e "\n" >> "$output_file"
}

find "$input_dir" -type f ! -name "$(basename "$output_file")" | while read -r file; do
    process_file "$file"
done

echo "All files have been processed. Output written to $output_file"
