local base={
  nextUrl=nil,
  is_end=false,
  data={},
}




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




function base:getData(callback)
  Http.post("https://x-zes-96.huajicloud.ml/api",self.md5str,head,function(code,content)
    if code==200 then
      Http.get(self.url,{
        ["cookie"] = 获取Cookie("https://www.zhihu.com/");
        ["x-api-version"] = "3.0.91";
        ["x-zse-93"] = "101_3_3.0";
        ["x-zse-96"] = "2.0_"..content;
        ["x-app-za"] = "OS=Web";
        },function(codee,contentt)
        if codee==200 then
          local data=require "cjson".decode(contentt)
          if data.paging.is_end then
            --[[          
           if #data.data==0 then
           提示("没有搜索到相关数据")
           else]]
            提示("已经到底啦")
            --            end
           else
            初始化(data.paging.next,self)
            self.resultfunc(data)
          end
         elseif codee==403 then
          提示("出错 请重新尝试")
        end
      end)
     elseif code==500
      return 提示("出错")
    end
  end)
  return self
end


return base
