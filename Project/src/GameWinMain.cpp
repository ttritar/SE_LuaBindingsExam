//-----------------------------------------------------------------
// Game Engine WinMain Function
// C++ Source - GameWinMain.cpp - version v8_01
//-----------------------------------------------------------------


//debug console window
#include <windows.h>
#include <iostream>
#include <cstdio>

void SetupConsole()
{
    // Allocate a console for this application
    AllocConsole();

    // Redirect standard input, output, and error to the new console
    FILE* f;
    freopen_s(&f, "CONOUT$", "w", stdout); // Redirect stdout
    freopen_s(&f, "CONOUT$", "w", stderr); // Redirect stderr
    freopen_s(&f, "CONIN$", "r", stdin);  // Redirect stdin
}




//-----------------------------------------------------------------
// Include Files
//-----------------------------------------------------------------
#include "GameWinMain.h"
#include "GameEngine.h"

#include "Game.h"	
#include <lua.hpp>

//-----------------------------------------------------------------
// Create GAME_ENGINE global (singleton) object and pointer
//-----------------------------------------------------------------
GameEngine myGameEngine;
GameEngine* GAME_ENGINE{ &myGameEngine };

// helper functions
//==================
wchar_t* utf8_to_wchar(const char* utf8_str)    // UTF-8 encoded string to wide char string
{
    if (!utf8_str) return NULL;

    size_t len = mbstowcs(NULL, utf8_str, 0);
    if (len == (size_t)-1) {
        return NULL; 
    }

    wchar_t* wstr = (wchar_t*)malloc((len + 1) * sizeof(wchar_t)); 
    if (!wstr) return NULL;

    mbstowcs(wstr, utf8_str, len + 1); 
    return wstr;
}

// lua bindings
//=============

// draw functions
//-----------------
int lua_SetColor(lua_State* L)
{
    // Get color from lua
    float R = static_cast<float>(luaL_checknumber(L, 1)); 
    float G = static_cast<float>(luaL_checknumber(L, 2)); 
    float B = static_cast<float>(luaL_checknumber(L, 3)); 

    // Call game engine function
    GAME_ENGINE->SetColor(RGB(R, G, B));

    return 0; 
}
int lua_FillWindowRect(lua_State* L)
{ 
    // Get color from lua
    float R = static_cast<float>(luaL_checknumber(L, 1)); 
    float G = static_cast<float>(luaL_checknumber(L, 2)); 
    float B = static_cast<float>(luaL_checknumber(L, 3)); 

    // Call game engine function
    GAME_ENGINE->FillWindowRect(RGB(R, G, B));

    return 0; 

}
int lua_DrawRect(lua_State* L) 
{
    // Get values from lua
    float left = static_cast<float>(luaL_checknumber(L, 1));  
    float top = static_cast<float>(luaL_checknumber(L, 2));   
    float right = static_cast<float>(luaL_checknumber(L, 3)); 
    float bottom = static_cast<float>(luaL_checknumber(L, 4));

    // Call game engine function
    GAME_ENGINE->DrawRect(left, top, right, bottom);

    return 0; 
}
int lua_FillRect(lua_State* L)
{
    // Get values from lua
    float left = static_cast<float>(luaL_checknumber(L, 1));
    float top = static_cast<float>(luaL_checknumber(L, 2));
    float right = static_cast<float>(luaL_checknumber(L, 3));
    float bottom = static_cast<float>(luaL_checknumber(L, 4));

    // Call game engine function
    GAME_ENGINE->FillRect(left, top, right, bottom);

    return 0;
}
int lua_DrawOval(lua_State* L)
{
    // Get values from lua
    float left = static_cast<float>(luaL_checknumber(L, 1));
    float top = static_cast<float>(luaL_checknumber(L, 2));
    float right = static_cast<float>(luaL_checknumber(L, 3));
    float bottom = static_cast<float>(luaL_checknumber(L, 4));

    // Call game engine function
    GAME_ENGINE->DrawOval(left, top, right, bottom);

    return 0;
}
int lua_FillOval(lua_State* L)
{
    // Get values from lua
    float left = static_cast<float>(luaL_checknumber(L, 1));
    float top = static_cast<float>(luaL_checknumber(L, 2));
    float right = static_cast<float>(luaL_checknumber(L, 3));
    float bottom = static_cast<float>(luaL_checknumber(L, 4));

    // Call game engine function
    GAME_ENGINE->FillOval(left, top, right, bottom);

    return 0;
}
int lua_DrawString(lua_State* L)
{
    // Get startPos and string from lua
    const char* utf8_str = luaL_checkstring(L, 1);
    float left = static_cast<float>(luaL_checknumber(L, 2)); 
    float top = static_cast<float>(luaL_checknumber(L, 3));  

    // Convert string to wcar string
    wchar_t* wstr = utf8_to_wchar(utf8_str);
    if (!wstr) {
        luaL_error(L, "Could not convert string to wchar string!!");
        return 0;
    }

    // Call gane engine function
    GAME_ENGINE->DrawString(wstr, left, top);

   
    free(wstr); // Free the wchar string

    return 0;
}


