#!/bin/bash
mc=/etc/portage/make.conf
[ ! -e $mc ] && echo "Cannot find $mc, are you sure you're running Gentoo?" && exit 1
. $mc
od=$PORTDIR_OVERLAY
[ -z "$PORTDIR_OVERLAY" ] && echo PORTDIR_OVERLAY not specified in $mc && exit 1
[ "$(echo $PORTDIR_OVERLAY | wc -w)" -gt 1 ] && echo "Sorry I can't handle more than one overlay path, please follow instructions in README" && exit 1
[ ! -e $PORTDIR_OVERLAY ] && echo Cannot find PORTDIR_OVERLAY directory $PORTDIR_OVERLAY && exit 1
[ ! -d media-sound ] && "Cannot find media-sound directory" && exit 1
cp -r media-sound $PORTDIR_OVERLAY/
result=$?
[ $result -gt 1 ] && echo Error copying media-sound directory to $PORTDIR_OVERLAY, aborting && exit 1
for eb in /usr/local/portage/media-sound/logitechmediaserver-bin/lo*; do
  ebuild $eb digest
  result=$?
  if [ $result -gt 0 ]; then
    echo Something went wrong with ebuild $eb, consult error messages above
    exit 2
    fi
  done
ak="media-sound/logitechmediaserver-bin ~x86"
akf=/etc/portage/package.keywords
if [ -d $akf ]; then
  akf=$akf/logitechmediaserver
elif [ ! -f $akf ]; then
  echo "No idea what's going on, $akf isn't a directory or file, skipping for safety. Please consult README"
  exit 1
  fi

[ ! -f $akf ] && touch $akf
if [ -z "$(grep "$ak" "$akf")" ]; then
  echo Adding \'$ak\' to $akf
  echo "$ak" >> $akf
  result=$?
  [ $result -gt 0 ] && echo Something went wrong with keyword addition, aborting && exit 1
  fi
echo "All seems well, updated files are in local overlay."
echo "execute 'emerge -aDvt logitechmediaserver-bin' to install or apply updates"
exit 0


