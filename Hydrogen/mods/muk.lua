require "import"
import "mods.imports"

versionCode=16.071
导航栏高度=activity.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().navigation_bar_height)
状态栏高度=activity.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().status_bar_height)
型号 = Build.MODEL
SDK版本 = tonumber(Build.VERSION.SDK)
安卓版本 = Build.VERSION.RELEASE
ROM类型 = string.upper(Build.MANUFACTURER)
内部存储路径=Environment.getExternalStorageDirectory().toString().."/"

应用版本名=activity.getPackageManager().getPackageInfo(activity.getPackageName(), PackageManager.GET_ACTIVITIES).versionName;
应用版本=activity.getPackageManager().getPackageInfo(activity.getPackageName(), PackageManager.GET_ACTIVITIES).versionCode;

APP_CACHEDIR="/data/data/"..activity.getPackageName().."/cache/webviewCache";

if this.getSharedData("调式模式")=="true" then
  this.setDebug(true)
end

if activity.getSharedData("font_size")==nil then
  activity.setSharedData("font_size","20")
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


function 状态栏颜色(n)
  pcall(function()
    local window=activity.getWindow()
    window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
    window.setStatusBarColor(n)
    statusbarcolor=n
    if SDK版本>=23 then
      if n==0x3f000000 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
        window.setStatusBarColor(0xffffffff)
       else
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE)
        window.setStatusBarColor(n)
      end
    end
  end)
end

function 导航栏颜色(n,n1)
  pcall(function()
    local window=activity.getWindow()
    window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
    window.setNavigationBarColor(n)
    if SDK版本>=23 then
      if n==0x3f000000 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
        window.setNavigationBarColor(0xffffffff)
       else
        if n1 then
          window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
         else
          window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE)
        end
        window.setNavigationBarColor(n)
      end
    end
  end)
end

function 沉浸状态栏(n1,n2,n3)
  pcall(function()
    local window=activity.getWindow()
    window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
    pcall(function()
      window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
      window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
      window.setStatusBarColor(Color.TRANSPARENT)
      window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE)
    end)
    if SDK版本>=23 then
      if n1 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE|View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
       elseif n2 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
       elseif n3 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE|View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR)
      end
    end

  end)
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
    f=File(tostring(File(tostring(路径)).getParentFile())).mkdirs()
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

function 文件修改时间(path)
  f = File(path);
  time = f.lastModified()
  return time
end

function 内置存储(t)
  return Environment.getExternalStorageDirectory().toString().."/"..t
end

function 压缩(from,to,name)
  ZipUtil.zip(from,to,name)
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

pcall(function()activity.getActionBar().hide()end)


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


function 主题(str)
  全局主题值=str
  if 全局主题值=="Day" then
    primaryc="#448aff"
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
    cardedge="#FFF6F6F6"
    状态栏颜色(0x3f000000)
    导航栏颜色(0x3f000000)
    pcall(function()
      local _window = activity.getWindow();
      _window.setBackgroundDrawable(ColorDrawable(0xffffffff));
      local _wlp = _window.getAttributes();
      _wlp.gravity = Gravity.BOTTOM;
      _wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
      _wlp.height = WindowManager.LayoutParams.MATCH_PARENT;--WRAP_CONTENT
      _window.setAttributes(_wlp);
      activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
    end)
   elseif 全局主题值=="Night" then
    primaryc="#FF88B0F8"
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
    cardedge="#555555"
    状态栏颜色(0xff191919)
    导航栏颜色(0xff191919)
    pcall(function()
      local _window = activity.getWindow();
      _window.setBackgroundDrawable(ColorDrawable(0xff222222));
      local _wlp = _window.getAttributes();
      _wlp.gravity = Gravity.BOTTOM;
      _wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
      _wlp.height = WindowManager.LayoutParams.MATCH_PARENT;--WRAP_CONTENT
      _window.setAttributes(_wlp);
      activity.setTheme(android.R.style.Theme_Material_NoActionBar)
    end)
  end
end


lsmactivity={
  setData=function(string_name,sth_value,string_mode)
    activity.setSharedData(string_name,sth_value)
  end,
  setDataR=function(string_name,sth_value,string_mode)
    if activity.getSharedData(string_name)==nil then
      activity.setSharedData(string_name,sth_value)
    end
  end,
  getData=function(string_name,string_mode,sth_notresult)
    if activity.getSharedData(string_name) then
      return activity.getSharedData(string_name)
     elseif string_mode=="Custom string" then
      return sth_notresult
     else
      return nil
    end
  end,
  CUSTOM_STRING="Custom string",
  CUSTOM_THINGS="Custom things",
}


if lsmactivity.getData("Setting_Auto_Night_Mode")==nil then
  activity.setSharedData("Setting_Auto_Night_Mode","true")
end


function 设置主题()
  if Boolean.valueOf(lsmactivity.getData("Setting_Auto_Night_Mode"))==true then
    if 获取系统夜间模式() then
      主题("Night")
     else --暂时这样写，后期修复
      if Boolean.valueOf(lsmactivity.getData("Setting_Night_Mode"))==true then
        主题("Night")
       else
        主题("Day")
      end
    end
   else
    if Boolean.valueOf(lsmactivity.getData("Setting_Night_Mode"))==true then
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

function 随机数(最小值,最大值)
  return math.random(最小值,最大值)
end

function 设置视图(t)
  activity.setContentView(loadlayout(t))
end



function 加载js(id,js)
  if js~=nil then
    id.evaluateJavascript(js,nil)
  end
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
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
      end
      if lx=="方主题" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
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

