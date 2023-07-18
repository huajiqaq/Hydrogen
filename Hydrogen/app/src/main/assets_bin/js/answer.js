window.onload = function () {
    var style = document.createElement('style');
    //防止页面不全
    style.innerHTML = '.css-1cqr2ue{width:100% !important}'
    //防止无法关闭
    style.innerHTML += '.css-1x9te0t{position:unset !important}';
    //防止关注出去
    style.innerHTML += '.css-14ur8a8.AuthorInfo-badgeText{width:unset !important}';
    //防止喜欢显示不全
    style.innerHTML += '.Menu-item{width:unset !important}';
    style.innerHTML += '.ContentItem-action{margin-left:auto !important}';
    style.innerHTML += '.ContentItem-actions{flex-wrap:wrap !important}';
    document.head.appendChild(style);
    console.log("加载完成")
}