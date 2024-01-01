require "import"
import "mods.imports"

import "model.zHttp"
import "model.zhihu_url"

luajson=require "json"

initApp=true
useCustomAppToolbar=true
import "jesse205"

oldTheme=ThemeUtil.getAppTheme()
oldDarkActionBar=getSharedData("theme_darkactionbar")

--重写SwipeRefreshLayout到自定义view 原SwipeRefreshLayout和滑动组件有bug
SwipeRefreshLayout = luajava.bindClass "com.hydrogen.view.CustomSwipeRefresh"
--重写BottomSheetDialog到自定义view 解决横屏显示不全问题
BottomSheetDialog = luajava.bindClass "com.hydrogen.view.BaseBottomSheetDialog"


versionCode=0.4
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
  if Build.VERSION.SDK_INT >=30 then
    return activity.getExternalFilesDir(nil).toString() .. "/" ..t
  end
  return Environment.getExternalStorageDirectory().toString().."/"..t
end


function 获取Cookie(url,isckeck)
  if isckeck and url=="https://www.zhihu.com/" then
    if activity.getSharedData("signdata")~=nil and getLogin() then
      local data=luajson.decode(activity.getSharedData("signdata")).cookie
      local mdata={}
      for k,v pairs(data)
        table.insert(mdata,k.."="..v)
      end
      mdata=table.concat(mdata,"; ")
      return mdata;
    end
  end
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


