window.onload = function () {
    document.querySelector(".PostIndex").childNodes[3].remove()
    var style
    style = document.createElement('style');
    style.innerHTML = '.Medal-img{display:none !important}'
    document.head.appendChild(style);
    document.querySelector(".UserLine-Main").addEventListener('click', function (e) {
        console.log("查看用户")
        e.stopPropagation();
    },true)
    
    document.querySelector(".PostTime").childNodes[1].childNodes[1].addEventListener('click', function () {
        console.log("申请转载")
    })
    
}