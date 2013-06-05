#!/bin/bash
ARG1=$1
REMOTE=`cat .live_sync_remote`
CWD=$(pwd)
LOCAL_LOCK_FILE=$CWD/.live_sync.lock
GLOBAL_LOCK_FILE=/Users/conner/Clockwork/live_sync/live_sync.lock

if [ "$ARG1" == "-r" ];
	then
if [ -f $LOCAL_LOCK_FILE ]
then
	growlnotify -m "$CWD Locked, Cannot Sync To $REMOTE" -t "Live Sync" -a /Applications/LiveReload.app/
	exit
fi
if [ -f $GLOBAL_LOCK_FILE ]
then
	growlnotify -m "Live Sync Locked, Cannot Sync to Remotes" -t "Live Sync" -a /Applications/LiveReload.app/
	exit
fi
	rsync -rltvz --exclude=".svn" --exclude-from 'exclude-list.txt' --delete . $REMOTE
	growlnotify -m "$CWD Synced to $REMOTE" -t "Live Sync" -a /Applications/LiveReload.app/
	exit
fi


if [ "$ARG1" == "-s" ];
	then
	rsync -rltvz --exclude=".svn" --exclude-from 'exclude-list.txt' --delete $REMOTE .
	growlnotify -m "$REMOTE\
	Synced to\
	$CWD" -t "Live Sync" -a /Applications/LiveReload.app/
	exit
fi
if [ "$ARG1" == "-l" ]
	then
	touch $LOCAL_LOCK_FILE
	growlnotify -m "$CWD Locked" -a /Applications/LiveReload.app/ -t "Live Sync"
	exit
fi
if [ "$ARG1" == "-u" ]
	then
	rm $LOCAL_LOCK_FILE
	growlnotify -m "$CWD Unlocked" -a /Applications/LiveReload.app/ -t "Live Sync"
	exit
fi
if [ "$ARG1" == "-g" ]
	then
	touch $GLOBAL_LOCK_FILE
	growlnotify -m "Globally Locked" -a /Applications/LiveReload.app/ -t "Live Sync"
	exit
fi
if [ "$ARG1" == "-k" ]
	then
	rm $GLOBAL_LOCK_FILE
	growlnotify -m "Globally Unlocked" -a /Applications/LiveReload.app/ -t "Live Sync"
	exit
fi

cat << EOF
Live Sync
Syncs directories using rsync
usage: live_sync [-r] [-s] [-l] [-u] [-g] [-k]

Options: 
     -r     Sync to Remote
     -s     Sync to Local
     -l     Lock Local Directory
     -u     Unlock Local Directory     
     -g     Lock Globally
     -k     Unlock Globally
EOF

