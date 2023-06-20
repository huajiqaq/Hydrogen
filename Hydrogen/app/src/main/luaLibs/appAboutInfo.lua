appInfo={
  {
    name=R.string.app_name,
    message="很棒的软件",
    iconResource=R.mipmap.ic_launcher,
    browserUrl="https://jesse205.github.io/",
    clickable=true,
  },
}

--[[检查更新
function onUpdate()
end]]

--开发者们
developers={
  {
    name="Eddie",
    qq=2140125724,
    message="很棒的开发者",
    url="https://b23.tv/Xp0Cc4P",
  },
}

--启用开源许可
openSourceLicenses=true

--[[格式：
{
  {
    name="群名称"; -- 群名称
    qqGroup=708199076; -- 群号
    contextMenuEnabled=true; -- 启用ContextMenu
  },
  {
    name="百度", -- 显示的名称
    url="http://www.baidu.com" -- 跳转连接
    browserUrl="http://www.baidu.com" -- 浏览器打开链接
    func=function(view) -- 执行的函数
    end,
  },
  --以此类推
}
]]
moreItem={
  {--交流群
    SettingsLayUtil.ITEM_NOSUMMARY;
    title=R.string.jesse205_qqGroup;
    icon=R.drawable.ic_account_group_outline;
    newPage="newApp";
    qqGroup=708199076;
    contextMenuEnabled=true;
    menus={
      {
        title="Edde 综合群",
        qqGroup=708199076,
      },
    };
  },
  --[[{--频道
    SettingsLayUtil.ITEM_NOSUMMARY;
    title=R.string.jesse205_qqChannel;
    icon=R.drawable.ic_qq_channel;
    newPage="newApp";
    url="https://pd.qq.com/s/n51c4k";
  },]]
  {--支持
    SettingsLayUtil.ITEM_NOSUMMARY;
    title=R.string.jesse205_supportProject;
    icon=R.drawable.ic_wallet_giftcard;
    contextMenuEnabled=true;
    menus={
      {
        title="更多软件",
        url="https://jesse205.github.io/",
      },
    };
  },
}

--感谢名单
thanks={
  --难忘的旋律={"PhotoView"},
  frrrrrits={"AnimeonGo（为Edde系列应用优化提供了重要参考）"}
}

--版权信息
--copyright="Copyright (c) 2022, Jesse205"
