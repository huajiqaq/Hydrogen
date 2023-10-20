console.log("重新加载")
window.onload = function () {
  var style
  //去除顶栏知乎图标
  document.querySelector(".ColumnPageHeader-content").childNodes[0].style.display = "none"
  //去除顶栏间隔
  document.querySelector(".ColumnPageHeader-content").childNodes[1].style.display = "none"
  //防止编辑框宽度超过屏幕宽度
  document.querySelector(".ColumnPageHeader-profile").style.display = "none"
  //防止顶栏宽度超过屏幕宽度
  document.querySelector(".ColumnPageHeader-content").style.width = "unset"
  document.querySelector(".ColumnPageHeader-content").style.padding = "unset"

  //防止编辑框宽度超过屏幕宽度
  style = document.createElement('style');
  style.innerHTML = '.PostEditor .RichText{min-width:unset !important}'
  style.innerHTML += '.css-1so3nbl{width:unset !important}'
  style.innerHTML += 'div.WriteIndexLayout-main > div:nth-child(2){width:unset !important}'
  document.head.appendChild(style);

  //防止选择框高度不是一行
  style = document.createElement('style');
  style.innerHTML = '.css-vtcda0{flex-wrap:wrap !important}'
  document.head.appendChild(style);

  //优化卡片显示
  style = document.createElement('style');
  style.innerHTML = '.Modal--large{width:100% !important}'
  style.innerHTML += '.Modal-closeButton{position:unset !important}'
  document.head.appendChild(style);
  //占满宽度
  style = document.createElement('style');
  style.innerHTML = '.Modal--fullPage{width:100% !important}'
  document.head.appendChild(style);
  //优化历史显示
  style = document.createElement('style');
  style.innerHTML = '.DraftHistory-version{height:unset !important}'
  style.innerHTML += '.DraftHistory-main{flex:unset !important}'
  document.head.appendChild(style);

  //防止图片压缩
  style = document.createElement('style');
  style.innerHTML = 'img{max-width:unset !important}'
  document.head.appendChild(style);

  //防止图片栏压缩
  style = document.createElement('style');
  style.innerHTML = '.css-rj2dwy{display:block !important}'
  style.innerHTML += '.css-4cffwv{display:block !important}'
  style.innerHTML += '.css-zelv4t{min-width:unset !important}'
  style.innerHTML += '.css-ec1dnj{line-height:unset !important}'
  style.innerHTML += '.css-zzm66r{line-height:unset !important}'
  style.innerHTML += '.MaterialLibraryNav{width:unset !important}'
  document.head.appendChild(style);

  //导入视频页面防压缩
  style = document.createElement('style');
  style.innerHTML = '.css-10rx4cn{width:unset !important}'
  document.head.appendChild(style);

  //优化
  style = document.createElement('style');
  //防止有空隙
  style.innerHTML = 'div[role="listitem"]:empty{display: none; !important}'
  //防止上传视频页面的按钮显示不全
  style.innerHTML += '.css-jajnrr{width:unset !important}'
  //下方功能 防止内容超过屏幕
  style.innerHTML += '.css-1p9otau{padding-left:unset !important}'
  //图片个人素材按钮宽高
  style.innerHTML += '.css-1c5mg10{width:unset !important}'
  style.innerHTML += '.css-1c5mg10{height:unset !important}'
  document.head.appendChild(style);

  //防止按钮放的波
  style = document.createElement('style');
  style.innerHTML = '.Modal{box-shadow:unset !important; max-width:100vw !important}'
  document.head.appendChild(style);

  document.getElementsByTagName("textarea")[0].rows = 2
  style = document.createElement('style');
  style.innerHTML = '.WriteIndex-titleInput .Input {height:unset !important}'
  document.head.appendChild(style);

  console.log("加载完成")
}
