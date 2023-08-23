require "import"
import "mods.imports"

initApp=true
useCustomAppToolbar=true
import "jesse205"

oldTheme=ThemeUtil.getAppTheme()
oldDarkActionBar=getSharedData("theme_darkactionbar")

--重写SwipeRefreshLayout到自定义view 原SwipeRefreshLayout和滑动组件有bug
SwipeRefreshLayout = luajava.bindClass "com.hydrogen.view.CustomSwipeRefresh"
--重写BottomSheetDialog到自定义view 解决横屏显示不全问题
BottomSheetDialog = luajava.bindClass "com.hydrogen.view.BaseBottomSheetDialog"


versionCode=0.11
layout_dir="layout/item_layout/"


if this.getSharedData("调式模式")=="true" then
  this.setDebug(true)
 else
  this.setDebug(false)
end

onResume=function()
  local res =this.getResources();
  local config = res.getConfiguration();
  config.fontScale=tonumber(activity.getSharedData("font_size"))/20
  res.updateConfiguration(config,res.getDisplayMetrics());
end

onStart=onResume

function tokb(m)
  if m<=1024 then
    return m.."B"
   elseif m<=(1024^2) then
    return (math.floor((m/1024*100)+0.5)/100).."KB"
   elseif m<=(1024^3) then
    return (math.floor((m/(1024^2)*100)+0.5)/100).."MB"
   elseif m<=(1024^4) then
    return (math.floor((m/(1024^3)*100)+0.5)/100).."GB"
  end
end

function Ripple(id,color,t)
  local ripple
  if t=="圆" or t==nil then
    if not(RippleCircular) then
      RippleCircular=activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0,0)
    end
    ripple=RippleCircular
   elseif t=="方" then
    if not(RippleSquare) then
      RippleSquare=activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0,0)
    end
    ripple=RippleSquare
  end
  local Pretend=activity.Resources.getDrawable(ripple)
  if id then
    id.setBackground(Pretend.setColor(ColorStateList(int[0].class{int{}},int{color})))
   else
    return Pretend.setColor(ColorStateList(int[0].class{int{}},int{color}))
  end
end

function 时间戳(t)
  --local t=t/1000
  local nowtime=os.time()
  local between=nowtime-t
  if nowtime-t<60*60 then --一小时
    local min = between % 3600 / 60
    return tointeger(min+0.5).." 分钟前"
   elseif nowtime-t<24*60*60 then --一天
    local hours = between % (24 * 3600) / 3600
    return tointeger(hours+0.5).." 小时前"
   elseif tonumber(os.date("%Y",os.time()))==tonumber(os.date("%Y",t)) then
    return os.date("%m-%d",t)
  end
  return os.date("%Y-%m-%d",t)
end

function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end

