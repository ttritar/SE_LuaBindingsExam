---@meta
-- This file provides type annotations for Lua scripts interacting with C++ via SOL2.

----------------------------------------------------------------------------------------------------
--- A C++ function exposed to lua
--- @param Red number # RGB red value [0-255].
--- @param Green number # RGB green value [0-255].
--- @param Blue number # RGB blue value [0-255].
--- @return void # colors the window with specified RGB value [0-255]
function FillWindowRect(Red, Green, Blue) end

----------------------------------------------------------------------------------------------------
--- A C++ function exposed to lua
--- @param Red number # RGB red value [0-255].
--- @param Green number # RGB green value [0-255].
--- @param Blue number # RGB blue value [0-255].
--- @return void # sets the color (that will be drawn/filled/painted with) to a specified RGB value [0-255].
function SetColor(Red, Green, Blue) end

----------------------------------------------------------------------------------------------------
--- A C++ function exposed to lua
--- @param Left number # left of the drawn rectangle.
--- @param Top number # top of the drawn rectangle.
--- @param Right number # right of the drawn rectangle.
--- @param Bottom number # bottom of the drawn rectangle.
--- @return void # draws a rectangle on the screen/window.
function DrawRect(Left, Top, Right, Bottom) end

----------------------------------------------------------------------------------------------------
--- A C++ function exposed to lua
--- @param Left number # left of the filled rectangle.
--- @param Top number # top of the filled rectangle.
--- @param Right number # right of the filled rectangle.
--- @param Bottom number # bottom of the filled rectangle.
--- @return void # fills a rectangle on the screen/window.
function FillRect(Left, Top, Right, Bottom) end

----------------------------------------------------------------------------------------------------
--- A C++ function exposed to lua
--- @param Left number # left of the drawn oval.
--- @param Top number # top of the drawn oval.
--- @param Right number # right of the drawn oval.
--- @param Bottom number # bottom of the drawn oval.
--- @return void # draws an oval on the screen
function DrawOval(Left, Top, Right, Bottom) end

----------------------------------------------------------------------------------------------------
--- A C++ function exposed to lua
--- @param Left number # left of the filled oval.
--- @param Top number # top of the filled oval.
--- @param Right number # right of the filled oval.
--- @param Bottom number # bottom of the filled oval.
--- @return void # fills an oval on the screen
function FillOval(Left, Top, Right, Bottom) end

----------------------------------------------------------------------------------------------------
--- A C++ function exposed to lua
--- @param Text string # drawn text string
--- @param Left number # left of desired text start location.
--- @param Top number # top of desired text start location.
--- @return void # draws text at specified location (on the screen/window).
function DrawString(Text, Left,Top) end  

----------------------------------------------------------------------------------------------------
--- A C++ function exposed to lua
--- @param key string # Input Key (only "character" keys).
--- @return void # checks if and what key is being pressed.
function IsKeyDown(key) end  