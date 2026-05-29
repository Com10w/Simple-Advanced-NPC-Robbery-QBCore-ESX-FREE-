#  Advanced NPC Robbery (QBCore & ESX)

A highly optimized, immersive, and fully configurable NPC Robbery script for FiveM. This script allows players to hold up NPCs at gunpoint, forcing them to surrender and hand over their cash and valuables. Built from the ground up to support both **QBCore** and **ESX** frameworks seamlessly.

## Key Features

* **Multi-Framework Support:** Works flawlessly out of the box with both QBCore and ESX. Just change one line in the config!
* **Weapon Whitelist:** Players can only rob NPCs if they are aiming with a configured weapon (e.g., knives, pistols, rifles). Fully customizable weapon list.
* **Immersive Animations:** NPCs will put their hands up in fear when aimed at and will flee the scene after the robbery is completed (or canceled).
* **Dynamic Loot System:** Gives a randomized amount of cash based on your config, plus a configurable % chance to drop a rare item (like a stolen phone).
* **Integrated Dispatch:** Built-in support for popular dispatch scripts (`ps-dispatch`, `qb-dispatch`, `cd_dispatch`, and standard police alerts).
* **Exploit & Spam Protected:** Includes cooldowns, distance checks, and server-side verification to prevent macro spamming and cheating.
* **Highly Optimized:** Runs at `0.00ms` on idle.

## Requirements

* [QBCore Framework](https://github.com/qbcore-framework/qb-core) **OR** [ESX Framework](https://github.com/esx-framework/esx_core)
* Target script is **NOT** required. This script uses an interactive 3D text and aiming detection system.

## Installation

1. Download the script and extract the folder.
2. Rename the folder to `custom-npc-robbery` (or whatever you prefer, just make sure to match the server.cfg).
3. Drag and drop the folder into your server's `resources` directory.
4. Open `config.lua` and set your framework and adjust the economy/weapons to your liking:
   ```lua
   Config.Framework = 'qb' -- Change to 'esx' if you are using ESX Legacy