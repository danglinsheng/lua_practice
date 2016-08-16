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

	// �������Эͬ����
	// ���ﷵ��LUA_YIELD
	bRet = lua_resume(L1, 1);
	printf( "bRet:%d\n", bRet);

	// ��ӡL1ջ��Ԫ�صĸ���
	printf( "Element Num::%d\n", lua_gettop(L1));

	// ��ӡyield���ص�����ֵ
	printf("Value 1:%d\n", lua_tointeger(L1, -2));
	printf("Value 2:%d\n", lua_tointeger(L1, -1));

	// �ٴ�����Эͬ����
	// ���ﷵ��0
	bRet = lua_resume(L1, 0);
	printf( "bRet:%d\n", bRet);

	printf( "Element Num::%d\n", lua_gettop(L1));
	printf("Value 1:%d\n", lua_tointeger(L1, -1));

	lua_close(L);

	return 0;
}