function px2dp(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return pxValue / scale + 0.5
end

function px2sp(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity;
  return pxValue / scale + 0.5
end

function sp2px(spValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return spValue * scale + 0.5
end


function 写入文件(路径,内容)
  xpcall(function()
    local 文件夹路径=tostring(File(tostring(路径)).getParentFile())
    if not(文件夹是否存在(文件夹路径)) then
      f=File(文件夹路径).mkdirs()
    end
    io.open(tostring(路径),"w"):write(tostring(内容)):close()
    end,function()
    提示("写入文件 "..路径.." 失败")
  end)
end

function 读取文件(路径)
  if 文件是否存在(路径) then
    rtn=io.open(路径):read("*a")
   else
    rtn=""
  end
  return rtn
end

function 复制文件(from,to)
  xpcall(function()
    LuaUtil.copyDir(from,to)
    end,function()
    提示("复制文件 从 "..from.." 到 "..to.." 失败")
  end)
end

function 创建文件夹(file)
  xpcall(function()
    File(file).mkdir()
    end,function()
    提示("创建文件夹 "..file.." 失败")
  end)
end

function 创建文件(file)
  xpcall(function()
    File(file).createNewFile()
    end,function()
    提示("创建文件 "..file.." 失败")
  end)
end

function 创建多级文件夹(file)
  xpcall(function()
    File(file).mkdirs()
    end,function()
    提示("创建文件夹 "..file.." 失败")
  end)
end

function 文件是否存在(file)
  return File(file).exists()
end

function 删除文件(file)
  xpcall(function()
    LuaUtil.rmDir(File(file))
    end,function()
    提示("删除文件(夹) "..file.." 失败")
  end)
end

function 内置存储(t)
  if Build.VERSION.SDK_INT >29 then
    return activity.getExternalFilesDir(nil).toString() .. "/" ..t
  end
  return Environment.getExternalStorageDirectory().toString().."/"..t
end


function 获取Cookie(url)
  local cookieManager = CookieManager.getInstance();
  return cookieManager.getCookie(url);
end

function 设置Cookie(url,b)
  local cookieManager = CookieManager.getInstance();
  return cookieManager.setCookie(url,b);
end

function 初始化历史记录数据(save)
  recordtitle={}
  recordid={}
  退出时保存历史记录=save
  if (退出时保存历史记录==true)then
    local recordt={}
    local recordi={}
    for d in each(this.getSharedPreferences("Historyrecordtitle",0).getAll().entrySet()) do
      recordt[tonumber(d.getKey())]=d.getValue()
    end
    for d in each(this.getSharedPreferences("Historyrecordid",0).getAll().entrySet()) do
      recordi[tonumber(d.getKey())]=d.getValue()
    end
    local k=0
    for i=#recordt,1,-1 do
      k=k+1
      recordtitle[k]=recordt[i]
      recordid[k]=recordi[i]
    end
  end
end

function saveHistoryrecord(a,b,num)
  recordtitle[#recordtitle+1]=a
  recordid[#recordid+1]=b
  local www=num
  if (num==nil)then
    www=#recordtitle
  end
  if (退出时保存历史记录==true)then
    this.getSharedPreferences("Historyrecordtitle",0).edit().clear().commit()
    this.getSharedPreferences("Historyrecordid",0).edit().clear().commit()
    local k=#recordtitle+1
    for i=1,www do
      this.getSharedPreferences("Historyrecordtitle",0).edit().putString(tostring(i),recordtitle[k-i]).apply()
      this.getSharedPreferences("Historyrecordid",0).edit().putString(tostring(i),recordid[k-i]).apply()
    end
   else
    if (#recordtitle>www)then
      local c=#recordtitle-www
      for i=1,#recordtitle do
        recordtitle[i]=recordtitle[i+c]
        recordid[i]=recordid[i+c]
      end
    end
  end
end

function 保存历史记录(a,b,num)
  local ok=nil
  for i,v in ipairs(recordid)do
    if (b==(v))then
      for b=i,#recordtitle do
        recordtitle[b]=recordtitle[b+1]
        recordid[b]=recordid[b+1]
      end
      saveHistoryrecord(a,b,num)
      ok=1
      return true
    end
  end
  if (ok==1)then
   else
    saveHistoryrecord(a,b,num)
  end
end

function 清除历史记录()
  this.getSharedPreferences("Historyrecordtitle",0).edit().clear().commit()
  this.getSharedPreferences("Historyrecordid",0).edit().clear().commit()
  recordtitle={}
  recordid={}
end


function 获取系统夜间模式()
  _,Re=xpcall(function()
    import "android.content.res.Configuration"
    currentNightMode = activity.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK
    return currentNightMode == Configuration.UI_MODE_NIGHT_YES--夜间模式启用
    end,function()
    return false
  end)
  return Re
end

function 获取主题夜间模式()
  _,Re=xpcall(function()
    NightMode = AppCompatDelegate.getDefaultNightMode();
    return NightMode == AppCompatDelegate.MODE_NIGHT_YES--夜间模式启用
    end,function()
    return false
  end)
  return Re
end


function dec2hex(n)
  local color=0xFFFFFFFF & n
  hex_str = string.format("#%08X", color)
  return hex_str
end

function 主题(str)
  全局主题值=str
  if 全局主题值=="Day" then
    if 获取主题夜间模式() == true then
      if Boolean.valueOf(this.getSharedData("Setting_Auto_Night_Mode"))==true then
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
       else
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
      end
      --      activity.recreate()
      return
    end
    --    primaryc="#448aff"
    primaryc=dec2hex(res.color.attr.colorPrimary)
    secondaryc="#fdd835"
    textc="#212121"
    stextc="#424242"
    backgroundc="#ffffffff"
    barbackgroundc="#efffffff"
    cardbackc="#fff1f1f1"
    viewshaderc="#00000000"
    grayc="#ECEDF1"
    ripplec="#559E9E9E"
    --    cardedge="#FFE0E0E0"
    cardedge=dec2hex(res.color.attr.colorSurface)
    oricardedge="#FFF6F6F6"
    --    cardedge="#FFF6F6F6"
    pcall(function()
      local _window = activity.getWindow();
      _window.setBackgroundDrawable(ColorDrawable(0xffffffff));
      local _wlp = _window.getAttributes();
      _wlp.gravity = Gravity.BOTTOM;
      _wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
      _wlp.height = WindowManager.LayoutParams.MATCH_PARENT;--WRAP_CONTENT
      _window.setAttributes(_wlp);
      --      activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
    end)
   elseif 全局主题值=="Night" then
    if 获取主题夜间模式() == false and 获取系统夜间模式() == false then
      AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
      --      activity.recreate()
      return
    end
    --    primaryc="#FF88B0F8"
    primaryc=dec2hex(res.color.attr.colorPrimary)
    secondaryc="#ffbfa328"
    --    textc="#808080"
    textc="#FFCBCBCB"
    --    stextc="#666666"
    stextc="#808080"
    backgroundc="#ff191919"
    barbackgroundc="#ef191919"
    cardbackc="#ff212121"
    viewshaderc="#80000000"
    grayc="#212121"
    ripplec="#559E9E9E"
    cardedge=dec2hex(res.color.attr.colorSurface)
    oricardedge="#555555"
    --    cardedge="#555555"
    pcall(function()
      local _window = activity.getWindow();
      _window.setBackgroundDrawable(ColorDrawable(0xff222222));
      local _wlp = _window.getAttributes();
      _wlp.gravity = Gravity.BOTTOM;
      _wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
      _wlp.height = WindowManager.LayoutParams.MATCH_PARENT;--WRAP_CONTENT
      _window.setAttributes(_wlp);
      --      activity.setTheme(android.R.style.Theme_Material_NoActionBar)
    end)
  end
end


function 设置主题()
  if Boolean.valueOf(this.getSharedData("Setting_Auto_Night_Mode"))==true then
    if 获取系统夜间模式() and 获取主题夜间模式()~=true then
      主题("Night")
     else --暂时这样写，后期修复
      if Boolean.valueOf(this.getSharedData("Setting_Night_Mode"))==true then
        主题("Night")
       else
        主题("Day")
      end
    end
   else
    if Boolean.valueOf(this.getSharedData("Setting_Night_Mode"))==true then
      主题("Night")
     else
      主题("Day")
    end
  end
end


设置主题()


function 沉浸状态栏()
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
end

function activity背景颜色(color)
  _window = activity.getWindow();
  _window.setBackgroundDrawable(ColorDrawable(color));
  _wlp = _window.getAttributes();
  _wlp.gravity = Gravity.BOTTOM;
  _wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
  _wlp.height = WindowManager.LayoutParams.MATCH_PARENT;--WRAP_CONTENT
  _window.setAttributes(_wlp);
end

function 转0x(j)
  if #j==7 then
    jj=j:match("#(.+)")
    jjj=tonumber("0xff"..jj)
   else
    jj=j:match("#(.+)")
    jjj=tonumber("0x"..jj)
  end
  return jjj
end

function 提示(t)
  local w=activity.width

  local tsbj={
    LinearLayout,
    Gravity="bottom",
    {
      CardView,
      layout_width="-1";
      layout_height="-2";
      CardElevation="0",
      CardBackgroundColor=转0x(textc)-0x3f000000,
      Radius="8dp",
      layout_margin="16dp";
      layout_marginBottom="64dp";
      {
        LinearLayout,
        layout_height=-2,
        layout_width="-2";
        gravity="left|center",
        padding="16dp";
        paddingTop="12dp";
        paddingBottom="12dp";
        {
          TextView,
          textColor=转0x(backgroundc),
          textSize="14sp";
          layout_height=-2,
          layout_width=-2,
          text=t;
          Typeface=字体("product")
        },
      }
    }
  }

  Toast.makeText(activity,t,Toast.LENGTH_SHORT).setGravity(Gravity.BOTTOM|Gravity.CENTER, 0, 0).setView(loadlayout(tsbj)).show()
end

function 获取系统夜间模式()
  _,Re=xpcall(function()
    import "android.content.res.Configuration"
    currentNightMode = activity.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK
    return currentNightMode == Configuration.UI_MODE_NIGHT_YES--夜间模式启用
    end,function()
    return false
  end)
  return Re
end

function Snakebar(fill)
  提示(fill)
end

function 颜色渐变(控件,左色,右色)
  import "android.graphics.drawable.GradientDrawable"
  local drawable = GradientDrawable(GradientDrawable.Orientation.TR_BL,{左色,右色,});
  控件.IndeterminateDrawable=(drawable)
  --  控件.setBackgroundDrawable(ColorDrawable(左色))
end


function 设置视图(t)
  activity.setContentView(loadlayout(t))
end

function 加载js(id,js)
  if js~=nil then
    id.evaluateJavascript(js,nil)
  end
end

function 获取js(jsname)
  local path=activity.getLuaPath('/js')
  local path=path.."/"..jsname..".js"
  local content=io.open(path):read("*a")
  return content
end


function 屏蔽元素(id,tab)
  for i,v in pairs(tab) do
    加载js(id,[[document.getElementsByClassName(']]..v..[[')[0].style.display='none';]])
  end
end



function 静态渐变(a,b,id,fx)
  if fx=="竖" then
    fx=GradientDrawable.Orientation.TOP_BOTTOM
  end
  if fx=="横" then
    fx=GradientDrawable.Orientation.LEFT_RIGHT
  end
  drawable = GradientDrawable(fx,{
    a,--右色
    b,--左色
  });
  id.setBackgroundDrawable(drawable)
end

ripple = activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0,0)
ripples = activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0,0)

function 波纹(id,lx)
  xpcall(function()
    for index,content in pairs(id) do
      if lx=="圆白" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="方白" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="圆黑" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
      end
      if lx=="方黑" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
      end
      if lx=="圆主题" then
        --        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{转0x(primaryc)-0xdf000000})))
      end
      if lx=="方主题" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{转0x(primaryc)-0xdf000000})))
        --        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
      end
      if lx=="圆自适应" then
        if 全局主题值=="Day" then
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
        end
      end
      if lx=="方自适应" then
        if 全局主题值=="Day" then
          content.backgroundDrawable=(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
        end
      end
    end
  end,function(e)end)
end

function 控件显示(a)
  a.setVisibility(View.VISIBLE)
end

function 控件可见(a)
  a.setVisibility(View.VISIBLE)
end

function 控件不可见(a)
  a.setVisibility(View.INVISIBLE)
end

function 控件隐藏(a)
  a.setVisibility(View.GONE)
end

function 关闭对话框(an)
  an.dismiss()
end

