function loadzhihugif () {
    //优化gif显示
    var style
    style = document.createElement('style');
    style.innerHTML = '.GifPlayer img + [class*="GifPlayer"][class*="gif"]{pointer-events:none !important;display:none !important}'
    //    style.innerHTML += '.GifPlayer-icon{pointer-events:none !important;display:none !important}'
    document.head.appendChild(style);
}

window.addEventListener("load", loadzhihugif)