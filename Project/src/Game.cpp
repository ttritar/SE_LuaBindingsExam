//-----------------------------------------------------------------
// Main Game File
// C++ Source - Game.cpp - version v8_01
//-----------------------------------------------------------------

//-----------------------------------------------------------------
// Include Files
//-----------------------------------------------------------------
#include "Game.h"
#include <lua.hpp>
#include <locale>
#include <codecvt>


//-----------------------------------------------------------------
// Game Member Functions																				
//-----------------------------------------------------------------

Game::Game() 																	
{
	// nothing to create
}

Game::~Game()																						
{
	// nothing to destroy
}

void Game::Initialize()			
{
	// Code that needs to execute (once) at the start of the game, before the game window is created


	//Set WINDOW!
	//=================

	// Name
	//---
	lua_getglobal(GAME_ENGINE->GetLuaState(), "windowName");	// Push windowName on Lua stack
	
		// Check if windowName is a string/failed to be pushed on stack
	if (!lua_isstring(GAME_ENGINE->GetLuaState(), -1)) 
		std::cerr << "LUA Error: windowName does not exist/is of an incompatible type.\n";
	
	
		// Get the string value of 'windowName' and return it as a C++ std::string
	const char* windowName = lua_tostring(GAME_ENGINE->GetLuaState(), -1);

	tstringstream windowNameBuffer;
#ifdef _UNICODE	// if unicode was selected in projectsettings
	//convert to wide characters
	std::wstring_convert<std::codecvt_utf8<wchar_t>, wchar_t> converter;
	std::wstring wcharWindowName = converter.from_bytes(windowName);
	windowNameBuffer << wcharWindowName;
#else
	windowNameBuffer << windowName;
#endif

	// Width
	//---
	lua_getglobal(GAME_ENGINE->GetLuaState(), "windowWidth"); // Push windowWidth on Lua stack

	// Check if windowWidth is a int/failed to be pushed on stack
	if (!lua_isnumber(GAME_ENGINE->GetLuaState(), -1)) 
	{
    	std::cerr << "LUA Error: windowWidth does not exist/is of an incompatible type.\n" << std::endl;
    	lua_close(GAME_ENGINE->GetLuaState());
    	return;
	}
	int windowWidth = lua_tointeger(GAME_ENGINE->GetLuaState(), -1);
	lua_pop(GAME_ENGINE->GetLuaState(), 1);

	// Height
	//---
	lua_getglobal(GAME_ENGINE->GetLuaState(), "windowHeight");

	// Check if windowHeight is a int/failed to be pushed on stack
	if (!lua_isnumber(GAME_ENGINE->GetLuaState(), -1)) 
	{
    	std::cerr << "LUA Error: windowHeight does not exist/is of an incompatible type.\n"<< std::endl;
    	lua_close(GAME_ENGINE->GetLuaState());
    	return;
	}
	int windowHeight = lua_tointeger(GAME_ENGINE->GetLuaState(), -1);
	lua_pop(GAME_ENGINE->GetLuaState(), 1); 


	// FrameRate
	//---
    lua_getglobal(GAME_ENGINE->GetLuaState(), "frameRate");
    if (!lua_isnumber(GAME_ENGINE->GetLuaState(), -1)) {
        std::cerr << "LUA Error: frameRate does not exist/is of an incompatible type." << std::endl;
        lua_close(GAME_ENGINE->GetLuaState());
        return;
    }
    int frameRate = lua_tointeger(GAME_ENGINE->GetLuaState(), -1);
    lua_pop(GAME_ENGINE->GetLuaState(), 1);



	AbstractGame::Initialize();
	GAME_ENGINE->SetTitle(windowNameBuffer.str());
	GAME_ENGINE->SetWidth(windowWidth);
	GAME_ENGINE->SetHeight(windowHeight);
	GAME_ENGINE->SetFrameRate(frameRate);


	// Set the keys that the game needs to listen to
	//=================

	lua_getglobal(GAME_ENGINE->GetLuaState(), "listenKeys");	// Push listenKeys on Lua stack
	
		// Check if listenKeys is a string/failed to be pushed on stack
	if (!lua_isstring(GAME_ENGINE->GetLuaState(), -1)) 
		std::cerr << "LUA Error: listenKeys does not exist/is of an incompatible type.\n";
	
	
		// Get the string value of 'listenKeys' and return it as a C++ std::string
	const char* listenKeys = lua_tostring(GAME_ENGINE->GetLuaState(), -1);


	tstringstream listenKeysBuffer;
#ifdef _UNICODE	// if unicode was selected in projectsettings
	//convert to wide characters
	std::wstring wcharListenKeys = converter.from_bytes(listenKeys);
	listenKeysBuffer << wcharListenKeys;
#else
	listenKeysBuffer << listenKeys;
#endif
	GAME_ENGINE->SetKeyList(listenKeysBuffer.str());
}