// keyboard functions
//-----------------
int lua_IsKeyDown(lua_State* L)
{
    // Check if input is a string and if it has a valid length
    const char* utf8_str = luaL_checkstring(L, 1);

    if (strlen(utf8_str) != 1) {
        luaL_error(L, "Input is not a single char string!");
        return 0;
    }

    // Convert char to wchar
    wchar_t key = 0;
    size_t len = mbstowcs(&key, utf8_str, 1);

    if (len == (size_t)-1) {
        luaL_error(L, "Could not convert char to wchar!");
        return 0;
    }

    // Call gane engine function
    bool isKeyDown = GAME_ENGINE->IsKeyDown(key);

    // Push the result onto the Lua stack
    lua_pushboolean(L, isKeyDown);

    return 1;   // bool result
}



// Register 
//---------
void RegisterLuaFunctions(lua_State* L)
{
    // draw functions
    lua_register(L, "SetColor", lua_SetColor);
    lua_register(L, "FillWindowRect", lua_FillWindowRect);
    lua_register(L, "DrawRect", lua_DrawRect);
    lua_register(L, "FillRect", lua_FillRect);
    lua_register(L, "DrawOval", lua_DrawOval);
    lua_register(L, "FillOval", lua_FillOval);
    lua_register(L, "DrawString", lua_DrawString);

    // keyboard functions
    lua_register(L, "IsKeyDown", lua_IsKeyDown);
    
}



//-----------------------------------------------------------------
// Main Function
//-----------------------------------------------------------------

int APIENTRY wWinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance, _In_ LPWSTR lpCmdLine, _In_ int nCmdShow)
{
    SetupConsole();

    lua_State* L = luaL_newstate(); // Initialize Lua State
    luaL_openlibs(L);               // Load Lua libraries

    GAME_ENGINE->SetGame(new Game(), L); // Set game object

    // Register the wrapper function in Lua
    RegisterLuaFunctions(L);

    // Check if a Lua script was dragged and passed as a command-line argument
    if (lpCmdLine && wcslen(lpCmdLine) > 0) {
        // `lpCmdLine` contains the file path of the Lua script
        std::wstring luaFilePath(lpCmdLine);
        if (luaL_dofile(L, std::string(luaFilePath.begin(), luaFilePath.end()).c_str())) {
            std::cerr << "Lua Error: " << lua_tostring(L, -1) << std::endl;
        }
        std::cout << "Playing dragged script!\n";
    }
    else {
        // If no file dragged, 
        //      play default script
        if (luaL_dofile(L, "../../../Breakout.lua")) {
            std::cerr << "Lua Error: " << lua_tostring(L, -1) << std::endl;
        }
        std::cout << "Playing default script!\n";
    }

    int result = GAME_ENGINE->Run(hInstance, nCmdShow);

    lua_close(L); // Close Lua state

    return result;
}


