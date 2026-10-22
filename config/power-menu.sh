#!/usr/bin/env bash
set -eu

# Tokyo Night-compatible Rofi power menu for Sway.
# Destructive actions require a second confirmation.

rofi_cmd=(rofi -dmenu -i -p "Power")
choice="$(
  printf '%s\n' \
    '󰌾  Lock' \
    '󰤄  Suspend' \
    '󰍃  Log out' \
    '󰜉  Reboot…' \
    '󰐥  Shut down…' \
    '󰗼  Cancel' |
    "${rofi_cmd[@]}"
)" || exit 0

confirm() {
  local action="$1"
  local answer
  answer="$(
    printf 'Cancel\n%s\n' "$action" |
      rofi -dmenu -i -p "Confirm $action?"
  )" || return 1
  [[ "$answer" == "$action" ]]
}

case "$choice" in
  '󰌾  Lock')
    swaylock
    ;;
  '󰤄  Suspend')
    systemctl suspend
    ;;
  '󰍃  Log out')
    if confirm "Log out"; then
      swaymsg exit
    fi
    ;;
  '󰜉  Reboot…')
    if confirm "Reboot"; then
      systemctl reboot
    fi
    ;;
  '󰐥  Shut down…')
    if confirm "Shut down"; then
      systemctl poweroff
    fi
    ;;
  *)
    exit 0
    ;;
esac
