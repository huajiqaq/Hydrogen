window.onload = function () {
    //防止图片显示不正确
    if (document.querySelector(".OpenInAppButton")) {
        var style
        style = document.createElement('style');
        style.innerHTML = '.OpenInAppButton{display:none !important}'
        document.head.appendChild(style);
        var ele = document.querySelector(".FollowButton")
        ele.outerHTML = ele.outerHTML
        ele = document.querySelector(".FollowButton")
        ele.addEventListener('click', function () {
            console.log("关注分割" + ele.innerText);
        });
    }
}