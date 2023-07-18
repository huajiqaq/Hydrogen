window.onload = function () {
    //去除顶栏知乎图标
    document.querySelector(".css-1g2nzan").childNodes[0].style.display = "none"
    //去除顶栏间隔
    document.querySelector(".css-hv1qc4").style.display = "none"
    //防止编辑框宽度超过屏幕宽度
    document.querySelector(".css-arjme8").style.width = "unset"
    document.querySelector(".css-3uhrzt").style.display = "none"
    //防止顶栏宽度超过屏幕宽度
    document.querySelector(".css-1g2nzan").style.width = "unset"
    //去除图文回答与发布设置的间隔
    document.querySelector(".css-29tdoj").style.minHeight = "unset"


    //防止选择框宽度超过屏幕宽度
    var style = document.createElement('style');
    style.innerHTML = '.Select-button{width:unset !important}'
    document.head.appendChild(style);

    //防止选择框高度不是一行
    var style = document.createElement('style');
    style.innerHTML = '.css-1pfsia3{padding-right:unset !important}'
    document.head.appendChild(style);

    //优化卡片显示 
    var style = document.createElement('style');
    style.innerHTML = '.Modal--large{width:unset !important}'
    style.innerHTML = '.Modal{width:unset !important}'
    style.innerHTML += '.Modal-closeButton{position:unset !important}'
    document.head.appendChild(style);
    //占满宽度
    var style = document.createElement('style');
    style.innerHTML = '.Modal--fullPage{width:100% !important}'
    document.head.appendChild(style);
    //优化历史显示
    var style = document.createElement('style');
    style.innerHTML += '.DraftHistory-version{height:unset !important}'
    style.innerHTML += '.DraftHistory-main{flex:unset !important}'
    document.head.appendChild(style);

    //防止图片压缩
    var style = document.createElement('style');
    style.innerHTML = 'img{max-width:unset !important}'
    document.head.appendChild(style);
    
    console.log("加载完成")

}