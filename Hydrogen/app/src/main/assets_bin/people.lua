require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"

people_id,是否记录=...

activity.setContentView(loadlayout("layout/people"))

初始化历史记录数据(true)
波纹({followtext},"方自适应")
波纹({sixintext},"方自适应")


people_itemc=获取适配器项目布局("people/people")

local people_adp=MyLuaAdapter(activity,people_datas,people_itemc)


task(1,function()
  people_list.addHeaderView(loadlayout({
    LinearLayout;
    layout_height="-1";
    orientation="vertical";
    layout_width="-1";
    {
      MaterialCardView;
      --    layout_marginBottom="0dp";
      layout_width="-1";
      radius="8dp";
      layout_height="-2";
      layout_marginTop="0dp";
      layout_margin="16dp";
      Elevation="0";
      StrokeColor=cardedge;
      StrokeWidth=dp2px(1),
      {
        LinearLayout;
        layout_height="-1";
        orientation="vertical";
        padding="16dp";
        layout_width="-1";
        {
          LinearLayout;
          layout_height="-1";
          orientation="vertical";
          layout_width="-1";
          {
            CircleImageView;
            layout_height="64dp";
            layout_width="64dp";
            layout_gravity="center";
            src="logo",
            id="people_image",
          };
          {
            TextView;
            gravity="center";
            id="people_name",
            textSize="20sp";
            textColor=textc,
            Typeface=字体("product-Bold");
            layout_gravity="center";
            layout_marginTop="10dp";
          };
          {
            TextView;
            layout_marginTop="5dp";
            textColor=textc,
            id="people_sign",
            Typeface=字体("product");
            layout_gravity="center";
            --                    singleLine=true;
          };
          {
            LinearLayout;
            id="people_o";
            layout_marginTop="10dp",
            layout_width="-1";
            layout_height="-1",
            gravity="center",
            Visibility=View.GONE;
            {
              CardView;
              layout_marginRight="10dp";
              id="following";
              layout_width="-2";
              layout_height="-2";
              radius="4dp";
              layout_gravity="center",
              --background=primaryc;
              CardBackgroundColor=primaryc;
              {
                TextView;
                id="followtext",
                layout_width="-1";
                layout_height="-1";
                textSize="14sp";
                paddingRight="12dp";
                paddingLeft="12dp";
                paddingTop="8dp";
                paddingBottom="8dp";
                Text="关注";
                textColor=backgroundc;
                gravity="center";
                Typeface=字体("product-Bold");
              };
            };
            {
              CardView;
              id="sixin";
              layout_width="-2";
              layout_height="-2";
              radius="4dp";
              layout_gravity="center",
              --background=primaryc;
              CardBackgroundColor=primaryc;
              {
                TextView;
                id="sixintext",
                layout_width="-1";
                layout_height="-1";
                textSize="14sp";
                paddingRight="12dp";
                paddingLeft="12dp";
                paddingTop="8dp";
                paddingBottom="8dp";
                Text="私信";
                textColor=backgroundc;
                gravity="center";
                Typeface=字体("product-Bold");
              };
            };
          };
        };
      };
    };
    {
      MyTab
      {
        id="peotab",
      },
      contentDescription="关注标签",
    };
    {
      LinearLayout;
      layout_width="fill";
      orientation="horizontal";
      layout_height="fill";
      id="_sortvis";
      Visibility=8;
      {
        TextView;
        id="_num";
      };
      {
        LinearLayout;
        layout_gravity="end";
        gravity="end";
        layout_width="match_parent";
        {
          LinearLayout;
          layout_gravity="center";
          gravity="center";
          id="_sort";
          layout_width="wrap_content";
          {
            TextView;
            id="_sortt";
            text="按时间排序";
          };
          {
            ImageView;
            ColorFilter=textc;
            src=图标("keyboard_arrow_down");
          };
        };
      };
    };
  },nil),nil,false)
  function _sort.onClick(view)
    if chobu=="answer" then
      pop=PopupMenu(activity,view)
      menu=pop.Menu
      menu.add("按时间排序").onMenuItemClick=function(a)
        if _sortt.text=="按时间排序" then
          return
        end
        _sortt.text="按时间排序"
        pcall(function()people_adp.clear()end)
        其他("clear",false)
        people_adp.notifyDataSetChanged()
      end
      menu.add("按赞数排序").onMenuItemClick=function(a)
        if _sortt.text=="按赞数排序" then
          return
        end
        _sortt.text="按赞数排序"
        pcall(function()people_adp.clear()end)
        其他("clear",false)
        people_adp.notifyDataSetChanged()
      end
      pop.show()--显示
     else
    end
  end
end)

people_list.adapter=people_adp

