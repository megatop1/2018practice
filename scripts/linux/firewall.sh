#!/bin/bash

#
# Automated iptables firewall setup based on port file.
#

usage()
{
    echo "$(basename "$0") [-h] [-e] [-f] [-i] [file]

    where:
        -h   show this help text
        -e   apply rules as egress
        -f   fully flush rules before applying
        -i   apply rules as ingress [default]
        file list of allowed ports seperated by newline. Format [port] [protocol]"
        exit 1
}

setup_egress()
{
    arr=$@
    port=${arr[0]}
    protocol=${arr[1]}

    echo "Adding egress iptables rule for port $port on protocol $protocol"
    iptables -A OUTPUT -p $protocol --dport $port -j ACCEPT
}

setup_ingress()
{
    arr=$@
    port=${arr[0]}
    protocol=${arr[1]}

    echo "Adding ingress iptables rule for port $port on protocol $protocol"
    iptables -A INPUT -p $protocol --dport $port -j ACCEPT
}

if [[ $# == 0 ]]; then
    usage
fi

INGRESS=true
FLUSH_TABLES=false

while getopts ':hefi' option; do
    case "$option" in
        h) usage
            ;;
        e) INGRESS=false
            ;;
        f) FLUSH_TABLES=true
            ;;
        i) INGRESS=true
            ;;
        \?) printf "illegal option: -%s\n" "$OPTARG" >&2
            usage
            ;;
        *) usage
            ;;
    esac
done
shift $((OPTIND - 1))

PORT_FILE=$1
if [[ ! -z $PORT_FILE && ! -f $PORT_FILE ]]; then
    echo "File specified is invalid!"
    exit 1
fi

if [[ $EUID != 0 ]]; then
    echo "This script must be run as root!"
    exit 1
fi

if [[ $FLUSH_TABLES == true ]]; then
    echo "Flushing iptables..."
    iptables -F

    if [[ $INGRESS == false ]]; then
        iptables -A INPUT -i lo -j ACCEPT
    else
        iptables -A OUTPUT -o lo -j ACCEPT
    fi
fi

echo "Setting up loopback rules..."
if [[ $INGRESS == true ]]; then
    iptables -F INPUT
    iptables -A INPUT -i lo -j ACCEPT
else
    iptables -F OUTPUT
    iptables -A OUTPUT -o lo -j ACCEPT
fi

if [[ ! -z $PORT_FILE ]]; then
    while read line; do
        arr=($line)
        if [[ $INGRESS == true ]]; then
            setup_ingress $arr
        else
            setup_egress $arr
        fi
    done <$PORT_FILE
fi

echo "Adding remaining rules (block and accept established)..."
if [[ $INGRESS == true ]]; then
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p icmp -j ACCEPT
    iptables -A INPUT -j DROP
else
    iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p icmp -j ACCEPT
    iptables -A OUTPUT -j DROP
fi