void Game::Start()
{
	// Insert code that needs to execute (once) at the start of the game, after the game window is created
}

void Game::End()
{
	// Insert code that needs to execute when the game ends
}

void Game::Paint(RECT rect) const	// Insert paint code
{
	lua_getglobal(GAME_ENGINE->GetLuaState(), "Paint"); // Get Paint function

	if (!lua_isfunction(GAME_ENGINE->GetLuaState(), -1)) 
	{
		std::cerr << "Error: Could not find a funtion named 'Paint'!\n";
		lua_close(GAME_ENGINE->GetLuaState());

		return;
	}

	// Call Paint (no returns ecpected)
	if (lua_pcall(GAME_ENGINE->GetLuaState(), 0, 0, 0) != LUA_OK) 
	{
		std::cerr << "Error (tried calling Paint): " << lua_tostring(GAME_ENGINE->GetLuaState(), -1) << std::endl;
		lua_close(GAME_ENGINE->GetLuaState());

		return;
	}
}

void Game::Tick()
{
	lua_getglobal(GAME_ENGINE->GetLuaState(), "Tick"); // Get func Tick

	if (!lua_isfunction(GAME_ENGINE->GetLuaState(), -1))
	{
		std::cerr << "Error: Could not find a funtion named 'Tick'!\n";
		lua_close(GAME_ENGINE->GetLuaState());
		return;
	}

	// Call Tick (no returns expected)
	if (lua_pcall(GAME_ENGINE->GetLuaState(), 0, 0, 0) != LUA_OK)
	{
		std::cerr << "Error (tried calling Tick): " << lua_tostring(GAME_ENGINE->GetLuaState(), -1) << std::endl;
		lua_close(GAME_ENGINE->GetLuaState());
		return;
	}
}

void Game::MouseButtonAction(bool isLeft, bool isDown, int x, int y, WPARAM wParam)
{	
	lua_getglobal(GAME_ENGINE->GetLuaState(), "MouseButtonAction"); //Get func MouseButtonAction

	if (!lua_isfunction(GAME_ENGINE->GetLuaState(), -1)) 
	{
		std::cerr << "Error: Could not find a funtion named 'MouseButtonAction'!\n";
		lua_close(GAME_ENGINE->GetLuaState());
		return;
	}

	// Push all arguments onto Lua stack
	lua_pushboolean(GAME_ENGINE->GetLuaState(), isLeft);  // Push as boolean
	lua_pushboolean(GAME_ENGINE->GetLuaState(), isDown);  // Push as boolean
	lua_pushinteger(GAME_ENGINE->GetLuaState(), x);       // Push as integer
	lua_pushinteger(GAME_ENGINE->GetLuaState(), y);       // Push as integer
	lua_pushinteger(GAME_ENGINE->GetLuaState(), wParam);  // Push as integer

	// Call MouseButtonAction (no returns expected, 5 arguments should be passed)
	if (lua_pcall(GAME_ENGINE->GetLuaState(), 5, 0, 0) != LUA_OK)
	{
		std::cerr << "Error (Tried calling MouseButtonAction): " << lua_tostring(GAME_ENGINE->GetLuaState(), -1) << std::endl;
		lua_close(GAME_ENGINE->GetLuaState());
		return;
	}
}

void Game::MouseWheelAction(int x, int y, int distance, WPARAM wParam)
{	
	// Insert code for a mouse wheel action
}

