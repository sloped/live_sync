# Live Sync

Scripts to make workly remotely with Live Reload a joy. (Or at least simple)

## Instructions

Clone this repository. 

```
git clone git://github.com/sloped/live_sync.git
```


In live_sync.sh update `LIVE_SYNC_DIRECTORY` to the newly cloned directory. 

In my setup I have a directory called bin in my home directory that is included in my Path. Copy live_sync.sh and setup_live_sync to a directory included in your path. 

```
cp live_sync.sh /home/User/bin/live_sync
cp setup_live_sync /home/User/bin/setup_live_sync
```
Inside a directory you want to sync with the server, run `setup_live_sync`

setup_live_sync ssh:/path/to/remote/directory/
````
Be sure to include the final slash, otherwise bad things can happen. Also, check the file .live_sync/exclude-list.txt to verify it matches what your project looks like. 

If this is a brand new directory on the server with no files you can skip the next step. 

cd to the directory you wish to work in. 

```
live_sync -s
```

This will copy all the files from the server to your local machine. 

In Live Reload. Create a new location at the directory you created and run setup_live_sync in. Click Options next to Run a custom command after proecessing changes. 

In the box type the command `live_sync -r` 

This will run every time you change a file, sending all local changes to the server. 

Be sure to run `live_sync -s` inside of the folder if you change things on the server, otherwise you will overwrite those changes with the local files. 


## License

MIT licensed

Copyright (C) 2013 Conner McCall http://connermccall.com