appInfo={
  {
    name=R.string.app_name,
    message="很棒的软件",
    icon=R.mipmap.ic_launcher,
    --[[click=function()
    end,]]
  },
}

--开发者们
developers={
  {
    name="维护者",
    qq=1906327347,
    message="很棒的开发者",
  },
}

--启用开源许可
openSourceLicenses=true

--单个QQ群
--qqGroup=708199076

--多个QQ群
--[[qqGroups={
  {
    name="Edde 综合群",
    id=708199076,
  },
}]]
--[[格式：
{
  {
    name="群名称",--群名称
    id=708199076,--群号
  },
  {
    name="群名称",--群名称
    id=708199076,--群号
  },
  --以此类推
}
]]

--支持项目
--supportUrl="https://afdian.net/@Jesse205"--支持项目链接
supportNewPage=false--支持项目页面跳转标识
supportList={--如果有多种方式支持项目，可以使用列表
  {
    name="问题反馈",
    func=function() newActivity(tostring(ContextCompat.getDataDir(activity)).."/files/feedback") end,
  },
  {
    name="参与开发",
    url="https://gitee.com/huajicloud/Hydrogen",
  },
  --[[
  {
    name="资金支持",
    func=function(view)
      print("暂不支持")
    end,
  },]]
}
--[[格式：
{
  {
    name="百度",--显示的名称
    url="http://www.baidu.com"--跳转链接
    func=function(view)--函数（不可和url共存）
    end,
  },
  {
    name="百度",--显示的名称
    url="http://www.baidu.com"--跳转链接
    func=function(view)--函数（不可和url共存）
    end,
  },
  --以此类推
}
]]

--版权信息
--copyright="No Copyright"
