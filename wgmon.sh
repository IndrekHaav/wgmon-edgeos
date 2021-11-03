#!/bin/bash
#
# Author: Indrek Haav
# Source: https://github.com/IndrekHaav/wgmon-edgeos

cmd="/opt/vyatta/bin/vyatta-op-cmd-wrapper"
interface="wg0"

declare -A wg_peers
while read -a peer; do
    pubkey="${peer[5]}"
    name="${peer[7]}"
    wg_peers["$pubkey"]="$name"
done < <($cmd show configuration commands | grep "wireguard $interface peer .* description")

status=$(script -e -q -c "sudo wg show $interface" /dev/null | cat)

for key in "${!wg_peers[@]}"; do
    name="${wg_peers[$key]}"
    status="${status/$key/$name}"
done

echo -e "$status"
