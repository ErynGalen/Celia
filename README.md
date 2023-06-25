> **Note**
> This branch (`merge-all-features`) is used to gather the features brought by all the branches of this repo.
> Its history isn't clean because many branches are going to be merged several times with it.
>
> The `master` branch isn't used for this purpose, in order to keep it clean and coherent with upstream.

Celia
--------

A PICO-8 TAS framework based on [picolove](https://github.com/picolove/picolove)

Requires LÖVE 11.4 (LÖVE 11.x experimentally supported)

What is PICO-8:

 * See http://www.lexaloffle.com/pico-8.php

What is LÖVE:

 * See https://love2d.org/

# What Celia is:

Celia has 3 uses:

 * A general TAS tool for tasing any PICO-8 cart
 * A framework for developing designated TAS tools PICO-8 games
 * A fully fledged TAS tool for [celeste](https://www.lexaloffle.com/bbs/?tid=2145) and mods.

# Limitations and caveats

* Celia is based on [this](https://github.com/gonengazit/picolove) fork of picolove. Carts not supported by it will not work. in particular, some more advanced/newer PICO-8 features might not be avaliable (though it does have many features not present in other picolove forks, such as support for \_ENV and bitwise ops).
* Due to the last point, Celia uses floats instead of 16.16 Fixed point numbers, which may cause some differences from PICO-8
* No support for seeding reproducing randomness deterministically (yet)
* No support for coroutines, as they cannot be serialized in standard lua, as far as I know
* The spritesheet and music/sfx data are not serialized as part of the state, and will not rewind correctly.
* Right now Celia is a bit of a memory hog, consuming ~0.5MB per frame (depending on the cart). A more "traditional" savestate-based TAS tool could be created to address this issue

# Usage

this is the usage for the general PICO-8 TAS tool. For usage specific to the cctas (celeste) Tas tool, see [here](/cctas.md) (but make sure to read this file as well)

clone the repository, and place the cart that you want to run in the `carts` folder, then run

`<path to your love executable> . cartname.p8` from a terminal/command line in the project root directory

In the center of the screen, you'll see the PICO-8 screen, displaying the current frame
On the left, you'll see the HUD, displaying the current frame number, and an input display, with the currently pressed inputs
On the right, you'll see the pianoroll, which shows the inputs in the frames around the current one

## Controls
* __L__ - advance 1 frame forward
* __K__ - rewind 1 frame back
* __Left__, __Right__, __Up__, __Down__, __Z__/__C__, __X__ (controller buttons)- toggle the respective button for the current frame
* __Shift__ + __controller button__ - toggle hold of the respective button. held buttons will be pressed when advancing/rewinding to a frame
* __D__ - preform a full-rewind, return to frame 0
* __P__ - start realtime playback. The TAS will play back in real time, and inputs can't be modified. any keypress during realtime playback will stop it.
* __Shift + R__ - reset, clear the inputs, and rewind to frame 0
* __M__ - save the current inputs to a file <cartname>.lua, in the games data folder (By default, on windows this is %appdata%/love/Celia, and on linux ~/.local/share/love/Celia). The filepath will be outputted to the terminal.
* __Shift + W__ - Load the input file from the data folder
* __Insert__ - Insert a blank input frame before the current frame (This respects held keys)
* __Ctrl + Insert__ - Duplicate the current input frame
* __Delete__ - Delete the current input frame
* __Ctrl + V__ - paste inputs from the clipboard before the current frame
* __Ctrl + Z__ - perform undo. pretty much any operation that changes the inputs can be undone. max undo depth is 30
* __Ctrl + Shift + Z__ perform redo.
* __Shift__ + __L__ - enable visual selection mode
* __Ctrl + T__ - toggle console
* __F3__ - begin gif recording
* __F4__ - stop gif recording
* __F6__ - take screenshot
* __Ctrl + R__ - reload cart and tas tool (Warning: this cannot be undone!)
* __F11__ - hide/show the input overlay (both in the TAS tool and the GIF recordings)
* __H__ - toggle hitboxes. When the cart defines `objects`, each of the objects having a `hitbox` field will have a green outline showing its hitbox.


#### Second player inputs
You can use the inputs of the second player as follow:
* __Semicolon__, __Comma__, __Period__, __Slash__ ('__;__' , '__,__' , '__.__' , '__/__') - correspond respectively to __E__, __S__, __D__, __F__ in Pico 8 (directionnal keys)
* __\[__ , __\]__ , __\\__ - also available for __S__, __D__, __F__
* __1__, __Q__ - equivalent of __X__ for the first player (also correspond to __A__ in Pico 8)
* __Tab__, __W__ - equivalent of __C__/__Z__ for the first player (also correspond to __LeftShift__ in Pico 8)

To toggle the display of an input in the piano roll, you can press __Ctrl + Shift + \<input binding\>__. However __Ctrl + Shift + W__ and __Ctrl + Shift + Q__ aren't available.
If any of the input of the second player is displayed in the piano roll, a second input display will be shown under the first one on the left hand side of the screen, showing the inputs for the second player.

### Mouse input
* __Ctrl + Shift + Space__ - enables or disables the mouse. If the cart calls `poke(0x5f2d, 1)` in its `_init()` or at top level to request the mouse, the tastool starts with the mouse already enabled.

> **Warning**
> The mouse inputs are only saved when the mouse is enabled in the cart by calling `poke(0x5f2d, 1)`.

The mouse input display indicates:
* "__x: ..., y: ...__" - the mouse position for the current frame. This line turns red when __Space__ is pressed. See below for more informations.
* "__(..., ...)__" - the position of your mouse
* "__btns: ...__" - the state of the mouse buttons for the current frame. This field is a bitmask, where the left mouse button is 1, the right mouse button is 2, and the middle mouse button is 4. (i.e. if more than one button is pressed the sum is displayed)

The same informations are shown in the Pico 8 screen by 2 indicators, at the mouse position for the current frame and at the position of your mouse:
* A red cross indicates the mouse position for the current frame
* A red dot indicates the position of your mouse
* Pink rectangles are drawn next to these, representing the mouse buttons

The state of the buttons for the current frame can be modified as any regular controller button, by using the mouse buttons instead of a controller button. The only difference is that you can't toggle the auto-hold (__Shift + controller button__) of a mouse button. It's still possible to frame advance while manually holding the button to set it.

The mouse position is handled as follow:
* To set the mouse position for the current frame, press __Space__, it will set it to current position of your mouse.
* Generally, when a new mouse position is needed for a frame, if __Space__ is held then the position of your mouse will be used, otherwise the mouse position of the previous frame will be used.
* To indicate this, when __Space__ is held the mouse input display shows the mouse position for the frame in red.


### Visual selection mode
Visual selection mode allows you to perform operations on a contiguous range of inputs. The selected range will always start with the current frame (highlighted blue on the piano roll), and contain all subsequent frames (highlighted gray). You can always exit visual selection mode, by making the selection empty, or pressing __ESC__.

* __L__ - advance selection 1 frame forward
* __K__ - move selection 1 frame back. if the selection now only includes the current frame, exit visual selection mode.
* __ESC__ - exit visual selection mode
* __End__ - extend selection until last frame
* __Home__ - reduce selection to the current frame, and the next one.
* __controller button / mouse button__ - set/unset the button for all selected frames
* __Alt + basic button / mouse button__ - toggle the button for all selected frames
* __Ctrl + C__ - copy selected frames to clipboard
* __Ctrl + V__ - replace selection with frames pasted from clipboard
* __Ctrl + X__ - cut frames to clipboard

### Console
Using the console, you can access and modify the variables of the PICO-8 instance. it supports standard terminal keybindings, and allows you to input and run lua code on the pico8 instance.

Warning: making changes to variables in the PICO-8 instance, then rewinding before the changes will lose the changes. It's very easy to make TASes that desync by modifying the variables of the cart, so use it carefully.

# Acknowledgements
* [gamax92/picolove](https://github.com/gamax92/picolove) and [picolove/picolove](https://github.com/picolove/picolove)
* [Love2d integrated console by rameshvarun](https://github.com/rameshvarun/love-console)
* [Lua 30log class library](https://github.com/Yonaba/30log)
* [Original Celeste TAS tool by akliant917](https://github.com/CelesteClassic/ClassicTAS)
* [Lua parser taken and modified from LuaMinify](https://github.com/stravant/LuaMinify)







