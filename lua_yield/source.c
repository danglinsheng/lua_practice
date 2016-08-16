#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

// �жϻ�������JellyThink�Ƿ�������
static int IsSet(lua_State *L)
{
	lua_getfield(L, LUA_ENVIRONINDEX, "JellyThink");

	if (lua_isnil(L, -1))
	{
		printf("Not set\n");
		return 0;
	}
	return 1;
}

static int Func1(lua_State *L)
{
	// û�б����þ͹���
	if (!IsSet(L))
	{
		printf("Begin yield\n");
		return lua_yield(L, 0);
	}
	
	// �������ˣ���ȡֵ�����ر����õ�ֵ
	printf("Resumed again\n");
	lua_getfield(L, LUA_ENVIRONINDEX, "JellyThink");
	return 1;
}

// ����JellThink��ֵ
static int Func2(lua_State *L)
{
	luaL_checkinteger(L, 1);

	// ���õ���������
	lua_pushvalue(L, 1);
	lua_setfield(L, LUA_ENVIRONINDEX, "JellyThink");
	return 0;
}

static struct luaL_reg arrayFunc[] =
{
	{"Func1", Func1},
	{"Func2", Func2},
	{NULL, NULL}
};

int luaopen_lua_yieldDemo(lua_State *L)
{
	printf("Thread Start\n");
	lua_newtable(L);
	lua_replace(L, LUA_ENVIRONINDEX);

	luaL_register(L, "Module", arrayFunc);
	return 1;
}
