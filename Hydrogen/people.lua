require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "com.michael.NoScrollListView"
import "com.michael.NoScrollGridView"

people_id=...

activity.setContentView(loadlayout("layout/people"))

初始化历史记录数据(true)
波纹({followtext},"方自适应")


people_itemc=
{
  LinearLayout;
  layout_width="-1";
  orientation="horizontal";
  --background=backgroundc,
  BackgroundColor=backgroundc;
  {
    CardView;
    layout_gravity="center";
    layout_height="-2";
    CardBackgroundColor=cardedge,
    Elevation="0";
    layout_width="-1";
    layout_margin="0dp";
    layout_marginTop="0dp";
    layout_marginBottom="0dp";
    radius="0dp";
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius="0dp";
      layout_margin="4px";
      layout_width="-1";
      layout_height="-1";
      {
        LinearLayout;
        layout_height="fill";
        id="background";
        layout_width="fill";
        ripple="圆自适应",

        {
          LinearLayout;
          orientation="horizontal";
          padding="24dp";
          paddingTop="18dp";
          paddingBottom="18dp";
          {
            TextView;
            id="people_url";
            textSize="0sp";
          };
          {
            LinearLayout;
            orientation="vertical";
            {
              LinearLayout;
              orientation="horizontal";
              {
                CircleImageView;
                layout_width="20dp",
                layout_height="20dp",
                id="people_image",
              };
              {
                TextView;
                id="people_action";
                layout_marginLeft="6dp",
                textColor=stextc;
                layout_gravity="center_vertical",
                Typeface=字体("product");
                textSize="12sp";
              };
              {
                TextView;
                id="people_question";
                textSize="0sp";
              };

            };
            {
              TextView;
              textSize="14sp";
              id="people_title";
              textColor=textc;
              letterSpacing="0.02";
              layout_marginTop="8dp";
              Typeface=字体("product-Bold");

            };
            {
              TextView;
              textSize="12sp";
              id="people_art";
              textColor=stextc;
              MaxLines=3;--设置最大输入行数
              letterSpacing="0.02";
              ellipsize="end",
              layout_marginTop="8dp";
              Typeface=字体("product");
            };
            {
              LinearLayout;
              layout_marginTop="8dp";
              orientation="horizontal";
              id="people_palne",
              {
                ImageView;
                src=图标("vote_up"),
                ColorFilter=textc;
                layout_height="16dp",
                layout_width="16dp",
              };
              {
                TextView;
                id="people_vote";
                layout_marginLeft="6dp",
                textColor=textc;
                textSize="12sp";
                Typeface=字体("product");
              };
              {
                ImageView;
                layout_marginLeft="24dp",
                src=图标("message"),
                ColorFilter=textc;
                layout_height="16dp",
                layout_width="16dp",
              };
              {
                TextView;
                layout_marginLeft="6dp",
                textSize="12sp";
                id="people_comment";
                textColor=textc;
                Typeface=字体("product");
              };
            };
          };
        };
      };
    };
  };
};

local people_adp=LuaAdapter(activity,people_datas,people_itemc)



people_list.adapter=people_adp

local base_people=require "model.people":new(people_id)
:getData(function(data)
  local 名字=data.name
  头像=data.avatar_url
  local 大头像=data.avatar_url_template
  local 签名=data.headline
  用户id=data.id

  if 用户id~=nil and 用户id~="" and 用户id~=activity.getSharedData("idx") then
    following.setVisibility(View.VISIBLE)
  end
  if data.is_following then
    followtext.Text="取消关注";
  end
  function following.onClick()
    if followtext.Text=="立即关注"
      Http.post("https://api.zhihu.com/people/"..用户id.."/followers","",{
        ["cookie"] = 获取Cookie("https://www.zhihu.com/");
        ["Content-Type"] = ""
        },function(a,b)
        if a==200 then
          followtext.Text="取消关注";
          提示("关注成功")
        end
      end)
     elseif followtext.Text=="取消关注"
      Http.delete("https://api.zhihu.com/people/"..用户id.."/followers/"..activity.getSharedData("idx"),{
        ["cookie"] = 获取Cookie("https://www.zhihu.com/");
        ["Content-Type"] = ""
        },function(a,b)
        if a==200 then
          followtext.Text="立即关注";
          提示("取关成功")
        end
      end)
    end
  end

  _title.Text=名字
  people_name.Text=名字
  people_sign.Text=签名
  people_image.setImageBitmap(loadbitmap(大头像))

end)