function 三按钮对话框(bt,nr,qd,qx,ds,qdnr,qxnr,dsnr,gb)
  if 全局主题值=="Day" then
    bwz=0x3f000000
   else
    bwz=0x3fffffff
  end

  import "com.google.android.material.bottomsheet.*"

  local gd2 = GradientDrawable()
  gd2.setColor(转0x(backgroundc))--填充
  local radius=dp2px(16)
  gd2.setCornerRadii({radius,radius,radius,radius,0,0,0,0})--圆角
  gd2.setShape(0)--形状，0矩形，1圆形，2线，3环形
  local dann={
    LinearLayout;
    layout_width="-1";
    layout_height="-1";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="-1";
      layout_height="-2";
      Elevation="4dp";
      BackgroundDrawable=gd2;
      id="ztbj";
      {
        CardView;
        layout_gravity="center",
        --        background=cardedge,
        CardBackgroundColor=cardedge,
        radius="3dp",
        Elevation="0dp";
        layout_height="6dp",
        layout_width="56dp",
        layout_marginTop="12dp";
      };

      {
        TextView;
        layout_width="-1";
        layout_height="-2";
        textSize="20sp";
        layout_marginTop="24dp";
        layout_marginLeft="24dp";
        layout_marginRight="24dp";
        Text=bt;
        Typeface=字体("product-Bold");
        textColor=primaryc;
      };
      {
        ScrollView;
        layout_width="-1";
        layout_height="-1";
        {
          TextView;
          layout_width="-1";
          layout_height="-2";
          textSize="14sp";
          layout_marginTop="8dp";
          layout_marginLeft="24dp";
          layout_marginRight="24dp";
          layout_marginBottom="8dp";
          Typeface=字体("product");
          Text=nr;
          textColor=textc;
          id="sandhk_wb";
        };
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_width="-1";
        layout_height="-2";
        gravity="right|center";
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="2dp";
          --background="#00000000";
          CardBackgroundColor="#00000000";
          layout_marginTop="8dp";
          layout_marginLeft="24dp";
          layout_marginBottom="24dp";
          Elevation="0";
          onClick=dsnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            Typeface=字体("product-Bold");
            paddingRight="16dp";
            paddingLeft="16dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=ds;
            textColor=stextc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
        {
          LinearLayout;
          orientation="horizontal";
          layout_width="-1";
          layout_height="-2";
          layout_weight="1";
        };
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="2dp";
          --background="#00000000";
          CardBackgroundColor="#00000000";
          layout_marginTop="8dp";
          layout_marginLeft="8dp";
          layout_marginBottom="24dp";
          Elevation="0";
          onClick=qxnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            Typeface=字体("product-Bold");
            paddingRight="16dp";
            paddingLeft="16dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=qx;
            textColor=stextc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="4dp";
          --background=primaryc;
          CardBackgroundColor=primaryc;
          layout_marginTop="8dp";
          layout_marginLeft="8dp";
          layout_marginRight="24dp";
          layout_marginBottom="24dp";
          Elevation="1dp";
          onClick=qdnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            paddingRight="16dp";
            paddingLeft="16dp";
            Typeface=字体("product-Bold");
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=qd;
            textColor=backgroundc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
      };
    };
  };
  local bottomSheetDialog = BottomSheetDialog(this)
  bottomSheetDialog.setContentView(loadlayout(dann))
  an=bottomSheetDialog.show()
end


function 双按钮对话框(bt,nr,qd,qx,qdnr,qxnr,gb)
  if 全局主题值=="Day" then
    bwz=0x3f000000
   else
    bwz=0x3fffffff
  end

  import "com.google.android.material.bottomsheet.*"

  local gd2 = GradientDrawable()
  gd2.setColor(转0x(backgroundc))--填充
  local radius=dp2px(16)
  gd2.setCornerRadii({radius,radius,radius,radius,0,0,0,0})--圆角
  gd2.setShape(0)--形状，0矩形，1圆形，2线，3环形
  local dann={
    LinearLayout;
    layout_width="-1";
    layout_height="-1";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="-1";
      layout_height="-2";
      Elevation="4dp";
      BackgroundDrawable=gd2;
      id="ztbj";
      {
        CardView;
        layout_gravity="center",
        --background=cardedge,
        CardBackgroundColor=cardedge;
        radius="3dp",
        Elevation="0dp";
        layout_height="6dp",
        layout_width="56dp",
        layout_marginTop="12dp";
      };
      {
        TextView;
        layout_width="-1";
        layout_height="-2";
        textSize="20sp";
        layout_marginTop="24dp";
        layout_marginLeft="24dp";
        layout_marginRight="24dp";
        Text=bt;
        Typeface=字体("product-Bold");
        textColor=primaryc;
      };
      {
        ScrollView;
        layout_width="-1";
        layout_height="-1";
        {
          TextView;
          layout_width="-1";
          layout_height="-2";
          textSize="14sp";
          layout_marginTop="8dp";
          layout_marginLeft="24dp";
          layout_marginRight="24dp";
          layout_marginBottom="8dp";
          Typeface=字体("product");
          Text=nr;
          textColor=textc;
          id="sandhk_wb";
        };
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_width="-1";
        layout_height="-2";
        gravity="right|center";
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="2dp";
          --background="#00000000";
          CardBackgroundColor="#00000000";
          layout_marginTop="8dp";
          layout_marginLeft="8dp";
          layout_marginBottom="24dp";
          Elevation="0";
          onClick=qxnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            Typeface=字体("product-Bold");
            paddingRight="16dp";
            paddingLeft="16dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=qx;
            textColor=stextc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="4dp";
          --background=primaryc;
          CardBackgroundColor=primaryc;
          layout_marginTop="8dp";
          layout_marginLeft="8dp";
          layout_marginRight="24dp";
          layout_marginBottom="24dp";
          Elevation="1dp";
          onClick=qdnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            paddingRight="16dp";
            paddingLeft="16dp";
            Typeface=字体("product-Bold");
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=qd;
            textColor=backgroundc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
      };
    };
  };
  local bottomSheetDialog = BottomSheetDialog(this)
  bottomSheetDialog.setContentView(loadlayout(dann))
  an=bottomSheetDialog.show()
end


function 问题详情(nr,code)
  if 全局主题值=="Day" then
    bwz=0x3f000000
   else
    bwz=0x3fffffff
  end

  local gd2 = GradientDrawable()
  gd2.setColor(转0x(backgroundc))
  local radius=dp2px(16)
  gd2.setCornerRadii({radius,radius,radius,radius,0,0,0,0})--圆角
  gd2.setShape(0)
  local dann={
    LinearLayout;
    layout_width="-1";
    layout_height="-1";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="-1";
      layout_height="-2";
      Elevation="4dp";
      BackgroundDrawable=gd2;
      id="ztbj";
      {
        CardView;
        layout_gravity="center",
        --background=cardedge,
        CardBackgroundColor=cardedge;
        radius="3dp",
        Elevation="0dp";
        layout_height="6dp",
        layout_width="56dp",
        layout_marginTop="12dp";
      };
      {
        TextView;
        layout_width="-1";
        layout_height="-2";
        textSize="19sp";
        layout_marginTop="12dp";
        layout_marginLeft="24dp";
        layout_marginRight="24dp";
        Text="详细描述";
        Typeface=字体("product-Bold");
        textColor=primaryc;
      };
      {
        LuaWebView;
        id="show",
        layout_width="-1";
        layout_height="-1";

      };
    };
  };
  local bottomSheetDialog = BottomSheetDialog(this)
  bottomSheetDialog.setContentView(loadlayout(dann))
  an=bottomSheetDialog.show()
end




function 内置存储文件(u)
  if u =="" or u==nil then
    return 内置存储("Hydrogen/")
   else
    return 内置存储("Hydrogen/"..u)
  end
end


function 解压缩(压缩路径,解压缩路径)
  xpcall(function()
    ZipUtil.unzip(压缩路径,解压缩路径)
    end,function()
    提示("解压文件 "..压缩路径.." 失败")
  end)
end

function 重命名文件(旧,新)
  xpcall(function()
    File(旧).renameTo(File(新))
    end,function()
    提示("重命名文件 "..旧.." 失败")
  end)
end

function 追加更新文件(path, content)
  io.open(path,"a+"):write(content):close()
end

function 文件夹是否存在(file)
  if File(file).isDirectory()then
    return true
   else
    return false
  end
end

function 移动文件(旧,新)
  xpcall(function()
    File(旧).renameTo(File(新))
    end,function()
    提示("移动文件 "..旧.." 至 "..新.." 失败")
  end)
end

function 跳转页面(ym,cs)
  if cs then
    activity.newActivity(ym,cs)
   else
    activity.newActivity(ym)
  end
end

function 渐变跳转页面(ym,cs)
  if cs then
    activity.newActivity(ym,android.R.anim.fade_in,android.R.anim.fade_out,cs)
   else
    activity.newActivity(ym,android.R.anim.fade_in,android.R.anim.fade_out)
  end
end

