console.log("重新加载")

let logFetch = window.fetch

function onfetch(callback) {
	window.fetch = function(input, init) {
		return new Promise((resolve, reject) => {
			logFetch(input, init)
				.then(function(response) {
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

window.onload = function () {
    var style
    function emulateMouseClick(element) {
        let event = new MouseEvent('click', {
            bubbles: true,
            cancelable: true
        });
        element.dispatchEvent(event);
    }

    document.querySelector(".App-main").style.display = 'none'
    //防止图片显示不正确
    style = document.createElement('style');
    style.innerHTML = '.Modal-closeButton{position:unset !important}'
    document.head.appendChild(style);
    //防止按钮放的波
    style = document.createElement('style');
    style.innerHTML = '.Modal{box-shadow:unset !important;width:unset}'
    document.head.appendChild(style);
    //防止输入框被下面视图覆盖
    style = document.createElement('style');
    style.innerHTML = '.Ask-items{max-width:unset !important;max-height:unset !important}'
    style.innerHTML += '.Editable-content{max-width:unset !important;max-height:unset !important}'
    //条件 ：元素名为 Ask-form 的 form 元素 下的直接子元素 且 该直接子元素是一个没有名称的div 位于父元素的第一个
    //直接子元素：当前元素下面第一级的元素是直接子元素
    style.innerHTML += 'form.Ask-form > div:not([name]):first-child{height:unset !important}'
    document.head.appendChild(style);
    //优化推荐问题
    style = document.createElement('style');
    //防止推荐问题超出屏幕
    style.innerHTML = '.AskTitle-suggestionContainer{width:100% !important}'
    //防止推荐问题宽度不统一
    style.innerHTML += '.Menu-item{width:100vw !important}'
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