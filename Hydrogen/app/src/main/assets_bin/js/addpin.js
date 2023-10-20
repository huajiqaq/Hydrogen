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
	if (url == "https://www.zhihu.com/api/v4/v2/pins") {
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
window.onload=function() {
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
  style.innerHTML = '.Modal{box-shadow:unset !important;width:100%;min-width:unset}'
  document.head.appendChild(style);
  //防止输入框被下面视图覆盖
  style = document.createElement('style');
  style.innerHTML = '.Ask-items{max-width:unset !important;max-height:unset !important}'
  style.innerHTML += '.Editable-content{max-width:unset !important;max-height:unset !important}'
  document.head.appendChild(style);
  //优化卡片
  style = document.createElement('style');
  //添加卡片间隔
  style.innerHTML = '.css-1v2yy2g{margin-top:5px !important}'
  //防止卡片显示不全
  style.innerHTML += '.css-ko5bgx{height:unset !important}'
  //防止布局错乱
  style.innerHTML += '.css-fbcqx2{flex-wrap:wrap !important}'
  //防止视频页面超出屏幕
  style.innerHTML += '.css-10rx4cn{width:unset !important; height:unset !important}'
  document.head.appendChild(style);

  waitForKeyElements('.Modal-closeButton', function () {
      document.querySelector(".Modal-wrapper").style.bottom = "unset"
      document.querySelector(".Modal-inner").style.width = "100%"
      document.querySelector(".Modal-inner").style.height = "100%"
      document.querySelector(".Modal-inner").style.position = "fixed"
      document.getElementsByClassName("Button Modal-closeButton")[0].style.display = "none"
      console.log("加载完成")
  })

  emulateMouseClick(document.querySelectorAll(".GlobalWriteV2-topItem")[3])

}