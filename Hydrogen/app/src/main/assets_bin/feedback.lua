require "import"
import "mods.muk"

activity.setContentView(loadlayout("layout/feedback"))
设置toolbar(toolbar)
波纹({fh,_more},"圆主题")
波纹({send},"圆自适应")


help_item={
  {--标题
    LinearLayout;

    layout_width="fill";
    layout_height="-2";
    {
      TextView;
      Focusable=true;
      layout_marginTop="12dp";
      layout_marginBottom="0dp";
      gravity="center_vertical";
      Typeface=字体("product");
      id="title";
      textSize="13sp";
      textColor=primaryc;
      layout_marginLeft="16dp";
    };
  };

  {--标题
    LinearLayout;

    layout_width="fill";
    layout_height="-2";
    {
      TextView;
      Focusable=true;
      layout_marginTop="12dp";
      layout_marginBottom="0dp";
      gravity="center_vertical";
      Typeface=字体("product");
      id="subtitle";
      textSize="15sp";
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
      layout_marginRight="16dp",
      layout_marginLeft="16dp",
      layout_margin="8dp";
    };
  };


};

data = {}
adp=LuaMultiAdapter(this,data,help_item)
adp.add{__type=2,subtitle="权限"}
adp.add{__type=3,content="    Hydrogen仅会申请本地存储权限，用于保存本地收藏以及一文文章，如您用不到上述功能，您可以选择不授予。"}
adp.add{__type=2,subtitle="声明"}
adp.add{__type=3,content="    Hydrogen 并无商业行为，仅作为个人兴趣业余开发。此应用并非破解，仅仅是一个简化后的浏览容器，相关付费内容仍需对应平台会员身份/购买。相关资源、文章版权归 知乎 原公司及原创作者所有。从未收集任何用户隐私，应用内所有内容直接请求官方接口，所有操作产生的数据都保留在用户本地。"}
adp.add{__type=2,subtitle="视频无法播放？"}
adp.add{__type=3,content="    请升级你的Webview"}
adp.add{__type=2,subtitle="软件有点卡？"}
adp.add{__type=3,content="    没错是这样的"}
adp.add{__type=2,subtitle="软件安不安全？"}
adp.add{__type=3,content="    通过网页登录不会存储你的账号信息，所有数据均直接请求于官方接口"}


help_list.setAdapter(adp)


send.onClick=function()
  send.setVisibility(8)
  progress.setVisibility(0)
  task(300,function()
    send.setVisibility(0) progress.setVisibility(8)
    local 单选列表={"使用Gitee Issues反馈","使用Github Issues反馈","使用QQ反馈"}
    local dofun={
      function()
        双按钮对话框("提示","不推荐使用Gitee Issues反馈 使用该方式必须要实名才可提交","继续","取消",function(an)
          浏览器打开("https://gitee.com/huajicloud/Hydrogen/issues")
          关闭对话框(an)
          end,function(an)
          关闭对话框(an)
        end)
      end,
      function()
        浏览器打开("https://github.com/huajiqaq/Hydrogen/issues")
      end,
      function()
        local uri=Uri.parse("mqqwpa://im/chat?chat_type=wpa&uin=1906327347")
        if not(pcall(activity.startActivity,Intent(Intent.ACTION_VIEW,uri))) then
          提示("你没安装QQ")
         else
          提示("跳转成功 请使用QQ反馈Bug")
        end
    end}
    dialog=AlertDialog.Builder(this)
    .setTitle("请选择反馈方式")
    .setSingleChoiceItems(单选列表,-1,{onClick=function(v,p)
        dofun[p+1]()
        dialog.dismiss()
    end})
    .setPositiveButton("关闭",nil)
    .show()
  end)
end