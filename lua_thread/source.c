#include <stdio.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"


int main()
{
	lua_State *L = luaL_newstate();
	if (!L)
	{
		return 0;
	}

	luaL_openlibs(L);

	lua_State *L1 = lua_newthread(L);
	if (!L1)
	{
		return 0;
	}

	int bRet = luaL_loadfile(L, "test.lua");
	if (bRet)
	{
		return 0;
	}

	bRet = lua_pcall(L, 0, 0, 0);
	if (bRet)
	{
		return 0;
	}

	
	lua_getglobal(L1, "Func1");
	lua_pushinteger(L1, 10);

	// 运行这个协同程序
	// 这里返回LUA_YIELD
	bRet = lua_resume(L1, 1);
	printf( "bRet:%d\n", bRet);

	// 打印L1栈中元素的个数
	printf( "Element Num::%d\n", lua_gettop(L1));

	// 打印yield返回的两个值
	printf("Value 1:%d\n", lua_tointeger(L1, -2));
	printf("Value 2:%d\n", lua_tointeger(L1, -1));

	// 再次启动协同程序
	// 这里返回0
	bRet = lua_resume(L1, 0);
	printf( "bRet:%d\n", bRet);

	printf( "Element Num::%d\n", lua_gettop(L1));
	printf("Value 1:%d\n", lua_tointeger(L1, -1));

	lua_close(L);

	return 0;
}