function 获取系统夜间模式(isApplicationContext)
  local mactivity
  if isApplicationContext==true then
    mactivity=activity.getApplicationContext()
   else
    mactivity=activity
  end
  _,Re=xpcall(function()
    import "android.content.res.Configuration"
    currentNightMode = mactivity.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK
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
  local hex_str = string.format("#%08X", color)
  return hex_str
end

function 主题(str)
  全局主题值=str
  if 全局主题值=="Day" then
    --primaryc="#448aff"
    primaryc=dec2hex(res.color.attr.colorPrimary)
    secondaryc="#fdd835"
    textc="#212121"
    stextc="#424242"
    backgroundc="#ffffffff"
    oribarbackgroundc="#efffffff"
    barbackgroundc=android.res.color.attr.colorBackground&0xFFFFFF+0xFF000000*0.8
    cardbackc="#fff1f1f1"
    viewshaderc="#00000000"
    grayc="#ECEDF1"
    ripplec="#559E9E9E"
    --cardedge="#FFE0E0E0"
    cardedge=dec2hex(res.color.attr.colorSurface)
    oricardedge="#FFF6F6F6"
    --cardedge="#FFF6F6F6"
    pcall(function()
      local _window = activity.getWindow();
      _window.setBackgroundDrawable(ColorDrawable(0xffffffff));
      local _wlp = _window.getAttributes();
      _wlp.gravity = Gravity.BOTTOM;
      _wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
      _wlp.height = WindowManager.LayoutParams.MATCH_PARENT;--WRAP_CONTENT
      _window.setAttributes(_wlp);
    end)
    if 获取主题夜间模式() == true then
      if Boolean.valueOf(this.getSharedData("Setting_Auto_Night_Mode"))==true then
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
       else
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
      end
      return
     else
      AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
      return
    end
   elseif 全局主题值=="Night" then
    --primaryc="#FF88B0F8"
    primaryc=dec2hex(res.color.attr.colorPrimary)
    secondaryc="#ffbfa328"
    --textc="#808080"
    textc="#FFCBCBCB"
    --stextc="#666666"
    stextc="#808080"
    backgroundc="#ff191919"
    oribarbackgroundc="#ef191919"
    barbackgroundc=android.res.color.attr.colorBackground&0xFFFFFF+0xFF000000*0.8
    cardbackc="#ff212121"
    viewshaderc="#80000000"
    grayc="#212121"
    ripplec="#559E9E9E"
    cardedge=dec2hex(res.color.attr.colorSurface-0x4f000000)
    oricardedge="#555555"
    --cardedge="#555555"
    pcall(function()
      local _window = activity.getWindow();
      _window.setBackgroundDrawable(ColorDrawable(0xff222222));
      local _wlp = _window.getAttributes();
      _wlp.gravity = Gravity.BOTTOM;
      _wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
      _wlp.height = WindowManager.LayoutParams.MATCH_PARENT;
      _window.setAttributes(_wlp);
    end)
    if 获取主题夜间模式() == false and 获取系统夜间模式() == false then
      AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
      return
    end
  end
end

function 设置主题()
  if Boolean.valueOf(this.getSharedData("Setting_Auto_Night_Mode"))==true then
    if 获取系统夜间模式(true) then
      主题("Night")
     else
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

function 转0x(j,isAndroid)
  if #j==7 then
    jj=j:match("#(.+)")
    jjj=tonumber("0xff"..jj)
   else
    jj=j:match("#(.+)")
    jjj=tonumber("0x"..jj)
  end
  -- 如果安卓的颜色值大于2^31-1，那么它是一个负数，需要减去2^32
  if isAndroid and jjj > 2^31 - 1 then
    jjj = tointeger(jjj - 2^32)
  end
  return jjj
end

function 提示(t)

  if my_toast then
    my_toast.cancel()
  end

  local w=activity.width

  local tsbj={
    LinearLayout,
    Gravity="bottom",
    {
      MaterialCardView,
      layout_width="-1";
      layout_height="-2";
      CardElevation="0",
      CardBackgroundColor=转0x(textc)-0x3f000000,
      StrokeWidth=0,
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

  my_toast=Toast.makeText(activity,t,Toast.LENGTH_SHORT).setGravity(Gravity.BOTTOM|Gravity.CENTER, 0, 0).setView(loadlayout(tsbj)).show()
end


function Snakebar(fill)
  提示(fill)
end

function 颜色渐变(控件,左色,右色)
  import "android.graphics.drawable.GradientDrawable"
  local drawable = GradientDrawable(GradientDrawable.Orientation.TR_BL,{左色,右色,});
  控件.IndeterminateDrawable=(drawable)
  --控件.setBackgroundDrawable(ColorDrawable(左色))
end


function 设置视图(t)
  activity.setContentView(loadlayout(t))
end

function 加载js(id,js)
  if js~=nil then
    id.post{
      run=function()
        id.evaluateJavascript(js,nil)
      end
    }
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
    加载js(id,[[let doc=document.createElement('style');doc.innerHTML=']]..v..[[{display:none !important}';document.head.appendChild(doc);]])
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
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{转0x(primaryc)-0xdf000000})))
      end
      if lx=="方主题" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{转0x(primaryc)-0xdf000000})))
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
  local bwz
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
    layout_width=-1;
    layout_height=-1;
    {
      LinearLayout;
      orientation="vertical";
      layout_width=-1;
      layout_height=-2;
      Elevation="4dp";
      BackgroundDrawable=gd2;
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
        TextView;
        layout_width=-1;
        layout_height=-2;
        textSize="20sp";
        layout_marginTop="24dp";
        layout_marginLeft="24dp";
        layout_marginRight="24dp";
        Text=bt;
        Typeface=字体("product-Bold");
        textColor=转0x(primaryc);
      };
      {
        ScrollView;
        layout_width=-1;
        layout_height=-1;
        {
          TextView;
          layout_width=-1;
          layout_height=-2;
          textSize="14sp";
          layout_marginTop="8dp";
          layout_marginLeft="24dp";
          layout_marginRight="24dp";
          layout_marginBottom="8dp";
          Typeface=字体("product");
          Text=nr;
          textColor=转0x(textc);
          id="sandhk_wb";
        };
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_width=-1;
        layout_height=-2;
        gravity="right|center";
        {
          MaterialButton_TextButton;
          layout_marginTop="16dp";
          layout_marginLeft="16dp";
          layout_marginRight="16dp";
          layout_marginBottom="16dp";
          textColor=转0x(stextc);
          text=ds;
          id="dsnr_c";
          RippleColor=ColorStateList(int[0].class{int{}},int{bwz});
          Typeface=字体("product-Bold");
        };
        {
          LinearLayout;
          orientation="horizontal";
          layout_width=-1;
          layout_height=-2;
          layout_weight=1;
        };
        {
          MaterialButton_TextButton;
          textColor=转0x(stextc);
          text=qx;
          id="qxnr_c";
          RippleColor=ColorStateList(int[0].class{int{}},int{bwz});
          Typeface=字体("product-Bold");
        };
        {
          MaterialButton;
          layout_marginTop="16dp";
          layout_marginLeft="16dp";
          layout_marginRight="16dp";
          layout_marginBottom="16dp";
          textColor=转0x(backgroundc);
          text=qd;
          id="qdnr_c";
          Typeface=字体("product-Bold");
        };
      };
    };
  };

  local bottomSheetDialog = BottomSheetDialog(this)
  bottomSheetDialog.setContentView(loadlayout2(dann))
  local an=bottomSheetDialog.show()
  dsnr_c.onClick=function()
    dsnr(an)
  end;
  qxnr_c.onClick=function()
    qxnr(an)
  end;
  qdnr_c.onClick=function()
    qdnr(an)
  end;
