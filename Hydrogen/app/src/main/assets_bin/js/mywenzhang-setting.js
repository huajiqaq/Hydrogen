console.log("重新加载")
window.onload = function () {
    document.getElementsByTagName("header")[0].style.display = "none"
    style = document.createElement('style');
    style.innerHTML = '.Post-NormalSub{display:none !important}'
    style.innerHTML += '.ColumnPageHeader-Wrapper{display:none !important}'
    style.innerHTML += '.ContentItem-action{margin-left:unset !important}'
    style.innerHTML += '.ContentItem-actions>span{display:none !important}'
    style.innerHTML += '.Post-content{min-width:unset !important; padding:20px !important}'
    style.innerHTML += '.Post-NormalMain>div, .Post-NormalSub>div{width:unset !important}'
    style.innerHTML += '.RichContent-actions .ContentItem-actions>:nth-child(n){margin-left:unset !important}'
    style.innerHTML += '.Post-ActionMenuButton{margin-left:unset !important; margin-right:24px !important}'
    document.head.appendChild(style);

    document.querySelector(".Button--withIcon.Button--plain").remove()
    document.querySelector(".Button--withIcon.Button--plain").remove()
    document.querySelector(".Button--withIcon.Button--plain").remove()
    document.querySelector(".Button--withIcon.Button--plain").remove()

    //防止图片显示不正确
    style = document.createElement('style');
    style.innerHTML = '.Modal-closeButton{position:unset !important; width:unset !important}'
    document.head.appendChild(style);
    //防止按钮放的波
    style = document.createElement('style');
    style.innerHTML = '.Modal{box-shadow:unset !important;width:unset}'
    document.head.appendChild(style);
    //隐藏底部的按钮
    style = document.createElement('style');
    style.innerHTML = '.OpenInAppButton{display:none !important}'
    document.head.appendChild(style);
    console.log("加载完成")
}