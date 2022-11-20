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
              lineHeight="20sp";
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
    标题="一个想法"
    问题id="想法分割"..v.target.id
    预览内容=v.target.content[1].content
   else
    问题id="文章分割"..tointeger(v.target.id)
    标题=v.target.title
  end
  people_list.Adapter.add{people_action=活动,people_art=预览内容,people_vote=点赞数,people_comment=评论数,people_question=问题id,people_title=标题,people_image=头像}

end)


function 刷新()
  提示("加载中")
  base_people:next(function(r,a)
    if r==false and base_people.is_end==false then
      提示("获取个人动态列表出错 "..a)
      --  刷新()

    end
  end)
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




people_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)
    保存历史记录(v.Tag.people_title.Text,v.Tag.people_url.Text,50)
    local open=activity.getSharedData("内部浏览器查看回答")
    if tostring(v.Tag.people_question.text):find("文章分割") then
      activity.newActivity("column",{tostring(v.Tag.people_question.Text):match("文章分割(.+)"),tostring(v.Tag.people_question.Text):match("分割(.+)")})
     elseif tostring(v.Tag.people_question.text):find("话题分割") then
      activity.newActivity("huida",{"https://www.zhihu.com/topic/"..tostring(v.Tag.people_question.Text):match("话题分割(.+)")})
     elseif tostring(v.Tag.people_question.text):find("问题分割") then
      activity.newActivity("question",{tostring(v.Tag.people_question.Text):match("(.+)问题分割")})
     elseif tostring(v.Tag.people_question.text):find("想法分割") then
      activity.newActivity("column",{tostring(v.Tag.people_question.Text):match("想法分割(.+)"),"想法"})
     else
      if open=="false" then
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