end


function 双按钮对话框(bt,nr,qd,qx,qdnr,qxnr,gb)

  local bwz
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
    layout_width=-1;
    layout_height=-1;
    {
      LinearLayout;
      orientation="vertical";
      layout_width=-1;
      layout_height=-2;
      Elevation="4dp";
      BackgroundDrawable=gd2;
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
        TextView;
        layout_width=-1;
        layout_height=-2;
        textSize="20sp";
        layout_marginTop="24dp";
        layout_marginLeft="24dp";
        layout_marginRight="24dp";
        Text=bt;
        Typeface=字体("product-Bold");
        textColor=转0x(primaryc);
      };
      {
        ScrollView;
        layout_width=-1;
        layout_height=-1;
        {
          TextView;
          layout_width=-1;
          layout_height=-2;
          textSize="14sp";
          layout_marginTop="8dp";
          layout_marginLeft="24dp";
          layout_marginRight="24dp";
          layout_marginBottom="8dp";
          Typeface=字体("product");
          Text=nr;
          textColor=转0x(textc);
          id="sandhk_wb";
        };
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_width=-1;
        layout_height=-2;
        gravity="right|center";
        {
          MaterialButton_TextButton;
          textColor=转0x(stextc);
          text=qx;
          id="qxnr_c";
          RippleColor=ColorStateList(int[0].class{int{}},int{bwz});
          Typeface=字体("product-Bold");
        };
        {
          MaterialButton;
          layout_marginTop="16dp";
          layout_marginLeft="16dp";
          layout_marginRight="16dp";
          layout_marginBottom="16dp";
          textColor=转0x(backgroundc);
          text=qd;
          id="qdnr_c";
          Typeface=字体("product-Bold");
        };
      };
    };
  };

  local bottomSheetDialog = BottomSheetDialog(this)
  bottomSheetDialog.setContentView(loadlayout2(dann))
  local an=bottomSheetDialog.show()
  qxnr_c.onClick=function()
    qxnr(an)
  end;
  qdnr_c.onClick=function()
    qdnr(an)
  end;
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
        双按钮对话框("安装APP",[===[您下载了安装包文件，要现在安装吗？ 取消后可前往]===]..path.."手动安装","立即安装","取消",function(an)
          安装apk(path)
          end,function(an)
          关闭对话框(an)
        end)
        if myupdatedialog then
          myupdatedialog.getButton(myupdatedialog.BUTTON_POSITIVE).Text="立即安装"
          myupdatedialog.getButton(myupdatedialog.BUTTON_POSITIVE).onClick=function()
            安装apk(path)
          end
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
    if t.isload_codeEx~=true then
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
            local _,merror=pcall(function()
              load(edit.Text)()
            end)
            if _==false then
              提示(merror)
             else
              --              提示("执行成功")
            end
          end
      end})
      t.isload_codeEx=true
    end
  end

  for k,v in ipairs(t.list) do
    tab.poplist.adapter.add{popadp_image=loadbitmap(v.src),popadp_text=v.text}
  end

  tab.poplist.adapter.notifyDataSetChanged()
  return tab
end

