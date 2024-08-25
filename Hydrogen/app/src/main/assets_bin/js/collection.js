function emulateMouseClick(element) {
	let event = new MouseEvent('click', {
		bubbles: true,
		cancelable: true
	});
	element.dispatchEvent(event);
}

function keyboardInput(dom, value) {
	let input = dom;
	let lastValue = input.value;
	input.value = value;
	let event = new Event("input", {
		bubbles: true
	});
	let tracker = input._valueTracker;
	if (tracker) {
		tracker.setValue(lastValue);
	}
	input.dispatchEvent(event);
}

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
	if (url.includes("https://www.zhihu.com/api/v4/collections")) {
		if (response.status === 200) {
			response.json()
				.then(res => {
					console.log(res.collection.id + '新建收藏夹成功' + res.collection.is_public);
				})
		} else {
			console.log("失败 状态码" + response.status)
		}
	}
})

function start() {
	emulateMouseClick(document.querySelector(".CollectionsHeader-addFavlistButton"));
	emulateMouseClick(document.querySelectorAll(".Favlists-privacyOptionRadio")[1]);
}

function setpublic() {
	emulateMouseClick(document.querySelectorAll(".Favlists-privacyOptionRadio")[0]);
}

function setprivacy() {
	emulateMouseClick(document.querySelectorAll(".Favlists-privacyOptionRadio")[1]);
}

function submit(title, content) {
	keyboardInput(document.querySelectorAll(".Input")[1], title);
	keyboardInput(document.querySelectorAll(".Input")[2], content);
	emulateMouseClick(document.querySelectorAll(".Button--primary")[2]);
}


window.onload = function() {
	start()
}