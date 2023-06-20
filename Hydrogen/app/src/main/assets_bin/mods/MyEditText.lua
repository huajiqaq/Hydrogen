import "android.util.TypedValue"
import "android.widget.TextView"
import "java.lang.Integer"
import "android.view.animation.ScaleAnimation"
import "android.view.animation.TranslateAnimation"
import "android.graphics.drawable.GradientDrawable"
import "android.widget.LinearLayout"
import "android.widget.FrameLayout"
import "java.lang.Long"
import "android.widget.EditText"
import "android.view.View"
import "android.view.animation.AnimationSet"
import "android.animation.ObjectAnimator"
import "android.view.animation.DecelerateInterpolator"
function math.dp2int(dpValue)
  import "android.util.TypedValue"
  return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dpValue, activity.getResources().getDisplayMetrics())
end
local function sp2dp(spValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return (spValue * scale + 0.5) / scale + 0.5
end

local function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale+0.5
end

local function getFontHeight(fontSize)
  import "java.lang.Math"
  import "java.lang.Long"
  import "android.graphics.Paint"
  local paint = Paint()
  paint.setTextSize(fontSize)
  local fm = paint.getFontMetrics()
  return Math.ceil(fm.descent - fm.top)
end

local function ButtonFrame(view,Thickness,FrameColor,InsideColor,radiu)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setStroke(Thickness, FrameColor)
  drawable.setColor(InsideColor)
  local radiu=radiu or 0
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  view.setBackgroundDrawable(drawable)
end


local function isDarkColor(color)
  import 'java.lang.Long'
  local r=utf8.sub(color,3,4)
  local g=utf8.sub(color,5,6)
  local b=utf8.sub(color,7,8)
  local function toint(e)
    return Long.parseLong(e, 16)
  end
  return ((toint(r) * 0.299) + (toint(g) * 0.587) + (toint(b) * 0.114))<= 192
end
local function delpxdpsp(str)
  if str then
    local str=(tostring(str)):gsub("dp",""):gsub("px",""):gsub("sp","")
    return tonumber(str)
  end
end

local function MyEditTextOpenAnim(view,TextHintSize,editH)
  local animationSet=AnimationSet(true)
  animationSet.addAnimation(TranslateAnimation(0,0,editH,0).setDuration(150))
  --animationSet.addAnimation(ScaleAnimation(TextHintSize(),1,TextHintSize(),1).setDuration(150))
  view.startAnimation(animationSet.setFillAfter(true))
  local animationSet=AnimationSet(true)
  --animationSet.addAnimation(TranslateAnimation(0,0,editH,0).setDuration(150))
  animationSet.addAnimation(ScaleAnimation(TextHintSize(),1,TextHintSize(),1).setDuration(150))
  view.getChildAt(0).startAnimation(animationSet.setFillAfter(true))
end
local function MyEditTextCloseAnim(view,TextHintSize,editH)
  local animationSet=AnimationSet(true)
  animationSet.addAnimation(TranslateAnimation(0,0,0,editH).setDuration(150))
  --animationSet.addAnimation(ScaleAnimation(1,TextHintSize(),1,TextHintSize()).setDuration(158))
  view.startAnimation(animationSet.setFillAfter(true))
  local animationSet=AnimationSet(true)
  --animationSet.addAnimation(TranslateAnimation(0,0,0,editH).setDuration(150))
  animationSet.addAnimation(ScaleAnimation(1,TextHintSize(),1,TextHintSize()).setDuration(158))
  view.getChildAt(0).startAnimation(animationSet.setFillAfter(true))
end

local function MyEditAutoHintColor(info,windowBackground)
  if isDarkColor(string.upper(Integer.toHexString(info.backgroundColor or windowBackground))) then
    return 0xFFFFFFFF
   else
    return 0x70000000
  end
end

function MyEditText(info)
  local array = activity.getTheme().obtainStyledAttributes({
    android.R.attr.windowBackground,
    android.R.attr.colorAccent,
  });
  
  if not(pcall(function()local windowBackground = array.getColor(0, 0xFF00FF)end)) then windowBackground=nil end
  if not(pcall(function()local colorAccent = array.getColor(1, 0xFF00FF)end)) then colorAccent=nil end

  info=info or {}

  local lay=loadlayout{
    LinearLayout;
    --layout_width="fill";
    --layout_height="fill";
    {
      FrameLayout;
      layout_width="fill";
      layout_height="fill";
      {
        LinearLayout;
        layout_margin="8dp";
        layout_height="fill";
        layout_width="fill";
      };
      {
        LinearLayout;
        layout_height="fill";
        layout_width="fill";
        orientation="vertical";
        {
          EditText;
          --layout_marginTop="16sp";
          --layout_marginLeft="16dp";
          layout_margin="18dp";
          backgroundColor=0;
          style="?android:attr/textStyle";
          --layout_marginBottom="8dp";
          --layout_height="fill";
          layout_weight=1;
          layout_width="fill";
          textSize=info.textSize or "16sp";
          --text=info.text or "";
          --layout_marginRight="16dp";
          gravity="top|left";
          --includeFontPadding=false;
          textColor=info.textColor or (function() if isDarkColor(string.upper(Integer.toHexString(info.backgroundColor or windowBackground))) then return 0xFFFFFFFF else return 0xFF000000 end end)()
        };
      };
      {
        LinearLayout;
        --layout_marginTop="18dp";
        --layout_marginTop=0;
        --TranslationY="18dp";
        layout_marginLeft="16dp";
        layout_height="fill";
        layout_marginRight="16dp";
        --layout_marginTop="8dp";
        --layout_marginBottom="8dp";
        layout_gravity="top|left";
        layout_width="fill";
        {
          LinearLayout;
          --layout_marginTop="18dp";
          --layout_marginTop=0;
          --TranslationY="18dp";
          backgroundColor=info.backgroundColor or windowBackground;
          --layout_marginTop="8dp";
          --layout_marginBottom="8dp";
          {
            TextView;
            layout_marginLeft="2dp";
            layout_marginRight="2dp";
            --layout_marginBottom="2dp";
            textSize="12sp";
            --textSize=info.textSize or "16sp";
            --text=info.Hint or "";
          };
        };
      };
    };
  }

  local localid={
    EditText=lay.getChildAt(0).getChildAt(1).getChildAt(0),
    HintView=lay.getChildAt(0).getChildAt(2).getChildAt(0).getChildAt(0),
    MainView=lay
  }

  if info.password==tostring(true) then
    localid.EditText.setInputType(0x81)
  end


  function localid.getText()
    return tostring(localid.EditText.text)
  end
  function localid.setText(text)
    localid.EditText.text=text or ""
    return localid
  end
  function localid.getHint()
    return tostring(localid.HintView.text)
  end
  function localid.setHint(text)
    if text and text~="" then
      lay.getChildAt(0).getChildAt(2).setVisibility(View.VISIBLE)
     else
      lay.getChildAt(0).getChildAt(2).setVisibility(View.GONE)
    end
    localid.HintView.text=text or ""
    return localid
  end
  function localid.setFocusable(...)
    localid.EditText.setFocusable(...)
    return localid
  end
  function localid.setFocusableInTouchMode(...)
    localid.EditText.setFocusableInTouchMode(...)
    return localid
  end

  if tostring(info.focusable)=="false" or tostring(info.Focusable)=="false" then
    localid.setFocusable(false)
   else
    localid.setFocusable(true)
  end
  if tostring(info.focusableInTouchMode)=="false" or tostring(info.FocusableInTouchMode)=="false" then
    localid.setFocusableInTouchMode(false)
   else
    localid.setFocusableInTouchMode(true)
  end
  localid.MainView.onClick=function()
    localid.EditText.requestFocus()
  end;
  if info.id then
    _G[info.id]=localid
  end
  localid.setHint(info.Hint or info.hint)
  localid.setText(info.text or info.Text)

  import "android.view.animation.ScaleAnimation"
  import "android.view.animation.TranslateAnimation"
  import "android.graphics.drawable.StateListDrawable"
  import "android.content.Context"

  --local editH=math.dp2int(15)
  local editH=dp2px(17)

  local function TextHintSize()
    return (delpxdpsp(info.textSize) or 16)/12
  end
  localid.HintView.textColor=info.HintTextColor or MyEditAutoHintColor(info,windowBackground)
  ButtonFrame(lay.getChildAt(0).getChildAt(0),math.dp2int(1),info.HintTextColor or MyEditAutoHintColor(info,windowBackground),info.backgroundColor or windowBackground,info.radius or math.dp2int(4))

  MyEditTextCloseAnim(lay.getChildAt(0).getChildAt(2),TextHintSize,editH)
  localid.EditText.setOnFocusChangeListener{
    onFocusChange=function(view,hasFocus)
      if hasFocus then--判断焦点是否存在
        localid.HintView.textColor=info.HintTextColor or colorAccent
        ButtonFrame(lay.getChildAt(0).getChildAt(0),math.dp2int(2),info.HintTextColor or colorAccent,info.backgroundColor or windowBackground,info.radius or math.dp2int(4))
        activity.getSystemService(Context.INPUT_METHOD_SERVICE).showSoftInput(localid.EditText, 0)
        if view.text=="" then
          MyEditTextOpenAnim(lay.getChildAt(0).getChildAt(2),TextHintSize,editH)
        end
       else
        lay.getChildAt(0).getChildAt(0).backgroundColor=info.HintTextColor or MyEditAutoHintColor(info,windowBackground)
        localid.HintView.textColor=info.HintTextColor or MyEditAutoHintColor(info,windowBackground)
        ButtonFrame(lay.getChildAt(0).getChildAt(0),math.dp2int(1),info.HintTextColor or MyEditAutoHintColor(info,windowBackground),info.backgroundColor or windowBackground,info.radius or math.dp2int(4))
        if view.text=="" then
          MyEditTextCloseAnim(lay.getChildAt(0).getChildAt(2),TextHintSize,editH)

        end
      end
  end}



  localid.EditText.addTextChangedListener{
    onTextChanged=function(text,a,b)
      if #text==0 and not(localid.EditText.isFocused()) then
        MyEditTextCloseAnim(lay.getChildAt(0).getChildAt(2),TextHintSize,editH)

      end
      if a==0 and b==0 and not(localid.EditText.isFocused()) then
        MyEditTextOpenAnim(lay.getChildAt(0).getChildAt(2),TextHintSize,editH)
      end
    end
  }

  if localid.EditText.text~="" then
    MyEditTextOpenAnim(lay.getChildAt(0).getChildAt(2),TextHintSize,editH)
  end
  return function() return lay end
end

return MyEditText
--[[
--属性配置
MyEditText({
  text="text";
  Hint="Hint";
  radius=20;
  textSize="5dp";
  HintTextColor=0xFF000000;
  textColor=0xFFFF0000;
  })

--获取ID
MyEditText("getView").getHintView(id)
MyEditText("getView").getEditTextView(id)


]]