--例如
--[[
  tab={

    {"menu 1",function() print("1") end},--one
    {"menu 2",function() print("2") end},
    {"menu 3",function() print("3") end},

    {--box
      "子菜单1",
      {
        {"menu 1",function() print("1") end},
        {"menu 2",function() print("2") end},
        {"menu 3",function() print("3") end},
      },
    },

  }
  showPopMenu(tab,"主菜单").showAsDropDown(menu)--弹出菜单
]]
function showPopMenu(tab,title)
  local lp = activity.getWindow().getAttributes();
  lp.alpha = 0.85;
  activity.getWindow().setAttributes(lp);
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
  local ripple = activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0,0)
  local ripples = activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0,0)
  local Popup_layout={
    LinearLayout;
    {
      MaterialCardView;
      Elevation="0";
      CardBackgroundColor=0xfffafafa;
      StrokeWidth=0,
      layout_width="192dp";
      layout_height="-2";
      layout_marginLeft="8dp";
      {
        ScrollView;
        layout_height="fill";
        layout_width="fill";
        {
          LinearLayout;
          layout_height="fill";
          layout_width="fill";
          {
            LinearLayout;
            layout_height="-1";
            layout_width="-1";
            orientation="vertical",
            id="Popup_list";
          };
        };
      }
    };
  };
  --PopupWindow
  pops=PopupWindow(activity)
  --PopupWindow加载布局
  pops.setContentView(loadlayout(Popup_layout))
  pops.setWidth(-2)
  pops.setHeight(-2)
  pops.setFocusable(true)
  pops.setOutsideTouchable(true)
  pops.setBackgroundDrawable(ColorDrawable(0x00000000))
  pops.onDismiss=function()
    local lp = activity.getWindow().getAttributes();
    lp.alpha = 1;
    activity.getWindow().setAttributes(lp);
    activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
  end

  --PopupWindow标题项布局
  local Popup_list_title={
    LinearLayout;
    layout_width="-1";
    layout_height="48dp";
    {
      TextView;
      id="popadp_text";
      Typeface=Typeface.DEFAULT_BOLD,
      textColor=0xFF2196F3;

      layout_width="-1";
      layout_height="-1";
      textSize="14sp";
      gravity="left|center";
      paddingLeft="16dp";
      Enabled=false,
    };
  };

  if title then--如果有标题
    local view=loadlayout(Popup_list_title)--设置标题项布局
    Popup_list.addView(view)--添加
    popadp_text.setText(title)--设置标题
  end

  --PopupWindow列表项布局
  local Popup_list_item={
    LinearLayout;
    layout_width="-1";
    layout_height="48dp";
    {
      TextView;
      id="popadp_text";
      textColor=stextc;
      Typeface=字体("product");
      layout_width="-1";
      layout_height="-1";
      textSize="14sp";
      gravity="left|center";
      paddingLeft="16dp";
    };
  };

  for a,b in ipairs(tab) do--遍历
    view=loadlayout(Popup_list_item)--设置菜单项布局
    view.BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x10000000}));
    if type(b[2])=="function" then--one

      Popup_list.addView(view)--添加
      popadp_text.setText(b[1])--设置文字
      view.onClick=function()--菜单项点击事件
        pops.dismiss()--关闭
        b[2]()--事件
      end

     elseif type(b[2])=="table" then--box

      Popup_list.addView(view)--添加
      popadp_text.setText(b[1].."...")--设置文字
      view.onClick=function()--菜单项点击事件
        pops.dismiss()--关闭
        showPopMenu(b[2],b[1])--打开子菜单
      end

    end
  end
  return pops
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
  local list,dialog_lay,lp,lq,add_button,add_text,cp,lay,Choice_dialog,adp
  import "android.widget.LinearLayout$LayoutParams"
  list=ListView(activity).setFastScrollEnabled(true)
  dialog_lay=LinearLayout(activity)
  .setOrientation(0)
  .setGravity(Gravity.RIGHT|Gravity.CENTER)

  lp=LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
  lp.gravity = Gravity.RIGHT|Gravity.CENTER
  lq=LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
  lq.gravity = Gravity.CENTER

  add_button=ImageView(activity).setImageBitmap(loadbitmap(图标("add")))
  .setColorFilter(转0x(textc))
  .setLayoutParams(lp);

  add_text=TextView(activity).setText("新建收藏夹")
  .setTypeface(字体("product"))
  .setLayoutParams(lp);

  dialog_lay.addView(add_text).addView(add_button)

  add_text.onClick=function()
    新建收藏夹(function(mytext,myid)
      adp.insert(0,{
        mytext=mytext,
        myid=myid,
        status={Checked=false},
        oristatus=false
      })
      activity.setResult(1600)
    end)

  end

  cp=TextView(activity)
  lay=LinearLayout(activity).setOrientation(1).addView(dialog_lay).addView(cp).addView(list)
  Choice_dialog=AlertDialog.Builder(activity)--创建对话框
  .setTitle("选择路径")
  .setPositiveButton("确认",{
    onClick=function()
      local dotab={
        add={},
        remove={}
      }
      for k, v in pairs(adp.getData()) do
        local oristatus=v.oristatus
        local status=v.status.Checked
        if oristatus~=status then
          if status==true then
            table.insert(dotab.add,v.myid)
           elseif status==false then
            table.insert(dotab.remove,v.myid)
          end
        end
      end
      local addstr=urlEncode(table.concat(dotab.add,","))
      local removestr=urlEncode(table.concat(dotab.remove,","))
      if addstr=="" and removestr=="" then
        return
      end
      zHttp.put("https://api.zhihu.com/collections/contents/"..收藏类型.."/"..回答id,"add_collections="..addstr.."&remove_collections="..removestr,head,function(code,json)
        canload=true
        if code==200 then
          提示("成功")
         else
          提示("失败")
        end
      end)
  end})
  .setNegativeButton("取消",nil)
  .setView(lay)
  .show()

  local item={
    LinearLayout,
    orientation="horizontal",
    layout_width="fill",
    {
      LinearLayout;
      layout_weight=1;
      {
        TextView,
        id="mytext",
        layout_width="wrap",
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
      };
    },
    {
      LinearLayout,
      layout_gravity="center_vertical",
      layout_marginRight="10dp";
      {
        CheckBox;
        id="status";
        gravity="center_vertical",
        focusable=false;
        clickable=false;
      };
    };
  }

  adp=LuaAdapter(activity,item)
  list.setAdapter(adp)


  list.onItemClick=function(l,v,p,s)--列表点击事件
    if v.Tag.status.Checked then
      l.adapter.getData()[s].status["Checked"]=false
     else
      l.adapter.getData()[s].status["Checked"]=true
    end
    l.adapter.notifyDataSetChanged()--更新列表
  end

  local nextutl
  local function 收藏列表刷新()
    local collections_url= nextutl or "https://www.zhihu.com/api/v4/collections/contents/"..收藏类型.."/"..回答id
    zHttp.get(collections_url,head,function(code,content)
      if code==200 then
        adp.setNotifyOnChange(true)
        for k,v in ipairs(luajson.decode(content).data) do
          adp.add({
            mytext=v.title,
            myid=tostring((v.id)),
            status={Checked=v.is_favorited},
            oristatus=v.is_favorited
          })
        end

        if luajson.decode(content).paging.is_end==false then
          nextutl=luajson.decode(content).paging.next
          return 收藏列表刷新()
        end

      end
    end)
  end
  收藏列表刷新()
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
      if luajson.decode(content).url_token then
        collection_webview.loadUrl("https://www.zhihu.com/people/"..luajson.decode(content).url_token.."/collections/")
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
      collection_webview.clearCache(true)
      collection_webview.clearFormData()
      collection_webview.clearHistory()
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