:setresultfunc(function(v)
  local 活动=v.action_text
  --  local 预览内容=v.target.excerpt_new
  local 预览内容=v.target.excerpt
  local 点赞数=tointeger(v.target.voteup_count)
  local 评论数=tointeger(v.target.comment_count)
  if v.target.type=="answer" then
    问题id=tointeger(v.target.question.id or 1).."分割"..tointeger(v.target.id)
    标题=v.target.question.title
   elseif v.target.type=="topic" then
    people_list.Adapter.add{people_action=活动,people_art={Visibility=8},people_palne={Visibility=8},people_comment={Visibility=8},people_question="话题分割"..v.target.id,people_title=v.target.name,people_image=头像}
    return
   elseif v.target.type=="question" then
    问题id=tointeger(v.target.id or 1).."问题分割"
    标题=v.target.title
   elseif v.target.type=="column" then
    return
   elseif v.target.type=="collection" then
    return
   elseif v.target.type=="pin" then
    标题=v.target.author.name.."发表了想法"
    问题id="想法分割"..v.target.id
    预览内容=v.target.content[1].content
   else
    问题id="文章分割"..tointeger(v.target.id)
    标题=v.target.title
  end
  people_list.Adapter.add{people_action=活动,people_art=预览内容,people_vote=点赞数,people_comment=评论数,people_question=问题id,people_title=标题,people_image=头像}

end)

local head = {
  ["x-api-version"] = "3.0.89";
  ["x-app-za"] = "OS=Android";
  ["x-app-version"] = "8.44.0";
  ["cookie"] = 获取Cookie("https://www.zhihu.com/")
}

chobu="all"

function 全部()
  _sort.setVisibility(8)
  base_people:next(function(r,a)
    if r==false and base_people.is_end==false then
      提示("获取个人动态列表出错 "..a)
      --  刷新()
    end
  end)
end

local myurl={}

function 其他(isclear)
  if chobu=="all" then
    if isclear=="clear" then
      base_people:clear()
    end
    return 全部()
  end
  if isclear=="clear" then
    myurl[chobu]=nil
  end
  if chobu=="搜索" then
    return search_base:getData()
   else
    if search_base then
      search_base:clear()
    end
  end
  geturl=myurl[chobu] or "https://api.zhihu.com/people/"..people_id.."/"..chobu.."s?order_by=created&offset=0&limit=20"
  _sort.setVisibility(8)
  if chobu=="zvideo" then
    geturl=myurl[chobu] or "https://api.zhihu.com/members/"..people_id.."/"..chobu.."s?order_by=created&offset=0&limit=20"
   elseif chobu=="answer"
    _sort.setVisibility(0)
    if _sortt.text=="按赞数排序" then
      geturl=myurl[chobu] or "https://api.zhihu.com/people/"..people_id.."/answers?order_by=votenum&offset=0&limit=20"
    end
  end

  Http.get(geturl,head,function(code,content)
    if code==200 then
      if require "cjson".decode(content).paging.next then
        testurl=require "cjson".decode(content).paging.next
        if testurl:find("http://") then
          testurl=string.gsub(testurl,"http://","https://",1)
        end
        myurl[chobu]=testurl
      end
      if require "cjson".decode(content).paging.is_end and isclear~="clear" then
        提示("已经没有更多内容了")
       else
        提示("加载中")
      end
      for i,v in ipairs(require "cjson".decode(content).data) do
        --  local 预览内容=v.excerpt_new
        local 预览内容=v.excerpt
        local 点赞数=tointeger(v.voteup_count)
        local 评论数=tointeger(v.comment_count)
        if v.type=="answer" then
          活动="回答了问题"
          问题id=tointeger(v.question.id or 1).."分割"..tointeger(v.id)
          标题=v.question.title
         elseif v.type=="topic" then
          people_list.Adapter.add{people_action=活动,people_art={Visibility=8},people_palne={Visibility=8},people_comment={Visibility=8},people_question="话题分割"..v.id,people_title=v.name,people_image=头像}
          return
         elseif v.type=="question" then
          活动="发布了问题"
          问题id=tointeger(v.id or 1).."问题分割"
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
        people_list.Adapter.add{people_action=活动,people_art=预览内容,people_vote=点赞数,people_comment=评论数,people_question=问题id,people_title=标题,people_image=头像}
      end
    end
  end)
end

Http.get("https://api.zhihu.com/people/"..people_id.."/profile/tab",head,function(code,content)

  if code==200 then
    for i,v in ipairs(require "cjson".decode(content).tabs_v3[1].sub_tab) do
      if v.name~="更多" then
        if v.number>0 then
          num=" "..tostring(tointeger(v.number))
         else
          num=""
        end
        peotab:addTab(v.name..num,function() pcall(function()people_list.adapter.clear()end) chobu=v.key 其他("clear") people_list.adapter.notifyDataSetChanged() end,3)
      end
      peotab:showTab(1)
    end
  end
end)


