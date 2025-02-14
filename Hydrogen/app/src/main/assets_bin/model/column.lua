--想法 专栏 视频项目的获取类
--author huajiqaq
--time 2023-9-1
--self:对象本身


local base={}

function base:new(id,type)--类的new方法
  local child=table.clone(self)
  child.id=id
  child.type=type
  child:getinfo()
  return child
end

function base:setinfo(key,value)
  if value then
    value=value..self.id
    self[key]=value
  end
  return self
end

function base:getinfo()
  local type1=self.type
  local geturl,weburl,type2,fxurl
  switch type1
   case "文章"
    geturl="https://www.zhihu.com/api/v4/articles/"
    weburl="https://www.zhihu.com/appview/p/"
    type2="article"
    fxurl="https://zhuanlan.zhihu.com/p/"
   case "想法"
    geturl="https://www.zhihu.com/api/v4/pins/"
    weburl="https://www.zhihu.com/appview/pin/"
    type2="pin"
    fxurl="https://www.zhihu.com/appview/pin/"
   case "视频"
    geturl="https://www.zhihu.com/api/v4/zvideos/"
    weburl="https://www.zhihu.com/zvideo/"
    type2="zvideo"
    fxurl="https://www.zhihu.com/zvideo/"
   case "直播"
    geturl="https://api.zhihu.com/drama/theaters/"
    weburl="https://www.zhihu.com/theater/"
    type2="drama"
    fxurl=weburl
   case "圆桌"
    weburl="https://www.zhihu.com/roundtable/"
    fxurl="https://www.zhihu.com/roundtable/"
   case "专题"
    weburl="https://www.zhihu.com/special/"
    fxurl="https://www.zhihu.com/special/"
  end

  self.urltype=type2
  self:setinfo("geturl",geturl)
  :setinfo("weburl",weburl)
  :setinfo("fxurl",fxurl)

  return self
end


function base:getData(cb,issave)
  local url=self.geturl
  if not url then
    if self.weburl then
      return cb(true)
    end
    return
  end
  zHttp.get(url,head,function(a,b)
    if a==200 then
      local b=luajson.decode(b)
      local type1=self.type

      if issave then
        switch type1
         case "文章","想法","视频"
          local title=b.title
          if type1=="想法" then
            title=获取想法标题(b.content[1].title or "")
          end
          if title=="" then
            title="一个"..type1
          end
          --修复想法标题获取异常的问题
          b.title=title
          保存历史记录(type1.."分割"..self.id,title,b.excerpt_title or b.excerpt or "")
          local username=b.author.name
          b.savepath=内置存储文件("Download/"..title.."/"..username)
        end
      end
      cb(b)
     else
      cb(false)
    end
  end)
end


return base