function 检查链接(url,b)
  local open=activity.getSharedData("内部浏览器查看回答")
  --  local url="https"..url:match("https(.+)")
  if url:find("zhihu.com/question") then

    local answer,questions=0,0
    if url:find("answer") then
      questions,answer=url:match("question/(.-)/"),url:match("answer/(.-)?") or url:match("answer/(.+)")
     else
      questions,answer=url:match("question/(.-)?") or url:match("question/(.+)"),nil
      if b then
        return true
      end
      if open=="false" then
        activity.newActivity("question",{questions,true})
       else
        activity.newActivity("huida",{url})
      end
      return
    end
    if b then
      return true
    end
    if open=="false" then
      activity.newActivity("answer",{questions,answer,nil,true})
     else
      activity.newActivity("huida",{url})--"https://www.zhihu.com/question/"..tostring(v.Tag.链接2.Text):match("(.+)分割").."/answer/"..tostring(v.Tag.链接2.Text):match("分割(.+)")})
    end
   elseif url:find("zhuanlan.zhihu.com/p/") then--/p/143744216
    if b then return true end
    activity.newActivity("column",{url:match("zhihu.com/p/(.+)")})
   elseif url:find("zhuanlan.zhihu.com") then--/p/143744216
    if b then return true end
    activity.newActivity("huida",{url})
   elseif url:find("zhihu.com/appview/p/") then--/p/143744216
    if b then return true end
    activity.newActivity("column",{url:match("appview/p/(.+)")})
   elseif url:find("zhihu.com/topics/") then--/p/143744216
    if b then return true end
    activity.newActivity("topic",{url:match("/topics/(.+)")})
   elseif url:find("zhihu.com/topic/") then--/p/143744216
    if b then return true end
    activity.newActivity("topic",{url:match("/topic/(.+)")})
   elseif url:find("zhihu.com/pin/") then
    if b then return true end
    activity.newActivity("column",{url:match("/pin/(.+)"),"想法"})
   elseif url:find("zhihu.com/video/") then
    if b then return true end
    local videoid= url:match("video/(.+)")
    zHttp.get("https://lens.zhihu.com/api/v4/videos/"..videoid,head,function(code,content)
      if code==200 then
        local v=require "cjson".decode(content)
        xpcall(function()
          视频链接=v.playlist.SD.play_url
          end,function()
          视频链接=v.playlist.LD.play_url
          end,function()
          视频链接=v.playlist.HD.play_url
        end)
        --        activity.finish()
        activity.newActivity("huida",{视频链接})
       elseif code==401 then
        提示("请登录后查看视频")
      end
    end)
   elseif url:find("zhihu.com/zvideo/") then
    if b then return true end
    local videoid=url:match("/zvideo/(.-)?") or url:match("/zvideo/(.+)")
    activity.newActivity("column",{videoid,"视频"})
   elseif url:find("zhihu.com/people") or url:find("zhihu.com/org") then
    if b then return true end
    local people_name=url:match("/people/(.-)?") or url:match("/people/(.+)")
    zHttp.get(url,head,function(code,content)
      if code==200 then
        local peopleid=content:match('":{"id":"(.-)","urlToken')
        --        activity.finish()
        activity.newActivity("people",{peopleid,true})
       elseif code==401 then
        提示("请登录后查看用户")
      end
    end)
   elseif url:find("zhihu.com/signin") then
    if b then return false end
    activity.newActivity("login")
   elseif url:find("https://ssl.ptlogin2.qq.com/jump") then
    if b then return false end
    activity.finish()
    activity.newActivity("login",{url})
   elseif url:find("zhihu://") then
    if b then return true end
    检查意图(url)
   else
    if b then return false end
    activity.newActivity("huida",{url})
  end
end

function 检查意图(url,b)
  local get=require "model.answer"
  local open=activity.getSharedData("内部浏览器查看回答")
  if url and url:find("zhihu://") then
    if url:find "answers" then
      if b then return true end
      local id=url:match("answers/(.-)?")
      get:getAnswer(id,function(s)
        activity.newActivity("answer",{tointeger(s.question.id),tointeger(id),nil,true})
      end)
     elseif url:find "answer" then
      if b then return true end
      local id=url:match("answer/(.-)/") or url:match("answer/(.+)")
      get:getAnswer(id,function(s)
        activity.newActivity("answer",{tointeger(s.question.id),tointeger(id),nil,true})
      end)
     elseif url:find "questions" then
      if b then return true end
      activity.newActivity("question",{url:match("questions/(.-)?"),true})
     elseif url:find "question" then
      if b then return true end
      activity.newActivity("question",{url:match("question/(.-)?"),true})
     elseif url:find "topic" then
      if b then return true end
      activity.newActivity("topic",{url:match("topic/(.-)/")})
     elseif url:find "people" then
      if b then return true end
      activity.newActivity("people",{url:match("people/(.-)?"),true})
     elseif url:find "articles" then
      if b then return true end
      activity.newActivity("column",{url:match("articles/(.-)?")})
     elseif url:find "article" then
      if b then return true end
      activity.newActivity("column",{url:match("article/(.-)?")})
     elseif url:find "pin" then
      if b then return true end
      activity.newActivity("column",{url:match("pin/(.-)?"),"想法"})
     elseif url:find "zvideo" then
      if b then return true end
      activity.newActivity("column",{url:match("zvideo/(.-)?"),"视频"})
     else
      if b then return false end
      提示("暂不支持的知乎意图"..intent)
    end
   elseif url and (url:find("http://") or url:find("https://")) and url:find("zhihu.com") then
    --    local myurl="https"..url:match("https(.+)")
    检查链接(url)
  end
end

function 关闭页面()
  activity.finish()
end

function 清除所有cookie()
  local cookieManager=CookieManager.getInstance();
  cookieManager.setAcceptCookie(true);
  cookieManager.removeSessionCookie();
  cookieManager.removeAllCookie();
end

function 复制文本(文本)
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(文本)
end

function 全屏()
  window = activity.getWindow();
  window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN|View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN|View.SYSTEM_UI_FLAG_LAYOUT_STABLE | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
  | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
  | View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
  window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
  xpcall(function()
    lp = window.getAttributes();
    lp.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
    window.setAttributes(lp);
  end,
  function(e)
  end)
end

if this.getSharedData("全屏模式")=="true" then
  全屏()
end

function 图标(n)
  return "res/twotone_"..n.."_black_24dp.png"
end

function 下载文件(链接,文件名,配置)
  downloadManager=activity.getSystemService(Context.DOWNLOAD_SERVICE);
  url=Uri.parse(链接);
  request=DownloadManager.Request(url);
  request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_MOBILE|DownloadManager.Request.NETWORK_WIFI);
  if type(配置)=="table" then
    if 配置.Referer then
      request.addRequestHeader("Referer",配置.Referer)
    end
  end
  request.setDestinationInExternalPublicDir("Download",文件名);
  request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
  downloadManager.enqueue(request);
  提示("正在下载，下载到："..内置存储("Download/"..文件名).."\n请查看通知栏以查看下载进度。")
end


function xdc(url,path)
  require "import"
  import "java.net.URL"
  local ur =URL(url)
  import "java.io.File"
  file=File(path);
  local con = ur.openConnection();
  con.setRequestProperty("Accept-Encoding", "identity");
  local co = con.getContentLength();
  local is = con.getInputStream();
  local bs = byte[1024]
  local len,read=0,0
  import "java.io.FileOutputStream"
  local wj= FileOutputStream(path);
  len = is.read(bs)
  while len~=-1 do
    wj.write(bs, 0, len);
    read=read+len
    pcall(call,"ding",read,co)
    len = is.read(bs)
  end
  wj.close();
  is.close();
  pcall(call,"dstop",co)
end
function appDownload(url,path)
  thread(xdc,url,path)
end

