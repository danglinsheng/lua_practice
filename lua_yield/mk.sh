
gcc -c -fPIC -o source.o source.c
gcc -shared -o lua_yieldDemo.so source.o
cp lua_yieldDemo.so /usr/lib64/lua/5.1/
