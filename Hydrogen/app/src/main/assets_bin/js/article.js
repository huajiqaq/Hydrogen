window.onload = function () {
    document.querySelector(".PostIndex").childNodes[3].remove()
    var style
    style = document.createElement('style');
    style.innerHTML = '.Medal-img{display:none !important}'
    document.head.appendChild(style);
    document.querySelector(".PostTime").childNodes[1].childNodes[1].onclick = function () {
        console.log("申请转载")
    }
    document.querySelector(".UserLine-Main").onclick = function () {
        console.log("查看用户")
    }
}