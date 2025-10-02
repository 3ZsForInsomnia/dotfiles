function gprune() {
    local branches_to_check=()
    local branches_to_delete=()

    _get_merged_pr_branches() {
        gh pr list --state merged --json headRefName --jq '.[].headRefName'
    }

    _filter_existing_local_branches() {
        while read -r branch; do
            if [[ -n "$branch" ]] && git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
                echo "$branch"
            fi
        done
    }

    _display_branches_with_numbers() {
        local i=1
        for branch in "$@"; do
            echo "$i) $branch"
            ((i++))
        done
    }

    _parse_exclusions() {
        local input="$1"
        local exclusions=()
        if [[ -n "$input" ]]; then
            exclusions=(${(s:,:)input})
        fi
        echo "${exclusions[@]}"
    }

    _remove_excluded_branches() {
        local -a all_branches=("$@")
        local exclusions_input
        read "exclusions_input?Enter numbers to exclude (comma-separated, or Enter for none): "

        local -a exclusion_numbers=($(_parse_exclusions "$exclusions_input"))
        local -a filtered_branches=()

        for i in {1..$#all_branches}; do
            if [[ ! " ${exclusion_numbers[@]} " =~ " $i " ]]; then
                filtered_branches+=("$all_branches[$i]")
            fi
        done

        echo "${filtered_branches[@]}"
    }

    # Get all merged PR branches that exist locally
    branches_to_check=($(_get_merged_pr_branches | _filter_existing_local_branches))

    # Filter out main branch
    branches_to_check=(${branches_to_check:#main})

    if [[ ${#branches_to_check} -eq 0 ]]; then
        echo "No local branches found for merged PRs."
        return 0
    fi

    echo "Found ${#branches_to_check} local branch(es) for merged PRs:"
    _display_branches_with_numbers "${branches_to_check[@]}"

    branches_to_delete=($(_remove_excluded_branches "${branches_to_check[@]}"))

    if [[ ${#branches_to_delete} -eq 0 ]]; then
        echo "No branches selected for deletion."
        return 0
    fi

    echo "\nDeleting ${#branches_to_delete} branch(es):"
    printf '%s\n' "${branches_to_delete[@]}"

    for branch in "${branches_to_delete[@]}"; do
        git branch -D "$branch"
    done
}

function gprune_closed() {
    local branches_to_delete=()

    _get_closed_prs_with_local_branches() {
        gh pr list --state closed --json number,title,headRefName --jq '.[] | select(.headRefName != null)' | \
        while IFS= read -r pr_json; do
            local branch=$(echo "$pr_json" | jq -r '.headRefName')
            if [[ -n "$branch" ]] && git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
                echo "$pr_json"
            fi
        done
    }

    _display_closed_prs_with_numbers() {
        local i=1
        while IFS= read -r pr_json; do
            local number=$(echo "$pr_json" | jq -r '.number')
            local title=$(echo "$pr_json" | jq -r '.title')
            local branch=$(echo "$pr_json" | jq -r '.headRefName')
            echo "$i) #$number: $title ($branch)"
            ((i++))
        done
    }

    _parse_selections() {
        local input="$1"
        local selections=()
        if [[ -n "$input" ]]; then
            selections=(${(s:,:)input})
        fi
        echo "${selections[@]}"
    }

    _get_selected_branches() {
        local -a all_prs=("$@")
        local selections_input
        read "selections_input?Enter numbers to DELETE (comma-separated, or Enter for none): "

        local -a selection_numbers=($(_parse_selections "$selections_input"))
        local -a selected_branches=()

        for num in "${selection_numbers[@]}"; do
            if [[ "$num" -ge 1 && "$num" -le ${#all_prs} ]]; then
                local branch=$(echo "${all_prs[$num]}" | jq -r '.headRefName')
                selected_branches+=("$branch")
            fi
        done

        echo "${selected_branches[@]}"
    }
 
    # Get all closed PRs with local branches
    local pr_data
    pr_data=($(_get_closed_prs_with_local_branches))
 
    if [[ ${#pr_data} -eq 0 ]]; then
        echo "No local branches found for closed PRs."
        return 0
    fi
 
    echo "Found ${#pr_data} local branch(es) for closed PRs:"
    printf '%s\n' "${pr_data[@]}" | _display_closed_prs_with_numbers
 
    branches_to_delete=($(_get_selected_branches "${pr_data[@]}"))

    if [[ ${#branches_to_delete} -eq 0 ]]; then
        echo "No branches selected for deletion."
        return 0
    fi

    echo "\nDeleting ${#branches_to_delete} branch(es):"
    printf '%s\n' "${branches_to_delete[@]}"

    for branch in "${branches_to_delete[@]}"; do
        git branch -D "$branch"
    done
}

