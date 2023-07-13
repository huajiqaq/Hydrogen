require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "android.text.Html$TagHandler"
import "android.text.Html$ImageGetter"
question_id,是否记录历史记录=...

设置视图("layout/question")

波纹({fh,_more},"圆主题")
波纹({discussion,view,description},"方自适应")

--卡片布局
question_itemc=获取适配器项目布局("question/question")

question_adp=MyLuaAdapter(activity,question_datas,question_itemc)

question_list.addFooterView(loadlayout({
  LinearLayout,
  layout_width="fill",
  layout_height="55dp",
  orientation="horizontal",
  gravity= "center",
  id="resultbar",
  {
    ProgressBar,
    layout_height="19dp",
    layout_width="19dp",
    ProgressBarBackground2=转0x(primaryc),
    style="?android:attr/progressBarStyleLarge"
  },
  {
    TextView,
    text="加载中",
    layout_marginLeft="15dp",
    Typeface=字体("product");
    textSize="14sp",
    gravity= "center",
    textColor=primaryc;
  },
},nil),nil,false)

resultbar.Visibility=8

question_list.adapter=question_adp


function 刷新()

  question_base:next(function(r,a)
    if r==false and question_base.is_end==false then
      提示("获取回答列表出错 "..a or "")
      --  刷新()
     else
      resultbar.Visibility=8
    end
  end)
end


function bit.onScrollChange(a,b,j,y,u)
  if (bit.getChildAt(0).getMeasuredHeight()==bit.getScrollY()+bit.getHeight() and question_base.is_end==false) then
    resultbar.Visibility=0
    刷新()
    System.gc()
  end
end


question_base=require "model.question":new(question_id)
:setresultfunc(function(tab)
  question_adp.add{
    question_author=tab.author.name,
    question_voteup=tointeger(tab.voteup_count).."",
    question_comment=tointeger(tab.comment_count).."",
    question_id=tointeger(tab.id),
    question_art=tab.excerpt,
    question_image=tab.author.avatar_url,
  }
end)
:getTag(function(name,url)
  tags.ids.load.parent.visibility=0
  tags:addTab(name,function()检查链接(url)end,2)
end)
:getData(function(tab)


  title.Text=tab.title

  if 是否记录历史记录 then
    初始化历史记录数据(true)
    保存历史记录(title.Text,question_id,50)
  end

  _comment.Text=tostring(tointeger(tab.comment_count))
  _star.Text=tostring(tointeger(tab.follower_count))
  _title.Text="共"..tostring(tointeger(tab.answer_count)).."个回答"


  if #tab.excerpt>0 then
    description.Text=tab.excerpt
   else
    description.visibility=8
  end
  description.onClick=function()
    description.setVisibility(8)
    show.setVisibility(0)
    show.loadUrl("")
  end

  function imgReset()
    show.loadUrl("javascript:(function(){" ..
    "var objs = document.getElementsByTagName('img'); " ..
    "for(var i=0;i<objs.length;i++) " ..
    "{"
    .. "var img = objs[i]; " ..
    " img.style.maxWidth = '100%'; img.style.height = 'auto'; " ..
    "}" ..
    "})()")
  end

  settings = show.getSettings();
  settings.setJavaScriptEnabled(true)

  if activity.getSharedData("禁用缓存")=="true"
    show
    .getSettings()
    .setAppCacheEnabled(false)
    --//开启 DOM 存储功能
    .setDomStorageEnabled(false)
    --//开启 数据库 存储功能
    .setDatabaseEnabled(false)
    .setCacheMode(WebSettings.LOAD_NO_CACHE);
   else
    show
    .getSettings()
    .setAppCacheEnabled(true)
    --//开启 DOM 存储功能
    .setDomStorageEnabled(true)
    --//开启 数据库 存储功能
    .setDatabaseEnabled(true)
    .setCacheMode(2)
  end

  show.setDownloadListener({
    onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
      webview下载文件(链接, UA, 相关信息, 类型, 大小)
  end})

  show.setWebViewClient{
    shouldOverrideUrlLoading=function(view,url)
      view.stopLoading()
      检查链接(url)
    end,
    onPageFinished=function(view,url)
      show.setFocusable(false)

      if 全局主题值=="Night" then
        加载js(view,获取js("darkpage"))
      end

      imgReset()

      view.evaluateJavascript(获取js("imgload"),{onReceiveValue=function(b)end})

      local z=JsInterface{
        execute=function(b)
          if b~=nil then
            activity.newActivity("image",{b})
          end
        end
      }

      view.addJSInterface(z,"androlua")

      if isLoaded == 1 then
       else
        isLoaded = 1
        show.loadDataWithBaseURL(nil,tab.detail,"text/html","utf-8",nil);
      end

    end,

    onProgressChanged=function(view,Progress)
    end,
    onLoadResource=function(view,url)
    end,
  }

end)

刷新()

question_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)
    local open=activity.getSharedData("内部浏览器查看回答")
    if open=="false" then
      activity.newActivity("answer",{question_id,tostring(v.Tag.question_id.Text),question_base:getChild(tointeger(v.Tag.question_id.Text))})
     else
      activity.newActivity("huida",{"https://www.zhihu.com/question/"..question_id.."/answer/"..tostring(v.Tag.question_id.Text)})
    end

  end
})

a=MUKPopu({
  tittle="问题",
  list={
    {src=图标("share"),text="分享",onClick=function()
        分享文本("https://www.zhihu.com/question/"..question_id)
    end},
    {src=图标("format_align_left"),text="按时间顺序",onClick=function()
        question_base:setSortBy("created")
        question_base:clear()
        question_adp.clear()
        刷新()
    end},
    {src=图标("notes"),text="按默认顺序",onClick=function()
        question_base:setSortBy("default")
        question_base:clear()
        question_adp.clear()
        刷新()
    end},
    {
      src=图标("colorize"),text="回答",onClick=function()
        if not(getLogin()) then
          return 提示("请登录后使用本功能")
        end
        local url=" https://www.zhihu.com/question/"..question_id.."/write"

        activity.newActivity("huida",{url,nil,true})
      end
    },
  }
})

if activity.getSharedData("问题提示0.01")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("你可点击问题的标题下面的区域来展开问题")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("问题提示0.01","true") end})
  .show()
end

function onActivityResult(a,b,c)
  if b==100 then
    activity.recreate()
  end

end

function onDestroy()
  show.destroy()
end