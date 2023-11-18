console.log("重新加载")
window.onload = function () {
    document.getElementsByTagName("header")[0].style.display = "none"
    style = document.createElement('style');
    style.innerHTML = '.ZVideoComment{display:none !important}'
    style.innerHTML += '.ContentItem-action{margin-left:unset !important}'
    style.innerHTML += '.ContentItem-actions>span{display:none !important}'
    style.innerHTML += '.VideoUploadForm-item{width:unset !important}'
    style.innerHTML += '.VideoUploadForm-imageContainer{width:100% !important;height:unset !important}'
    style.innerHTML += ' .VideoCoverEditor-Modal{width:unset !important;height:unset !important}'
    style.innerHTML += ' .css-cevo2p{width:unset !important;height:unset !important}'
    document.head.appendChild(style);
    document.querySelector(".ZVideo-sideColumnWeb").style.display = "none"

    document.querySelector(".ZVideo-tags").style.display = "none"
    document.querySelector(".ZVideo-video").style.display = "none"
    document.querySelector(".ZVideo-author").style.display = "none"

    document.querySelector(".Button--withIcon.Button--plain").remove()
    document.querySelector(".Button--withIcon.Button--plain").remove()
    document.querySelector(".Button--withIcon.Button--plain").remove()
    document.querySelector(".Button--withIcon.Button--plain").remove()

    //防止图片显示不正确
    style = document.createElement('style');
    style.innerHTML = '.Modal-closeButton{position:unset !important}'
    document.head.appendChild(style);
    //防止按钮放的波
    style = document.createElement('style');
    style.innerHTML = '.Modal{box-shadow:unset !important;width:unset}'
    document.head.appendChild(style);
    //隐藏底部的按钮
    style = document.createElement('style');
    style.innerHTML = '.OpenInAppButton{display:none !important}'
    document.head.appendChild(style);
    console.log("加载完成")
}