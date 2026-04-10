#!/usr/bin/env bash

BOARD_ID=1228
PROJECT="CRAI"
CACHE_FILE="/tmp/sketchybar_sprint_cache"
CACHE_MAX_AGE=300  # 5 minutes

check_auth() {
    acli auth status 2>&1 | grep -q "Following apps are not authenticated.*Jira"
    if [ $? -eq 0 ]; then
        return 1
    fi
    return 0
}

fetch_sprint_data() {
    if ! check_auth; then
        echo "AUTH_NEEDED"
        return
    fi

    sprint_json=$(acli jira board list-sprints --id $BOARD_ID --state active --json 2>/dev/null)
    
    if [ -z "$sprint_json" ] || echo "$sprint_json" | grep -q "Error"; then
        echo "FETCH_FAILED"
        return
    fi

    sprint_id=$(echo "$sprint_json" | jq -r '.sprints[0].id // empty')
    sprint_name=$(echo "$sprint_json" | jq -r '.sprints[0].name // empty')
    
    if [ -z "$sprint_id" ]; then
        echo "NO_SPRINT"
        return
    fi

    issues_json=$(acli jira sprint list-workitems --board $BOARD_ID --sprint $sprint_id --json --paginate 2>/dev/null)
    
    if [ -z "$issues_json" ]; then
        echo "FETCH_FAILED"
        return
    fi

    issue_keys=$(echo "$issues_json" | jq -r '.issues[].key' | sort -u)
    
    total_sp=0
    done_sp=0
    
    for key in $issue_keys; do
        issue_data=$(acli jira workitem view "$key" --fields "status,customfield_11114" --json 2>/dev/null)
        
        sp=$(echo "$issue_data" | jq -r '.fields.customfield_11114 // 0')
        status_category=$(echo "$issue_data" | jq -r '.fields.status.statusCategory.key // "unknown"')
        
        if [ "$sp" != "null" ] && [ "$sp" != "0" ]; then
            total_sp=$((total_sp + sp))
            
            if [ "$status_category" = "done" ]; then
                done_sp=$((done_sp + sp))
            fi
        fi
    done
    
    short_name=$(echo "$sprint_name" | sed 's/FY[0-9]*Q[0-9]*-//' | sed 's/-/ /')
    
    echo "$short_name|$done_sp|$total_sp"
}

update_cache_background() {
    (
        result=$(fetch_sprint_data)
        echo "$result" > "$CACHE_FILE"
    ) &
}

get_sprint_burndown() {
    # Check if cache exists and is fresh
    if [ -f "$CACHE_FILE" ]; then
        cache_age=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)))
        cached_data=$(cat "$CACHE_FILE")
        
        if [ $cache_age -gt $CACHE_MAX_AGE ]; then
            # Cache is stale, refresh in background
            update_cache_background
        fi
        
        # Use cached data
        case "$cached_data" in
            AUTH_NEEDED)
                sketchybar --set $NAME label="🔐 acli jira auth login"
                ;;
            FETCH_FAILED)
                sketchybar --set $NAME label="⚠️ Jira error"
                update_cache_background
                ;;
            NO_SPRINT)
                sketchybar --set $NAME label="📊 No active sprint"
                ;;
            *)
                IFS='|' read -r sprint_name done_sp total_sp <<< "$cached_data"
                if [ -n "$sprint_name" ] && [ -n "$total_sp" ]; then
                    sketchybar --set $NAME label="📊 $sprint_name: $done_sp/$total_sp SP"
                else
                    sketchybar --set $NAME label="📊 Loading..."
                    update_cache_background
                fi
                ;;
        esac
    else
        # No cache, fetch and display loading
        sketchybar --set $NAME label="📊 Loading..."
        update_cache_background
    fi
}

get_sprint_burndown
