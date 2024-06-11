#!/usr/bin/env bash

# More safety, by turning some bugs into errors.
set -o errexit -o pipefail -o noclobber -o nounset

# ignore errexit with `&& true`
getopt --test >/dev/null && true
if [[ $? -ne 4 ]]; then
	echo 'I’m sorry, `getopt --test` failed in this environment.'
	exit 1
fi

VERSION="xxx"

# options
LONGOPTS="help,quiet,version"
OPTIONS="hq"

# parse options
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@") || exit 2
eval set -- "$PARSED"

opt_quiet=false

# now enjoy the options in order and nicely split until we see --
while true; do
	case "$1" in

	# print help
	-h | --help)
		echo "Backup the system."
		echo ""
		echo "Usage:"
		echo "  vbackup [OPTION]"
		echo ""
		echo "Options:"
		echo "  -h, --help   Print usage"
		echo "  -q, --quiet  Be quiet"
		echo "  --version    Print version"
		exit 0
		;;

	-q | --quiet)
		opt_quiet=true
		shift
		;;

	# print version
	--version)
		echo "$VERSION"
		exit 0
		;;

	--)
		shift
		break
		;;

	*)
		echo "Programming error"
		exit 3
		;;

	esac
done

# print version
if [ "$opt_version" = true ]; then
	exit 0
fi

echo fin
exit 1

echo $opt_quiet
echo $opt_version

exit 0

x="${XDG_CONFIG_DIRS:-/etc/}"

# handle non-option arguments
if [[ $# -ne 1 ]]; then
	echo "$0: A single input file is required."
	exit 4
fi

echo "verbose: $v, force: $f, debug: $d, in: $1, out: $outFile"

echo $x

IFS=":"
for d in $CONFIG_DIRS; do
	echo $d
done
IFS=" "

exit 0

REPO="sftp:root@rousset.duckdns.org:/mnt/rousset/backups/$(hostname)"
EXCLUDE_FILE="/etc/backup/exclude"

if [ $EUID -ne 0 ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

restic --one-file-system --repo="$REPO" --exclude-caches --exclude-file="$EXCLUDE_FILE" backup / --verbose