function 下载文件对话框(title,url,path,ex)

  import "com.google.android.material.bottomsheet.*"

  local path=内置存储("Download/"..path)
  local rootpath=内置存储("Download")
  if not 文件夹是否存在(rootpath) then
    创建文件夹(rootpath)
  end
  appDownload(url,path)
  local gd2 = GradientDrawable()
  gd2.setColor(转0x(backgroundc))--填充
  local radius=dp2px(16)
  gd2.setCornerRadii({radius,radius,radius,radius,0,0,0,0})--圆角
  gd2.setShape(0)--形状，0矩形，1圆形，2线，3环形
  local 布局={
    LinearLayout,
    id="appdownbg",
    layout_width="fill",
    layout_height="fill",
    orientation="vertical",
    BackgroundDrawable=gd2;
    {
      TextView,
      id="appdownsong",
      text=title,
      --  typeface=Typeface.DEFAULT_BOLD,
      layout_marginTop="24dp",
      layout_marginLeft="24dp",
      layout_marginRight="24dp",
      layout_marginBottom="8dp",
      textColor=primaryc,
      textSize="20sp",
    },
    {
      TextView,
      id="appdowninfo",
      text="已下载：0MB/0MB\n下载状态：准备下载",
      --id="显示信息",
      --  typeface=Typeface.MONOSPACE,
      layout_marginRight="24dp",
      layout_marginLeft="24dp",
      layout_marginBottom="8dp",
      textSize="14sp",
      textColor=textc;
    },
    {
      ProgressBar,
      ProgressBarBackground=转0x(primaryc),
      id="进度条",
      style="?android:attr/progressBarStyleHorizontal",
      layout_width="fill",
      progress=0,
      max=100;
      layout_marginRight="24dp",
      layout_marginLeft="24dp",
      layout_marginBottom="24dp",
    },
  }

  local bottomSheetDialog = BottomSheetDialog(this)
  bottomSheetDialog.setContentView(loadlayout(布局))
  ao=bottomSheetDialog.show()


  function ding(a,b)--已下载，总长度(byte)
    appdowninfo.Text=string.format("%0.2f",a/1024/1024).."MB/"..string.format("%0.2f",b/1024/1024).."MB".."\n下载状态：正在下载"
    进度条.progress=(a/b*100)
  end

  function dstop(c)--总长度
    关闭对话框(ao)

    if ex then
      提示("导入中…稍等哦(^^♪")
      解压缩(path,ex)
      删除文件(path)
      提示("导入完成ʕ•ٹ•ʔ")
     else
      if path:find(".apk$")~=nil then
        提示("安装包下载成功,大小"..string.format("%0.2f",c/1024/1024).."MB，储存在："..path)
        双按钮对话框("安装APP",[===[您下载了安装包文件，要现在安装吗？ 取消后可前往]===]..path.."手动安装","立即安装","取消",function()
          --    关闭对话框(an)
          安装apk(path)
          end,function()
          关闭对话框(an)
        end)
        myupdatedialog.getButton(myupdatedialog.BUTTON_POSITIVE).Text="立即安装"
        myupdatedialog.getButton(myupdatedialog.BUTTON_POSITIVE).onClick=function()
          安装apk(path)
        end
       else
        提示("下载完成，大小"..string.format("%0.2f",c/1024/1024).."MB，储存在："..path)
      end
    end
  end
end

function 安装apk(安装包路径)

  local result=get_installApp_permissions()

  if result~=true then
    return false
  end

  import "java.io.File"
  import "android.content.Intent"
  import "android.net.Uri"
  import "androidx.core.content.FileProvider"
  local apkType="application/vnd.android.package-archive"
  local FileProviderStr=".FileProvider"
  local 获取安装包=File(安装包路径)
  if Build.VERSION.SDK_INT >= 24 then
    local apkUri = FileProvider.getUriForFile(this, this.getPackageName() .. FileProviderStr,获取安装包);
    intent_apk = Intent(Intent.ACTION_INSTALL_PACKAGE);
    intent_apk.setData(apkUri);
    intent_apk.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
   else
    local apkUri = Uri.fromFile(获取安装包);
    intent_apk = Intent(Intent.ACTION_VIEW);
    intent_apk.setDataAndType(apkUri, apkType);
    intent_apk.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
  end
  activity.startActivity(intent_apk)
end

function 浏览器打开(pageurl)
  import "android.content.Intent"
  import "android.net.Uri"
  viewIntent = Intent("android.intent.action.VIEW",Uri.parse(pageurl))
  activity.startActivity(viewIntent)
end


function 字体(t)
  return Typeface.createFromFile(File(activity.getLuaDir().."/res/"..t..".ttf"))
end


function MUKPopu(t)

  local tab={}
  local pop=PopupWindow(activity)
  --PopupWindow加载布局
  pop.setContentView(loadlayout({
    LinearLayout;
    {
      CardView;
      CardElevation="6dp";
      CardBackgroundColor=backgroundc;
      Radius="8dp";
      layout_width="-1";
      layout_height="-2";
      layout_margin="8dp";
      {
        TextView;
        Text=t.tittle,
        gravity="left";
        padding="12dp";
        paddingTop="12dp";
        Typeface=字体("product-Bold");
        textColor=primaryc;
        layout_width="-1";
        layout_height="-1";
        textSize="13sp";
      };
      {
        ListView;
        layout_marginTop="32dp",
        layout_height="-1";
        layout_width="-1";
        DividerHeight=0;
        id="poplist";
        OnItemClickListener={
          onItemClick=function(i,v,p,l)
            t.list[l].onClick(v.Tag.popadp_text.Text)
            tab.pop.dismiss()
          end,
        },
        adapter=LuaAdapter(activity,{
          LinearLayout;
          layout_width="-1";
          layout_height="48dp";

          {
            LinearLayout;
            layout_width="-1";
            orientation="horizontal";
            layout_height="48dp";

            {
              ImageView;
              id="popadp_image",
              layout_width="23dp";
              layout_height="23dp";
              layout_marginLeft="12dp",
              layout_gravity="center";
              ColorFilter=textc;

            };
            {
              TextView;
              id="popadp_text";
              textColor=textc;
              layout_width="-1";
              layout_height="-1";
              textSize="14sp";
              gravity="left|center";
              paddingLeft="16dp";
              Typeface=字体("product");
            };
          };
        }),
      }
    }

  },tab))
  pop.setWidth(dp2px(192))
  pop.setHeight(-2)

  pop.setOutsideTouchable(true)
  pop.setBackgroundDrawable(ColorDrawable(0x00000000))

  pop.onDismiss=function()
    if t.消失事件 then
      t.消失事件()
    end

  end
  tab.pop=pop

  if this.getSharedData("允许加载代码")=="true" then
    table.insert(t.list,{src=图标("build"),text="执行代码",onClick=function()
        local InputLayout={
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
            lines="1",
            ellipsize="end",
            id="edit";
          };
        };

        local dialog=AlertDialog.Builder(this)
        .setTitle("输入要执行的代码")
        .setView(loadlayout(InputLayout))
        .setPositiveButton("确定",nil)
        .setNegativeButton("取消",nil)
        .setCancelable(false)
        .show()

        dialog.getButton(dialog.BUTTON_POSITIVE).onClick=function()
          load(edit.Text)()
        end
    end})
  end

  for k,v in ipairs(t.list) do
    tab.poplist.adapter.add{popadp_image=loadbitmap(v.src),popadp_text=v.text}
  end

  tab.poplist.adapter.notifyDataSetChanged()
  return tab
end

function showpop(view,pop)
  pop.showAsDropDown(view)
end

function 分享文本(t)

  import "android.content.*"
  intent=Intent(Intent.ACTION_SEND)
  .setType("text/plain")
  .putExtra(Intent.EXTRA_SUBJECT, "Hydrogen-分享")
  .putExtra(Intent.EXTRA_TEXT, t)
  .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

  activity.startActivity(Intent.createChooser(intent,"分享到:"));
end

--utf8.findTable
--参数:str,modetable

utf8.findTable=function(str,tab)
  for i=1,#tab do
    local result=utf8.find(str,tab[i])
    if result then
      return result

    end
  end
  return false
end

--table.join

--参数 oldtable,addtable
function table.join(old,add)
  for k,v in pairs(add) do
    old[k]=v
  end
end

