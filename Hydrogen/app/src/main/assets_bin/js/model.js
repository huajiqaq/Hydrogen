window.onload = function () {
    var style
    //防止图片显示不正确
    style = document.createElement('style');
    style.innerHTML = '.Modal-closeButton{position:unset !important}'
    document.head.appendChild(style);
    //防止按钮放的波
    style = document.createElement('style');
    style.innerHTML = '.Modal{box-shadow:unset !important;width:unset}'
    document.head.appendChild(style);
    //隐藏底部的按钮
    style = document.createElement('style');
    style.innerHTML = '.OpenInAppButton{display:none !important}'
    document.head.appendChild(style);
}