function 刷新()
  --[[
  base_people:next(function(r,a)
    if r==false and base_people.is_end==false then
      提示("获取个人动态列表出错 "..a)
      
      --  刷新()
      


    end
  end)
  ]]
  其他()
end

刷新()


add=true

function bit.onScrollChange(a,b,j,y,u)
  if (add and bit.getChildAt(0).getMeasuredHeight()==bit.getScrollY()+bit.getHeight() and base_people.is_end==false) then
    add=false
    task(2000,function()add=true
    end)
    --sr.setRefreshing(true)
    刷新()
    System.gc()

  end
end

function _sort.onClick(view)
  if chobu=="answer" then
    pop=PopupMenu(activity,view)
    menu=pop.Menu
    menu.add("按时间排序").onMenuItemClick=function(a)
      if _sortt.text=="按时间排序" then
        return
      end
      _sortt.text="按时间排序"
      pcall(function()people_list.adapter.clear()end)
      其他("clear")
      people_list.adapter.notifyDataSetChanged()
    end
    menu.add("按赞数排序").onMenuItemClick=function(a)
      if _sortt.text=="按赞数排序" then
        return
      end
      _sortt.text="按赞数排序"
      pcall(function()people_list.adapter.clear()end)
      其他("clear")
      people_list.adapter.notifyDataSetChanged()
    end
    pop.show()--显示
   else
  end
end

function nochecktitle(str)
  local oridata=people_list.adapter.getData()

  for b=1,2 do
    if b==2 then
      提示("搜索完毕 共搜索到"..#people_list.adapter.getData().."条数据")
      if #people_list.adapter.getData()==0 then
        其他("clear")
      end
    end
    for i=#oridata,1,-1 do
      if not oridata[i].people_title:find(str) then
        table.remove(oridata, i)
        people_list.adapter.notifyDataSetChanged()
      end
    end
  end
end

function checktitle(str)
  Http.get("https://www.zhihu.com/api/v4/me",{
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
    },function(code,content)
    if code==200 then
      if okstart=="true" then--开启
        local 请求链接="https://www.zhihu.com/api/v4/search_v3?correction=1&t=general&q="..urlEncode(str).."&restricted_scene=member&restricted_field=member_hash_id&restricted_value="..people_id
        chobu="搜索"
        提示("搜索中 请耐心等待")
        pcall(function()people_list.Adapter.clear()end)
        search_base=require "model.dohttp"
        :new(请求链接)
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
            if v.object.type=="answer" then
              活动="回答了问题"
              问题id=tointeger(v.object.question.id or 1).."分割"..tointeger(v.object.id)
              标题=v.object.question.name
             elseif v.object.type=="topic" then
              people_list.Adapter.add{people_action=活动,people_art={Visibility=8},people_palne={Visibility=8},people_comment={Visibility=8},people_question="话题分割"..v.object.id,people_title=v.object.name,people_image=头像}
              return
             elseif v.object.type=="question" then
              活动="发布了问题"
              问题id=tointeger(v.object.id or 1).."问题分割"
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
            people_list.Adapter.add{people_action=活动,people_art=预览内容,people_vote=点赞数,people_comment=评论数,people_question=问题id,people_title=标题,people_image=头像}
            people_list.adapter.notifyDataSetChanged()
          end
        end)
        search_base:getData()
       else
        nochecktitle(str)
      end
     elseif code==401 then
      nochecktitle(str)
    end
  end)


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
        保存历史记录(v.Tag.people_title.Text,v.Tag.people_url.Text,50)
        activity.newActivity("answer",{tostring(v.Tag.people_question.Text):match("(.+)分割"),tostring(v.Tag.people_question.Text):match("分割(.+)")})
       else
        activity.newActivity("huida",{"https://www.zhihu.com/question/"..tostring(v.Tag.follow_id.Text):match("(.+)分割").."/answer/"..tostring(v.Tag.follow_id.Text):match("分割(.+)")})
      end
    end
  end
})

波纹({fh,_more},"圆主题")


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
        .setPositiveButton("确定", {onClick=function() checktitle(edit.text) end})
        .setNegativeButton("取消", nil)
        .show();

    end},
    {src=图标("share"),text="分享",onClick=function()
        分享文本("https://www.zhihu.com/people/"..用户id)
    end},
    --[[    {src=图标("share"),text="关注",onClick=function()
     Http.post("https://api.zhihu.com/people/"..用户id.."/followers","",,{
      ["cookie"] = 获取Cookie("https://www.zhihu.com/")
    },function(a,b)
            if a==200 then
提示("关注成功")
            end
          end)
    end},
    {src=图标("share"),text="取关",onClick=function()
        分享文本("删除 后加自己用户"..用户id)
    end},]]
  }
})
