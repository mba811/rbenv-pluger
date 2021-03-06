#!/usr/bin/env bash
set -e

which add-apt-repository &>/dev/null ||{
  sudo apt-get -y update
  #easily add repo to apt eg. add-apt-repository ppa:nginx/stable
  #Ubuntu Quantal and above (>= 12.10) — sudo apt-get install software-properties-common
  #Earlier Ubuntu versions (< 12.10) — sudo apt-get install python-software-properties
  sudo apt-get -y install python-software-properties
}

which rethinkdb &>/dev/null || {
  sudo add-apt-repository ppa:rethinkdb/ppa
  sudo apt-get -y update
  sudo apt-get -y install rethinkdb
}
echo ==finished!
