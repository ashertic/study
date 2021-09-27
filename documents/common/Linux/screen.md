## Step 1
Run the `screen` command to start a new "screen". Optionally, include the -S option to give it a name.
```
$ screen -S myCommand
```

## Step 2
In the new screen session, execute the command or script you wish to put in the background.
```
$ /path/to/myScript.sh
```

## Step 3
Press `Ctrl + A` on your keyboard, and then `D`. This will detach the screen, then you can close the terminal, logout of your SSH session, etc, and the screen will persist. To see a list of screens, use this command.

```
$ screen -ls
There is a screen on:
	2741.myCommand	(04/08/2021 01:13:24 PM)	(Detached)
1 Socket in /run/screen/S-linuxconfig.
```

## Step 4
To reattach to a screen, use the following command, substituting the number below with the process ID of your own.
```
$ screen -r 2741
```