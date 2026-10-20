# Bundle Info

A **Don't Starve Together** mod that shows what's inside a bundle when you hover over it, without having to unwrap it.

## What it does

When you point the mouse at a `bundle` (the already-wrapped package), the hover text shows the name plus every item inside along with its quantity:

```
Bundle
5 x Rocks
1 x Twigs
1 x Berries
1 x Cut Grass
```

- Works with freshly wrapped bundles and with bundles loaded from a saved game.
- Supports 1 to 4 items, which is the maximum a bundle can hold.
- Items that aren't stacks are shown with quantity 1.

## Installation

1. Copy the mod folder (`bundle-info`) into the game's `mods` folder.
2. Open Don't Starve Together and enable **Bundle info** from the world's mods menu.

## How it works

Wrapped items are stored in the `unwrappable` component (the `itemdata` field), and components only exist on the server. Since the hover text is built on the client, the mod splits the work.
```

- **Server:** when the bundle is created (or loaded from a saved game), it reads `itemdata`, converts it into a `name:quantity` text (one line per item) and writes it into a `net_string`.
- **Client:** the game syncs that variable automatically. The bundle's `displaynamefn` reads it, converts it back into a table and builds the hover text.
- The quantity comes from `data.stackable.stack` in each item's record. If that field doesn't exist, the quantity is 1.

## Structure

       File        |       Description                 
       ---         |           ---                     
   `modinfo.lua`   |       Mod metadata                
   `modmain.lua`   |       All of the mod's logic      

## Known limitations

- Tested in a local game (single player). Not tested on dedicated servers or with multiple players.
- Item names come from the game (`STRINGS.NAMES`). If an item from another mod has no registered name, its internal prefab name is shown instead.