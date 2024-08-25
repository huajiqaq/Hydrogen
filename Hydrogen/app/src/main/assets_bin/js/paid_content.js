console.log("重新加载")
window.onload = function () {
    //防止图片显示不正确
    if (document.querySelector(".WebPage-fixOpenInApp-2N4Qk")) {
        var style
        style = document.createElement('style');
        style.innerHTML = '.WebPage-fixOpenInApp-2N4Qk{display:none !important}'
        document.head.appendChild(style);
        var ele = document.querySelectorAll(".ToolbarButton-root-7QcPF")[1]
        ele.outerHTML = ele.outerHTML
        ele = document.querySelectorAll(".ToolbarButton-root-7QcPF")[1]
        ele.addEventListener('click', function () {
            console.log("显示评论");
        });
    }
    console.log("加载完成")
}