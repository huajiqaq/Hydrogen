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
	if (url == "https://www.zhihu.com/api/v4/reports") {
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