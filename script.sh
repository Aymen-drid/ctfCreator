#!/bin/zsh

# Base directory for CTF repositories
BASE_DIR="/media/user/sh1/Aymen-drid.github.io"
GLOBAL_README="${BASE_DIR}/README.md"

# Function to create a new CTF
create_ctf() {
    local ctf_name="$1"
    
    if [[ -z "$ctf_name" ]]; then
        echo "Error: Please provide a CTF name"
        return 1
    }

    # Create CTF directory
    local ctf_dir="${BASE_DIR}/${ctf_name}"
    mkdir -p "$ctf_dir"

    # Create global CTF README
    local ctf_readme="${ctf_dir}/README.md"
    cat > "$ctf_readme" << EOF
---
layout: default
---
# ${ctf_name} CTF Writeups

## Categories
- [reverse](rev/README.md)
- [crypto](crypto/README.md)
- [pwn](pwn/README.md)
- [web](web/README.md)
- [osint](osint/README.md)
- [misc](misc/README.md)
- [blockchain](blockchain/README.md)
- soon adding more
EOF

    # Update global README.md
    sed -i "/{% include disqus.html %}/i ## >> [${ctf_name}](./${ctf_name}/README)" "$GLOBAL_README"

    # Create category directories
    local categories=("rev" "crypto" "pwn" "web" "osint" "misc" "blockchain")
    for category in "${categories[@]}"; do
        local category_dir="${ctf_dir}/${category}"
        mkdir -p "$category_dir"

        # Create category README
        local category_readme="${category_dir}/README.md"
        cat > "$category_readme" << EOF
---
layout: default
---
# ${ctf_name} - ${category^} Challenges
EOF
    done

    echo "CTF '${ctf_name}' created successfully!"
}

# Function to create a new category in an existing CTF
create_category() {
    local ctf_name="$1"
    local category="$2"

    if [[ -z "$ctf_name" || -z "$category" ]]; then
        echo "Error: Please provide CTF name and category"
        return 1
    }

    local ctf_dir="${BASE_DIR}/${ctf_name}"
    local category_dir="${ctf_dir}/${category}"
    local ctf_readme="${ctf_dir}/README.md"
    local category_readme="${category_dir}/README.md"

    # Validate CTF exists
    if [[ ! -d "$ctf_dir" ]]; then
        echo "Error: CTF '${ctf_name}' does not exist"
        return 1
    }

    # Create category directory
    mkdir -p "$category_dir"

    # Update CTF README to include new category
    sed -i "/soon adding more/i - [${category}](${category}/README.md)" "$ctf_readme"

    # Create category README
    cat > "$category_readme" << EOF
---
layout: default
---
# ${ctf_name} - ${category^} Challenges
EOF

    echo "Category '${category}' created in CTF '${ctf_name}' successfully!"
}

# Function to create a new challenge
create_challenge() {
    local ctf_name="$1"
    local category="$2"
    local challenge_name="$3"

    if [[ -z "$ctf_name" || -z "$category" || -z "$challenge_name" ]]; then
        echo "Error: Please provide CTF name, category, and challenge name"
        return 1
    }

    local ctf_dir="${BASE_DIR}/${ctf_name}"
    local category_dir="${ctf_dir}/${category}"
    local challenge_dir="${category_dir}/${challenge_name}"
    local category_readme="${category_dir}/README.md"
    local challenge_readme="${challenge_dir}/README.md"

    # Validate category exists
    if [[ ! -d "$category_dir" ]]; then
        echo "Error: Category '${category}' does not exist in CTF '${ctf_name}'"
        return 1
    fi

    # Create challenge directory
    mkdir -p "$challenge_dir"

    # Create challenge README
    cat > "$challenge_readme" << EOF
---
layout: default
---
# ${ctf_name} - ${category^} Challenge: ${challenge_name}

## Description

## Solution

## Flag
EOF

    # Update category README to include new challenge
    sed -i "/# ${ctf_name} - ${category^} Challenges/a - [${challenge_name}](${challenge_name}/README.md)" "$category_readme"

    echo "Challenge '${challenge_name}' created in CTF '${ctf_name}' category '${category}' successfully!"
}

# Main script logic
case "$1" in
    "create-ctf")
        create_ctf "$2"
        ;;
    "create-category")
        create_category "$2" "$3"
        ;;
    "create-challenge")
        create_challenge "$2" "$3" "$4"
        ;;
    *)
        echo "Usage:"
        echo "  $0 create-ctf <ctf_name>"
        echo "  $0 create-category <ctf_name> <category>"
        echo "  $0 create-challenge <ctf_name> <category> <challenge_name>"
        exit 1
        ;;
esac