function 加入收藏夹(回答id,收藏类型)
  if not(getLogin()) then
    return 提示("请登录后使用本功能")
  end
  import "android.widget.LinearLayout$LayoutParams"
  list=ListView(activity).setFastScrollEnabled(true)
  dialog_lay=LinearLayout(activity)
  .setOrientation(0)
  .setGravity(Gravity.RIGHT|Gravity.CENTER)

  lp=LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
  lp.gravity = Gravity.RIGHT|Gravity.CENTER
  lq=LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
  lq.gravity = Gravity.CENTER

  tip_text=TextView(activity)
  .setText("待选中收藏夹")
  .setTypeface(字体("product"))
  .setLayoutParams(lq);

  add_button=ImageView(activity).setImageBitmap(loadbitmap(图标("add")))
  .setColorFilter(转0x(textc))
  .setLayoutParams(lp);

  add_text=TextView(activity).setText("新建收藏夹")
  .setTypeface(字体("product"))
  .setLayoutParams(lp);

  dialog_lay.addView(add_text).addView(add_button)

  add_text.onClick=function()
    新建收藏夹(function(mytext,myid)
      adp.add({
        mytext=mytext,
        myid=myid
      })
    end)

  end

  cp=TextView(activity)
  lay=LinearLayout(activity).setOrientation(1).addView(tip_text).addView(dialog_lay).addView(cp).addView(list)
  Choice_dialog=AlertDialog.Builder(activity)--创建对话框
  .setTitle("选择路径")
  .setPositiveButton("确认",{
    onClick=function()
      local head = {
        ["cookie"] = 获取Cookie("https://www.zhihu.com/")
      }
      zHttp.put("https://api.zhihu.com/collections/contents/"..收藏类型.."/"..回答id,"add_collections="..选中收藏夹,head,function(code,json)
        if code==200 then
          提示("收藏成功")
         else
          提示("收藏失败")
        end
      end)
  end})
  .setNegativeButton("取消",nil)
  .setView(lay)
  .show()

  local item={
    LinearLayout,
    orientation="vertical",
    layout_width="fill",
    {
      TextView,
      id="mytext",
      layout_width="match_parent",
      layout_height="wrap_content",
      textSize="16sp",
      gravity="center_vertical",
      Typeface=字体("product-Bold");
      paddingStart=64,
      paddingEnd=64,
      minHeight=192
    },
    {
      TextView,
      id="myid",
      layout_width="0dp",
      layout_height="0dp",
    },
  }

  adp=LuaAdapter(activity,item)
  list.setAdapter(adp)


  list.onItemClick=function(l,v,p,s)--列表点击事件
    tip_text.Text="当前选中收藏夹："..v.Tag.mytext.Text
    选中收藏夹=v.Tag.myid.Text
  end

  list.onItemLongClick=function(l,v,p,s)--列表长按事件
    双按钮对话框("删除收藏","删除收藏夹？该操作不可撤消！","是的","点错了",function()
      an.dismiss()
      zHttp.delete("https://api.zhihu.com/collections/"..选中收藏夹,head,function(code,json)
        if code==200 then
          提示("已删除")
          adp.setNotifyOnChange(true)
          adp.remove(p)
          adp.notifyDataSetChanged()
        end
      end)
    end,function()an.dismiss()end)
  end

  local collections_url= "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/collections_v2?offset=0&limit=20"

  local head = {
    ["cookie"] = 获取Cookie("https://www.zhihu.com/")
  }

  zHttp.get(collections_url,head,function(code,content)
    if code==200 then
      adp.setNotifyOnChange(true)
      for k,v in ipairs(require "cjson".decode(content).data) do
        adp.add({
          mytext=v.title,
          myid=tostring(tointeger(v.id))
        })
      end

    end
  end)
end

function 新建收藏夹(callback)
  import "com.lua.LuaWebChrome"
  InputLayout={
    LinearLayout;
    orientation="vertical";
    Focusable=true,
    FocusableInTouchMode=true,
    {
      LuaWebView;
      id="collection_webview";
      layout_width="0dp";
      layout_height="0dp";
    };
    {
      TextView;
      id="Prompt",
      textSize="15sp",
      layout_marginTop="10dp";
      layout_marginLeft="10dp",
      layout_marginRight="10dp",
      layout_width="match_parent";
      layout_gravity="center",
      Typeface=字体("product");
      text="收藏夹标题:";
    };
    {
      EditText;
      hint="输入";
      layout_marginTop="5dp";
      layout_marginLeft="10dp",
      layout_marginRight="10dp",
      layout_width="match_parent";
      layout_gravity="center",
      Typeface=字体("product");
      id="edit";
    };
    {
      TextView;
      id="Promptt",
      textSize="15sp",
      layout_marginTop="10dp";
      layout_marginLeft="10dp",
      layout_marginRight="10dp",
      layout_width="match_parent";
      layout_gravity="center",
      Typeface=字体("product");
      text="收藏夹描述(可选):";
    };
    {
      EditText;
      hint="输入";
      layout_marginTop="5dp";
      layout_marginLeft="10dp",
      layout_marginRight="10dp",
      layout_width="match_parent";
      layout_gravity="center",
      Typeface=字体("product");
      id="editt";
    };
    {
      RadioButton;
      Text="仅自己可见";
      Typeface=字体("product");
      id="新建私密";
      onClick=function() if 新建公开.checked==true then 新建公开.checked=false 新建状况="false";
      加载js(collection_webview,'setprivacy()') end end;
    };
    {
      RadioButton;
      Text="公开";
      Typeface=字体("product");
      id="新建公开";
      onClick=function() if 新建私密.checked==true then 新建私密.checked=false 新建状况="true"
      加载js(collection_webview,'setpublic()') end end;
    };
  };
  collection_dialog=AlertDialog.Builder(this)
  .setTitle("新建收藏夹页面")
  .setView(loadlayout(InputLayout))
  .setPositiveButton("确定",nil)
  .setNegativeButton("返回",nil)
  .setCancelable(false)
  .show()
  collection_dialog.getButton(collection_dialog.BUTTON_NEGATIVE).onClick=function()
    if waitload then
      提示("你还不可以离开 正在添加中 如果长时间没反应请检查网络或报告bug")
     else
      collection_dialog.dismiss()
    end
  end

  collection_dialog.getButton(collection_dialog.BUTTON_POSITIVE).onClick=function()
    waitload=true
    if waitload then
      提示("正在添加中 请耐心等待 如果长时间没反应请检查网络或报告bug")
    end
    if edit.Text=="" then
      提示("请输入内容")
     else
      加载js(collection_webview,'submit("'..edit.text..'","'..editt.text..'")')
    end
  end
  collection_webview.getSettings()
  .setUseWideViewPort(true)
  .setBuiltInZoomControls(true)
  .setSupportZoom(true)
  .setUserAgentString("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36");

  collection_webview.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
    onConsoleMessage=function(consoleMessage)
      local console_message=consoleMessage.message()
      if console_message:find("新建收藏夹成功")
        waitload=nil
        local mytext=edit.text
        local myid=console_message:match("(.+)新建收藏夹成功")
        local ispublic=console_message:match("新建收藏夹成功(.+)")
        if callback then
          callback(mytext,myid,ispublic)
        end
        提示("添加成功")
        加载js(collection_webview,'start()')
       elseif console_message:find("失败")
        提示(console_message)
      end
  end}))

  zHttp.get("https://api.zhihu.com/people/"..activity.getSharedData("idx").."/profile?profile_new_version=1",head,function(code,content)
    if code==200 then
      if require "cjson".decode(content).url_token then
        collection_webview.loadUrl("https://www.zhihu.com/people/"..require "cjson".decode(content).url_token.."/collections/")
       else
        提示("出错 请联系作者")
        collection_dialog.dismiss()
      end
    end
  end)

  local dl=AlertDialog.Builder(this)
  .setTitle("提示")
  .setMessage("内容加载中 请耐心等待 如若想停止加载 请点击下方取消")
  .setNeutralButton("取消",{onClick=function()
      --加载一个空白页
      collection_webview.loadUrl("about:blank");
      --移除webview
      collection_webview.removeAllViews();
      --销毁webview自身
      collection_webview.destroy();
      collection_dialog.dismiss()
  end})
  .setCancelable(false)
  .show()


  collection_webview.setWebViewClient{
    shouldOverrideUrlLoading=function(view,url)
      --Url即将跳转
    end,
    onPageStarted=function(view,url,favicon)
      加载js(view,获取js("collection"))
    end,
    onPageFinished=function(view,url)
      dl.dismiss()
  end}

  if 新建公开.checked==false and 新建私密.checked==false then
    新建私密.checked=true
    新建状态="false"
  end
