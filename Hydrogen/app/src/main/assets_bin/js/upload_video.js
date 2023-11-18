console.log("重新加载")
window.onload = function () {
  document.getElementsByTagName("header")[0].style.display = "none"
  var style
  style = document.createElement('style');
  //防止显示不全
  style.innerHTML = '.VideoUploadHint-iconBg{--bg-size:unset !important}'
  //防止超出屏幕
  style.innerHTML += '.VideoUploadHint{min-width:unset !important; min-height:unset !important}'
  style.innerHTML += '.css-qozf2{width:unset !important; flex-wrap:wrap}'
  style.innerHTML += '.css-1947tn5{width:unset !important}'
  document.head.appendChild(style);
  //防止视频超出
  style = document.createElement('style');
  style.innerHTML += '.css-i9srcr{left: unset !important; width: -webkit-fill-available !important}'
  style.innerHTML += '.css-1a0xlxc{width:100% !important}'
  style.innerHTML += '.css-1laza99{width:unset !important}'
  document.head.appendChild(style);
  style = document.createElement('style');
  //防止显示不全
  style.innerHTML = '.Popover-content{width:100% !important}'
  document.head.appendChild(style);
  console.log("加载完成")
}
