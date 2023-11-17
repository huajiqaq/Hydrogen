window.onload = function () {
    //防止图片显示不正确
    var style
    style = document.createElement('style');
    style.innerHTML = '.css-10ti98u{display:none !important}'
    document.head.appendChild(style);
    if (document.querySelector(".ToolbarButton--collect")) {
        var ele = document.querySelector(".Toolbar-functionButtons")
        ele.childNodes[1].outerHTML = ele.childNodes[1].outerHTML
        ele.childNodes[1].addEventListener('click', function () {
            console.log("收藏")
        });
        ele.childNodes[2].addEventListener('click', function () {
            console.log("显示评论")
        });

        ele.childNodes[3].addEventListener('click', function (e) {
            console.log("查看用户")
            e.stopPropagation();
        },true);

        document.querySelector(".Toolbar-customizedArea").addEventListener('click', function () {
            console.log("显示评论")
        });

    }
}