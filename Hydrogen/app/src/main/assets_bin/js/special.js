window.onload = function () {
    //防止图片显示不正确
    if (document.querySelector(".FollowButton-module-root-3aFK")) {
        var style
        style = document.createElement('style');
        style.innerHTML = '.OpenInAppButton{display:none !important}'
        document.head.appendChild(style);
        var ele = document.querySelector(".FollowButton-module-root-3aFK")
        ele.outerHTML = ele.outerHTML
        ele = document.querySelector(".FollowButton-module-root-3aFK")
        ele.addEventListener('click', function () {
            console.log("关注专题分割" + ele.innerText);
        });
    }
}