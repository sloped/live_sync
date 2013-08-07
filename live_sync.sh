#!/bin/bash
ARG1=$1
CWD=$(pwd)

LIVE_SYNC_DIR=$CWD/.live_sync

if [ ! -d $LIVE_SYNC_DIR ]; 
	then
	echo "Live Sync Isn't Setup, run live_sync_setup to setup"
	exit
else
REMOTE_FILE=$LIVE_SYNC_DIR/live_sync_remote
REMOTE=`cat $REMOTE_FILE`
LOCAL_LOCK_FILE=$LIVE_SYNC_DIR/live_sync.lock
GLOBAL_LOCK_FILE=/tmp/live_sync.lock
EXCLUDE_LIST=$LIVE_SYNC_DIR/exclude-list.txt
TRIGGER=$LIVE_SYNC_DIR/watchman_trigger
TRIGGER_DEL=$LIVE_SYNC_DIR/watchman_trigger-del
LOCK_FILE_DEL_CMD='rm $LOCAL_LOCK_FILE'
WATCH_LOCK_FILE=$LIVE_SYNC_DIR/watching

if [ -f $LOCAL_LOCK_FILE ]
	then
	PID=$(cat $PID_FILE)
fi
fi

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
	rsync -rltvz --exclude=".svn" --exclude-from $EXCLUDE_LIST --delete . $REMOTE
	growlnotify -m "$CWD Synced to $REMOTE" -t "Live Sync" -a /Applications/LiveReload.app/
	exit
fi


if [ "$ARG1" == "-s" ];
	then
if [ -f $WATCH_LOCK_FILE ]
then
	cat $TRIGGER_DEL | watchman -j > /dev/null
fi
	rsync -rltvz --exclude=".svn" --exclude-from $EXCLUDE_LIST --delete $REMOTE .
	wait
	growlnotify -m "$REMOTE\
	Synced to\
	$CWD" -t "Live Sync" -a /Applications/LiveReload.app/
if [ -f $WATCH_LOCK_FILE ]
then
	cat $TRIGGER | watchman -j > /dev/null
fi
	exit
fi

if [ "$ARG1" == "-w" ]
	then
	cat $TRIGGER | watchman -j > /dev/null
	touch $WATCH_LOCK_FILE
	growlnotify -m "$CWD Syncing" -a /Applications/LiveReload.app/ -t "Live Sync"
	exit
fi

if [ "$ARG1" == "-x" ]
	then
	cat $TRIGGER_DEL | watchman -j > /dev/null
if [ -f $WATCH_LOCK_FILE ]
then
	rm $WATCH_LOCK_FILE
fi
	growlnotify -m "$CWD Syncing Stopped" -a /Applications/LiveReload.app/ -t "Live Sync"
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

if [ "$ARG1" == "-p" ]
	then
	echo "Syncing To $REMOTE"
	exit
fi

cat << EOF
Live Sync
Syncs directories using rsync
usage: live_sync [-r] [-s] [-l] [-u] [-g] [-k] [-p]

Options: 
     -r     Sync to Remote
     -s     Sync to Local
     -w     Start Watching
     -x     Stop Watching
     -l     Lock Local Directory
     -u     Unlock Local Directory     
     -g     Lock Globally
     -k     Unlock Globally
     -p     Print Remote
EOF

