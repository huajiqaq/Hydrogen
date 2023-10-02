console.log("重新加载")
window.onload = function () {
    var style
    style = document.createElement('style');
    //防止页面不全
    style.innerHTML = '.css-1aq8hf9{width:100% !important}'
    //防止无法关闭
    style.innerHTML += '.css-1b6xkse{position:unset !important}';
    //防止关注出去
    style.innerHTML += '.AuthorInfo-badgeText{width:unset !important}';
    //防止喜欢显示不全
    style.innerHTML += '.Menu-item{width:unset !important}';
    style.innerHTML += '.ContentItem-action{margin-left:auto !important}';
    style.innerHTML += '.ContentItem-actions{flex-wrap:wrap !important}';
    document.head.appendChild(style);
    console.log("加载完成")
}