function 返回波纹(lx)
  if lx=="圆白" then
    return (activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
  end

  if lx=="方白" then
    return (activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
  end
  if lx=="圆黑" then
    return (activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
  end
  if lx=="方黑" then
    return (activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
  end
  if lx=="圆主题" then
    return (activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
  end
  if lx=="方主题" then
    return (activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
  end
  if lx=="圆自适应" then
    if 全局主题值=="Day" then
      return (activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
     else
      return (activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
    end
  end
  if lx=="方自适应" then
    if 全局主题值=="Day" then
      return (activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
     else
      return (activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
    end
  end


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

function 对话框按钮颜色(dialog,button,WidgetColor)
  if button==1 then
    dialog.getButton(dialog.BUTTON_POSITIVE).setTextColor(WidgetColor)
   elseif button==2 then
    dialog.getButton(dialog.BUTTON_NEGATIVE).setTextColor(WidgetColor)
   elseif button==3 then
    dialog.getButton(dialog.BUTTON_NEUTRAL).setTextColor(WidgetColor)
  end
end

function 关闭对话框(an)
  an.dismiss()
end

function 控件圆角(view,radiu,InsideColor)
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(InsideColor)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  view.setBackgroundDrawable(drawable)
end

function 三按钮对话框(bt,nr,qd,qx,ds,qdnr,qxnr,dsnr,gb)
  if 全局主题值=="Day" then
    bwz=0x3f000000
   else
    bwz=0x3fffffff
  end

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

  dialog=BottomDialog(activity)
  dialog.setView(loadlayout(dann))
  --设置弹窗位置
  dialog.setGravity(Gravity.BOTTOM)
  --设置弹窗高度,宽度，最低高度
  dialog.setHeight(-2)
  dialog.setMinHeight(0)
  dialog.setWidth(activity.getWidth())
  --设置圆角
  dialog.setRadius(dp2px(14),转0x(backgroundc))
  an=dialog.show()
  an.getWindow().setDimAmount(0.5)
  an.window.decorView.setPadding(0,0,0,0)
end


function 双按钮对话框(bt,nr,qd,qx,qdnr,qxnr,gb)
  if 全局主题值=="Day" then
    bwz=0x3f000000
   else
    bwz=0x3fffffff
  end

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

  --[[dl=AlertDialog.Builder(activity)
  dl.setView(loadlayout(dann))
  if gb==0 then
    dl.setCancelable(false)
  end
  an=dl.show()
  ]]
  dialog=BottomDialog(activity)
  dialog.setView(loadlayout(dann))
  --设置弹窗位置
  dialog.setGravity(Gravity.BOTTOM)
  --设置弹窗高度,宽度，最低高度
  dialog.setHeight(-2)
  dialog.setMinHeight(0)
  dialog.setWidth(activity.getWidth())
  --设置圆角
  dialog.setRadius(dp2px(14),转0x(backgroundc))
  an=dialog.show()
  an.getWindow().setDimAmount(0.5)
  an.window.decorView.setPadding(0,0,0,0)
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

  dialog=BottomDialog(activity)
  dialog.setView(loadlayout(dann))
  --设置弹窗位置
  dialog.setGravity(Gravity.BOTTOM)
  --设置弹窗高度,宽度，最低高度
  dialog.setHeight(-2)
  dialog.setMinHeight(0)
  dialog.setWidth(activity.getWidth())
  --设置圆角
  dialog.setRadius(dp2px(14),转0x(backgroundc))
  an=dialog.show()

  an.getWindow().setDimAmount(0.5)
  an.window.decorView.setPadding(0,0,0,0)
end




function 内置存储文件(u)
  if u =="" or u==nil then
    return 内置存储("Hydrogen/")
   else
    return 内置存储("Hydrogen/"..u)
  end
end


function 获取文件修改时间(path)
  f = File(path);
  cal = Calendar.getInstance();
  time = f.lastModified()
  cal.setTimeInMillis(time);
  return cal.getTime().toLocaleString()
end



function 解压缩(压缩路径,解压缩路径)
  xpcall(function()
    ZipUtil.unzip(压缩路径,解压缩路径)
    end,function()
    提示("解压文件 "..压缩路径.." 失败")
  end)
end

function 压缩(原路径,压缩路径,名称)
  xpcall(function()
    LuaUtil.zip(原路径,压缩路径,名称)
    end,function()
    提示("压缩文件 "..原路径.." 至 "..压缩路径.."/"..名称.." 失败")
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

--[[function 检查链接(url,b)
  local url="https"..url:match("https(.+)")

  if url:find("zhihu.com/question") then

    local answer,questions=0,0
    if url:find("answer") then
      questions,answer=url:match("question/(.-)/"),url:match("answer/(.+)")
     else
      questions,answer=url:match("question/(.+)"),nil
    end
    local open=activity.getSharedData("内部浏览器查看回答")
    if b then
      return true
    end
    if open=="false" then
      activity.newActivity("answer",{questions,answer})
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
   else
    if b then return false end
    activity.newActivity("huida",{url})
  end
end]]

function 检查链接(url,b)
  local open=activity.getSharedData("内部浏览器查看回答")
  local url="https"..url:match("https(.+)")

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
    Http.get("https://lens.zhihu.com/api/v4/videos/"..videoid,{
      ["cookie"] = 获取Cookie("https://www.zhihu.com/");
      },function(code,content)
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
   elseif url:find("zhihu.com/signin") then
    if b then return false end
    activity.newActivity("login")
   elseif url:find("https://ssl.ptlogin2.qq.com/jump") then
    if b then return false end
    activity.finish()
    activity.newActivity("login",{url})
   else
    if b then return false end
    activity.newActivity("huida",{url})
  end
end

function 检查意图(url,b)
  local get=require "model.answer"
  local open=activity.getSharedData("内部浏览器查看回答")

  local get=require "model.answer"
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
    local myurl="https"..url:match("https(.+)")
    检查链接(myurl)
  end
end

function 检测键盘()
  imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
  isOpen=imm.isActive()
  return isOpen==true or false
end

function 隐藏键盘()
  activity.getSystemService(INPUT_METHOD_SERVICE).hideSoftInputFromWindow(WidgetSearchActivity.this.getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS)
end

function 显示键盘(id)
  activity.getSystemService(INPUT_METHOD_SERVICE).showSoftInput(id, 0)
end

function 关闭页面()
  activity.finish()
end

function filter_spec_chars(s)
  local ss = {}
  for k = 1, #s do
    local c = string.byte(s,k)
    if not c then break end
    if ((c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) )then

      table.insert(ss, string.char(c))

     elseif c>=228 and c<=233 then
      local c1 = string.byte(s,k+1)
      local c2 = string.byte(s,k+2)
      if c1 and c2 then
        local a1,a2,a3,a4 = 128,191,128,191
        if c == 228 then a1 = 184
         elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165
        end
        if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then
          k = k + 2
          table.insert(ss, string.char(c,c1,c2))
        end
      end
    end
  end
  return table.concat(ss)
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

function QQ群(h)
  url="mqqapi://card/show_pslcard?src_type=internal&version=1&uin="..h.."&card_type=group&source=qrcode"
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end

function QQ(h)
  url="mqqapi://card/show_pslcard?src_type=internal&source=sharecard&version=1&uin="..h
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
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

function 高斯模糊(id,tp,radius1,radius2)
  function blur( context, bitmap, blurRadius)
    renderScript = RenderScript.create(context);
    blurScript = ScriptIntrinsicBlur.create(renderScript, Element.U8_4(renderScript));
    inAllocation = Allocation.createFromBitmap(renderScript, bitmap);
    outputBitmap = bitmap;
    outAllocation = Allocation.createTyped(renderScript, inAllocation.getType());
    blurScript.setRadius(blurRadius);
    blurScript.setInput(inAllocation);
    blurScript.forEach(outAllocation);
    outAllocation.copyTo(outputBitmap);
    inAllocation.destroy();
    outAllocation.destroy();
    renderScript.destroy();
    blurScript.destroy();
    return outputBitmap;
  end
  bitmap=loadbitmap(tp)
  function blurAndZoom(context,bitmap,blurRadius,scale)
    return zoomBitmap(blur(context,zoomBitmap(bitmap, 1 / scale), blurRadius), scale);
  end

  function zoomBitmap(bitmap,scale)
    w = bitmap.getWidth();
    h = bitmap.getHeight();
    matrix = Matrix();
    matrix.postScale(scale, scale);
    bitmap = Bitmap.createBitmap(bitmap, 0, 0, w, h, matrix, true);
    return bitmap;
  end


  加深后的图片=blurAndZoom(activity,bitmap,radius1,radius2)
  id.setImageBitmap(加深后的图片)
end

function 获取应用信息(archiveFilePath)
  pm = activity.getPackageManager()
  info = pm.getPackageInfo(archiveFilePath, PackageManager.GET_ACTIVITIES);
  if info ~= nil then
    appInfo = info.applicationInfo;
    appName = tostring(pm.getApplicationLabel(appInfo))
    packageName = appInfo.packageName; --安装包名称
    version=info.versionName; --版本信息
    icon = pm.getApplicationIcon(appInfo);--图标
  end
  return packageName,version,icon
end

function 编辑框颜色(eid,color)
  eid.getBackground().setColorFilter(PorterDuffColorFilter(color,PorterDuff.Mode.SRC_ATOP))
end

function 下载文件(链接,文件名)
  downloadManager=activity.getSystemService(Context.DOWNLOAD_SERVICE);
  url=Uri.parse(链接);
  request=DownloadManager.Request(url);
  request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_MOBILE|DownloadManager.Request.NETWORK_WIFI);
  request.setDestinationInExternalPublicDir(内置存储("Download",文件名));
  request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
  downloadManager.enqueue(request);
  提示("正在下载，下载到："..内置存储("Download/"..文件名).."\n请查看通知栏以查看下载进度。")
end

function 获取文件MIME(name)
  ExtensionName=tostring(name):match("%.(.+)")
  Mime=MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)
  return tostring(Mime)
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
  local path=内置存储("Download/"..path)
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
  local dldown=AlertDialog.Builder(activity)
  dldown.setView(loadlayout(布局))
  进度条.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(转0x(primaryc),PorterDuff.Mode.SRC_ATOP))
  dldown.setCancelable(false)
  local ao=dldown.show()
  window = ao.getWindow();
  window.setBackgroundDrawable(ColorDrawable(0x00ffffff));
  wlp = window.getAttributes();
  wlp.gravity = Gravity.BOTTOM;
  wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
  wlp.height = WindowManager.LayoutParams.WRAP_CONTENT;
  window.setAttributes(wlp);

  function ding(a,b)--已下载，总长度(byte)
    appdowninfo.Text=string.format("%0.2f",a/1024/1024).."MB/"..string.format("%0.2f",b/1024/1024).."MB".."\n下载状态：正在下载"
    进度条.progress=(a/b*100)
  end

  function dstop(c)--总长度
    --[[if path:find(".bin") then
      lpath=path
      path=path:gsub(".bin",".apk")
      重命名文件(lpath,path)
    end ]]
    关闭对话框(ao)

    --    if url:find("step")~=nil then
    if ex then
      提示("导入中…稍等哦(^^♪")
      解压缩(path,ex)
      删除文件(path)
      提示("导入完成ʕ•ٹ•ʔ")
     else
      --      提示("下载完成，大小"..string.format("%0.2f",c/1024/1024).."MB，储存在："..path)
      if path:find(".apk$")~=nil then
        提示("安装包下载成功,大小"..string.format("%0.2f",c/1024/1024).."MB，储存在："..path)
        双按钮对话框("安装APP",[===[您下载了安装包文件，要现在安装吗？ 取消后可前往]===]..path.."手动安装","立即安装","取消",function()
          --    关闭对话框(an)
          安装apk(path)end,function()关闭对话框(an)end)
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
  import "java.io.File"
  import "android.content.Intent"
  import "android.net.Uri"
  import "android.content.FileProvider"
  intent = Intent(Intent.ACTION_VIEW)
  intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
  intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
  if Build.VERSION.SDK_INT >= 24 then
    获取安装包=File(安装包路径)
    authority=activity.getApplicationContext().getPackageName()
    apkUri =FileProvider.getUriForFile(activity, authority, 获取安装包)
    intent.setDataAndType(apkUri, "application/vnd.android.package-archive");
   else
    intent.setDataAndType(Uri.parse("file://"..安装包路径), "application/vnd.android.package-archive")
  end
  activity.startActivity(intent)
end

function 浏览器打开(pageurl)
  import "android.content.Intent"
  import "android.net.Uri"
  viewIntent = Intent("android.intent.action.VIEW",Uri.parse(pageurl))
  activity.startActivity(viewIntent)
end

function 设置图片(preview,url)
  preview.setImageBitmap(loadbitmap(url))
end

function 字体(t)
  return Typeface.createFromFile(File(activity.getLuaDir().."/res/"..t..".ttf"))
end

function 开关颜色(id,color,color2)
  id.ThumbDrawable.setColorFilter(PorterDuffColorFilter(转0x(color),PorterDuff.Mode.SRC_ATOP))
  id.TrackDrawable.setColorFilter(PorterDuffColorFilter(转0x(color2),PorterDuff.Mode.SRC_ATOP))
end
--[[
function 微信扫一扫()
  intent = activity.getPackageManager().getLaunchIntentForPackage("com.tencent.mm");
  intent.putExtra("LauncherUI.From.Scaner.Shortcut", true);
  activity.startActivity(intent);
end]]

function 微信扫一扫()
  import "android.content.Intent"
  import "android.content.ComponentName"
  intent = Intent();
  intent.setComponent( ComponentName("com.tencent.mm", "com.tencent.mm.ui.LauncherUI"));
  intent.putExtra("LauncherUI.From.Scaner.Shortcut", true);
  intent.setFlags(335544320);
  intent.setAction("android.intent.action.VIEW");
  activity.startActivity(intent);
end

function 支付宝扫一扫()
  import "android.net.Uri"
  import "android.content.Intent"
  uri = Uri.parse("alipayqr://platformapi/startapp?saId=10000007");
  intent = Intent(Intent.ACTION_VIEW, uri);
  activity.startActivity(intent);
end

function 支付宝捐赠()
  --https://qr.alipay.com/fkx06301lzsvnw6bnfkfqe5
  xpcall(function()
    local url = "alipayqr://platformapi/startapp?saId=10000007&clientVersion=3.7.0.0718&qrcode=https://qr.alipay.com/fkx06301lzsvnw6bnfkfqe5"
    activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)));
  end,
  function()
    local url = "https://qr.alipay.com/fkx06301lzsvnw6bnfkfqe5";
    activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)));
  end)
end

function 颜色字体(t,c)
  local sp = SpannableString(t)
  sp.setSpan(ForegroundColorSpan(转0x(c)),0,#sp,Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  return sp
end

function 翻译(str,sth)
  retstr=str
  import "com.kn.rhino.*"
  import "java.net.URLEncoder"

  res=Js.runFunction(activity,[[function token(a) {
    var k = "";
    var b = 406644;
    var b1 = 3293161072;

    var jd = ".";
    var sb = "+-a^+6";
    var Zb = "+-3^+b+-f";

    for (var e = [], f = 0, g = 0; g < a.length; g++) {
        var m = a.charCodeAt(g);
        128 > m ? e[f++] = m: (2048 > m ? e[f++] = m >> 6 | 192 : (55296 == (m & 64512) && g + 1 < a.length && 56320 == (a.charCodeAt(g + 1) & 64512) ? (m = 65536 + ((m & 1023) << 10) + (a.charCodeAt(++g) & 1023), e[f++] = m >> 18 | 240, e[f++] = m >> 12 & 63 | 128) : e[f++] = m >> 12 | 224, e[f++] = m >> 6 & 63 | 128), e[f++] = m & 63 | 128)
    }
    a = b;
    for (f = 0; f < e.length; f++) a += e[f],
    a = RL(a, sb);
    a = RL(a, Zb);
    a ^= b1 || 0;
    0 > a && (a = (a & 2147483647) + 2147483648);
    a %= 1E6;
    return a.toString() + jd + (a ^ b)
};

function RL(a, b) {
    var t = "a";
    var Yb = "+";
    for (var c = 0; c < b.length - 2; c += 3) {
        var d = b.charAt(c + 2),
        d = d >= t ? d.charCodeAt(0) - 87 : Number(d),
        d = b.charAt(c + 1) == Yb ? a >>> d: a << d;
        a = b.charAt(c) == Yb ? a + d & 4294967295 : a ^ d ;
    }
    return a
};]],"token",{str})
  url="https://translate.google.cn/translate_a/single?"
  datastr=""
  data={"client=webapp",
    "sl=auto",
    "tl=zh-CN",
    "hl=zh-CN",
    "dt=at",
    "dt=bd",
    "dt=ex",
    "dt=ld",
    "dt=md",
    "dt=qca",
    "dt=rw",
    "dt=rm",
    "dt=ss",
    "dt=t",
    "ie=UTF-8",
    "oe=UTF-8",
    "source=btn",
    "ssel=0",
    "tsel=0",
    "kc=0",
    "tk="..res,
    "q="..URLEncoder.encode(str)}
  datastr=table.concat(data,"&")
  Http.get(url..datastr,{["User-Agent"]="Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7"},function(code,content)
    rettior=content
    sth()
  end)
end

function MD5(str)

  local HexTable = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
  local A = 0x67452301
  local B = 0xefcdab89
  local C = 0x98badcfe
  local D = 0x10325476

  local S11 = 7
  local S12 = 12
  local S13 = 17
  local S14 = 22
  local S21 = 5
  local S22 = 9
  local S23 = 14
  local S24 = 20
  local S31 = 4
  local S32 = 11
  local S33 = 16
  local S34 = 23
  local S41 = 6
  local S42 = 10
  local S43 = 15
  local S44 = 21

  local function F(x,y,z)
    return (x & y) | ((~x) & z)
  end
  local function G(x,y,z)
    return (x & z) | (y & (~z))
  end
  local function H(x,y,z)
    return x ~ y ~ z
  end
  local function I(x,y,z)
    return y ~ (x | (~z))
  end
  local function FF(a,b,c,d,x,s,ac)
    a = a + F(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end
  local function GG(a,b,c,d,x,s,ac)
    a = a + G(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end
  local function HH(a,b,c,d,x,s,ac)
    a = a + H(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end
  local function II(a,b,c,d,x,s,ac)
    a = a + I(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end



  local function MD5StringFill(s)
    local len = s:len()
    local mod512 = len * 8 % 512
    --需要填充的字节数
    local fillSize = (448 - mod512) // 8
    if mod512 > 448 then
      fillSize = (960 - mod512) // 8
    end

    local rTab = {}

    --记录当前byte在4个字节的偏移
    local byteIndex = 1
    for i = 1,len do
      local index = (i - 1) // 4 + 1
      rTab[index] = rTab[index] or 0
      rTab[index] = rTab[index] | (s:byte(i) << (byteIndex - 1) * 8)
      byteIndex = byteIndex + 1
      if byteIndex == 5 then
        byteIndex = 1
      end
    end
    --先将最后一个字节组成4字节一组
    --表示0x80是否已插入
    local b0x80 = false
    local tLen = #rTab
    if byteIndex ~= 1 then
      rTab[tLen] = rTab[tLen] | 0x80 << (byteIndex - 1) * 8
      b0x80 = true
    end

    --将余下的字节补齐
    for i = 1,fillSize // 4 do
      if not b0x80 and i == 1 then
        rTab[tLen + i] = 0x80
       else
        rTab[tLen + i] = 0x0
      end
    end

    --后面加原始数据bit长度
    local bitLen = math.floor(len * 8)
    tLen = #rTab
    rTab[tLen + 1] = bitLen & 0xffffffff
    rTab[tLen + 2] = bitLen >> 32

    return rTab
  end

  --	Func:	计算MD5
  --	Param:	string
  --	Return:	string
  ---------------------------------------------

  function string.md5(s)
    --填充
    local fillTab = MD5StringFill(s)
    local result = {A,B,C,D}

    for i = 1,#fillTab // 16 do
      local a = result[1]
      local b = result[2]
      local c = result[3]
      local d = result[4]
      local offset = (i - 1) * 16 + 1
      --第一轮
      a = FF(a, b, c, d, fillTab[offset + 0], S11, 0xd76aa478)
      d = FF(d, a, b, c, fillTab[offset + 1], S12, 0xe8c7b756)
      c = FF(c, d, a, b, fillTab[offset + 2], S13, 0x242070db)
      b = FF(b, c, d, a, fillTab[offset + 3], S14, 0xc1bdceee)
      a = FF(a, b, c, d, fillTab[offset + 4], S11, 0xf57c0faf)
      d = FF(d, a, b, c, fillTab[offset + 5], S12, 0x4787c62a)
      c = FF(c, d, a, b, fillTab[offset + 6], S13, 0xa8304613)
      b = FF(b, c, d, a, fillTab[offset + 7], S14, 0xfd469501)
      a = FF(a, b, c, d, fillTab[offset + 8], S11, 0x698098d8)
      d = FF(d, a, b, c, fillTab[offset + 9], S12, 0x8b44f7af)
      c = FF(c, d, a, b, fillTab[offset + 10], S13, 0xffff5bb1)
      b = FF(b, c, d, a, fillTab[offset + 11], S14, 0x895cd7be)
      a = FF(a, b, c, d, fillTab[offset + 12], S11, 0x6b901122)
      d = FF(d, a, b, c, fillTab[offset + 13], S12, 0xfd987193)
      c = FF(c, d, a, b, fillTab[offset + 14], S13, 0xa679438e)
      b = FF(b, c, d, a, fillTab[offset + 15], S14, 0x49b40821)

      --第二轮
      a = GG(a, b, c, d, fillTab[offset + 1], S21, 0xf61e2562)
      d = GG(d, a, b, c, fillTab[offset + 6], S22, 0xc040b340)
      c = GG(c, d, a, b, fillTab[offset + 11], S23, 0x265e5a51)
      b = GG(b, c, d, a, fillTab[offset + 0], S24, 0xe9b6c7aa)
      a = GG(a, b, c, d, fillTab[offset + 5], S21, 0xd62f105d)
      d = GG(d, a, b, c, fillTab[offset + 10], S22, 0x2441453)
      c = GG(c, d, a, b, fillTab[offset + 15], S23, 0xd8a1e681)
      b = GG(b, c, d, a, fillTab[offset + 4], S24, 0xe7d3fbc8)
      a = GG(a, b, c, d, fillTab[offset + 9], S21, 0x21e1cde6)
      d = GG(d, a, b, c, fillTab[offset + 14], S22, 0xc33707d6)
      c = GG(c, d, a, b, fillTab[offset + 3], S23, 0xf4d50d87)
      b = GG(b, c, d, a, fillTab[offset + 8], S24, 0x455a14ed)
      a = GG(a, b, c, d, fillTab[offset + 13], S21, 0xa9e3e905)
      d = GG(d, a, b, c, fillTab[offset + 2], S22, 0xfcefa3f8)
      c = GG(c, d, a, b, fillTab[offset + 7], S23, 0x676f02d9)
      b = GG(b, c, d, a, fillTab[offset + 12], S24, 0x8d2a4c8a)

      --第三轮
      a = HH(a, b, c, d, fillTab[offset + 5], S31, 0xfffa3942)
      d = HH(d, a, b, c, fillTab[offset + 8], S32, 0x8771f681)
      c = HH(c, d, a, b, fillTab[offset + 11], S33, 0x6d9d6122)
      b = HH(b, c, d, a, fillTab[offset + 14], S34, 0xfde5380c)
      a = HH(a, b, c, d, fillTab[offset + 1], S31, 0xa4beea44)
      d = HH(d, a, b, c, fillTab[offset + 4], S32, 0x4bdecfa9)
      c = HH(c, d, a, b, fillTab[offset + 7], S33, 0xf6bb4b60)
      b = HH(b, c, d, a, fillTab[offset + 10], S34, 0xbebfbc70)
      a = HH(a, b, c, d, fillTab[offset + 13], S31, 0x289b7ec6)
      d = HH(d, a, b, c, fillTab[offset + 0], S32, 0xeaa127fa)
      c = HH(c, d, a, b, fillTab[offset + 3], S33, 0xd4ef3085)
      b = HH(b, c, d, a, fillTab[offset + 6], S34, 0x4881d05)
      a = HH(a, b, c, d, fillTab[offset + 9], S31, 0xd9d4d039)
      d = HH(d, a, b, c, fillTab[offset + 12], S32, 0xe6db99e5)
      c = HH(c, d, a, b, fillTab[offset + 15], S33, 0x1fa27cf8)
      b = HH(b, c, d, a, fillTab[offset + 2], S34, 0xc4ac5665)

      --第四轮
      a = II(a, b, c, d, fillTab[offset + 0], S41, 0xf4292244)
      d = II(d, a, b, c, fillTab[offset + 7], S42, 0x432aff97)
      c = II(c, d, a, b, fillTab[offset + 14], S43, 0xab9423a7)
      b = II(b, c, d, a, fillTab[offset + 5], S44, 0xfc93a039)
      a = II(a, b, c, d, fillTab[offset + 12], S41, 0x655b59c3)
      d = II(d, a, b, c, fillTab[offset + 3], S42, 0x8f0ccc92)
      c = II(c, d, a, b, fillTab[offset + 10], S43, 0xffeff47d)
      b = II(b, c, d, a, fillTab[offset + 1], S44, 0x85845dd1)
      a = II(a, b, c, d, fillTab[offset + 8], S41, 0x6fa87e4f)
      d = II(d, a, b, c, fillTab[offset + 15], S42, 0xfe2ce6e0)
      c = II(c, d, a, b, fillTab[offset + 6], S43, 0xa3014314)
      b = II(b, c, d, a, fillTab[offset + 13], S44, 0x4e0811a1)
      a = II(a, b, c, d, fillTab[offset + 4], S41, 0xf7537e82)
      d = II(d, a, b, c, fillTab[offset + 11], S42, 0xbd3af235)
      c = II(c, d, a, b, fillTab[offset + 2], S43, 0x2ad7d2bb)
      b = II(b, c, d, a, fillTab[offset + 9], S44, 0xeb86d391)

      --加入到之前计算的结果当中
      result[1] = result[1] + a
      result[2] = result[2] + b
      result[3] = result[3] + c
      result[4] = result[4] + d
      result[1] = result[1] & 0xffffffff
      result[2] = result[2] & 0xffffffff
      result[3] = result[3] & 0xffffffff
      result[4] = result[4] & 0xffffffff
    end

    --将Hash值转换成十六进制的字符串
    local retStr = ""
    for i = 1,4 do
      for _ = 1,4 do
        local temp = result[i] & 0x0F
        local str = HexTable[temp + 1]
        result[i] = result[i] >> 4
        temp = result[i] & 0x0F
        retStr = retStr .. HexTable[temp + 1] .. str
        result[i] = result[i] >> 4
      end
    end

    return retStr
  end

  return string.md5(str)

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
  for k,v in ipairs(t.list) do

    tab.poplist.adapter.add{popadp_image=loadbitmap(v.src),popadp_text=v.text}
  end
  tab.poplist.adapter.notifyDataSetChanged()
  return tab
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

function 系统下载文件(a,b,c,d)
  import "android.content.Context"
  import "android.net.Uri"
  downloadManager=activity.getSystemService(Context.DOWNLOAD_SERVICE);
  url=Uri.parse(a);
  request=DownloadManager.Request(url);
  request.addRequestHeader("Referer",d)
  request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_MOBILE|DownloadManager.Request.NETWORK_WIFI);
  request.setDestinationInExternalPublicDir(b,c);
  request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
  downloadManager.enqueue(request);
end

--[[function java下载(url,path,进度条id,大小id,百分之id)
function xdc(url,path)
  require "import"
  import "java.net.URL"
  local ur =URL(url)
  import "java.io.File"
  file =File(path);
  con = ur.openConnection();
  co = con.getContentLength();
  is = con.getInputStream();
  bs = byte[1024]
  local len,read=0,0
  import "java.io.FileOutputStream"
  wj= FileOutputStream(path);
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
function download(url,path)
  thread(xdc,url,path)
end
function ding(a,b)--已下载，总长度(byte)
if 进度条id~=false then
  进度条id.Max=(b)
  进度条id.Progress=(a)
  end
if 大小id~=false then
  大小id.Text=(a/1024).."kb / "..(b/1024).."kb"
  end
if 百分之id~=false then
  百分之id.Text="正在下载中…"..(a/b*100).."%"
  end
end
--下载完成后调用
function dstop(c)--总长度
  function 完成()
    --完成id.Text="文件下载完成，总长度"..(c/1024).."kb"
    提示("下载完成")
  end
  function 完成b()
   -- text2.Text="正在加载中,稍等"
   downcallback()
    import "com.androlua.ZipUtil"
    import "java.io.File"
    ZipUtil.unzip(activity.getLuaDir()..".zip",activity.getLuaDir().."/")
    text2.Text="加载完成"
    os.remove(activity.getLuaDir()..".zip")
    activity.setSharedData("version",版本)
    local dl=AlertDialog.Builder(this)
    .setTitle("告知")
    .setMessage("恭喜你 文件加载成功 返回请点击我知道了")
    .setCancelable(false)
    .setPositiveButton("我知道了",{onClick=function()
        activity.newActivity("main")
        activity.finish()
    end})
    dl.create()
    dl.show()
  end
  thread(function()
    call("完成")
    call("完成b")
  end)
end
end]]

function table2string(tablevalue)
  local function serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
      lua = lua .. obj
     elseif t == "boolean" then
      lua = lua .. tostring(obj)
     elseif t == "string" then
      lua = lua .. string.format("%q", obj)
     elseif t == "table" then
      lua = lua .. "{"
      for k, v in pairs(obj) do
        lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","
      end
      local metatable = getmetatable(obj)
      if metatable ~= nil and type(metatable.__index) == "table" then
        for k, v in pairs(metatable.__index) do
          lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","
        end
      end
      lua = lua .. "}"
     elseif t == "nil" then
      return nil
     else
      error("can not serialize a " .. t .. " type.")
    end
    return lua
  end
  local stringtable = serialize(tablevalue)
  return stringtable
end


function 加入收藏夹(回答id,收藏类型)
  coll=""
  Http.get("https://www.zhihu.com/api/v4/me",{
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
    },function(code,content)
    if code==200 then
      import "android.widget.LinearLayout$LayoutParams"
      local function 新建收藏夹()
        InputLayout={
          LinearLayout;
          orientation="vertical";
          Focusable=true,
          FocusableInTouchMode=true,
          {
            LuaWebView;
            id="hhhh";
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
            id="editt";
          };
          {
            RadioButton;
            Text="仅自己可见";
            id="新建私密";
            onClick=function() if 新建公开.checked==true then 新建公开.checked=false 新建状况="false";
                加载js(hhhh,[[
        emulateMouseClick(
  document.getElementsByClassName("Favlists-privacyOptionRadio")[1]
);
        ]]) end end;
          };
          {
            RadioButton;
            Text="公开";
            id="新建公开";
            onClick=function() if 新建私密.checked==true then 新建私密.checked=false 新建状况="true"
                加载js(hhhh,[[
        emulateMouseClick(
  document.getElementsByClassName("Favlists-privacyOptionRadio")[0]
);
        ]]) end end;
          };
          --[[      {
        CheckBox;
        Text="设置为默认收藏夹";
        id="设置默认";
      };]]
        };
        aaaa=AlertDialog.Builder(this)
        .setTitle("新建收藏夹页面")
        .setView(loadlayout(InputLayout))
        .setPositiveButton("确定",nil)
        .setNegativeButton("取消",nil)
        .show()
        aaaa.getButton(aaaa.BUTTON_POSITIVE).onClick=function()
          local head = {
            ["cookie"] = 获取Cookie("https://www.zhihu.com/")
          }
          --    local newcollections_url= "https://www.zhihu.com/api/v4/collections"
          if edit.Text==""
            collecttitle=""
           else
            collecttitle=edit.Text
          end
          if editt.Text==""
            collectde=""
           else
            collectde=editt.Text
          end
          if edit.Text=="" then
            提示("请输入内容")
           else
            加载js(hhhh,'keyboardInput(document.getElementsByClassName("Input")[1], "'..collecttitle..'"); keyboardInput(document.getElementsByClassName("Input")[2], "'..collectde..'"); emulateMouseClick(document.getElementsByClassName("Button Button--primary Button--blue")[1]);  ')
            Http.get("https://api.zhihu.com/people/"..activity.getSharedData("idx").."/collections_v2?offset=0&limit=20",head,function(code,content)
              if code==200 then
                aaaa.dismiss()
                adp.clear()
                adp.setNotifyOnChange(true)
                for k,v in ipairs(require "cjson".decode(content).data) do

                  adp.add(v.title);
                end

              end
            end)
          end
        end
        hhhh.getSettings()
        .setUseWideViewPort(true)
        .setBuiltInZoomControls(true)
        .setSupportZoom(true)
        .setUserAgentString("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36");

        Http.get("https://api.zhihu.com/people/"..activity.getSharedData("idx"),head,function(code,content)
          if code==200 then
            if require "cjson".decode(content).url_token then
              hhhh.loadUrl("https://www.zhihu.com/people/"..require "cjson".decode(content).url_token.."/collections/")
             else
              提示("出错 请联系作者")
              aaaa.dismiss()
            end
          end
        end)

        dl=ProgressDialog.show(activity,nil,'加载中 请耐心等待')
        dl.show()


        hhhh.setWebViewClient{
          shouldOverrideUrlLoading=function(view,url)
            --Url即将跳转
          end,
          onPageStarted=function(view,url,favicon)
            --网页加载
          end,
          onPageFinished=function(view,url)
            view.evaluateJavascript([[
function emulateMouseClick(element) {
  // 创建事件
  var event = document.createEvent("MouseEvents");
  // 定义事件 参数： type, bubbles, cancelable
  event.initEvent("click", true, true);
  // 触发对象可以是任何元素或其他事件目标
  element.dispatchEvent(event);
}
function keyboardInput(dom, value) {
  let input = dom;
  let lastValue = input.value;
  input.value = value;
  let event = new Event("input", { bubbles: true });
  let tracker = input._valueTracker;
  if (tracker) {
    tracker.setValue(lastValue);
  }
  input.dispatchEvent(event);
}
emulateMouseClick(
  document.getElementsByClassName(
    "Button CollectionsHeader-addFavlistButton Button--link Button--withIcon Button--withLabel"
  )[0]
);
        emulateMouseClick(
  document.getElementsByClassName("Favlists-privacyOptionRadio")[1]
);
 ]],nil)
            dl.dismiss()
            --网页加载完成
        end}

        if 新建公开.checked==false and 新建私密.checked==false then
          新建私密.checked=true
          新建状态="false"
        end
        import "android.view.View$OnFocusChangeListener"
        edit.setOnFocusChangeListener(OnFocusChangeListener{
          onFocusChange=function(v,hasFocus)
            if hasFocus then
              Prompt.setTextColor(0xFD009688)
             else
              Prompt.setTextColor(-1979711488)
            end
        end})
        editt.setOnFocusChangeListener(OnFocusChangeListener{
          onFocusChange=function(v,hasFocus)
            if hasFocus then
              Promptt.setTextColor(0xFD009688)
             else
              Promptt.setTextColor(-1979711488)
            end
        end})
      end

      --创建ListView作为文件列表
      lv=ListView(activity).setFastScrollEnabled(true)
      addd=LinearLayout(activity)
      .setOrientation(0)
      .setGravity(Gravity.RIGHT|Gravity.CENTER)
      --创建路径标签


      lp=LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
      lp.gravity = Gravity.RIGHT|Gravity.CENTER
      lq=LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
      lq.gravity = Gravity.CENTER

      ac=TextView(activity).setText("待选中收藏夹")
      .setLayoutParams(lq);

      ab=ImageView(activity).setImageBitmap(loadbitmap(图标("add")))
      .setColorFilter(转0x(textc))
      .setLayoutParams(lp);

      ap=TextView(activity).setText("新建收藏夹")
      --      .setTextColor(0xFF000300)
      --      .setLayoutParams(lp);
      .setLayoutParams(lp);

      addd.addView(ap).addView(ab)
      --      addd.addView(ap)
      --[[      ab.onClick=function()
        新建收藏夹()
      end
]]
      ap.onClick=function()
        新建收藏夹()
      end

      cp=TextView(activity)
      lay=LinearLayout(activity).setOrientation(1).addView(ac).addView(addd).addView(cp).addView(lv)
      ChoiceFile_dialog=AlertDialog.Builder(activity)--创建对话框
      .setTitle("选择路径")
      .setPositiveButton("确认",{
        onClick=function()
          local head = {
            ["cookie"] = 获取Cookie("https://www.zhihu.com/")
          }
          Http.put("https://api.zhihu.com/collections/contents/"..收藏类型.."/"..回答id,"add_collections="..选中收藏夹,head,function(code,json)
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
      datas={}


      adp=ArrayAdapter(activity,android.R.layout.simple_list_item_1)
      lv.setAdapter(adp)

      lv.onItemClick=function(l,v,p,s)--列表点击事件
        ac.Text="当前选中收藏夹："..v.Text
        选中收藏夹=coll:match(v.Text..'(.-)'..v.Text)
      end

      local collections_url= "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/collections_v2?offset=0&limit=20"

      local head = {
        ["cookie"] = 获取Cookie("https://www.zhihu.com/")
      }

      Http.get(collections_url,head,function(code,content)
        if code==200 then
          adp.setNotifyOnChange(true)
          for k,v in ipairs(require "cjson".decode(content).data) do
            if coll:match(v.title) then
              coll=""
            end
            coll=coll..v.title..tostring(tointeger(v.id))..v.title
            adp.add(v.title);
          end

        end
      end)
     elseif code==401 then
      提示("请登录后使用本功能")
    end
  end)
end

import "android.graphics.drawable.GradientDrawable"

function CircleButton(view,InsideColor,radiu)
  local drawable = GradientDrawable()
  .setShape(GradientDrawable.RECTANGLE)
  .setColor(InsideColor)
  .setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu})
  --可通过 GradientDrawable 的其他方法实现其他效果
  pcall(function() view.setBackgroundDrawable(drawable) end)
  return drawable
end

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
  local 请求url="https://x-zes-96.huajicloud.ml/api"
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
      Http.get(url,{
        ["cookie"] = 获取Cookie("https://www.zhihu.com/");
        ["x-api-version"] = "3.0.91";
        ["x-zse-93"] = "101_3_3.0";
        ["x-zse-96"] = "2.0_"..content;
        ["x-app-za"] = "OS=Web";
        },function(codee,contentt)
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
  return string.gsub(s, " ", " ")
end

local get_api= "https://huajicloud.gitee.io/hydrogen.html"

Http.get(get_api,function(code,content)
  if code==200 then
    okstart=content:match("start%=(.+),start")
  end
end)
import "com.baidu.mobstat.StatService"
StatService
.setAppKey("c5aac7351d")
.start(this)
cardback=全局主题值=="Day" and cardedge or backgroundc
cardmargin=全局主题值=="Day" and "4px" or false

function 黑暗模式主题(view)
  加载js(view,[[;(function () {
    'use strict';

    let util = {

        addStyle(id, tag, css) {
            tag = tag || 'style';
            let doc = document, styleDom = doc.getElementById(id);
            if (styleDom) return;
            let style = doc.createElement(tag);
            style.rel = 'stylesheet';
            style.id = id;
            tag === 'style' ? style.innerHTML = css : style.href = css;
            doc.head.appendChild(style);
        },

        hover(ele, fn1, fn2) {
            ele.onmouseenter = function () {  //移入事件
                fn1.call(ele);
            };
            ele.onmouseleave = function () { //移出事件
                fn2.call(ele);
            };
        },

        addThemeColor(color) {
            let doc = document, meta = doc.getElementsByName('theme-color')[0];
            if (meta) return meta.setAttribute('content', color);
            let metaEle = doc.createElement('meta');
            metaEle.name = 'theme-color';
            metaEle.content = color;
            doc.head.appendChild(metaEle);
        },

        getThemeColor() {
            let meta = document.getElementsByName('theme-color')[0];
            if (meta) {
                return meta.content;
            }
            return '#ffffff';
        },

        removeElementById(eleId) {
            let ele = document.getElementById(eleId);
            ele && ele.parentNode.removeChild(ele);
        },

        hasElementById(eleId) {
            return document.getElementById(eleId);
        },

        filter: '-webkit-filter: url(#dark-mode-filter) !important; filter: url(#dark-mode-filter) !important;',
        reverseFilter: '-webkit-filter: url(#dark-mode-reverse-filter) !important; filter: url(#dark-mode-reverse-filter) !important;',
        firefoxFilter: `filter: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg"><filter id="dark-mode-filter" color-interpolation-filters="sRGB"><feColorMatrix type="matrix" values="0.283 -0.567 -0.567 0 0.925 -0.567 0.283 -0.567 0 0.925 -0.567 -0.567 0.283 0 0.925 0 0 0 1 0"/></filter></svg>#dark-mode-filter') !important;`,
        firefoxReverseFilter: `filter: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg"><filter id="dark-mode-reverse-filter" color-interpolation-filters="sRGB"><feColorMatrix type="matrix" values="0.333 -0.667 -0.667 0 1 -0.667 0.333 -0.667 0 1 -0.667 -0.667 0.333 0 1 0 0 0 1 0"/></filter></svg>#dark-mode-reverse-filter') !important;`,
        noneFilter: '-webkit-filter: none !important; filter: none !important;',
    };

    let main = {

        addExtraStyle() {
            try {
                return darkModeRule;
            } catch (e) {
                return '';
            }
        },

        createDarkFilter() {
            if (util.hasElementById('dark-mode-svg')) return;
            let svgDom = '<svg id="dark-mode-svg" style="height: 0; width: 0;"><filter id="dark-mode-filter" x="0" y="0" width="99999" height="99999"><feColorMatrix type="matrix" values="0.283 -0.567 -0.567 0 0.925 -0.567 0.283 -0.567 0 0.925 -0.567 -0.567 0.283 0 0.925 0 0 0 1 0"></feColorMatrix></filter><filter id="dark-mode-reverse-filter" x="0" y="0" width="99999" height="99999"><feColorMatrix type="matrix" values="0.333 -0.667 -0.667 0 1 -0.667 0.333 -0.667 0 1 -0.667 -0.667 0.333 0 1 0 0 0 1 0"></feColorMatrix></filter></svg>';
            let div = document.createElementNS('http://www.w3.org/1999/xhtml', 'div');
            div.innerHTML = svgDom;
            let frag = document.createDocumentFragment();
            while (div.firstChild)
                frag.appendChild(div.firstChild);
            document.head.appendChild(frag);
        },

        createDarkStyle() {
            util.addStyle('dark-mode-style', 'style', `
                @media screen {
                    html {
                        ${this.isFirefox() ? util.firefoxFilter : util.filter}
                        scrollbar-color: #454a4d #202324;
                    }
            
                    /* Default Reverse rule */
                    img, 
                    .sr-backdrop {
                        ${this.isFirefox() ? util.firefoxReverseFilter : util.reverseFilter}
                    }
            
                    [style*="background:url"] *,
                    [style*="background-image:url"] *,
                    [style*="background: url"] *,
                    [style*="background-image: url"] *,
                    input,
                    [background] *,
                    img[src^="https://s0.wp.com/latex.php"],
                    twitterwidget .NaturalImage-image {
                        ${util.noneFilter}
                    }
            
                    /* Text contrast */
                    html {
                        text-shadow: 0 0 0 !important;
                    }
            
                    /* Full screen */
                    .no-filter,
                    :-webkit-full-screen,
                    :-webkit-full-screen *,
                    :-moz-full-screen,
                    :-moz-full-screen *,
                    :fullscreen,
                    :fullscreen * {
                        ${util.noneFilter}
                    }
                    
                    ::-webkit-scrollbar {
                        background-color: #202324;
                        color: #aba499;
                    }
                    ::-webkit-scrollbar-thumb {
                        background-color: #454a4d;
                    }
                    ::-webkit-scrollbar-thumb:hover {
                        background-color: #575e62;
                    }
                    ::-webkit-scrollbar-thumb:active {
                        background-color: #484e51;
                    }
                    ::-webkit-scrollbar-corner {
                        background-color: #181a1b;
                    }
            
                    /* Page background */
                    html {
                        background: #fff !important;
                    }
                    
                    ${this.addExtraStyle()}
                }
            
                @media print {
                    .no-print {
                        display: none !important;
                    }
                }`);
        },



        enableDarkMode() {
            if (this.isFullScreen()) return;
            !this.isFirefox() && this.createDarkFilter();
            this.createDarkStyle();
            util.addThemeColor('#131313');
        },

        disableDarkMode() {
            util.removeElementById('dark-mode-svg');
            util.removeElementById('dark-mode-style');
            util.addThemeColor('#ffffff');
        },

        addDarkTheme() {

                        lightDOM.style.transform = 'scale(1)';
                        lightDOM.style.opacity = '1';
                        darkDOM.style.transform = 'scale(0)';
                        darkDOM.style.opacity = '0';
                        this.enableDarkMode();
        },

        isTopWindow() {
            return window.self === window.top;
        },

        addListener() {
            document.addEventListener("fullscreenchange", (e) => {
                if (this.isFullScreen()) {
                    //进入全屏
                    this.disableDarkMode();
                } else {
                    //退出全屏
                    this.enableDarkMode();
                }
            });
        },

        isFullScreen() {
            return document.fullscreenElement;
        },

        isFirefox() {
            return /Firefox/i.test(navigator.userAgent);
        },

        firstEnableDarkMode() {
            if (document.head) {
                this.enableDarkMode();
            }
            const headObserver = new MutationObserver(() => {
                his.enableDarkMode();
            });
            headObserver.observe(document.head, {childList: true, subtree: true});

            if (document.body) {
                this.addDarkTheme();
            } else {
                const bodyObserver = new MutationObserver(() => {
                    if (document.body) {
                        bodyObserver.disconnect();
                        this.addDarkTheme();
                    }
                });
                bodyObserver.observe(document, {childList: true, subtree: true});
            }
        },

        init() {
            this.addListener();
            this.firstEnableDarkMode();
        }
    };
    main.init();
})();
]])
end

function 白天主题(view)
  加载js(view,[[;(function () {
    'use strict';

    let util = {

        addStyle(id, tag, css) {
            tag = tag || 'style';
            let doc = document, styleDom = doc.getElementById(id);
            if (styleDom) return;
            let style = doc.createElement(tag);
            style.rel = 'stylesheet';
            style.id = id;
            tag === 'style' ? style.innerHTML = css : style.href = css;
            doc.head.appendChild(style);
        },

        hover(ele, fn1, fn2) {
            ele.onmouseenter = function () {  //移入事件
                fn1.call(ele);
            };
            ele.onmouseleave = function () { //移出事件
                fn2.call(ele);
            };
        },

        addThemeColor(color) {
            let doc = document, meta = doc.getElementsByName('theme-color')[0];
            if (meta) return meta.setAttribute('content', color);
            let metaEle = doc.createElement('meta');
            metaEle.name = 'theme-color';
            metaEle.content = color;
            doc.head.appendChild(metaEle);
        },

        getThemeColor() {
            let meta = document.getElementsByName('theme-color')[0];
            if (meta) {
                return meta.content;
            }
            return '#ffffff';
        },

        removeElementById(eleId) {
            let ele = document.getElementById(eleId);
            ele && ele.parentNode.removeChild(ele);
        },

        hasElementById(eleId) {
            return document.getElementById(eleId);
        },

        filter: '-webkit-filter: url(#dark-mode-filter) !important; filter: url(#dark-mode-filter) !important;',
        reverseFilter: '-webkit-filter: url(#dark-mode-reverse-filter) !important; filter: url(#dark-mode-reverse-filter) !important;',
        firefoxReverseFilter: `filter: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg"><filter id="dark-mode-reverse-filter" color-interpolation-filters="sRGB"><feColorMatrix type="matrix" values="0.333 -0.667 -0.667 0 1 -0.667 0.333 -0.667 0 1 -0.667 -0.667 0.333 0 1 0 0 0 1 0"/></filter></svg>#dark-mode-reverse-filter') !important;`,
    };

    let main = {
    
        addExtraStyle() {
            try {
                return darkModeRule;
            } catch (e) {
                return '';
            }
        },



        createDayStyle() {
            util.addStyle('day-style', 'style', `
                @media screen {
                    img, 
                    .sr-backdrop {
                        ${this.isFirefox() ? util.firefoxReverseFilter : util.reverseFilter}
                    }                                                   
                }
            `);
        },


        isFirefox() {
            return /Firefox/i.test(navigator.userAgent);
        },


        init() {
            this.createDayStyle();
        }
    };
    main.init();
})();
]])
end

function 等待doc(view)
  加载js(view,[[function waitForKeyElements(selectorOrFunction, callback, waitOnce, interval, maxIntervals) {
		if (typeof waitOnce === "undefined") {
			waitOnce = true;
		}
		if (typeof interval === "undefined") {
			interval = 300;
		}
		if (typeof maxIntervals === "undefined") {
			maxIntervals = -1;
		}
		var targetNodes =
			typeof selectorOrFunction === "function" ? selectorOrFunction() : document.querySelectorAll(selectorOrFunction);

		var targetsFound = targetNodes && targetNodes.length > 0;
		if (targetsFound) {
			targetNodes.forEach(function(targetNode) {
				var attrAlreadyFound = "data-userscript-alreadyFound";
				var alreadyFound = targetNode.getAttribute(attrAlreadyFound) || false;
				if (!alreadyFound) {
					var cancelFound = callback(targetNode);
					if (cancelFound) {
						targetsFound = false;
					} else {
						targetNode.setAttribute(attrAlreadyFound, true);
					}
				}
			});
		}

		if (maxIntervals !== 0 && !(targetsFound && waitOnce)) {
			maxIntervals -= 1;
			setTimeout(function() {
				waitForKeyElements(selectorOrFunction, callback, waitOnce, interval, maxIntervals);
			}, interval);
		}
	}]])
end

function matchtext(str,regex)
  local t={}
  for i,v in string.gfind(str,regex) do
    table.insert(t,string.sub(str,i,v))
  end
  return t
end --返回table