require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "com.lua.*"
import "android.text.SpannableString"
import "android.view.inputmethod.InputMethodManager"
import "android.text.Html"
import "android.text.SpannableStringBuilder"
import "android.text.style.ClickableSpan"
import "android.text.style.URLSpan"
import "android.text.method.LinkMovementMethod"
import "android.text.style.UnderlineSpan"
activity.setContentView(loadlayout("layout/search_result"))


波纹({fh,_more},"圆主题")

result=...

if result==nil or #result<1 then
  activity.finish()
end

_title.Text="搜索 "..result.." 的结果"

local search_itemc=
{
  LinearLayout;
  layout_width="-1";
  orientation="horizontal";
  BackgroundColor=backgroundc;
  {
    CardView;
    layout_gravity="center";
    layout_height="-2";
    CardBackgroundColor=cardedge,
    Elevation="0";
    layout_width="-1";
    layout_margin="16dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    radius="8dp";
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius=dp2px(8)-2;
      layout_margin="2px";
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
          padding="16dp";
          layout_width="-1";
          id="search_ripple",
          {
            TextView;
            id="search_id";
            textSize="0sp";
          };
          {
            LinearLayout;
            orientation="vertical";

            {
              TextView;
              textSize="14sp";
              id="search_title";
              textColor=textc;
              layout_marginTop="2dp";
              Typeface=字体("product-Bold");

            };
            {
              TextView;
              textSize="12sp";
              id="search_art";
              textColor=stextc;
              MaxLines=3;--设置最大输入行数
              ellipsize="end",
              layout_marginTop="4dp";
              layout_marginBottom="4dp";
              Typeface=字体("product-Medium");
            };
            {
              LinearLayout;
              layout_marginTop="2dp";
              orientation="horizontal";
              id="search_ban",
              {
                ImageView;
                layout_gravity="center",
                layout_height="16dp",
                layout_width="16dp",
                src=图标("vote_up"),
                id="search_voteup2";
                ColorFilter=textc;
              };
              {
                TextView;
                id="search_voteup";
                layout_marginLeft="6dp",
                textSize="12sp";
                textColor=textc;
                Typeface=字体("product");
              };
              {
                ImageView;
                layout_marginLeft="24dp",
                src=图标("message"),
                ColorFilter=textc;
                layout_height="16dp",
                id="search_message2";
                layout_width="16dp",
                layout_gravity="center",
              };
              {
                TextView;
                layout_marginLeft="6dp",
                textSize="12sp";
                id="search_message";
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




search_list.addFooterView(loadlayout({
  LinearLayout,
  layout_width="fill",
  layout_height="45dp",
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
},nil,search_list),nil,false)

resultbar.Visibility=8

local madp,tmp=LuaAdapter(activity,search_itemc),{}

mpage=1
tmptab={}

search_list.setAdapter(madp)


function getUrl(a,b)
  return "https://www.sogou.com/sogou?query="..a.."&insite=zhihu.com&page="..b.."&ie=utf8"
end


function setSpan(t)
  local function MySpan(z)
    if tmptab[z] then

     else
      Http.get("https://www.sogou.com"..tostring(z),function(a,b)
        local url=b:match([[URL='(.-)']])
        tmptab[url]=url

        --activity.newActivity("answer",{v.Tag.seaech_id.Text,nil})
      end)
    end
    local mySpan=ClickableSpan{
      onClick=function(v)
        if tmptab[z] then
          检查链接(tmptab[z])
         else
          Http.get("https://www.sogou.com"..tostring(z),function(a,b)
            local url=b:match([[URL='(.-)']])
            tmptab[z]=url
            检查链接(url)
            --activity.newActivity("answer",{v.Tag.seaech_id.Text,nil})
          end)
        end
      end
    }
    return mySpan
  end
  local len= t.length()
  local tabs=luajava.astable(t.getSpans(0, len, URLSpan))
  if #tabs>0 then
    local style = SpannableStringBuilder(t);
    style.clearSpans()
    for i=1,#tabs do
      style.setSpan(MySpan(tabs[i].getURL()), t.getSpanStart(tabs[i]), t.getSpanEnd(tabs[i]), Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
      style.setSpan(UnderlineSpan(), t.getSpanStart(tabs[i]), t.getSpanEnd(tabs[i]), Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
    end
    return style,true
   else
    return t,false
  end
end




function 刷新(url)


  Http.get(url,function(a,b)
    if a==200 then

      for k,v in b:gmatch([[<div class%="vrwrap">(.-)<div class%="fb"]]) do

        local murl,c=k:match([[<h3 class="vrTitle">(.-)</a>]]):match([[href="(.-)">(.+)]])

        if tmp[murl] then continue end
        tmp[murl]=1
        Http.get("https://www.sogou.com"..murl,function(a,b)
          local url=b:match([[URL='(.-)']])
          tmptab[b]=url
        end)

        if not(c) then
          local c=k:match([[alt="(.-)"]]):match("(.+)_知乎")--<em><!--red_beg-->特朗普<!--red_end--></em>终于瞒不住了,德国带头力挺华为 高通用“假5..._知乎"")--<em><!%-%-red_beg%-%->(.-)<!%-%-red_end%-%-></em>(.-)_知乎"),
         else
          c=c:match("(.+)_知乎") or c
        end

        local zhihumes=k:match([[<div class="zhihu%-msg">(.-)</div>]])
        local 回答数,关注数,zhihuvis="","",0;
        local message=k:match([[div class="text%-layout">(.+)]]):match(">(.+)")
        if message:find("<i class") then message=message:match("i>(.+)") end
        if zhihumes~=nil then
          zhihumes=(filter_spec_chars(zhihumes))

          回答数,关注数=zhihumes:match([[(.+)个回答]]),zhihumes:match("nbspnbsp(.-)人关注")

         else
          zhihuvis=8
        end


        local span,istrue=setSpan(Html.fromHtml(message))
        local addTag={text=span}

        if istrue==true then
          addTag["MovementMethod"]=LinkMovementMethod.getInstance()
         else
          table.join(addTag,{
            focusable=false;
            clickable=false;

          })
        end
        if not(tmptab[murl]) then
          Http.get("https://www.sogou.com"..tostring(murl),function(a,b)
            local url=b:match([[URL='(.-)']])
            tmptab[url]=murl
          end)
        end

        madp.add{
          search_title={text=Html.fromHtml(c),focusable=false,clickable=false},
          search_message2={visibility=zhihuvis},
          search_voteup2={visibility=zhihuvis},
          search_message={
            text=回答数,
            visibility=zhihuvis;
          },
          search_ban={
            visibility=zhihuvis,
          },
          search_art=addTag,
          search_voteup={
            text=关注数,
            visibility=zhihuvis;
          },
          search_id=murl,
        }


      end

      --  print(a,b)--dump(require "cjson".decode(b)))
     else
      提示("查找搜索失败 "..b)
    end
  end)
end


刷新(getUrl(result,mpage))

search_list.onItemClick=function(a,b,c,d)
  local murl=tostring(b.tag.search_id.text)
  if tmptab[murl] then
    检查链接(tmptab[murl])
   else
    Http.get("https://www.sogou.com"..tostring(murl),function(a,b)
      local url=b:match([[URL='(.-)']])
      tmptab[murl]=url
      检查链接(tmptab[murl])
      --activity.newActivity("answer",{v.Tag.seaech_id.Text,nil})
    end)
  end
end

search_list.setOnScrollListener{
  onScroll=function(view,a,b,c)
    if a+b==madp.getCount() and search_list.getLastVisiblePosition()==madp.getCount()-1 and resultbar.Visibility==8 and madp.getCount()>0 then
      if search_list.getChildAt(search_list.getChildCount() - 1).getBottom() >= search_list.getHeight() then
        resultbar.Visibility=0
        mpage=mpage+1
        刷新(getUrl(result,mpage))
      end
    end

  end
}

a=MUKPopu({
  tittle="搜索",
  list={
    {
      src=图标("refresh"),text="刷新",onClick=function()
        if resultbar.Visibility==0 then
          刷新(getUrl(result,mpage))
         else
          mpage=mpage+1
          刷新(getUrl(result,mpage))
        end
        提示("正在刷新中")
      end
    },
    {src=图标("email"),text="反馈",onClick=function()
        activity.newActivity("feedback")
    end},
  }
})