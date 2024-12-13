#!/bin/bash

# Get the list of connected monitors
MONITORS=($(i3-msg -t get_outputs | jq -r '.[] | select(.active) | .name'))

if [ ${#MONITORS[@]} -ne 2 ]; then
    echo "Error: This script only works with exactly two monitors connected."
    exit 1
fi

# Get workspaces for each monitor
WORKSPACES_MON1=($(i3-msg -t get_workspaces | jq -r ".[] | select(.output == \"${MONITORS[0]}\") | .name"))
WORKSPACES_MON2=($(i3-msg -t get_workspaces | jq -r ".[] | select(.output == \"${MONITORS[1]}\") | .name"))

# Swap workspaces from Monitor 1 to Monitor 2
for WORKSPACE in "${WORKSPACES_MON1[@]}"; do
    i3-msg workspace "$WORKSPACE"
    i3-msg move workspace to output "${MONITORS[1]}"
done

# Swap workspaces from Monitor 2 to Monitor 1
for WORKSPACE in "${WORKSPACES_MON2[@]}"; do
    i3-msg workspace "$WORKSPACE"
    i3-msg move workspace to output "${MONITORS[0]}"
done

# Refocus the first workspace on Monitor 1 (optional)
if [ "${#WORKSPACES_MON1[@]}" -gt 0 ]; then
    i3-msg workspace "${WORKSPACES_MON1[0]}"
elif [ "${#WORKSPACES_MON2[@]}" -gt 0 ]; then
    i3-msg workspace "${WORKSPACES_MON2[0]}"
fi

echo "All workspaces swapped between ${MONITORS[0]} and ${MONITORS[1]}."
