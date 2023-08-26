require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "android.text.Html$TagHandler"
import "android.text.Html$ImageGetter"
import "androidx.core.widget.NestedScrollView"

question_id,是否记录历史记录=...

设置视图("layout/question")


--卡片布局
question_itemc=获取适配器项目布局("question/question")

question_adp=MyLuaAdapter(activity,question_datas,question_itemc)

task(1,function()
  question_list.addHeaderView(loadlayout({
    LinearLayout;
    layout_width="-1";
    --        padding="8dp";
    orientation="vertical";
    layout_height="-1";
    background=backgroundc,
    --          layoutTransition=LayoutTransition().enableTransitionType(LayoutTransition.CHANGING),
    {
      MyTab
      {
        id="tags",
        type=2
      },
      visibility=8,
      background=backgroundc,
      layout_marginLeft="10dp",
    },
    {
      CardView;
      CardBackgroundColor=cardedge,
      Elevation="0";
      radius="0dp";
      layout_margin="0dp",
      layout_marginTop="0dp",
      layout_marginBottom="0dp",
      layout_width="-1";
      layout_height="-2";
      {
        CardView;
        CardElevation="0dp";
        CardBackgroundColor=backgroundc;
        Radius="0dp";
        --              layout_margin="4px";
        layout_margin=cardmargin;
        layout_width="-1";
        layout_height="-1";
        {
          LinearLayout;
          layout_width="-1";
          orientation="vertical";
          padding="24dp";
          paddingTop="16dp";
          paddingBottom="16dp";
          layout_height="-1";
          {
            LinearLayout;
            orientation="vertical";
            layout_height="-2",
            {
              TextView;
              textSize="19.5sp";
              Typeface=字体("product-Bold");
              textColor=textc,
              letterSpacing="0.02";
              id="title",
              text="加载中";
              layout_width="-1";
              layout_marginTop="8dp";
            };
            {
              RelativeLayout;
              id="letgo";
              layout_width="-1";
              layout_height="wrap_content";
              {
                LuaWebView;
                layout_marginTop="8dp";
                id="show",
                layout_width="-1";

                layout_height="wrap_content",
              };
            };

            {
              TextView;
              typeface=字体("product");
              textSize="12sp";
              letterSpacing="0.02";
              textColor=textc,
              MaxLines=3;
              layout_width="-1";
              ellipsize="end",
              id="description",
              text="加载中";
              layout_marginTop="8dp";
              Visibility=0,
            };
          };
          {
            LinearLayout;
            layout_width="-1";
            layout_height="-1";
            padding="4dp";
            layout_marginTop="8dp";
            {
              CardView;
              layout_width="-2";
              layout_height="-2";
              radius="4dp";
              CardBackgroundColor=backgroundc;
              Elevation="0";
              {
                LinearLayout;
                id="view",
                onClick=function()end;
                padding="4dp",
                orientation="horizontal";
                {
                  ImageView;
                  colorFilter=textc,
                  layout_width="18dp";
                  layout_height="18dp";
                  src=图标("star");
                };
                {
                  TextView;
                  id="_star",
                  layout_marginLeft="4dp",
                  layout_width="-1";
                  layout_height="-1";
                  gravity="center";
                  Typeface=字体("product");
                  textColor=textc,
                  text="0";
                };
              };
            };
            {
              CardView;
              layout_width="-2";
              layout_height="-2";
              radius="4dp";
              cardBackgroundColor=backgroundc;
              Elevation="0";
              layout_marginLeft="32dp";
              {
                LinearLayout;
                onClick=function()
                  activity.newActivity("comment",{question_id,"questions"})
                end;
                id="discussion",
                padding="4dp",
                orientation="horizontal";
                {
                  ImageView;
                  colorFilter=textc,
                  layout_width="18dp";
                  layout_height="18dp";
                  src=图标("message");
                };
                {
                  TextView;
                  id="_comment",
                  layout_marginLeft="4dp",
                  layout_width="-1";
                  layout_height="-1";
                  gravity="center";
                  Typeface=字体("product");
                  textColor=textc,
                  text="0";
                };
              };
            };
          };
        };
      };
    };
  },nil),nil,false)
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
      ProgressBarBackground=转0x(primaryc),
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
  波纹({fh,_more},"圆主题")
  波纹({discussion,view,description},"方自适应")
end)

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

add=true

question_list.setOnScrollListener{
  onScrollStateChanged=function(view,scrollState)
    if scrollState == 0 then
      if view.getCount() >1 and view.getLastVisiblePosition() == view.getCount() - 1 and add then
        add=false
        刷新()
        resultbar.Visibility=0
        System.gc()
        add=false
        Handler().postDelayed(Runnable({
          run=function()
            add=true
          end,
        }),1000)
      end
    end
  end
}




question_base=require "model.question":new(question_id)
:setresultfunc(function(tab)
  if tab.excerpt == nil or tab.excerpt=="" then
    if tab.media_detail and tab.media_detail.videos
      if #tab.media_detail.videos>0 then
        tab.excerpt="[视频]"
      end
    end
  end
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
    show.loadUrl("")
    show.setHorizontalScrollBarEnabled(false);
    show.setVerticalScrollBarEnabled(false);
    show.setVisibility(0)
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
      --   show.setFocusable(false)

      if 全局主题值=="Night" then
        黑暗页(view)
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

task(1,function()
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
end)

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