local base_people=require "model.people":new(people_id)
:getData(function(data)
  local 名字=data.name
  local 大头像=data.avatar_url_template
  local 签名=data.headline
  用户id=data.id

  if 是否记录 then
    保存历史记录(名字,"用户分割"..用户id,50)
    是否记录=false
  end

  if 用户id~=nil and 用户id~="" and 用户id~=activity.getSharedData("idx") then
    people_o.setVisibility(View.VISIBLE)
  end
  if data.is_following then
    followtext.Text="取关";
  end
  function following.onClick()
    if followtext.Text=="关注"
      zHttp.post("https://api.zhihu.com/people/"..用户id.."/followers","",posthead,function(a,b)
        if a==200 then
          followtext.Text="取关";
          提示("关注成功")
         elseif a==500 then
          提示("请登录后使用本功能")
        end
      end)
     elseif followtext.Text=="取关"
      zHttp.delete("https://api.zhihu.com/people/"..用户id.."/followers/"..activity.getSharedData("idx"),posthead,function(a,b)
        if a==200 then
          followtext.Text="关注";
          提示("取关成功")
        end
      end)
    end
  end

  function sixin.onClick()
    if not(getLogin()) then
      return 提示("你需要登录使用本功能")
    end
    activity.newActivity("huida",{"https://www.zhihu.com/messages/"..people_id,true,true})
  end

  _title.Text=名字
  people_name.Text=名字
  people_sign.Text=签名
  loadglide(people_image,大头像)

end)

:setresultfunc(function(v)
  local 活动=v.source.action_text
  --  local 预览内容=v.target.excerpt_new
  local 预览内容=v.target.excerpt
  local 点赞数=tointeger(v.target.voteup_count)
  local 评论数=tointeger(v.target.comment_count)
  local 头像=v.source.actor.avatar_url
  if v.target.type=="answer" then
    问题id=tointeger(v.target.question.id) or "null"
    问题id=问题id.."分割"..tointeger(v.target.id)
    标题=v.target.question.title
   elseif v.target.type=="topic" then
    people_adp.add{people_action=活动,people_art={Visibility=8},people_palne={Visibility=8},people_comment={Visibility=8},people_question="话题分割"..v.target.id,people_title=v.target.name,people_image=头像}
    return
   elseif v.target.type=="question" then
    问题id=tointeger(v.target.id).."问题分割"
    标题=v.target.title
   elseif v.target.type=="column" then
    return
   elseif v.target.type=="collection" then
    return
   elseif v.target.type=="moments_pin" then
    标题=v.target.author.name.."发表了想法"
    问题id="想法分割"..tostring(v.target.id)
    预览内容=v.target.content[1].content
   else
    问题id="文章分割"..tointeger(v.target.id)
    标题=v.target.title
  end
  people_adp.add{people_action=活动,people_art=预览内容,people_vote=点赞数,people_comment=评论数,people_question=问题id,people_title=标题,people_image=头像}

end)

chobu="all"

function 全部()
  if _sortvis then
    _sortvis.setVisibility(8)
  end
  base_people:next(function(r,a)
    if r==false and base_people.is_end==false then
      提示("获取个人动态列表出错 "..a or "")
      --  刷新()
     elseif base_people.is_end==false then
      add=true
    end
  end)
end

local myurl={}

