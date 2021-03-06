#!/usr/bin/env bash 
set -e
version=${1:-help}
case "$version" in
  -h|--help|help)
    echo "Usage: [PREFIX=/opt/redis] [FORCE=1] $0 versions|latest|<a_version>|help"
    exit 1
    ;;
  versions|-l|--list)
    curl http://code.google.com/p/redis/downloads/list|grep --color=always a\ href=\"detail\?name=redis-
    exit 
    ;;
  latest|new)
    version_url=http://download.redis.io/redis-stable/src/version.h 
    version=$(curl $version_url)
    version=$(eval echo ${version##* })
    #http://download.redis.io/redis-stable.tar.gz or http://download.redis.io/releases/redis-2.8.4.tar.gz
    url=http://download.redis.io/releases/redis-$version.tar.gz
    ;;
  *)
    #old releases: http://code.google.com/p/redis/downloads/list
    url=http://redis.googlecode.com/files/redis-$version.tar.gz
    ;;
esac

root=${PREFIX:-/opt/redis}
[ -d $root ]||{ sudo mkdir -p $root && sudo chown -R $USER:$USER $root;}
cd $root && echo root: $root

[ -d redis-$version ] && [ -z "$FORCE" ] && echo Warn: found $root/redis-$version && exit 0 
[ -e redis-$version.tar.gz ]||{
  wget $url 
  tar xzf redis-$version.tar.gz
}
cd redis-$version
make V=1
PREFIX=$root/redis-$version make install
rm src/*.o

link=/usr/local/bin/redis-$version-cli
target_cli=$root/redis-$version/bin/redis-cli
if [ -e $link -a -z "$FORCE" ];then
  echo Warn: found an existed link $link
else
  echo "Make a handy link: $link -->$target_cli "
  sudo ln -sb $target_cli $link
fi

cat <<-Doc
==Have installed into path: $root/redis-$version
If on server, run below to configure init:

  run redis-init.bash script or direct ( cd $root/redis-$version/utils && sudo ./install_server.sh )

  Note: 
  
  * if run: make test, remember rm tests/tmp

==Ok, try it by run: $root/redis-$version/bin/redis-cli
Doc
