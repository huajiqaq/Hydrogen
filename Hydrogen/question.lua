require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "com.michael.NoScrollGridView"
import "com.michael.NoScrollListView"
import "android.text.Html$TagHandler"
import "android.text.Html$ImageGetter"
question_id,是否记录历史记录=...
设置视图("layout/question")

波纹({fh,_more},"圆主题")
波纹({discussion,view,description},"方自适应")
--卡片布局
question_itemc=
{
  LinearLayout;
  layout_width="fill";
  BackgroundColor=backgroundc;
  orientation="horizontal";
  {
    CardView;
    layout_gravity="center";
    layout_height="-2";
    CardBackgroundColor=cardedge,
    Elevation="0";
    layout_width="fill";
    layout_margin="0dp";
    layout_marginTop="0dp";
    layout_marginBottom="0dp";
    radius="0dp";
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius="0dp";
      --      layout_margin="4px";
      layout_margin=cardmargin;
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
            id="question_id";
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
                id="question_image";
                layout_height="20dp",
                layout_width="20dp",
              };
              {
                TextView;
                id="question_author";
                layout_marginLeft="6dp",
                textColor=textc;
                gravity="center_vertical",
                Typeface=字体("product");
                textSize="14sp";
              };
            };
            {
              TextView;
              textSize="12sp";
              id="question_art";
              MaxLines=3;--设置最大输入行数
              letterSpacing="0.02";
              ellipsize="end",
              textColor=stextc;
              layout_marginTop="9dp";
              Typeface=字体("product");
            };
            {
              LinearLayout;
              layout_marginTop="9dp";
              orientation="horizontal";
              {
                ImageView;
                layout_gravity="center",
                layout_height="16dp",
                layout_width="16dp",
                src=图标("vote_up"),
                ColorFilter=textc;
              };
              {
                TextView;
                id="question_voteup";
                textSize="12sp";
                layout_marginLeft="6dp",
                textColor=textc;
                Typeface=字体("product");
              };
              {
                ImageView;
                layout_marginLeft="24dp",
                src=图标("message"),
                ColorFilter=textc;
                layout_height="16dp",
                layout_width="16dp",
                layout_gravity="center",
              };
              {
                TextView;
                layout_marginLeft="6dp",
                id="question_comment";
                textColor=textc;
                textSize="12sp";
                Typeface=字体("product");
              };
            };
          };
        };
      };
    };
  };
};



question_adp=LuaAdapter(activity,question_datas,question_itemc)



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
},nil,question_list),nil,false)

resultbar.Visibility=8

question_list.adapter=question_adp


function 刷新()

  question_base:next(function(r,a)
    if r==false and question_base.is_end==false then
      提示("获取回答列表出错 "..a)
      --  刷新()
     else
      resultbar.Visibility=8
    end
  end)
end


function bit.onScrollChange(a,b,j,y,u)
  if (bit.getChildAt(0).getMeasuredHeight()==bit.getScrollY()+bit.getHeight() and question_base.is_end==false) then
    resultbar.Visibility=0
    --sr.setRefreshing(true)
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

  --[[
  if this.getSharedData("标题简略化")=="true" then
    title.Text="问题"
   else]]
  title.Text=tab.title
  --  end

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
    --        //开启 数据库 存储功能
    .setDatabaseEnabled(false)
    .setCacheMode(WebSettings.LOAD_NO_CACHE);
   else
    show
    .getSettings()
    .setAppCacheEnabled(true)
    --//开启 DOM 存储功能
    .setDomStorageEnabled(true)
    --        //开启 数据库 存储功能
    .setDatabaseEnabled(true)
    .setCacheMode(2)
  end
  
  show.setWebViewClient{
    shouldOverrideUrlLoading=function(view,url)
      view.stopLoading()
      检查链接(url)
    end,
    onPageFinished=function(view,url)
  w = View.MeasureSpec.makeMeasureSpec(0,

View.MeasureSpec.UNSPECIFIED);

h = View.MeasureSpec.makeMeasureSpec(0,

View.MeasureSpec.UNSPECIFIED);
show.measure(w, h);

      if 全局主题值=="Night" then
        --      黑暗模式主题(view)
        加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=80,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
      end

      imgReset()

      view.evaluateJavascript([[(function(){
    var tags=document.getElementsByTagName("img");         
    for(var i=0;i<tags.length;i++) {
        tags[i].onclick=function(){
         var tag=document.getElementsByTagName("img"); 
         var t={};     
         for(var z=0;z<tag.length;z++) {
            t[z]=tag[z].src; 
            if (tag[z].src==this.src) {
               t[tag.length]=z;
            }                      
         };  
           
         window.androlua.execute(JSON.stringify(t));
        }                                  
     };  
    return tags.length;  
    })();]],{onReceiveValue=function(b)end})

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
      --      if 全局主题值=="Night" then
      --        加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
      --      end

    end,
    onLoadResource=function(view,url)
      --      if 全局主题值=="Night" then
      --        加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
      --      end

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

    Http.get("https://www.zhihu.com/api/v4/me",{
      ["cookie"] = 获取Cookie("https://www.zhihu.com/");
    },function(code,content)
      if code==200 then
                url=" https://www.zhihu.com/question/"..question_id.."/answers/editor"

        activity.newActivity("huida",{url,nil,true})
       elseif code==401 then
        提示("请登录后使用本功能")
      end
    end)
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