end

import "android.graphics.drawable.GradientDrawable"

StringHelper = {}

--[[
utf-8编码规则
单字节 - 0起头
   1字节  0xxxxxxx   0 - 127
多字节 - 第一个字节n个1加1个0起头
   2 字节 110xxxxx   192 - 223
   3 字节 1110xxxx   224 - 239
   4 字节 11110xxx   240 - 247
可能有1-4个字节
--]]
function StringHelper.GetBytes(char)
  if not char then
    return 0
  end
  local code = string.byte(char)
  if code < 127 then
    return 1
   elseif code <= 223 then
    return 2
   elseif code <= 239 then
    return 3
   elseif code <= 247 then
    return 4
   else
    -- 讲道理不会走到这里^_^
    return 0
  end
end

function StringHelper.Sub(str, startIndex, endIndex)
  local tempStr = str
  local byteStart = 1 -- string.sub截取的开始位置
  local byteEnd = -1 -- string.sub截取的结束位置
  local index = 0 -- 字符记数
  local bytes = 0 -- 字符的字节记数

  startIndex = math.max(startIndex, 1)
  endIndex = endIndex or -1
  while string.len(tempStr) > 0 do
    if index == startIndex - 1 then
      byteStart = bytes+1;
     elseif index == endIndex then
      byteEnd = bytes;
      break
    end
    bytes = bytes + StringHelper.GetBytes(tempStr)
    tempStr = string.sub(str, bytes+1)

    index = index + 1
  end
  return string.sub(str, byteStart, byteEnd)
end

function 替换文件字符串(路径,要替换的字符串,替换成的字符串)
  if 路径 then
    路径=tostring(路径)
    内容=io.open(路径):read("*a")
    io.open(路径,"w+"):write(tostring(内容:gsub(要替换的字符串,替换成的字符串))):close()
    import "androidx.core.content.ContextCompat"
    filedir=tostring(ContextCompat.getDataDir(activity)).."/files/init.lua"
   else
    return false
  end
end

function 获取参数(url,callback)
  local 请求url="https://x-zse-96.huajicloud.ml/api"
  local 判断url="https://www.zhihu.com"
  if url:find(判断url) then
    请求参数= url:match("zhihu.com(.+)")
   elseif url:find("https://api.zhihu.com") then
    请求参数="/api/v4"..url:match("zhihu.com(.+)")
    url=判断url..请求参数
  end
  加密前数据="101_3_3.0+"..请求参数.."+"..获取Cookie("https://www.zhihu.com/"):match("d_c0=(.-);")
  md5化数据=string.lower(MD5(加密前数据))


  Http.post(请求url,md5化数据,head,function(code,content)
    if code==200 then
      zHttp.get(url,app_head,function(codee,contentt)
        if codee==200 then
          callback(contentt)
        end
      end)
     elseif code==500
      return print("出错")
    end
  end)
end

function urlEncode(s)
  s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
  return string.gsub(s, "", " ")
end

function urlDecode(s)
  s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
  return s
end

if not isstart and this.getSharedData("解析zse开关") then
  isstart=this.getSharedData("解析zse开关")
end

cardback=oricardedge
cardmargin="4px"

--cardback=全局主题值=="Day" and cardedge or backgroundc
--cardmargin=全局主题值=="Day" and "4px" or false

function 黑暗模式主题(view)
  加载js(view,获取js("darktheme"))
end

function 白天主题(view)
  加载js(view,获取js("daytheme"))
end

function 等待doc(view)
  加载js(view,获取js("waitdoc"))
end

function 黑暗页(view)
  加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=80,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
end

function matchtext(str,regex)
  local t={}
  for i,v in string.gfind(str,regex) do
    table.insert(t,string.sub(str,i,v))
  end
  return t
end --返回table

function webview下载文件(链接, UA, 相关信息, 类型, 大小)
  local result=get_write_permissions(true)
  if result~=true then
    return false
  end
  大小=string.format("%0.2f",大小/1024/1024).."MB"
  if 相关信息:match('filename="(.-)"') then
    文件名=urlDecode(相关信息:match('filename="(.-)"'))
   else
    import "android.webkit.URLUtil"
    文件名=URLUtil.guessFileName(链接,nil,nil)
  end
  local Download_layout={
    LinearLayout;
    orientation="vertical";
    id="Download_father_layout",
    {
      TextView;
      id="namehint",
      layout_marginTop="10dp";
      text="下载文件名",
      layout_marginLeft="10dp",
      layout_marginRight="10dp",
      layout_width="match_parent";
      textColor=WidgetColors,
      layout_gravity="center";
    };
    {
      EditText;
      id="nameedit",
      Text=文件名;
      layout_marginLeft="10dp",
      layout_marginRight="10dp",
      layout_width="match_parent";
      layout_gravity="center";
    };
  };

  AlertDialog.Builder(this)
  .setTitle("下载文件")
  .setMessage("文件类型："..类型.."\n".."文件大小："..大小)
  .setView(loadlayout(Download_layout))
  .setNeutralButton("复制",{onClick=function(v)
      复制文本(链接)
      提示("复制下载链接成功")
  end})
  .setPositiveButton("下载",{onClick=function(v)
      下载文件(链接,nameedit.Text)
  end})
  .setNegativeButton("取消",nil)
  .show()
end

function getDirSize(path)
  local len=0
  if not(File(path).exists()) then
    return 0
  end
  local a=luajava.astable(File(path).listFiles() or {})
  for k,v in pairs(a) do
    if v.isDirectory() then
      len=len+getDirSize(tab,tostring(v))
     else
      len=len+v.length()
    end
  end
  return len
end

import "androidx.core.content.ContextCompat"

--1毫秒后添加 防止加载失败
task(1,function()

  --停留30秒时才添加 防止不必要的清理
  task(30000,function()
    local old_onDestroy=onDestroy
    function onDestroy()
      if old_onDestroy~=nil then
        old_onDestroy()
      end
      old_onDestroy=nil

      --判断是否为主线程
      if Looper.myLooper() == Looper.getMainLooper() then
        --清理内存缓存
        Glide.get(this).clearMemory();
      end

      --[[
      --判断是否为主线程
      if Looper.myLooper() == Looper.getMainLooper() then
        --新建线程清理磁盘上的缓存
        Thread(Runnable({
          run=function()
            Glide.get(context).clearDiskCache()
          end
        })).start()
        --清理内存缓存
        Glide.get(this).clearMemory();
      end

      --清理缓存
      LuaUtil.rmDir(File(tostring(activity.getExternalCacheDir()).."/images"))
      LuaUtil.rmDir(File(tostring(ContextCompat.getDataDir(activity)).."/cache"))
]]

      collectgarbage("collect")
      System.gc()
    end
  end)

  local old_onResume=onResume
  function onResume()
    if old_onResume~=nil then
      old_onResume()
    end
    if (oldTheme~=ThemeUtil.getAppTheme()) or (oldDarkActionBar~=getSharedData("theme_darkactionbar")) then
      activity.recreate()
      return
    end
  end

end)

function 获取适配器项目布局(name)
  local dir="layout/item_layout/"
  return require(dir..name)
end


function table.swap(数据, 查找位置, 替换位置, ismode)
  if ismode then
    替换位置 = 替换位置 + 1
    查找位置 = 查找位置 + 1
  end
  xpcall(function()
    删除数据=table.remove(数据, 查找位置)
    end,function()
    return false
  end)
  table.insert(数据, 替换位置, 删除数据)
end

function getLogin()
  if activity.getSharedData("idx") then
    return true
   else
    return fasle
  end
end

head = {
  ["cookie"] = 获取Cookie("https://www.zhihu.com/");
}

posthead = {
  ["Content-Type"] = "application/json; charset=UTF-8";
  ["cookie"] = 获取Cookie("https://www.zhihu.com/");
}

apphead = {
  ["x-api-version"] = "3.0.89";
  ["x-app-za"] = "OS=Android";
  ["x-app-version"] = "8.44.0";
  ["cookie"] = 获取Cookie("https://www.zhihu.com/")
}