function 加入专栏(回答id,收藏类型)
  if not(getLogin()) then
    return 提示("请登录后使用本功能")
  end
  local list,dialog_lay,lp,lq,tip_text,add_button,add_text,cp,lay,Choice_dialog,adp
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
  .setText("待选中专栏")
  .setTypeface(字体("product"))
  .setLayoutParams(lq);

  add_button=ImageView(activity).setImageBitmap(loadbitmap(图标("add")))
  .setColorFilter(转0x(textc))
  .setLayoutParams(lp);

  add_text=TextView(activity).setText("新建专栏")
  .setTypeface(字体("product"))
  .setLayoutParams(lp);

  dialog_lay.addView(add_text).addView(add_button)

  add_text.onClick=function()
    activity.newActivity("huida",{"https://www.zhihu.com/column/request","新建专栏","null"})
    提示("已跳转 请自行添加")
  end

  cp=TextView(activity)
  lay=LinearLayout(activity).setOrientation(1).addView(tip_text).addView(dialog_lay).addView(cp).addView(list)
  Choice_dialog=AlertDialog.Builder(activity)--创建对话框
  .setTitle("选择路径")
  .setPositiveButton("确认",{
    onClick=function()
      zHttp.post("https://api.zhihu.com/"..收藏类型.."s/"..回答id.."/republish",'{"action":"create","column":"'..选中专栏..'"}',apphead,function(code,json)
        canload=true
        if code==200 then
          提示("成功")
         else
          提示("失败")
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
    tip_text.Text="当前选中专栏："..v.Tag.mytext.Text
    选中专栏=v.Tag.myid.Text
  end

  local nextutl
  local function 专栏列表刷新()
    local collections_url= nextutl or "https://api.zhihu.com/members/"..activity.getSharedData("idx").."/owned-columns?type="..收藏类型.."&id="..回答id

    zHttp.get(collections_url,apphead,function(code,content)
      if code==200 then
        adp.setNotifyOnChange(true)
        for k,v in ipairs(luajson.decode(content).data) do
          adp.add({
            mytext=v.title,
            myid=v.id
          })
        end

        if luajson.decode(content).paging and luajson.decode(content).paging.is_end==false then
          nextutl=luajson.decode(content).paging.next
          return 专栏列表刷新()
        end

      end
    end)
  end
  专栏列表刷新()
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

function StringHelper.getCount(str)
  local tempStr = str
  local index = 0 -- 字符记数
  local bytes = 0 -- 字符的字节记数

  endIndex = endIndex or -1
  while string.len(tempStr) > 0 do
    bytes = bytes + StringHelper.GetBytes(tempStr)
    tempStr = string.sub(str, bytes+1)

    index = index + 1
  end
  return index
end

function StringHelper.Sub(str,startIndex, endIndex,addStr)
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
  if addStr then
    if StringHelper.getCount(str)>=endIndex then
      addStr=addStr
     else
      addStr=""
    end
   else
    addStr=""
  end
  return string.sub(str, byteStart, byteEnd)..addStr
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

function urlEncode(s)
  s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
  return string.gsub(s, " ", " ")
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
--nil不设置 就是默认值
cardradius=nil

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

    collectgarbage("collect")
    System.gc()
  end

  islogin=getLogin()

  local old_onResume=onResume
  function onResume()
    if old_onResume~=nil then
      old_onResume()
    end
    if (oldTheme~=ThemeUtil.getAppTheme()) or (oldDarkActionBar~=getSharedData("theme_darkactionbar")) then
      activity.recreate()
      return
    end
    if islogin~=getLogin() then
      islogin=getLogin()
      onActivityResult(nil,100,nil)
    end
  end

  local old_onActivityResult=onActivityResult
  function onActivityResult(a,b,c)
    if b==100 then
      setHead()
      if mytip_dia and mytip_dia.isShowing() then
        mytip_dia.dismiss()
        mytip_dia=nil
        canload=true
      end
    end
    activity.setResult(b)
    --由于可能有setHead 所以必须写在前面
    if old_onActivityResult~=nil then
      old_onActivityResult(a,b,c)
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
    return false
  end
end

if not this.getSharedData("udid") then
  local length = 35 -- 指定生成字符串的长度
  local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_" -- 指定可用字符集
  local udid = ""

  for i = 1, length do
    local index = math.random(1, #chars) -- 生成随机索引
    udid = udid .. chars:sub(index, index) -- 在udid后面添加随机字符
  end

  activity.setSharedData("udid",udid.."=")

end

function setHead()
  if this.getSharedData("signdata") then
    local jsondata=luajson.decode(this.getSharedData("signdata"))
    access_token="Bearer "..jsondata.access_token
    head = {
      ["authorization"] = access_token,
      ["x-udid"] = this.getSharedData("udid"),
    }

    posthead=table.clone(head)
    posthead["content-type"]="application/json; charset=UTF-8"


    apphead = {
      ["x-api-version"] = "3.1.8";
      ["x-app-za"] = "OS=Android&Release=10&VersionName=9.13.0&VersionCode=16816&Product=com.zhihu.android&Installer=Market&DeviceType=AndroidPhone";
      ["x-app-version"] = "9.13.0";
      ["x-app-bundleid"] = "com.zhihu.android";
      ["x-app-flavor"] = "myapp";
      ["x-app-build"] = "release";
      ["x-network-type"] = "WiFi";
      ["authorization"] = access_token;
      ["x-udid"] = this.getSharedData("udid");
    }

    postapphead=table.clone(apphead)
    postapphead["content-type"]="application/json; charset=UTF-8"

   else
    head = {
      ["cookie"] = 获取Cookie("https://www.zhihu.com/");
      ["x-udid"] = this.getSharedData("udid");
    }

    posthead=table.clone(head)
    posthead["content-type"]="application/json; charset=UTF-8"

    apphead = {
      ["x-api-version"] = "3.1.8";
      ["x-app-za"] = "OS=Android&Release=10&VersionName=9.13.0&VersionCode=16816&Product=com.zhihu.android&Installer=Market&DeviceType=AndroidPhone";
      ["x-app-version"] = "9.13.0";
      ["x-app-bundleid"] = "com.zhihu.android";
      ["x-app-flavor"] = "myapp";
      ["x-app-build"] = "release";
      ["x-network-type"] = "WiFi";
      ["cookie"] = 获取Cookie("https://www.zhihu.com/");
      ["x-udid"] = this.getSharedData("udid");
    }

    postapphead=table.clone(apphead)
    postapphead["content-type"]="application/json; charset=UTF-8"
  end

  if homeapphead and homeapphead1 then
    homeapphead=table.clone(apphead)
    homeapphead["x-close-recommend"]="0"
    homeapphead["x-feed-prefetch"]="1"
    homeapphead1=table.clone(apphead)
    homeapphead1["scroll"]="down"
  end

  if followapphead then
    followapphead = table.clone(apphead)
    followapphead["x-moments-ab-param"] = "follow_tab=1";
  end

end

setHead()

function 清理内存()
  task(1,function()

    import "androidx.core.content.ContextCompat"
    local datadir=tostring(ContextCompat.getDataDir(activity))
    local imagetmp=tostring(activity.getExternalCacheDir()).."/images"
    require "import"
    import "java.io.File"
    local tmp={[1]=0}

    local function getDirSize(tab,path)
      if File(path).isDirectory() then
        if File(path).canWrite()==false then
          return
        end
        local a=luajava.astable(File(path).listFiles() or {})

        for k,v in pairs(a) do
          if v.isDirectory() then
           else
            tab[1]=tab[1]+v.length()
          end
        end

        LuaUtil.rmDir(File(path))

      end
    end

    local dar
    dar=datadir.."/cache"

    getDirSize(tmp,dar)
    getDirSize(tmp,imagetmp)

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
    if Build.VERSION.SDK_INT >=30 then
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

function getRandom(n)
  local t = {
    "0","1","2","3","4","5","6","7","8","9",
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
  }
  local s = ""
  for i =1, n do
    s = s .. t[math.random(#t)]
  end;
  return s
end

local glid_manage=Glide.with(this)
local glid_manager=Glide.get(this)
function loadglide(view,url)
  import "com.bumptech.glide.load.engine.DiskCacheStrategy"
  glid_manage
  .load(url)
  .diskCacheStrategy(DiskCacheStrategy.NONE)
  .into(view)
  glid_manager.clearMemory();
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

function ChoicePath(StartPath,callback)
  local lv,cp,lay,ChoiceFile_dialog,adp,path,ls,SetItem,项目,路径,edit_dialog
  --创建ListView作为文件列表
  lv=ListView(activity).setFastScrollEnabled(true)
  --创建路径标签
  cp=TextView(activity)
  cp.TextIsSelectable=true
  lay=LinearLayout(activity).setOrientation(1).addView(cp).addView(lv)
  ChoiceFile_dialog=AlertDialog.Builder(activity)--创建对话框
  .setTitle("选择路径")
  .setPositiveButton("确认",{
    onClick=function()
      callback(tostring(cp.Text))
  end})
  .setNeutralButton("填写路径",nil)
  .setNegativeButton("取消",nil)
  .setView(lay)
  .show()
  ChoiceFile_dialog.getButton(ChoiceFile_dialog.BUTTON_NEUTRAL).onClick=function()
    import "android.widget.EditText"
    edit=EditText(this)
    edit_dialog=AlertDialog.Builder(this)
    .setTitle("请输入")
    .setView(edit)
    .setPositiveButton("确定", {onClick=function()
        local path=edit.Text
        if File(path).canRead() then
          edit_dialog.dismiss()
          SetItem(path)
          提示("跳转成功")
         else
          提示("无法读取文件夹 请检查输入是否正确或是否可读")
        end
    end})
    .setNegativeButton("取消", nil)
    .show();
  end
  adp=ArrayAdapter(activity,android.R.layout.simple_list_item_1)
  lv.setAdapter(adp)
  function SetItem(path)
    path=tostring(path)
    adp.clear()--清空适配器
    cp.Text=tostring(path)--设置当前路径
    if path~="/" then--不是根目录则加上../
      adp.add("../")
    end
    ls=File(path).listFiles()
    if ls~=nil then
      ls=luajava.astable(File(path).listFiles()) --全局文件列表变量
      table.sort(ls,function(a,b)
        return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and a.Name<b.Name)
      end)
     else
      ls={}
    end
    for index,c in ipairs(ls) do
      if c.isDirectory() then--如果是文件夹则
        adp.add(c.Name.."/")
      end
    end
  end
  lv.onItemClick=function(l,v,p,s)--列表点击事件
    项目=tostring(v.Text)
    if tostring(cp.Text)=="/" then
      路径=ls[p+1]
     else
      路径=ls[p]
    end

    if 项目=="../" then
      SetItem(File(cp.Text).getParentFile())
     elseif 路径.isDirectory() then
      SetItem(路径)
     elseif 路径.isFile() then
      callback(tostring(路径))
      ChoiceFile_dialog.hide()
    end

  end

  SetItem(StartPath)
end

-- 定义一个函数，用于从字符串中获取数字和后续内容
function get_number_and_following(str)
  -- 定义一个空的table，用于存放结果
  local result = {}
  -- 使用正则表达式匹配数字和后续内容，直到遇到空格或字符串结束
  for s in string.gmatch(str, "%-?%d+%.?%d?[^%s]*") do
    -- 将匹配到的内容插入到table中
    table.insert(result, s)
  end
  -- 返回table
  return result
end

function getpage(view,str,num,allnum,onlylist,orinum)
  if view.adapter==nil or view.adapter.getCount()<allnum then
    if view.adapter and view.adapter.getCount()<allnum then
      allnum=allnum-view.adapter.getCount()
    end
    initpage(view,str,allnum,onlylist,orinum)
  end
  if orinum then
    num=orinum+num
  end
  if onlylist then
    local list=str.."list".."_"..tostring(num)
    return _G[list]
   else
    local sr=str.."sr".."_"..tostring(num)
    local list=str.."list".."_"..tostring(num)
    return _G[list],_G[sr]
  end
end

function initpage(view,str,allnum,onlylist,orinum)
  if orinum==nil then
    orinum=0
  end
  local pagadp=view.adapter or SWKLuaPagerAdapter()

  if onlylist then
    for i=1+orinum,allnum do

      local list=str.."list".."_"..tostring(i)
      local addview=
      {
        ListView;
        DividerHeight="0",
        layout_width="fill";
        id=list,
        layout_height="fill";
        nestedScrollingEnabled=true,
      };

      pagadp.add(loadlayout(addview))
      pagadp.notifyDataSetChanged()
    end
   else
    for i=1+orinum,allnum do
      local list=str.."list".."_"..tostring(i)
      local sr=str.."sr".."_"..tostring(i)
      local addview={
        SwipeRefreshLayout;
        id=sr;
        layout_height="fill";
        layout_width="fill";
        {
          ListView;
          DividerHeight="0",
          layout_width="fill";
          id=list,
          layout_height="fill";
          nestedScrollingEnabled=true,
        };
      }

      pagadp.add(loadlayout(addview))
      pagadp.notifyDataSetChanged()
    end
  end

  if view.adapter==nil then
    view.setAdapter(pagadp)
  end

end

function numtostr(num)
  if num>10000 then
    num=tostring(math.floor(num/10000)).."万"
  end
  return tostring(num)
end

if Build.VERSION.SDK_INT >= 21 then
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(转0x(backgroundc,true));
end


local cachemode=this.getSharedData("禁止生成缓存")
if cachemode=="true" then
  mytip_dia=AlertDialog.Builder(this)
  .setTitle("提示")
  .setMessage("已开启 禁止生成缓存 该选项可能会导致一些问题 请点击下方关闭 关闭后 你的登录状态将会变为未登录")
  .setCancelable(false)
  .setPositiveButton("我知道了",{onClick=function()
      local datadir=tostring(ContextCompat.getDataDir(activity))
      local mcache=datadir.."/cache"
      local mmcache=datadir.."/app_webview"
      删除文件(mcache)
      删除文件(mmcache)
      this.setSharedData("禁止生成缓存",nil)
      清除所有cookie()
      activity.setSharedData("signdata",nil)
      activity.setSharedData("idx",nil)
      activity.setSharedData("udid",nil)
      提示("已清除,即将重启")
      task(200,function()
        import "android.os.Process"
        local intent =activity.getBaseContext().getPackageManager().getLaunchIntentForPackage(activity.getBaseContext().getPackageName());
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        activity.startActivity(intent);
        Process.killProcess(Process.myPid());
      end)
  end})
  .show()
end