require "lua_yieldDemo"

local function1 = function ()
    local value
    repeat
      value = Module.Func1()
    until value
    return value
end

local thread1 = coroutine.create(function1)

-- 现在运行到了Module.Func1()
-- 100这个值将会被赋值给value
coroutine.resume(thread1)
--print(coroutine.status(thread1))

-- 设置C函数环境
Module.Func2(10)
print(coroutine.resume(thread1))