function 其他(isclear,isload)
  add=false
  if chobu=="all" then
    if isclear=="clear" then
      add=true
      base_people:clear()
    end
    if isload==false
      return
    end
    return 全部()
  end
  if isclear=="clear" then
    add=true
    myurl[chobu]=nil
  end
  if isload==false
    return
  end
  if chobu=="搜索" then
    if isclear=="clear" then
      add=true
      下一页数据=false
      search_base:clear()
    end
    if isload==false
      return
    end
    return search_base:getData(nil,nil,function()
      add=true
    end)
  end
  if chobu=="no搜索" then
    local oridata=people_adp.getData()

    for b=1,2 do
      if b==2 then
        提示("搜索完毕 共搜索到"..#people_adp.getData().."条数据")
        if #people_adp.getData()==0 then
          chobu="all"
          其他("clear",false)
        end
      end
      for i=#oridata,1,-1 do
        if not oridata[i].people_title:find(搜索内容) then
          table.remove(oridata, i)
          people_adp.notifyDataSetChanged()
        end
      end
    end
    return
  end
  geturl=myurl[chobu] or "https://api.zhihu.com/people/"..people_id.."/"..chobu.."s?order_by=created&offset=0&limit=20"
  _sortvis.setVisibility(8)
  if chobu=="zvideo" then
    geturl=myurl[chobu] or "https://api.zhihu.com/members/"..people_id.."/"..chobu.."s?order_by=created&offset=0&limit=20"
   elseif chobu=="answer"
    _sortvis.setVisibility(0)
    if _sortt.text=="按赞数排序" then
      geturl=myurl[chobu] or "https://api.zhihu.com/people/"..people_id.."/answers?order_by=votenum&offset=0&limit=20"
    end
  end

  zHttp.get(geturl,apphead,function(code,content)
    if code==200 then
      if luajson.decode(content).paging.next then
        testurl=luajson.decode(content).paging.next
        if testurl:find("http://") then
          testurl=string.gsub(testurl,"http://","https://",1)
        end
        myurl[chobu]=testurl
      end
      if luajson.decode(content).paging.is_end and isclear~="clear" then
        提示("已经没有更多内容了")
       else
        add=true
      end
      for i,v in ipairs(luajson.decode(content).data) do
        local 预览内容=v.excerpt
        local 点赞数=tointeger(v.voteup_count)
        local 评论数=tointeger(v.comment_count)
        pcall(function()
          local 头像=v.author.avatar_url
        end)
        if v.type=="answer" then
          活动="回答了问题"
          问题id=tointeger(v.question.id) or "null"
          问题id=问题id.."分割"..tointeger(v.id)
          标题=v.question.title
         elseif v.type=="topic" then
          people_adp.add{people_action=活动,people_art={Visibility=8},people_palne={Visibility=8},people_comment={Visibility=8},people_question="话题分割"..v.id,people_title=v.name,people_image=头像}
          return
         elseif v.type=="question" then
          活动="发布了问题"
          问题id=tointeger(v.id).."问题分割"
          标题=v.title
         elseif v.type=="column" then
          活动="发表了专栏"
          问题id="专栏分割"..v.id.."专栏标题"..v.title
          评论数=tointeger(v.items_count)
          标题=v.title

         elseif v.type=="collection" then
          return
         elseif v.type=="pin" then
          活动="发布了想法"
          标题=v.author.name.."发布了想法"
          问题id="想法分割"..v.id
          预览内容=v.content[1].content
         elseif v.type=="zvideo" then
          活动="发布了视频"
          xpcall(function()
            videourl=v.video.playlist.sd.url
            end,function()
            videourl=v.video.playlist.ld.url
            end,function()
            videourl=v.video.playlist.hd.url
          end)
          问题id="视频分割"..videourl
          标题=v.title
         else
          活动="发表了文章"
          问题id="文章分割"..tointeger(v.id)
          标题=v.title
        end
        people_adp.add{people_action=活动,people_art=预览内容,people_vote=点赞数,people_comment=评论数,people_question=问题id,people_title=标题,people_image=头像}
      end
    end
  end)
end

zHttp.get("https://api.zhihu.com/people/"..people_id.."/profile/tab",apphead,function(code,content)
  if code==200 then
    for i,v in ipairs(luajson.decode(content).tabs_v3[1].sub_tab) do
      if v.name~="更多" then
        if v.number>0 then
          num=" "..tostring(tointeger(v.number))
         else
          num=""
        end
        peotab:addTab(v.name..num,function() pcall(function()people_adp.clear()end) chobu=v.key 其他("clear",false) people_adp.notifyDataSetChanged() end,3)
      end
      peotab:showTab(1)
    end
  end
end)


function 刷新()
  其他()
end


add=true


people_list.setOnScrollListener{
  onScroll=function(view,a,b,c)
    --[[
    if chobu=="搜索" then
    if search_base.is_end then
    print("hhh")
    return
    end
   elseif base_people.is_end then
   print("jsjsje")
   return
   end
]]

    if a+b==c and add then
      刷新()
      System.gc()
    end
  end
}

function nochecktitle(str)
  chobu="no搜索"
  add=false
  刷新()
end

function checktitle(str)

  搜索内容=str

  if not(getLogin()) then
    return nochecktitle(str)
  end

  if isstart=="true" then--开启
    add=true
    chobu="搜索"
    --提示("搜索中 请耐心等待")
    local 请求链接="https://www.zhihu.com/api/v4/search_v3?correction=1&t=general&q="..urlEncode(str).."&restricted_scene=member&restricted_field=member_hash_id&restricted_value="..people_id

    pcall(function()people_adp.clear()end)
    search_base=require "model.dohttp"
    :new(下一页数据 or 请求链接)
    :setresultfunc(function(data)
      -- local 搜索结果数量=tointeger(data.search_action_info.lc_idx)
      提示("搜索完毕")
      下一页数据=data.paging.next
      peotab:showTab(1)
      _sort.setVisibility(8)
      for i,v in ipairs(data.data) do
        local 预览内容=v.object.excerpt
        local 点赞数=tointeger(v.object.voteup_count)
        local 评论数=tointeger(v.object.comment_count)
        pcall(function()
          头像=v.object.author.avatar_url
        end)
        if v.object.type=="answer" then
          活动="回答了问题"
          问题id=tointeger(v.object.question.id) or "null"
          问题id=问题id.."分割"..tointeger(v.object.id)
          标题=v.object.question.name
         elseif v.object.type=="topic" then
          people_adp.add{people_action=活动,people_art={Visibility=8},people_palne={Visibility=8},people_comment={Visibility=8},people_question="话题分割"..v.object.id,people_title=v.object.name,people_image=头像}
          return
         elseif v.object.type=="question" then
          活动="发布了问题"
          问题id=tointeger(v.object.id).."问题分割"
          标题=v.object.title
         elseif v.object.type=="column" then
          活动="发表了专栏"
          问题id="专栏分割"..v.object.id.."专栏标题"..v.object.title
          评论数=tointeger(v.object.items_count)
          标题=v.object.title

         elseif v.object.type=="collection" then
          return
         elseif v.object.type=="pin" then
          活动="发布了想法"
          标题=v.object.author.name.."发布了想法"
          问题id="想法分割"..v.object.id
          预览内容=v.object.content[1].content
         elseif v.object.type=="zvideo" then
          活动="发布了视频"
          xpcall(function()
            videourl=v.object.video.playlist.sd.url
            end,function()
            videourl=v.object.video.playlist.ld.url
            end,function()
            videourl=v.object.video.playlist.hd.url
          end)
          问题id="视频分割"..videourl
          标题=v.object.title
         else
          活动="发表了文章"
          问题id="文章分割"..tointeger(v.object.id)
          标题=v.object.title
        end
        people_adp.add{people_action=活动,people_art=预览内容,people_vote=点赞数,people_comment=评论数,people_question=问题id,people_title=标题,people_image=头像}
        people_adp.notifyDataSetChanged()
      end
    end)
   else
    nochecktitle(str)
  end

end

people_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)
    local open=activity.getSharedData("内部浏览器查看回答")
    if tostring(v.Tag.people_question.text):find("文章分割") then
      activity.newActivity("column",{tostring(v.Tag.people_question.Text):match("文章分割(.+)"),tostring(v.Tag.people_question.Text):match("分割(.+)")})
     elseif tostring(v.Tag.people_question.text):find("话题分割") then
      activity.newActivity("huida",{"https://www.zhihu.com/topic/"..tostring(v.Tag.people_question.Text):match("话题分割(.+)")})
     elseif tostring(v.Tag.people_question.text):find("问题分割") then
      activity.newActivity("question",{tostring(v.Tag.people_question.Text):match("(.+)问题分割")})
     elseif tostring(v.Tag.people_question.text):find("想法分割") then
      activity.newActivity("column",{tostring(v.Tag.people_question.Text):match("想法分割(.+)"),"想法"})
     elseif tostring(v.Tag.people_question.Text):find("视频分割") then
      activity.newActivity("huida",{tostring(v.Tag.people_question.Text):match("视频分割(.+)")})
     elseif tostring(v.Tag.people_question.Text):find("专栏分割") then
      activity.newActivity("people_column",{tostring(v.Tag.people_question.Text):match("专栏分割(.+)专栏标题"),tostring(v.Tag.people_question.Text):match("专栏标题(.+)")})
     else
      if open=="false" then
        activity.newActivity("answer",{tostring(v.Tag.people_question.Text):match("(.+)分割"),tostring(v.Tag.people_question.Text):match("分割(.+)"),nil,true})
       else
        activity.newActivity("huida",{"https://www.zhihu.com/question/"..tostring(v.Tag.follow_id.Text):match("(.+)分割").."/answer/"..tostring(v.Tag.follow_id.Text):match("分割(.+)")})
      end
    end
  end
})

波纹({fh,_more},"圆主题")

task(1,function()
  a=MUKPopu({
    tittle="用户",
    list={
      {
        src=图标("search"),text="在当前内容中搜索",onClick=function()
          InputLayout={
            LinearLayout;
            orientation="vertical";
            Focusable=true,
            FocusableInTouchMode=true,
            {
              EditText;
              hint="输入";
              layout_marginTop="5dp";
              layout_marginLeft="10dp",
              layout_marginRight="10dp",
              layout_width="match_parent";
              layout_gravity="center",
              id="edit";
            };
          };

          AlertDialog.Builder(this)
          .setTitle("请输入")
          .setView(loadlayout(InputLayout))
          .setPositiveButton("确定", {onClick=function() 其他("clear",false) checktitle(edit.text) end})
          .setNegativeButton("取消", nil)
          .show();

      end},
      {src=图标("share"),text="分享",onClick=function()
          分享文本("https://www.zhihu.com/people/"..用户id)
      end},
    }
  })
end)

function onActivityResult(a,b,c)
  if b==100 then
    其他("clear",false)
  end
end