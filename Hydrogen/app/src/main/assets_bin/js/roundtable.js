window.onload = function () {
    //防止图片显示不正确
    if (document.querySelector(".MetaArea-module-header-1S1T")) {
        var style
        style = document.createElement('style');
        style.innerHTML = '.OpenInAppButton{display:none !important}'
        document.head.appendChild(style);
        var ele = document.querySelector(".MetaArea-module-header-1S1T").childNodes[1].childNodes[1]
        ele.outerHTML = ele.outerHTML
        ele = document.querySelector(".MetaArea-module-header-1S1T").childNodes[1].childNodes[1]
        ele.addEventListener('click', function () {
            console.log("关注圆桌分割" + ele.innerText);
        });
    }
}