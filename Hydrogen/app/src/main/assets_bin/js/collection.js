window.onload = function() {
	function emulateMouseClick(element) {
		// 创建事件
		var event = document.createEvent("MouseEvents");
		// 定义事件 参数： type, bubbles, cancelable
		event.initEvent("click", true, true);
		// 触发对象可以是任何元素或其他事件目标
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
		emulateMouseClick(document.querySelectorAll("Button Button--primary Button--blue")[2]);
	}
	
	start()
}