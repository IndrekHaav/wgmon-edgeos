[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/IndrekHaav/wgmon-edgeos/lint.yml?branch=main)](https://github.com/IndrekHaav/wgmon-edgeos/actions/workflows/lint.yml) [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/IndrekHaav/wgmon-edgeos/link-check.yml?branch=main&label=link-check)](https://github.com/IndrekHaav/wgmon-edgeos/actions/workflows/link-check.yml)

# WireGuard monitor for EdgeOS

This is a simple helper script for monitoring [WireGuard](https://www.wireguard.com/) peers on [Ubiquiti EdgeRouter](https://www.ui.com/edgemax/comparison/) devices.

## Background

I wrote the script to solve the small yet annoying problem that WireGuard by itself has no concept of named peers and displays only their public keys. On an EdgeRouter, however, peer names can be added to the router's configuration:

```
# set interfaces wireguard wg0 peer <public_key_here> description <peer_name>
```

Except those names aren't actually visible to WireGuard itself.

What this script does, in a nutshell, is:
 - grab the names of each peer from EdgeOS configuration
 - run `wg show` and capture the output (colours and everything)
 - replace each peer's public key with its name
 - finally echo the modified output

So not a lot, sure, but then the output of `wg show` is already pretty informative.

## Requirements

 1. An EdgeRouter, obviously.<sup>1</sup> The script has been tested on an ER-4 and ER-Lite with v2 firmware.
 2. WireGuard installed and configured. If not, go [here](https://github.com/WireGuard/wireguard-vyatta-ubnt) to get started.

<small><sup>1)</sup> The script might also work on [VyOS](https://vyos.io/) (since [it and EdgeOS are related](https://blog.vyos.io/versions-mystery-revealed)), but it won't run on just any Linux system; for that, try [wgg.sh](https://github.com/FlyveHest/wg-friendly-peer-names/).</small>

## Usage

Download the script to your router and make it executable:

```shell
$ curl -OL https://raw.githubusercontent.com/IndrekHaav/wgmon-edgeos/main/wgmon.sh
$ chmod +x wgmon.sh
```

Then just run `./wgmon.sh` to see the output from `wg show` except with peer names instead of public keys:

![Screenshot](https://raw.githubusercontent.com/IndrekHaav/wgmon-edgeos/main/screenshot.png)

> **Note:** The script currently assumes that the WireGuard interface is `wg0`. If yours is different, then change it in the script. I might improve the script in the future to take the interface name as a command line argument.

## Advanced usage

You can keep the script running with `watch`:

```shell
$ watch -n 1 -t -c ~/wgmon.sh
```

Even better, add a bash alias to `~/.bashrc`:

```
alias wgmon="watch -n 1 -t -c ~/wgmon.sh"
```

Then `source .bashrc` (or log out and back in) to make it available, and you can simply run `wgmon` to see a constantly updating overview of your WireGuard peers with friendly names!

> **Note:** These steps have to be repeated after upgrading your EdgeRouter's firmware.
