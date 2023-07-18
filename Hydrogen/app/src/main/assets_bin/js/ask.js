window.onload = function () {
    function emulateMouseClick(element) {
        let event = new MouseEvent('click', {
            bubbles: true,
            cancelable: true
        });
        element.dispatchEvent(event);
    }

    //document.getElementById("root").style.display = "none"
    //防止图片显示不正确
    var style = document.createElement('style');
    style.innerHTML = '.Modal-closeButton{position:unset !important}'
    document.head.appendChild(style);
    //防止按钮放的波
    var style = document.createElement('style');
    style.innerHTML = '.Modal{box-shadow:unset !important;width:unset}'
    document.head.appendChild(style);
    //防止输入框被下面视图覆盖
    var style = document.createElement('style');
    style.innerHTML = '.Ask-items{max-width:unset !important;max-height:unset !important}'
    style.innerHTML += '.Editable-content{max-width:unset !important;max-height:unset !important}'
    document.head.appendChild(style);

    waitForKeyElements('.Modal-closeButton', function () {
        document.querySelector(".Modal-wrapper").style.bottom = "unset"
        document.querySelector(".Modal-inner").style.width = "100%"
        document.querySelector(".Modal-inner").style.height = "100%"
        document.querySelector(".Modal-inner").style.position = "fixed"
        document.getElementsByClassName("Button Modal-closeButton")[0].style.display = "none"
        document.getElementsByClassName("Modal Modal--large")[0].style.width = "-webkit-fill-available"
        console.log("提问加载完成")
    })

    emulateMouseClick(document.querySelector(".SearchBar-askButton"))

}