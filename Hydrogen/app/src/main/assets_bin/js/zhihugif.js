window.onload = function () {
    //优化gif显示
    var style
    style = document.createElement('style');
    style.innerHTML = '.GifPlayer-gif2mp4{pointer-events:none !important;display:none !important}'
    style.innerHTML += '.GifPlayer-icon{pointer-events:none !important;display:none !important}'
    document.head.appendChild(style);
}