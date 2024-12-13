BAR_NAME=i3_bar
BAR_CONFIG=/home/$USER/.config/polybar/config.ini

PRIMARY=$(xrandr --query | grep " connected" | grep "primary" | cut -d" " -f1)
OTHERS=$(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1)

echo "Primary: $PRIMARY"
echo "Others: $OTHERS"

# Launch on others monitor first to ensure this bar can take the system tray
for m in $OTHERS; do
 MONITOR=$m polybar --reload -c $BAR_CONFIG $BAR_NAME &
done
sleep 1

MONITOR=$PRIMARY polybar --reload -c $BAR_CONFIG $BAR_NAME &
