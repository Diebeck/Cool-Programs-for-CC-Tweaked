# CCTweaked Program Stash
A collection of cool programs for the Minecraft mod CC: Tweaked

Most of these are my creation, only a few are made by other people, given credit and catalogued.

Each file is a program, and should be installed using the guide below. (Some files may need to be installed with different names)

## Utility

### Mirror
Credit: Wojbies

Mirrors the screen to an attached monitor.
```
wget https://raw.githubusercontent.com/Diebeck/CCTweaked-Program-Stash/refs/heads/main/Utility/mirror.lua
```

### Simple GPS on Startup
Used for setting up a GPS system that doesnt need to be reset.

Run "edit startup.lua" and set the x, y, z of the computer.
```
wget https://raw.githubusercontent.com/Diebeck/CCTweaked-Program-Stash/refs/heads/main/Utility/simpleGPSonStartup.lua startup.lua
```

### Chatty
*Requires Adv. Peripherals.* Mirrors the in-game chat into the computer.
```
wget https://raw.githubusercontent.com/Diebeck/CCTweaked-Program-Stash/refs/heads/main/Utility/chatty.lua
```

### Term Utils
A package that adds some useful programs for the terminal:
Tree - Graphically displays files inside directories with a tree graph
Find - Finds files with a specific name
Palette - Changes the terminal's palette to a few presets
```
wget run https://raw.githubusercontent.com/Diebeck/CCTweaked-Program-Stash/refs/heads/main/Utility/termUtils/termUtilsInstaller.lua
```

## Communication

### Transmitter
Used with Receiver, transmits commands to a target computer.
```
wget https://raw.githubusercontent.com/Diebeck/CCTweaked-Program-Stash/refs/heads/main/Communication/transmitter.lua transmit.lua
```

### Receiver
Used with Transmitter, receives commands and runs them. Run on startup.
```
wget https://raw.githubusercontent.com/Diebeck/CCTweaked-Program-Stash/refs/heads/main/Communication/receiver.lua startup.lua
```

### AI Installer
Installs AIlink.lua, a program that listens to a pastebin page (https://pastebin.com/XDXyGBBW) and runs any commands on it, so that remote connection is possible. Could be repurposed, but I don't care that much.
```
wget run https://raw.githubusercontent.com/Diebeck/CCTweaked-Program-Stash/refs/heads/main/Communication/AIinstaller.lua
```

## Turtle

### BSTOR
A very versatile program for turtles to explore and interact with the world remotely.
```
wget https://raw.githubusercontent.com/Diebeck/CCTweaked-Program-Stash/refs/heads/main/Turtle/bstor.lua bstor.lua
```

### INVMAN
A very useful program for turtles to manage their inventory and other attached inventories remotely.
```
wget https://raw.githubusercontent.com/Diebeck/CCTweaked-Program-Stash/refs/heads/main/Turtle/invman.lua invman.lua
```

### Holoplayer
Program for pocket computers to broadcast their position at all times. BSTOR makes use of it and displays players near the turtle.
```
wget https://raw.githubusercontent.com/Diebeck/CCTweaked-Program-Stash/refs/heads/main/Turtle/holoplayer.lua
```

### Holoplayer Server
*Requires Adv. Peripherals.* Utilizes a player detector to get everyone's position, displaying them near the turtle. Privacy is a myth.
```
wget https://raw.githubusercontent.com/Diebeck/CCTweaked-Program-Stash/refs/heads/main/Turtle/holoplayerServer.lua
```
