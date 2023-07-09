-- Copyright (C) perfGao

local bit = require 'bit32'

local type = type
local tonumber = tonumber
local str_byte = string.byte
local str_sub = string.sub
local str_format = string.format
local str_char = string.char
local tab_concat = table.concat

local rshift = bit.rshift
local lshift = bit.lshift
local band = bit.band
local bor = bit.bor

local function utf8_to_unicode(srcstr)
  if type(srcstr) ~= "string" then
    return srcstr
  end

  local tb_result = {}
  local i = 0
  while true do
    i = i + 1
    local numbyte = str_byte(srcstr, i)
    if not numbyte then
      break
    end

    local value1, value2

    if numbyte >= 0x00 and numbyte <= 0x7f then
      value1 = numbyte
      value2 = 0
     elseif band(numbyte, 0xe0) == 0xc0 then

      local t1 = band(numbyte, 0x1f)

      i = i + 1

      local t2 = band(str_byte(srcstr, i), 0x3f)

      value1 = bor(t2, lshift(band(t1, 0x03), 6))
      value2 = rshift(t1, 2)
     elseif band(numbyte, 0xf0) == 0xe0 then

      local t1 = band(numbyte, 0x0f)

      i = i + 1

      local t2 = band(str_byte(srcstr, i), 0x3f)

      i = i + 1

      local t3 = band(str_byte(srcstr, i), 0x3f)

      value1 = bor(lshift(band(t2, 0x03), 6), t3)
      value2 = bor(lshift(t1, 4), rshift(t2, 2))
     else
      return nil, "out of range"
    end

    tb_result[#tb_result + 1] = str_format("\\u%02x%02x", value2, value1)
  end

  return tab_concat(tb_result)
end


local function unicode_to_utf8(srcstr)
  if type(srcstr) ~= "string" then
    return srcstr
  end

  local tb_result = {}
  local i = 1
  while true do
    local numbyte = str_byte(srcstr, i)
    if not numbyte then
      break
    end

    local substr = str_sub(srcstr, i, i + 1)
    if (substr == "\\u" or substr == "%u") then
      local unicode = tonumber("0x" .. str_sub(srcstr, i + 2, i + 5))
      if not unicode then
        tb_result[#tb_result + 1] = substr
        break
      end

      i = i + 6

      if unicode <= 0x007f then
        -- 0xxxxxxx
        tb_result[#tb_result + 1] = str_char(band(unicode, 0x7f))
       elseif unicode >= 0x0080 and unicode <= 0x07ff then
        -- 110xxxxx 10xxxxxx
        tb_result[#tb_result + 1] = str_char(bor(0xc0, band(rshift(
        unicode, 6), 0x1f)))
        tb_result[#tb_result + 1] = str_char(bor(0x80, band(
        unicode, 0x3f)))
       elseif unicode >= 0x0800 and unicode <= 0xffff then
        -- 1110xxxx 10xxxxxx 10xxxxxx
        tb_result[#tb_result + 1] = str_char(bor(0xe0, band(rshift(
        unicode, 12), 0x0f)))
        tb_result[#tb_result + 1] = str_char(bor(0x80, band(rshift(
        unicode, 6), 0x3f)))
        tb_result[#tb_result + 1] = str_char(bor(0x80, band(unicode,
        0x3f)))
      end

     else
      tb_result[#tb_result + 1] = str_char(numbyte)
      i = i + 1
    end
  end

  return tab_concat(tb_result)
end


local _M = {
  _VERSION = '0.01',
  encode = utf8_to_unicode,
  decode = unicode_to_utf8,
}


return _M