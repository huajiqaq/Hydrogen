console.log("重新加载")
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
    //优化页面
    style = document.createElement('style');
    //隐藏顶部
    style.innerHTML = '.ColumnPageHeader-Wrapper{display:none !important}'
    //防止显示不全
    style.innerHTML += '.ContentItem-actions{flex-wrap:wrap !important}'
    document.head.appendChild(style);
    console.log("加载完成")
}