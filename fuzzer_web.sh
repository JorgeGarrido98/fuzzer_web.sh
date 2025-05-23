#!/bin/bash

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
MAGENTA="\033[0;35m"
CYAN="\033[1;36m"
RESET="\033[0m"

# Title Script
echo -e "${MAGENTA}"
cat << "EOF"

 /$$$$$$$$ /$$   /$$ /$$$$$$$$ /$$$$$$$$ /$$$$$$$$ /$$$$$$$        /$$      /$$ /$$$$$$$$ /$$$$$$$ 
| $$_____/| $$  | $$|_____ $$ |_____ $$ | $$_____/| $$__  $$      | $$  /$ | $$| $$_____/| $$__  $$
| $$      | $$  | $$     /$$/      /$$/ | $$      | $$  \ $$      | $$ /$$$| $$| $$      | $$  \ $$
| $$$$$   | $$  | $$    /$$/      /$$/  | $$$$$   | $$$$$$$/      | $$/$$ $$ $$| $$$$$   | $$$$$$$ 
| $$__/   | $$  | $$   /$$/      /$$/   | $$__/   | $$__  $$      | $$$$_  $$$$| $$__/   | $$__  $$
| $$      | $$  | $$  /$$/      /$$/    | $$      | $$  \ $$      | $$$/ \  $$$| $$      | $$  \ $$
| $$      |  $$$$$$/ /$$$$$$$$ /$$$$$$$$| $$$$$$$$| $$  | $$      | $$/   \  $$| $$$$$$$$| $$$$$$$/
|__/       \______/ |________/|________/|________/|__/  |__/      |__/     \__/|________/|_______/ 

					    fuzzer_web.sh - v1.0
                                       	   Autor -> Jorge Garrido
EOF
echo -e "${RESET}"

# CODE
# Check that two parameters are provided: <dictionary> <base URL>
if [ $# -ne 2 ]; then
    echo -e "${RED}Usage: $0 <dictionary> <base URL>${RESET}"
    exit 1
fi

dictionary="$1"
url="$2"
output_file="found_urls.txt"

# Check if the dictionary file exists
if [ ! -f "$dictionary" ]; then
    echo -e "${RED}❌ Dictionary not found: $dictionary${RESET}"
    exit 1
fi

# Generate output filename with timestamp
timestamp=$(date +%Y%m%d_%H%M%S)
output_file="found_urls_$timestamp.txt"

# Clear the output file (create new)
> "$output_file"

# Count total lines in the dictionary for progress display
total_lines=$(wc -l < "$dictionary")
current_line=0

# Read dictionary line by line
while IFS= read -r line; do
    current_line=$((current_line + 1))
    echo -ne "${CYAN}Progress: $current_line/$total_lines\r${RESET}"

    # Perform HTTP request and get the response code only
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url$line/")

    case "$response" in
        200)
            echo -e "${GREEN}✅ [200 OK] $url$line/${RESET}"
            echo "$url$line/ [200]" >> "$output_file"
            ;;
        301|302)
            echo -e "${BLUE}🔁 [$response Redirect] $url$line/${RESET}"
            echo "$url$line/ [$response]" >> "$output_file"
            ;;
        403)
            echo -e "${RED}⛔ [403 Forbidden] $url$line/${RESET}"
            echo "$url$line/ [403]" >> "$output_file"
            ;;
        *)
            # Other codes are ignored (like 404)
            ;;
    esac

done < "$dictionary"

echo -e "${GREEN}\n✅ Process completed. Results saved in $output_file${RESET}"
