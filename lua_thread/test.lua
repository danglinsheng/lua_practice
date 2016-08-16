function Func1(param1)
    Func2(param1 + 10)
    print("Func1 ended.")
    return 30
end

function Func2(value)
    coroutine.yield(10, value)
    print("Func2 ended.")
end