{ pkgs, coreutils, ddcutil }:
pkgs.writeShellScript "brightness-ddc" ''
  set -euo pipefail
  [[ -z "$I2CBUS" ]] && exit 1
  handle() {
    local raw=$(${ddcutil}/bin/ddcutil --terse --bus "$I2CBUS" getvcp 10)
    local value=$(${coreutils}/bin/cut -d' ' -f 4 <<<"$raw")
    local max=$(${coreutils}/bin/cut -d' ' -f 5 <<<"$raw")
    case "$1" in
      up)
        value=$((value + 10))
        [[ $value -gt $max ]] && value=$max
        ;;
      down)
        value=$((value - 10))
        [[ $value -lt 0 ]] && value=0
        ;;
    esac
    echo "$((100 * value / max))"
    ${ddcutil}/bin/ddcutil --bus "$I2CBUS" setvcp 10 "$value"
  }
  trap 'handle down' USR1
  trap 'handle up' USR2
  raw=$(${ddcutil}/bin/ddcutil --terse --bus "$I2CBUS" getvcp 10)
  value=$(${coreutils}/bin/cut -d' ' -f 4 <<<"$raw")
  max=$(${coreutils}/bin/cut -d' ' -f 5 <<<"$raw")
  echo "$((100 * value / max))"
  while true; do read -r; done
''
