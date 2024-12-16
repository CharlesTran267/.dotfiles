#!/bin/bash

# get socket path
socket_path="/run/user/1000/i3/$(ls -t /run/user/1000/i3/ | awk '{print $1}' | grep ipc | head -n 1)"

# Get list of workspaces
WORKSPACES=$(i3-msg --socket $socket_path -t get_workspaces | jq -r '.[] | .name')

# Get focused workspace
FOCUSED_WORKSPACE=$(i3-msg --socket $socket_path -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')

# Get list of visible workspaces
VISIBLE_WORKSPACES=$(i3-msg --socket $socket_path -t get_workspaces | jq -r '.[] | select(.visible==true) | .name')

for workspace in $WORKSPACES; do
    echo "Moving workspace $workspace to output right"
    i3-msg --socket $socket_path [workspace=$workspace] move workspace to output right
done

# Focus on the workspace that was visible but not focused before first. This is to ensure all previously-visible are still visible and previously-focused are still focused
for workspace in $VISIBLE_WORKSPACES; do
    if [ "$workspace" != "$FOCUSED_WORKSPACE" ]; then
        echo "Focusing workspace $workspace"
        i3-msg --socket $socket_path [workspace=$workspace] focus
        break
    fi
done

# Focus on the workspace that was focused before
echo "Focusing workspace $FOCUSED_WORKSPACE"
i3-msg --socket $socket_path [workspace=$FOCUSED_WORKSPACE] focus
