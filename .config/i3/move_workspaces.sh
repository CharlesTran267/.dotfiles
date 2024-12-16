#!/bin/bash

# get socket path
socket_path="/run/user/1000/i3/$(ls -t /run/user/1000/i3/ | awk '{print $1}' | grep ipc | head -n 1)"

# Get list of workspaces
WORKSPACES=$(i3-msg --socket $socket_path -t get_workspaces | jq -r '.[] | .name')

# Get list of visible workspaces
VISIBLE_WORKSPACES=$(i3-msg --socket $socket_path -t get_workspaces | jq -r '.[] | select(.visible==true) | .name')

# Get focused monitor
FOCUSED_MONITOR=$(i3-msg --socket $socket_path -t get_workspaces | jq -r '.[] | select(.focused==true) | .output')

for workspace in $WORKSPACES; do
    echo "Moving workspace $workspace to output right"
    i3-msg --socket $socket_path [workspace=$workspace] move workspace to output right
done

# Focus on the workspace that was visible to ensure all previously-visible are still visible.
for workspace in $VISIBLE_WORKSPACES; do
    echo "Focusing workspace $workspace"
    i3-msg --socket $socket_path [workspace=$workspace] focus
done

# Focus on the Monitor that was focused
NEW_FOCUSED_WORKSPACE=$(i3-msg --socket $socket_path -t get_workspaces | jq -r '.[] | select(.output=="'$FOCUSED_MONITOR'") | select(.visible==true) | .name')

echo "Focusing workspace $NEW_FOCUSED_WORKSPACE"
i3-msg --socket $socket_path [workspace=$NEW_FOCUSED_WORKSPACE] focus
