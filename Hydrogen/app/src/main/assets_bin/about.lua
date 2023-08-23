require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"

设置视图("layout/about")

波纹({fh},"圆主题")
波纹({recheck_text,download_text},"方自适应")

控件隐藏(card_root)
控件隐藏(download)
控件隐藏(recheck)


about_item={
  {--标题
    LinearLayout;

    layout_width="fill";
    layout_height="-2";
    {
      TextView;
      Focusable=true;
      layout_marginTop="12dp";
      layout_marginBottom="12dp";
      gravity="center_vertical";
      Typeface=字体("product");
      id="title";
      textSize="15sp";
      textColor=primaryc;
      layout_marginLeft="16dp";
    };
  };

  {--图片,标题,简介
    LinearLayout;
    gravity="center";
    layout_width="fill";
    layout_height="64dp";
    {
      ImageView;
      layout_height="25dp";
      id="image";
      --padding="10dp";
      layout_width="25dp";
      layout_marginLeft="15dp";
      ColorFilter=textc;
    };
    {
      LinearLayout;
      orientation="vertical";
      layout_height="fill";
      gravity="center_vertical";
      layout_weight="1";
      {
        TextView;
        id="subtitle";
        textSize="16sp";
        textColor=textc;
        Typeface=字体("product");
        layout_marginLeft="16dp";
      };
      {
        TextView;
        textColor=stextc;
        id="message";
        textSize="14sp";
        Typeface=字体("product");
        layout_marginLeft="16dp";
      };
    };
  };

  {--图片,标题
    LinearLayout;
    layout_width="fill";
    layout_height="64dp";
    gravity="center_vertical";
    {
      ImageView;
      layout_height="25dp";
      id="image";
      --padding="10dp";
      layout_width="25dp";
      layout_marginLeft="15dp";
      ColorFilter=textc;
    };
    {
      TextView;
      id="subtitle";
      Typeface=字体("product");
      textSize="16sp";
      textColor=textc;
      layout_marginLeft="16dp";
    };
  };

  {--图片,标题
    LinearLayout;
    layout_width="fill";
    layout_height="64dp";
    gravity="center_vertical";
    {
      CircleImageView;
      layout_height="25dp";
      id="image";
      --padding="10dp";
      layout_width="25dp";
      layout_marginLeft="15dp";
    };
    {
      TextView;
      id="subtitle";
      Typeface=字体("product");
      textSize="16sp";
      textColor=textc;
      layout_marginLeft="16dp";
    };
  };
  {--文字
    LinearLayout;
    layout_width="-1";
    layout_height="-2";
    gravity="center_vertical";
    {

      TextView;
      id="content";
      Typeface=字体("product");
      textSize="14sp";
      textColor=textc;
      textIsSelectable=true,
      layout_margin="16dp";
    };
  };


};


appinfo=this.getPackageManager().getPackageInfo(this.getPackageName(),(0))

versionName=tostring(appinfo.versionName)

data = {}
adp=LuaMultiAdapter(this,data,about_item)
adp.add{__type=2,image=图标(""),subtitle="当前版本",message=versionName.."("..versionCode..")"}
adp.add{__type=3,image=图标(""),subtitle="前往官网"}
adp.add{__type=2,image=图标(""),subtitle="提交BUG",message="提出建议或反馈"}
adp.add{__type=3,image=图标(""),subtitle="开源地址"}

about_list.setAdapter(adp)



function check_update()
  控件可见(card_root)
  控件可见(recheck)
  update_title.Text="检查更新"
  update_message.Text="正在检查更新"
  update_info.Text="正在检查更新"
  local update_api="https://gitee.com/api/v5/repos/huaji110/huajicloud/contents/zhihu_hydrogen.html?access_token=abd6732c1c009c3912cbfc683e10dc45"

  Http.get(update_api,function(code,content)
    if code==200 then
      local content_json=require("cjson").decode(content)
      local content=base64dec(content_json.content)
      updateversioncode=tonumber(content:match("updateversioncode%=(.+),updateversioncode"))
      if updateversioncode > versionCode
        then
        控件可见(card_root)
        控件可见(download)
        updateversionname=content:match("updateversionname%=(.+),updateversionname")
        update_message.Text="发现新版本"..updateversionname.."("..updateversioncode..")"
        updateinfo=content:match("updateinfo%=(.+),updateinfo")
        update_info.Text=updateinfo
        updateurl=tostring(content:match("updateurl%=(.+),updateurl"))
        update_title.Text="更新•正式版"
       else
        控件可见(card_root)
        控件可见(recheck)
        update_title.Text="无可用更新"
        update_message.Text="您已是最新版本"
        update_info.Text="点击下方按钮重新检查更新"
      end
     else
      控件可见(card_root)
      update_message.Text="检查更新失败，请检查网络连接后再试"
      update_title.Text="更新"
      update_info.Text=""
      控件可见(recheck)
    end
  end)
end


about_list.setOnItemClickListener(AdapterView.OnItemClickListener{

  onItemClick=function(id,v,zero,one)

    if v.Tag.subtitle.Text=="当前版本" then
      check_update()
    end

    if v.Tag.subtitle.Text=="前往官网" then
      浏览器打开("https://myhydrogen.gitee.io/")
    end

    if v.Tag.subtitle.Text=="提交BUG" then
      activity.newActivity("feedback")
    end
    if v.Tag.subtitle.Text=="开源地址" then
      浏览器打开("https://gitee.com/huajicloud/Hydrogen/")
    end

    adp.notifyDataSetChanged()--更新列表
end})