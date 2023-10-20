local base={
  nextUrl=nil,
  is_end=false,
  data={},
}

local h = {
  zk = {1170614578, 1024848638, 1413669199, -343334464, -766094290, -1373058082, -143119608, -297228157, 1933479194, -971186181, -406453910, 460404854, -547427574, -1891326262, -1679095901, 2119585428, -2029270069, 2035090028, -1521520070, -5587175, -77751101, -2094365853, -1243052806, 1579901135, 1321810770, 456816404, -1391643889, -229302305, 330002838, -788960546, 363569021, -1947871109},
  zb = {20, 223, 245, 7, 248, 2, 194, 209, 87, 6, 227, 253, 240, 128, 222, 91, 237, 9, 125, 157, 230, 93, 252, 205, 90, 79, 144, 199, 159, 197, 186, 167, 39, 37, 156, 198, 38, 42, 43, 168, 217, 153, 15, 103, 80, 189, 71, 191, 97, 84, 247, 95, 36, 69, 14, 35, 12, 171, 28, 114, 178, 148, 86, 182, 32, 83, 158, 109, 22, 255, 94, 238, 151, 85, 77, 124, 254, 18, 4, 26, 123, 176, 232, 193, 131, 172, 143, 142, 150, 30, 10, 146, 162, 62, 224, 218, 196, 229, 1, 192, 213, 27, 110, 56, 231, 180, 138, 107, 242, 187, 54, 120, 19, 44, 117, 228, 215, 203, 53, 239, 251, 127, 81, 11, 133, 96, 204, 132, 41, 115, 73, 55, 249, 147, 102, 48, 122, 145, 106, 118, 74, 190, 29, 16, 174, 5, 177, 129, 63, 113, 99, 31, 161, 76, 246, 34, 211, 13, 60, 68, 207, 160, 65, 111, 82, 165, 67, 169, 225, 57, 112, 244, 155, 51, 236, 200, 233, 58, 61, 47, 100, 137, 185, 64, 17, 70, 234, 163, 219, 108, 170, 166, 59, 149, 52, 105, 24, 212, 78, 173, 45, 0, 116, 226, 119, 136, 206, 135, 175, 195, 25, 92, 121, 208, 126, 139, 3, 75, 141, 21, 130, 98, 241, 40, 154, 66, 184, 49, 181, 46, 243, 88, 101, 183, 8, 23, 72, 188, 104, 179, 210, 134, 250, 201, 164, 89, 216, 202, 220, 50, 221, 152, 140, 33, 235, 214},
  zm = {120, 50, 98, 101, 99, 98, 119, 100, 103, 107, 99, 119, 97, 99, 110, 111}
}

local function pad(data_to_pad)
  padding_len = 16 - #data_to_pad % 16
  padding = string.rep(string.char(padding_len), padding_len)
  return data_to_pad..padding
end

local function left_shift(x, y)
  x = bit32.band(x, 0xFFFFFFFF)
  y = y % 32
  return bit32.lshift(x, y)
end

local function Unsigned_right_shift(x, y)
  x = bit32.band(x, 0xFFFFFFFF)
  y = y % 32
  return bit32.rshift(x, y)
end

local function Q(e, t)
  -- 视e为无符号整数,转换为补码
  e = e % 2^32
  local ret = bit32.bor(left_shift(e, t), Unsigned_right_shift(e, 32 - t))
  -- 运算结果视为补码,转换回有符号整数
  if ret >= 2^31 then
    ret = ret - 2^32
  end
  return tointeger(ret)
end


local function G(e)

  local t = {string.byte(string.pack(">i", e), 1, 4)}

  local n = {h["zb"][t[1]+1 or 255], h["zb"][t[2]+1 or 255], h["zb"][t[3]+1 or 255], h["zb"][t[4]+1 or 255]}
  local r = string.unpack(">i", string.char(unpack(n)))
  return r ~ Q(r, 2) ~ Q(r, 10) ~ Q(r, 18) ~ Q(r, 24)
end



local function table_to_bytes(t)
  local s = ""
  for i = 1, #t do
    s = s .. string.char(t[i]) -- convert each element to a byte and then to a char
  end
  return s
end

local function g_r(e)
  local n={}
  local pos = 1 -- set the initial position
  for i = 1, #e / 4 do -- loop through every four elements in e
    local num
    num, pos = string.unpack(">i", table_to_bytes(e), pos) -- unpack one integer from e and update the position
    table.insert(n, num) -- insert the integer into n
  end
  for r = 1, 32 do
    local data = n[r] ~ G(n[r+1] ~ n[r+2] ~ n[r+3] ~ h['zk'][r])
    table.insert(n, data)
  end
  tab={string.byte(string.pack(">i", n[36]), 1, 4)}
  local tab1={string.byte(string.pack(">i", n[35]), 1, 4)}
  local tab2={string.byte(string.pack(">i", n[34]), 1, 4)}
  local tab3={string.byte(string.pack(">i", n[33]), 1, 4)}
  local endtable={}
  for k,v in pairs(tab) do
    table.insert(endtable, v)
  end
  for k,v in pairs(tab1) do
    table.insert(endtable, v)
  end
  for k,v in pairs(tab2) do
    table.insert(endtable, v)
  end
  for k,v in pairs(tab3) do
    table.insert(endtable, v)
  end
  return endtable
end

