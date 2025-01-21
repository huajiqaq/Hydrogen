require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "android.text.Html$TagHandler"
import "android.text.Html$ImageGetter"
import "androidx.core.widget.NestedScrollView"

question_id=...

设置视图("layout/question")
设置toolbar(toolbar)

question_itemc=获取适配器项目布局("question/question")

波纹({fh,_more},"圆主题")
波纹({discussion,view,description,follow,open,star},"方自适应")

function 问题详情(code)

  import "com.google.android.material.bottomsheet.*"

  local dann={
    LinearLayout;
    layout_width=-1;
    {
      LinearLayout;
      orientation="vertical";
      layout_width=-1;
      layout_height=-2;
      Elevation="4dp";
      BackgroundColor=转0x(backgroundc);
      id="ztbj";
      {
        CardView;
        layout_gravity="center",
        CardBackgroundColor=转0x(cardedge);
        radius="3dp",
        Elevation="0dp";
        layout_height="6dp",
        layout_width="56dp",
        layout_marginTop="12dp";
      };

      {
        LinearLayout;
        orientation="horizontal";
        layout_width=-1;
        layout_height=-1;

        {
          TextView;
          textSize="20sp";
          layout_marginTop="12dp";
          layout_marginLeft="12dp";
          layout_marginRight="12dp";
          Text="问题详情";
          Typeface=字体("product-Bold");
          textColor=转0x(primaryc);
        };

        {
          LinearLayout;
          orientation="horizontal";
          layout_width=-1;
          layout_height="wrap";
          gravity="right|center";
          {
            MaterialButton_OutlinedButton;
            layout_marginLeft="12dp";
            layout_marginRight="12dp";
            textColor=转0x(stextc);
            text="关闭";
            Typeface=字体("product-Bold");
            id="close_button"
          };
        };

      };


      {
        LuaWebView;
        id="show",
        layout_width=-1;
        layout_height=-1;

      };
    };
  };

  local tmpview={}
  bottomSheetDialog = BottomSheetDialog(this)
  bottomSheetDialog.setContentView(loadlayout2(dann,tmpview))
  local an=bottomSheetDialog.show()
  bottomSheetDialog.setCancelable(true);
  bottomSheetDialog.behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
  bottomSheetDialog.behavior.setDraggable(false)
  --bottomSheetDialog.behavior.setHideable(false)
  tmpview.close_button.onClick=function()
    an.cancel()
  end

  local show=tmpview.show

  function imgReset()
    加载js(show,"(function(){" ..
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

  if activity.getSharedData("禁用缓存")=="true" then
    show
    .getSettings()
    .setAppCacheEnabled(false)
    --关闭 DOM 存储功能
    .setDomStorageEnabled(false)
    --关闭 数据库 存储功能
    .setDatabaseEnabled(false)
    .setCacheMode(WebSettings.LOAD_NO_CACHE);
   else
    show
    .getSettings()
    .setAppCacheEnabled(true)
    --开启 DOM 存储功能
    .setDomStorageEnabled(true)
    --开启 数据库 存储功能
    .setDatabaseEnabled(true)
    .setCacheMode(WebSettings.LOAD_DEFAULT)
  end

  show.setDownloadListener({
    onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
      webview下载文件(链接, UA, 相关信息, 类型, 大小)
  end})

  local z=JsInterface{
    execute=function(b)
      if b~=nil then
        --newActivity传入字符串过大会造成闪退 暂时通过setSharedData解决
        this.setSharedData("imagedata",b)
        activity.newActivity("image")
      end
    end
  }

  show.addJSInterface(z,"androlua")

  show.setWebViewClient{
    shouldOverrideUrlLoading=function(view,url)
      view.stopLoading()
      检查链接(url)
    end,
    onPageStarted=function(view,url,favicon)
      view.evaluateJavascript(获取js("imgload"),{onReceiveValue=function(b)end})
      网页字体设置(view)
    end,
    onPageFinished=function(view,url)
      if 全局主题值=="Night" then
        夜间模式回答页(view)
      end
      imgReset()

    end,

    onProgressChanged=function(view,Progress)
    end,
    onLoadResource=function(view,url)
    end,
    shouldInterceptRequest=拦截加载}

  show.Visibility=8
  show.BackgroundColor=转0x("#00000000",true);
  show.loadDataWithBaseURL(nil,code,"text/html","utf-8",nil);
  show.Visibility=0

end



question_base=require "model.question":new(question_id)
:getTag(function(name,url)
  tags.ids.load.parent.visibility=0
  tags:addTab(name,function()检查链接(url)end,2)
end)


question_base:getData(function(tab)

  question_pagetool=question_base:initpage(question_recy,questionsr)


  if tab==false then
    return
  end

  title.text=tab.title

  初始化历史记录数据()
  保存历史记录("问题分割"..question_id,tab.title,tab.excerpt)

  _comment.Text=tostring((tab.comment_count))
  _star.Text=tostring((tab.follower_count))
  _title.Text="共"..tostring((tab.answer_count)).."个回答"

  if #tab.excerpt>0 then
    description_text.Text=tab.excerpt
    openroot.visibility=0
   else
    description_card.visibility=8
  end

  问题预览=tab.detail

  if tab.relationship.is_following then
    关注数量={[1]=tointeger(_star.Text),[2]=tointeger(_star.Text)-1}
    _follow.text="已关注"
   else
    关注数量={[1]=tointeger(_star.Text+1),[2]=tointeger(_star.Text)}
    _follow.text="未关注"
  end

  _root.Visibility=0

  pop={
    tittle="问题",
    list={
      {src=图标("share"),text="分享",onClick=function()
          local format="【问题】%s：%s"
          分享文本(string.format(format,title.text,"https://www.zhihu.com/question/"..question_id))
        end,
        onLongClick=function()
          local format="【问题】%s：%s"
          分享文本(string.format(format,title.text,"https://www.zhihu.com/question/"..question_id),true)
      end},
      {src=图标("format_align_left"),text="按时间顺序",onClick=function()
          question_pagetool:setUrlItem(question_base:getUrl("updated"))
          :clearItem(pos)
          :refer(pos,nil,true)
      end},
      {src=图标("notes"),text="按默认顺序",onClick=function()
          question_pagetool:setUrlItem(question_base:getUrl())
          :clearItem(pos)
          :refer(pos,nil,true)
      end},
    }
  }

  a=MUKPopu(pop)

  loadglide(people_image,tab.author.avatar_url)
  username.text=tab.author.name
  userheadline.text=tab.author.headline

  if userheadline.text=="" then
    userheadline.text="暂无签名"
  end

  用户id=tab.author.id
  if tab.author.is_following then
    following.Text="取关";
   else
    following.Text="关注";
  end

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

if this.getSharedData("禁用缓存")=="true" then
  function onStop()
    show.clearCache(true)
    show.clearFormData()
    show.clearHistory()
  end
end

task(1,function()
  a=MUKPopu({
    tittle="问题",
    list={
    }
  })
end)