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
	if (url == "https://www.zhihu.com/api/v4/columns/request") {
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

console.log("重新加载")
window.onload = function () {
    var style
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
    //优化页面
    style = document.createElement('style');
    //隐藏顶部
    style.innerHTML = '.MobileAppHeader{display:none !important}'
    document.head.appendChild(style);
    console.log("加载完成")
}