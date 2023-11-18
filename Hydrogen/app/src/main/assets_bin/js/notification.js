console.log("重新加载")
window.onload = function () {
  var style
  document.querySelector("header").style.display = "none"
  document.querySelector('.Notifications-Layout').childNodes[1].style.display = "none"
  style = document.createElement('style');
  //滑动始终显示在上面
  style.innerHTML = '.Sticky.is-fixed{top:-0 !important}'
  //全屏 去边距
  style.innerHTML += '.Notifications-Layout{width:100% !important; margin:0 !important; padding:0 !important}'
  style.innerHTML += '.Notifications-Main{width:100% !important; margin-right:0 !important}'
  document.head.appendChild(style);
  console.log("加载完成")
}