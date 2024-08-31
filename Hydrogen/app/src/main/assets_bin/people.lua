require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"

people_id=...

import "com.google.android.material.tabs.TabLayout"

activity.setContentView(loadlayout("layout/people"))

设置toolbar(toolbar)

初始化历史记录数据(true)
people_itemc=获取适配器项目布局("people/people")


if not(getLogin()) then
  提示("你可以登录使用更多过滤标签")
end


local base_people=require "model.people":new(people_id)
:getData(function(data,self)
  if data==false then
    _title.Text="获取用户信息失败"
    card.Visibility=8
    return false
  end
  local 名字=data.name
  大头像=data.avatar_url_template
  local 签名=data.headline
  用户id=data.id
  people_id=data.id

  if 签名=="" then
    签名="无签名"
  end

  保存历史记录("用户分割"..用户id,名字,签名)

  if 用户id~=nil and 用户id~="" and 用户id~=activity.getSharedData("idx") then
    people_o.setVisibility(View.VISIBLE)
  end

  local 获赞数=numtostr(data.voteup_count)
  local 粉丝数=numtostr(data.follower_count)
  local 关注数=numtostr(data.following_count)

  _voteup_count.Text=tostring(获赞数).."个获赞"
  _fans.Text=tostring(粉丝数).."个粉丝"
  _follow.Text=tostring(关注数).."个关注"
  function fans.onClick()
    if not(getLogin()) then
      return 提示("你需要登录使用本功能")
    end
    activity.newActivity("people_list",{名字.."的粉丝列表",用户id})
  end
  function follow.onClick()
    if not(getLogin()) then
      return 提示("你需要登录使用本功能")
    end
    activity.newActivity("people_list",{名字.."的关注列表",用户id})
  end

  if data.is_following then
    关注数量={[1]=粉丝数,[2]=numtostr(data.follower_count-1)}
    following.Text="取关";
   else
    关注数量={[1]=numtostr(data.follower_count+1),[2]=粉丝数}
    following.Text="关注";
  end

  _title.text=名字
  people_name.text=名字
  people_sign.text=签名

  图像.onClick=function()
    local data={["0"]=大头像,["1"]=1}
    this.setSharedData("imagedata",luajson.encode(data))
    activity.newActivity("image")
  end

  loadglide(图像,大头像)

  pop={
    tittle="用户",
    list={
      {
        src=图标("add"),text="拉黑",onClick=function(text)

          if not(getLogin()) then
            return 提示("请登录后使用本功能")
          end

          AlertDialog.Builder(this)
          .setTitle("提示")
          .setMessage("屏蔽过后如果想查看屏蔽的所有用户 可以在软件内主页右划 点击消息 选择设置 之后打开屏蔽即可管理屏蔽 你也可以选择管理屏蔽用户 但是这样没有选择设置可设置的多 如果只想查看屏蔽的用户 推荐选择屏蔽用户管理")
          .setPositiveButton("我知道了", {onClick=function()
              local mview=mpop.list[1]
              if text=="拉黑" then
                zHttp.post("https://api.zhihu.com/settings/blocked_users","people_id="..people_id,apphead,function(code,json)
                  if code==200 or code==201 then
                    mview.src=图标("close")
                    mview.text="取消拉黑"
                    提示("已拉黑")
                    a=MUKPopu(mpop)
                  end
                end)
               else
                zHttp.delete("https://api.zhihu.com/settings/blocked_users/"..people_id,posthead,function(code,json)
                  if code==200 then
                    mview.src=图标("add")
                    mview.text="拉黑"
                    提示("已取消拉黑")
                    a=MUKPopu(mpop)
                  end
                end)
              end
          end})
          .setNegativeButton("取消",nil)
          .show();

      end},
      {
        src=图标("add"),text="举报",onClick=function(text)

          if not(getLogin()) then
            return 提示("请登录后使用本功能")
          end

          local url="https://www.zhihu.com/report?id="..people_id.."&type=member"
          activity.newActivity("huida",{url.."&source=android&ab_signature=","举报"})

      end},
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
          .setPositiveButton("确定", {onClick=function()
              activity.newActivity("search_result",{edit.text,"people",用户id})
          end})
          .setNegativeButton("取消", nil)
          .show();

      end},
      {src=图标("share"),text="分享",onClick=function()
          local format="【用户】%s：%s"
          分享文本(string.format(format,名字,"https://www.zhihu.com/people/"..用户id))
      end},
    }
  }

  if data.is_blocking then
    pop.list[1].src=图标("close")
    pop.list[1].text="取消拉黑"
   else
    pop.list[1].src=图标("add")
    pop.list[1].text="拉黑"
  end

  a=MUKPopu(pop)

  self:getTab(function(self,tabname,urlinfo,answerindex)
    _G["urlinfo"]=urlinfo
    self:initpage(people_vpg,PeotabLayout)
    :setUrls(urlinfo)
    :addPage(2,tabname)
    :createfunc()
    :setOnTabListener(function(self,pos)
      _G["pos"]=pos
      if pos==answerindex then
        _sortvis.setVisibility(0)
       else
        _sortvis.setVisibility(8)
      end
    end)
    :refer(nil,nil,true)
  end)


end)

function 加载全部()
  base_people:next(function(r,a)
    if r==false and base_people.is_end==false then
      提示("获取个人动态列表出错 "..a or "")
     elseif base_people.is_end==false then
      add=true
    end
  end)
end

function _sort.onClick(view)
  local url=urlinfo[pos]
  pop=PopupMenu(activity,view)
  menu=pop.Menu
  menu.add("按时间排序").onMenuItemClick=function(a)
    if _sortt.text=="按时间排序" then
      return
    end
    _sortt.text="按时间排序"
    local url=replace_or_add_order_by(url,"created")
    people_pagetool
    :setUrlItem(url,pos)
    :clearItem(pos)
    :refer(pos,true)
  end
  menu.add("按赞数排序").onMenuItemClick=function(a)
    if _sortt.text=="按赞数排序" then
      return
    end
    _sortt.text="按赞数排序"
    local url=replace_or_add_order_by(url,"votenum")
    people_pagetool
    :setUrlItem(url,pos)
    :clearItem(pos)
    :refer(pos,true)
  end
  pop.show()--显示
end


波纹({fh,_more},"圆主题")

task(1,function()
  a=MUKPopu({
    tittle="用户",
    list={
    }
  })
end)

function onActivityResult(a,b,c)
  if b==100 then
    刷新(true)
  end
end