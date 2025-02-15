
require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "android.text.method.LinkMovementMethod"
import "com.google.android.material.bottomsheet.*"
import "com.google.android.material.chip.ChipGroup"
import "com.google.android.material.chip.Chip"
import "android.content.res.ColorStateList"
import "android.view.inputmethod.InputMethodManager"
import "com.google.android.material.textfield.TextInputLayout"
import "com.google.android.material.textfield.TextInputEditText"
import "android.content.res.ColorStateList"
comment_id,comment_type,保存路径,父回复id=...
local Chip = luajava.bindClass "com.google.android.material.chip.Chip"
import "com.google.android.material.floatingactionbutton.FloatingActionButton"

设置视图("layout/comment")
--activity.setContentView(loadlayout("layout/comment"))
edgeToedge(mainLay,send)
addAutoHideListener({comment_recy},{send})
波纹({fh,_more},"圆主题")




if comment_type=="local_chat" then
  internetnet.setVisibility(8)
  localcomment.setVisibility(0)

  comment_itemc=获取适配器项目布局("comment/comments_reply")

  sadapter=LuaAdapter(activity,comment_itemc)
  local_comment_list.setAdapter(sadapter)

  function getCommentData(filename, func)
    local file = io.open(filename, "r")
    local currentAuthor = nil
    local currentContentBuffer = ""

    for line in file:lines() do
      -- 检查是否开始一个新的author行
      if line:find('author="') then
        currentAuthor = line:match('author="([^"]+)"')
        currentContentBuffer = "" -- 重置content缓冲区
       else
        -- 累积content，直到找到结束引号
        currentContentBuffer = currentContentBuffer .. line
        local contentEndIndex = currentContentBuffer:find('"', 10) -- content从第10个字符开始
        if contentEndIndex then
          local currentContent = currentContentBuffer:sub(9, contentEndIndex - 1)
          func(currentAuthor, currentContent)
          currentAuthor = nil
          currentContentBuffer = "" -- 处理完一对后重置缓冲区
        end
      end
    end

    file:close()
  end


  getCommentData(comment_idl,function(用户名,内容)
    local myspan
    if 内容:find("https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]") then
      myspan=setstyle(Html.fromHtml(内容))
     else
      myspan=Html.fromHtml(内容)
    end


    sadapter.add{
      标题=用户名,
      预览内容={
        text=myspan,
        MovementMethod=LinkMovementMethod.getInstance(),
        Focusable=false,
        onLongClick=function(v)
          复制文本=v.Text
          import "android.content.*"
          activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(复制文本)
          提示("复制文本成功")
        end
      },
      提示内容={Visibility=8}
    }

  end)


  --对话列表 显示第一个的提示内容
  local_comment_listl.adapter.getData()[1].提示内容.Visibility=0
  local_comment_listl.adapter.notifyDataSetChanged()

  local_comment_listl.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(id,v,zero,one)
      if v.Tag.提示内容.getVisibility()==0 then
        提示("当前已在该对话列表内")
      end
  end})

  _title.text="对话列表"
end

if not(comment_type:find("local")) then
  send.onClick=function()
    发送评论("")
  end
  踩tab={}
  comment_item=获取适配器项目布局("comment/comment")
  if comment_type=="comments" then
    --楼中楼
    _title.text="对话列表"
  end
  --评论
  comment_base=require "model.comment"
  :new(comment_id,comment_type)
  comment_pagetool=comment_base
  :initpage(comment_recy,commentsr)
end


task(1,function()
  a=MUKPopu({
    tittle="评论",
    list={
      {src=图标("format_align_left"),text="按时间顺序",onClick=function()
          local comment_pagetool,comment_base=_G["comment_pagetool"],_G["comment_base"]
          comment_pagetool:setUrlItem(comment_base:getUrlByType("ts"))
          :clearItem()
          :refer(nil,nil,true)
      end},
      {src=图标("notes"),text="按默认顺序",onClick=function()
          local comment_pagetool,comment_base=_G["comment_pagetool"],_G["comment_base"]
          comment_pagetool:setUrlItem(comment_base:getUrlByType("score"))
          :clearItem()
          :refer(nil,nil,true)
      end},
    }
  })
end)

if comment_type:find("local") then
  task(1,function()
    a=MUKPopu({
      tittle=_title.text,
      list={

      }
    })
  end)
end

function onActivityResult(a,b,c)
  if b==100 then
    if comment_type~="local" then
      comment_base:clear()
      comment_list.Adapter.clear()
    end
  end
end