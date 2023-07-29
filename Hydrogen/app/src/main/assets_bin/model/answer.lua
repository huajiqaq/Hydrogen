--回答也相关数据类
--author huajiqaq
--time 2023-7-09
--self:对象本身
--TODO 针对pageinfo的获取是即时性的 也就代表如果pageinfo再次多加一个内容 可能会导致内容错位 一个解决方法是使用table本地存储 不过出现几率极低


local base={--表初始化
  isright=false,
  isleft=false,
  pageinfo={},
  getid=nil,
}

function base:new(id)--类的new方法
  local child=table.clone(self)
  child.id=id --这里的id是回答页id
  return child
end


function base:getAnswer(id,cb)
  local include='?include=ad_track_url%2Ccontent%2Ccreated_time%2Cupdated_time%2Creshipment_settings%2Cmark_infos%2Ccopyright_applications_count%2Cis_collapsed%2Ccollapse_reason%2Cannotation_detail%2Cis_normal%2Ccollaboration_status%2Creview_info%2Creward_info%2Crelationship.voting%2Crelationship.is_author%3Bsuggest_edit.unnormal_details%3Bcommercial_info%2Crelevant_info%2Csearch_words%2Cpagination_info'
  zHttp.get("https://api.zhihu.com/v4/answers/"..id..include,apphead
  ,function(a,b)
    if a==200 then
      cb(require "cjson".decode(b))
     elseif a==404 then
      AlertDialog.Builder(this)
      .setTitle("提示")
      .setMessage("发生错误 不存在该回答")
      .setCancelable(false)
      .setPositiveButton("我知道了",{onClick=function() activity.finish() end})
      .show()
    end
  end)
end


function base:getOneData(cb,z) --获取一条数据
  --判断id是否存在
  if self.getid then --如果数据存在
    --注释同上 这一步其实可以省略 但为了防止报错 所以加了
    if self.pageinfo.index then
      --判断是否为左滑
      if z==true then
        --获取过去的id表
        mygetid=self.pageinfo.prev_answer_ids
        --判断是否在最左
        self.isleft=(#mygetid>0 and {false} or {true})[1]
        --取出要访问的id 并保存
        self.getid=mygetid[#mygetid]
       else
        --注释同上
        mygetid=self.pageinfo.next_answer_ids
        self.isright=(#mygetid>0 and {false} or {true})[1]
        self.getid=mygetid[1]
      end
    end
    if self.getid then
      self:getAnswer(tointeger(self.getid),function(myz)
        --获取并存储pageinfo
        local mypageinfo=myz.pagination_info
        local mygetid
        if mypageinfo then
          self.pageinfo=mypageinfo
          --在请求后再次判断是否在最左or最右端
          self.isleft=(#self.pageinfo.prev_answer_ids>0 and {false} or {true})[1]
          self.isright=(#self.pageinfo.next_answer_ids>0 and {false} or {true})[1]
          --更新self.now 不过没什么用
          self.now=mypageinfo.index
        end
        cb(myz)
      end)
    end
  end

  return self
end

return base