local function g_x(e, t)
  local n = {}
  local i = 0
  for _ = #e, 1, -16 do
    local o = {}
    for j = 1, 16 do
      o[j] = e[16 * i + j]
    end
    local a = {}
    for c = 1, 16 do
      a[c] = bit32.bxor(o[c], t[c])
    end
    t = g_r(a)
    for c = 1, 16 do
      n[#n + 1] = t[c]
    end
    i = i + 1
  end
  return n
end

local function x_zse_96_b64encode(md5_bytes)

  local local_48 = {48, 53, 57, 48, 53, 51, 102, 55, 100, 49, 53, 101, 48, 49, 100, 55}
  local local_50 = string.char(63,0)..md5_bytes
  local_50 = pad(local_50)
  local local_34 = string.sub(local_50, 1, 16)

  local local_35 = {}
  for local_11 = 1, 16 do
    local_35[local_11] = string.byte(local_34, local_11) ~ local_48[local_11] ~ 42
  end
  local local_36 = g_r(local_35)

  local local_50_sub = string.sub(local_50, 17)
  local local_38 ={string.byte(local_50_sub, 1, 32)}
  local local_39 = g_x(local_38, local_36)
  --local_53 待优化 table相加
  local local_53 = {}
  for k,v in pairs(local_36) do
    table.insert(local_53, v)
  end
  for k,v in pairs(local_39) do
    table.insert(local_53, v)
  end
  local local_55 = '6fpLRqJO8M/c3jnYxFkUVC4ZIG12SiH=5v0mXDazWBTsuw7QetbKdoPyAl+hN9rgE'
  local local_56 = 0
  local local_57 = ''
  for local_13 = #local_53, 1, -3 do
    local_58 = 8 * (local_56 % 4)
    local_56 = local_56 + 1
    local_59 = local_53[local_13] ~ Unsigned_right_shift(58, local_58)
    local_58 = 8 * (local_56 % 4)
    local_56 = local_56 + 1
    local_59 = local_59 | (local_53[local_13-1] ~ Unsigned_right_shift(58, local_58)) << 8
    local_58 = 8 * (local_56 % 4)
    local_56 = local_56 + 1
    local_59 = local_59 | (local_53[local_13-2] ~ Unsigned_right_shift(58, local_58)) << 16
    local_57 = local_57..string.sub(local_55, local_59 % 64 + 1, local_59 % 64 + 1)
    local_57 = local_57..string.sub(local_55, Unsigned_right_shift(local_59, 6) % 64 + 1, Unsigned_right_shift(local_59, 6) % 64 + 1)
    local_57 = local_57..string.sub(local_55, Unsigned_right_shift(local_59, 12) % 64 + 1, Unsigned_right_shift(local_59, 12) % 64 + 1)
    local_57 = local_57..string.sub(local_55, Unsigned_right_shift(local_59, 18) % 64 + 1, Unsigned_right_shift(local_59, 18) % 64 + 1)
  end
  return local_57
end


function 初始化(url,b)
  local 判断url="https://www.zhihu.com"
  if url:find(判断url) then
    b.pat= url:match("zhihu.com(.+)")
    b.url=url
   elseif url:find("https://api.zhihu.com") then
    b.pat="/api/v4"..url:match("zhihu.com(.+)")
    b.url=判断url..b.pat
  end
  加密前数据="101_3_3.0+"..b.pat.."+"..获取Cookie("https://www.zhihu.com/"):match("d_c0=(.-);")
  b.md5str=string.lower(MD5(加密前数据))
end

function base:new(url)
  local child=table.clone(self)
  初始化(url,child)
  return child
end



function base:clear()
  self.nextUrl=nil
  self.is_end=false
  self.data={}
  return self
end




function base:setresultfunc(tab)
  self.resultfunc=tab
  return self
end


function base:setgetcallback(code,content,callback)
  if code==200 then
    local data=luajson.decode(content)
    if data.paging.is_end then
      提示("已经到底啦")
     else
      初始化(data.paging.next,self)
      self.resultfunc(data)
      if callback then
        callback(content)
      end
      if data.paging then
        self.is_end=data.paging.is_end
       else
        self.is_end=true
      end
    end
  end
end

function base:setothercallback(code,content,callback)
  if code==200 then
    local data=luajson.decode(content)
    self.resultfunc(data)
    if callback then
      callback(content)
    end
    if data.paging then
      self.is_end=data.paging.is_end
     else
      self.is_end=true
    end
  end
end

function base:getData(method,data,callback)
  local myhead = {
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
    ["x-api-version"] = "3.0.91";
    ["x-zse-93"] = "101_3_3.0";
    ["x-zse-96"] = "2.0_"..x_zse_96_b64encode(self.md5str);
    ["x-app-za"] = "OS=Web";
  }

  local myjshead = {
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
    ["x-api-version"] = "3.0.91";
    ["x-zse-93"] = "101_3_3.0";
    ["x-zse-96"] = "2.0_"..x_zse_96_b64encode(self.md5str);
    ["x-app-za"] = "OS=Web";
    ["Content-Type"] = "application/json; charset=UTF-8";
  }

  if not(method) or method=="get" then
    zHttp.get(self.url,myhead,function(code,content)
      self:setgetcallback(code,content,callback)
    end)
   elseif method == "delete" then
    zHttp.delete(self.url,myhead,function(code,content)
      self:setothercallback(code,content,callback)
    end)
   else
    if method == "post" then
      zHttp.post(self.url,data,myjshead,function(code,content)
        self:setothercallback(code,content,callback)
      end)
     elseif method == "put" then
      zHttp.put(self.url,data,myjshead,function(code,content)
        self:setothercallback(code,content,callback)
      end)
    end
  end
  return self
end


return base