void Game::MouseMove(int x, int y, WPARAM wParam)	// Insert code that needs to execute when the mouse pointer moves across the game window
{	
	lua_getglobal(GAME_ENGINE->GetLuaState(), "MouseMove"); // Get MouseMove func

	if (!lua_isfunction(GAME_ENGINE->GetLuaState(), -1)) 
	{
		std::cerr << "Error: Could not find a funtion named 'MouseMove'!\n";
		lua_close(GAME_ENGINE->GetLuaState());
		return;
	}

	// Push all arguments onto Lua stack
	lua_pushinteger(GAME_ENGINE->GetLuaState(), x);       // Push as integer
	lua_pushinteger(GAME_ENGINE->GetLuaState(), y);       // Push as integer
	lua_pushinteger(GAME_ENGINE->GetLuaState(), wParam);  // Push as integer

	// Call MouseButtonAction (no returns expected, 3 arguments should be passed)
	if (lua_pcall(GAME_ENGINE->GetLuaState(), 3, 0, 0) != LUA_OK) 
	{
		std::cerr << "Error (tried calling MouseMove): " << lua_tostring(GAME_ENGINE->GetLuaState(), -1) << std::endl;
		lua_close(GAME_ENGINE->GetLuaState());
		return;
	}
}

void Game::CheckKeyboard()		// Here you can check if a key is pressed down		// Is executed once per frame 
{	
	lua_getglobal(GAME_ENGINE->GetLuaState(), "CheckKeyboard"); // Get CheckKeyboard func

	if (!lua_isfunction(GAME_ENGINE->GetLuaState(), -1)) 
	{
		std::cerr << "Error: Could not find a funtion named 'CheckKeyboard'!\n";
		lua_close(GAME_ENGINE->GetLuaState());
		return;
	}

	// Push all arguments onto Lua stack -- no arguments
	
	// Call CheckKeyboard (no returns expected)
	if (lua_pcall(GAME_ENGINE->GetLuaState(), 0, 0, 0) != LUA_OK) 
	{
		std::cerr << "Error (tried calling CheckKeyboard): " << lua_tostring(GAME_ENGINE->GetLuaState(), -1) << std::endl;
		lua_close(GAME_ENGINE->GetLuaState());
		return;
	}
}

void Game::KeyPressed(TCHAR key)
{
	lua_getglobal(GAME_ENGINE->GetLuaState(), "KeyPressed"); // Get KeyPressedw func

	if (!lua_isfunction(GAME_ENGINE->GetLuaState(), -1))
	{
		std::cerr << "Error: Could not find a funtion named 'KeyPressed'!\n";
		lua_close(GAME_ENGINE->GetLuaState());
		return;
	}


	char charToSend[2];  // (Char)Buffer (only holds one char -and the required null terminator- )

	// Take proj settings into account
#ifdef UNICODE
	// key will be a wchar (if UNICODE) -> should be converted to a standard char 
	int len = WideCharToMultiByte(CP_UTF8, 0, &key, 1, charToSend, sizeof(charToSend), NULL, NULL);
	if (len == 0) 
	{
		std::cerr << "Error: Couldn't convert key of type TCHAR to a standard char in KeyPressed!" << std::endl;
		lua_close(GAME_ENGINE->GetLuaState());
		return;
	}
	charToSend[len] = '\0'; // Make sure the end of our string has the nullterminatoe
#else
	// key will be a char (ASCII)
	charToSend[0] = static_cast<char>(key);  // Assign char to the buffer
	charToSend[1] = '\0';  // Make sure the end of our string has the nullterminatoe
#endif

	lua_pushstring(GAME_ENGINE->GetLuaState(), charToSend);  // Push the charBuffer (string) to Lua

	// Call CheckKeyboard (no returns expected, 1 argument should be passed)
	if (lua_pcall(GAME_ENGINE->GetLuaState(), 1, 0, 0) != LUA_OK) {
		std::cerr << "Error calling function KeyPressed: " << lua_tostring(GAME_ENGINE->GetLuaState(), -1) << std::endl;
		lua_close(GAME_ENGINE->GetLuaState());
		return;
	}
}

void Game::CallAction(Caller* callerPtr)
{
	// Insert the code that needs to execute when a Caller (= Button, TextBox, Timer, Audio) executes an action
}




