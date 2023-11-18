console.log("重新加载")
window.onload = function () {
  document.getElementsByTagName("header")[0].style.display = "none"
  var style
  style = document.createElement('style');
  //防止页面不沾满全屏
  style.innerHTML = '.css-fqja0q{height:100vh !important}'
  //防止文本位置不正确
  style.innerHTML += '.css-1xgb13w{line-height:unset !important}'
  //防止布局混乱
  style.innerHTML += '.css-u8ex1v{flex:unset !important}'
  style.innerHTML += '.CreatorEditorSettingItem{height:unset !important}'
  //防止不到顶
  style.innerHTML += '.css-xcj52l{margin-top:unset !important; max-width:unset !important}'
  //防止标题止显示不全
  style.innerHTML += '.WriteIndex - titleInput.Input {height:unset !important}'
  document.head.appendChild(style);
  console.log("加载完成")
}
