local resty_sha1 = require "resty.sha1"

local sha1 = resty_sha1:new()
if not sha1 then
    ngx.say("failed to create the sha1 object")
    return
end

local ok = sha1:update("hello, ")
if not ok then
    ngx.say("failed to add data")
    return
end

ok = sha1:update("world")
if not ok then
    ngx.say("failed to add data")
    return
end

local digest = sha1:final()   

local str = require "resty.string"
ngx.say("sha1: ", str.to_hex(digest))


local resty_md5 = require "resty.md5"
local md5 = resty_md5:new()
if not md5 then
    ngx.say("failed to create md5 object")
    return
end

local ok = md5:update("hel")
if not ok then
    ngx.say("failed to add data")
    return
end

ok = md5:update("lo")
if not ok then
    ngx.say("failed to add data")
    return
end

local digest = md5:final()

local str = require "resty.string"
ngx.say("md5: ", str.to_hex(digest))

local resty_sha224 = require "resty.sha224"
local str = require "resty.string"
local sha224 = resty_sha224:new()
ngx.say(sha224:update("hello"))
local digest = sha224:final()
ngx.say("sha224: ", str.to_hex(digest))

local resty_sha256 = require "resty.sha256"
local str = require "resty.string"
local sha256 = resty_sha256:new()
ngx.say(sha256:update("hello"))
local digest = sha256:final()
ngx.say("sha256: ", str.to_hex(digest))

local resty_sha512 = require "resty.sha512"
local str = require "resty.string"
local sha512 = resty_sha512:new()
ngx.say(sha512:update("hello"))
local digest = sha512:final()
ngx.say("sha512: ", str.to_hex(digest))

local resty_sha384 = require "resty.sha384"
local str = require "resty.string"
local sha384 = resty_sha384:new()
ngx.say(sha384:update("hel"))
ngx.say(sha384:update("lo"))
local digest = sha384:final()
ngx.say("sha384: ", str.to_hex(digest))

local resty_random = require "resty.random"
local str = require "resty.string"
local random = resty_random.bytes(16)

ngx.say("pseudo-random: ", str.to_hex(random))

local resty_random = require "resty.random"
local str = require "resty.string"
local strong_random = resty_random.bytes(16,true)

while strong_random == nil do
    strong_random = resty_random.bytes(16,true)
end
ngx.say("random: ", str.to_hex(strong_random))

local aes = require "resty.aes"
local str = require "resty.string"
local aes_128_cbc_md5 = aes:new("AKeyForAES")

local encrypted = aes_128_cbc_md5:encrypt("Secret message!")
ngx.say("AES 128 CBC (MD5) Encrypted HEX: ", str.to_hex(encrypted))
ngx.say("AES 128 CBC (MD5) Decrypted: ", aes_128_cbc_md5:decrypt(encrypted))

local aes = require "resty.aes"
local str = require "resty.string"
local aes_256_cbc_sha512x5 = aes:new("AKeyForAES-256-CBC",
    "MySalt!", aes.cipher(256,"cbc"), aes.hash.sha512, 5)

local encrypted = aes_256_cbc_sha512x5:encrypt("Really secret message!")
ngx.say("AES 256 CBC (SHA-512, salted) Encrypted HEX: ", str.to_hex(encrypted))
ngx.say("AES 256 CBC (SHA-512, salted) Decrypted: ",
    aes_256_cbc_sha512x5:decrypt(encrypted))

local aes = require "resty.aes"
local str = require "resty.string"
local aes_128_cbc_with_iv = assert(aes:new("1234567890123456",
    nil, aes.cipher(128,"cbc"), {iv="1234567890123456"}))

local encrypted = aes_128_cbc_with_iv:encrypt("Really secret message!")
ngx.say("AES 128 CBC (WITH IV) Encrypted HEX: ", str.to_hex(encrypted))
ngx.say("AES 128 CBC (WITH IV) Decrypted: ",
    aes_128_cbc_with_iv:decrypt(encrypted))