if activity.getSharedData("signdata")~=nil and getLogin() then
  login_access_token="Bearer"..require "cjson".decode(activity.getSharedData("signdata")).access_token;
  post_access_token_head={
    ["Content-Type"] = "application/json; charset=UTF-8";
    ["authorization"] = login_access_token;
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
  }
  access_token_head={
    ["authorization"] = login_access_token;
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
  }
 else
  post_access_token_head= posthead
  access_token_head = head
end

zHttp = {}

function zHttp.setcallback(code,content,callback)
  if code==403 then
    decoded_content = require "cjson".decode(content)
    if decoded_content.error and decoded_content.error.message and decoded_content.error.redirect then
      AlertDialog.Builder(this)
      .setTitle("提示")
      .setMessage(decoded_content.error.message)
      .setCancelable(false)
      .setPositiveButton("立即跳转",{onClick=function() activity.newActivity("huida",{decoded_content.error.redirect}) 提示("已跳转 成功后请自行退出") end})
      .show()
     else
      callback(code,content)
    end
   else
    callback(code,content)
  end
end


function zHttp.get(url,head,callback)
  Http.get(url,head,function(code,content)
    zHttp.setcallback(code,content,callback)
  end)
end

function zHttp.delete(url,head,callback)
  Http.delete(url,head,function(code,content)
    zHttp.setcallback(code,content,callback)
  end)
end


function zHttp.post(url,data,head,callback)
  Http.post(url,data,head,function(code,content)
    zHttp.setcallback(code,content,callback)
  end)
end

function zHttp.put(url,data,head,callback)
  Http.put(url,data,head,function(code,content)
    zHttp.setcallback(code,content,callback)
  end)
end



function 清理内存()
  task(1,function()

    import "androidx.core.content.ContextCompat"
    local datadir=tostring(ContextCompat.getDataDir(activity))
    local imagetmp=tostring(activity.getExternalCacheDir()).."/images"
    --   dar=File(activity.getLuaDir()).parent.."/cache/webviewCache"
    require "import"
    import "java.io.File"
    local tmp={[1]=0}

    local function getDirSize(tab,path)
      if File(path).exists() then
        local a=luajava.astable(File(path).listFiles() or {})

        for k,v in pairs(a) do
          if v.isDirectory() then
            getDirSize(tab,tostring(v))
           else

            tab[1]=tab[1]+v.length()
          end
        end
      end
    end

    dar=datadir.."/cache"
    getDirSize(tmp,dar)
    getDirSize(tmp,imagetmp)

    local a1,a2=File(datadir.."/database/webview.db"),File(datadir.."/database/webviewCache.db")
    pcall(function()
      tmp[1]=tmp[1]+(a1.length() or 0)+(a2.length() or 0)
      a1.delete()
      a2.delete()
    end)

    LuaUtil.rmDir(File(dar))
    LuaUtil.rmDir(File(imagetmp))

    m = tmp[1]
    if m == 0 then
      提示("没有可清理的缓存")
     else
      提示("清理成功,共清理 "..tokb(m))
    end
  end)
end

write_permissions={"android.permission.WRITE_EXTERNAL_STORAGE","android.permission.READ_EXTERNAL_STORAGE"};

function get_write_permissions(checksdk)

  if checksdk~=true then
    if Build.VERSION.SDK_INT >29 then
      --因为安卓10以上不使用/sdcard/了 使用android/data了
      return true
    end
  end

  if Build.VERSION.SDK_INT <30 then

    if PermissionUtil.check(write_permissions)~=true then
      PermissionUtil.askForRequestPermissions({
        {
          name=R.string.jesse205_permission_storage,
          tool=R.string.app_name,
          todo=getLocalLangObj("获取文件列表，读取文件和保存文件","Get file list, read file and save file"),
          permissions=write_permissions;
        },
      })
      return false
     else
      return true
    end
   else
    if Environment.isExternalStorageManager()~=true then

      import "android.net.Uri"
      import "android.content.Intent"
      import "android.provider.Settings"

      pcall(function()
        request_storage_intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION);
        request_storage_intent.setData(Uri.parse("package:" .. this.getPackageName()));
      end)

      local pm = this.getPackageManager()
      if not(request_storage_intent) or not pm.resolveActivity(request_storage_intent, 0) then
        local diatitle=getLocalLangObj("提示","Prompt")
        local diamessage=getLocalLangObj("你的设备无法直接打开「管理全部文件权限」的设置 请手动打开设置授权权限","Your device cannot directly open the <Manage All File Permissions> setting Please manually open Set Authorization Permissions")
        AlertDialog.Builder(this)
        .setTitle(diatitle)
        .setMessage(diamessage)
        .setPositiveButton(getLocalLangObj("我知道了","OK"),nil)
        .setCancelable(false)
        .show()
        return false
      end

      local diatitle=getLocalLangObj("提示","Prompt")
      local diamessage=getLocalLangObj("请点击确认跳转授权「管理全部文件权限」权限以使用本功能","Please click OK to authorize the <Manage All File Permissions> permission to use this feature")
      AlertDialog.Builder(this)
      .setTitle(diatitle)
      .setMessage(diamessage)
      .setPositiveButton(getLocalLangObj("确定","OK"),{onClick=function()
          this.startActivityForResult(request_storage_intent, 1);
      end})
      .setNegativeButton(getLocalLangObj("取消","Cancel"),nil)
      .setCancelable(false)
      .show()
      return false
     else
      return true
    end
  end
end

function get_installApp_permissions()
  import "android.Manifest"
  import "android.net.Uri"
  import "android.provider.Settings"
  import "android.content.Intent"
  if Build.VERSION.SDK_INT >= 26 then
    local pm =this.getPackageManager()
    if pm.canRequestPackageInstalls()~=true then

      pcall(function()
        local uri = Uri.parse("package:" .. activity.getPackageName())
        request_installApp_intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, uri)
      end)

      if not(request_installApp_intent) or not pm.resolveActivity(request_installApp_intent, 0) then
        local diatitle=getLocalLangObj("提示","Prompt")
        local diamessage=getLocalLangObj("你的设备无法直接打开「安装未知应用程序」的设置 请手动打开设置授权权限","Your device cannot directly open the <Install unknown applications> setting Please manually open Set Authorization Permissions")
        AlertDialog.Builder(this)
        .setTitle(diatitle)
        .setMessage(diamessage)
        .setPositiveButton(getLocalLangObj("我知道了","OK"),nil)
        .setCancelable(false)
        .show()
        return false
      end

      local diatitle=getLocalLangObj("提示","Prompt")
      local diamessage=getLocalLangObj("请点击确认跳转授权「安装未知应用程序」权限以使用本功能","Please click OK to authorize the <Install unknown applications> permission to use this feature")
      AlertDialog.Builder(this)
      .setTitle(diatitle)
      .setMessage(diamessage)
      .setPositiveButton(getLocalLangObj("确定","OK"),{onClick=function()
          this.startActivityForResult(request_installApp_intent, 1);
      end})
      .setNegativeButton(getLocalLangObj("取消","Cancel"),nil)
      .setCancelable(false)
      .show()
      return false
     else
      return true
    end
   else
    return true
  end
end

function 替换文件字符串(路径,要替换的字符串,替换成的字符串)
  if 路径 then
    路径=tostring(路径)
    内容=io.open(路径):read("*a")
    io.open(路径,"w+"):write(tostring(内容:gsub(要替换的字符串,替换成的字符串))):close()
   else
    return false
  end
end

function getApiurl()
  import "java.net.URL"
  local urlConnection = URL("http://mtw.so/6h4kqE").openConnection();
  urlConnection.setRequestMethod("GET");
  local location = urlConnection.getHeaderField("Location");
  urlConnection.disconnect();
  return location
end

function loadglide(view,url)
  import "com.bumptech.glide.load.engine.DiskCacheStrategy"
  Glide.with(this)
  .load(url)
  .diskCacheStrategy(DiskCacheStrategy.NONE)
  .into(view)
  Glide.get(this).clearMemory();
end

local mybase64=require("base64")
--encode 编码
function base64enc(str)
  return mybase64.enc(str)
end
--decode 解码
function base64dec(str)
  return mybase64.dec(str)
end

MD5=require("md5")