require "import"
import "mods.muk"

activity.setContentView(loadlayout("layout/feedback"))
设置toolbar(toolbar)
波纹({fh,_more},"圆主题")
波纹({send},"圆自适应")

activity.SupportActionBar.setDisplayHomeAsUpEnabled(true)

toolbar.Title="反馈内容"
local originalTitle = toolbar.Title

import "androidx.appcompat.widget.Toolbar"
for i=0,toolbar.getChildCount() do
  local view = toolbar.getChildAt(i);
  if luajava.instanceof(view,TextView) then
    if view.getText()==originalTitle then
      local textView = view;
      textView.setGravity(Gravity.CENTER);
      local params = Toolbar.LayoutParams(Toolbar.LayoutParams.WRAP_CONTENT, Toolbar.LayoutParams.MATCH_PARENT);
      params.gravity = Gravity.CENTER;
      textView.setLayoutParams(params);
      textView.setTextSize(18)
    end
  end
end


help_item={
  {--标题 内容 type1
    LinearLayout;
    layout_width="fill";
    layout_height="wrap";
    orientation="vertical";
    {
      TextView;
      layout_marginTop="12dp";
      layout_marginBottom="0dp";
      gravity="center_vertical";
      Typeface=字体("product-Bold");
      id="title";
      textSize="15sp";
      textColor=primaryc;
      layout_marginLeft="16dp";
    };
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

  {--分割线 type2
    LinearLayout;
    layout_width="-1";
    layout_height="-2";
    gravity="center|left";
    onClick=function()end;
    {
      TextView;
      layout_width="-1";
      layout_height="3px";
      background=cardback,
    };
  };


};


data = {
  {__type=1,title="权限", content="Hydrogen仅会申请本地存储权限，用于保存本地收藏以及一文文章，如您用不到上述功能，您可以选择不授予。"},
  {__type=1,title="声明", content="Hydrogen 并无商业行为，仅作为个人兴趣业余开发。此应用并非破解，仅仅是一个简化后的浏览容器，相关付费内容仍需对应平台会员身份/购买。相关资源、文章版权归 知乎 原公司及原创作者所有。从未收集任何用户隐私，应用内所有内容直接请求官方接口，所有操作产生的数据都保留在用户本地。"},
  {__type=1,title="视频无法播放？", content="请升级你的Webview"},
  {__type=1,title="软件有点卡？", content="没错是这样的"},
  {__type=1,title="软件安不安全？", content="通过网页登录不会存储你的账号信息，所有数据均直接请求于官方接口"}
}

for k, v in ipairs(data) do
  if v.__type == 1 then
    table.insert(data, k + 1, {__type = 2})
  end
end

adp=LuaMultiAdapter(this,data,help_item)

help_list.setAdapter(adp)

function onOptionsItemSelected()
  activity.finish()
end

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