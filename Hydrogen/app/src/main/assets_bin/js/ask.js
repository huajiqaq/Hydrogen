console.log("重新加载")

let logFetch = window.fetch

function onfetch(callback) {
    window.fetch = function (input, init) {
        return new Promise((resolve, reject) => {
            logFetch(input, init)
                .then(function (response) {
                    callback(response.clone())
                    resolve(response)
                }, reject)
        })
    }
}

onfetch(response => {
    let url = response.url
    if (url == "https://www.zhihu.com/api/v4/questions") {
        if (response.status === 200) {
            response.json()
                .then(res => {
                    console.log("提交成功退出");
                })
        } else {
            console.log("失败 状态码" + response.status)
        }
    }
})

window.addEventListener("load", function () {
    var style
    function emulateMouseClick(element) {
        let event = new MouseEvent('click', {
            bubbles: true,
            cancelable: true
        });
        element.dispatchEvent(event);
    }

    style = document.createElement('style');
    //隐藏头部和底部
    style.innerHTML = '.App-main, .AppHeader{display:none !important}'
    //解决显示不全 536px是原来网页截取下来的
    style.innerHTML += '.Modal{width:100vw !important;height:100vh !important;max-width: 536px !important;max-height: unset !important}'
    document.head.appendChild(style);
    //防止输入框被下面视图覆盖
    style = document.createElement('style');
    style.innerHTML = '.Ask-items{max-width:unset !important;max-height:unset !important}'
    style.innerHTML += '.Editable-content{max-width:unset !important;max-height:unset !important}'
    //条件 ：元素名为 Ask-form 的元素 下的所有div元素 防止显示不全
    style.innerHTML += '.Ask-form > div{height:unset !important}'
    document.head.appendChild(style);
    //优化推荐问题
    style = document.createElement('style');
    //防止推荐问题超出屏幕
    style.innerHTML = '.AskTitle-suggestionContainer{width:100% !important}'
    //防止推荐问题宽度不统一
    style.innerHTML += '.Menu-item{width:100vw !important}'
    //隐藏添加问题的关闭按钮
    style.innerHTML += 'div.Modal.Modal--large > .Modal-closeButton{display:none !important}'
    //防止图片显示过大
    style.innerHTML += '.Image-resizerContainer > :first-child > :first-child{height:100% !important}'
    style.innerHTML += '.Image{width:100% !important;height:100% !important}'
    //防止按钮不显示
    style.innerHTML += '.Modal-closeButton{position:unset !important}'
    //防止滚动条
    style.innerHTML += '.Modal-content.Modal-content--spread{overflow: hidden !important}'
    //绑定手机号文本改间距
    style.innerHTML += '.Modal-content--spread > :first-child > :first-child{margin: 18px !important}'
    //防止显示不全
    style.innerHTML += '.Modal-inner{height: 100vh !important;width: 100vw !important}'
    document.head.appendChild(style);

    emulateMouseClick(document.querySelector(".SearchBar-askButton"))

    console.log("加载完成")

})