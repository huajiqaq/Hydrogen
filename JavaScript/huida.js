function waitForKeyElements(selectorOrFunction, callback, waitOnce, interval, maxIntervals) {
	if (typeof waitOnce === "undefined") {
		waitOnce = true;
	}
	if (typeof interval === "undefined") {
		interval = 300;
	}
	if (typeof maxIntervals === "undefined") {
		maxIntervals = -1;
	}
	var targetNodes =
		typeof selectorOrFunction === "function" ? selectorOrFunction() : document.querySelectorAll(selectorOrFunction);
 
	var targetsFound = targetNodes && targetNodes.length > 0;
	if (targetsFound) {
		targetNodes.forEach(function(targetNode) {
			var attrAlreadyFound = "data-userscript-alreadyFound";
			var alreadyFound = targetNode.getAttribute(attrAlreadyFound) || false;
			if (!alreadyFound) {
				var cancelFound = callback(targetNode);
				if (cancelFound) {
					targetsFound = false;
				} else {
					targetNode.setAttribute(attrAlreadyFound, true);
				}
			}
		});
	}
 
	if (maxIntervals !== 0 && !(targetsFound && waitOnce)) {
		maxIntervals -= 1;
		setTimeout(function() {
			waitForKeyElements(selectorOrFunction, callback, waitOnce, interval, maxIntervals);
		}, interval);
	}
}
 
 
 
waitForKeyElements(' [class="Body--Android Body--Tablet Body--BaiduApp"]',function () {
let observer = new MutationObserver(() => {
	if (document.getElementsByClassName("Body--Android Body--Tablet Body--BaiduApp")[0].style.position == "fixed") {
		document.getElementsByClassName("css-1cqr2ue")[0].style.width = '100%'
		document.getElementsByClassName("Button css-1x9te0t")[0].style.position = 'unset'
    }
});
 
// 监听body元素的属性变化
observer.observe(document.getElementsByClassName("Body--Android Body--Tablet Body--BaiduApp")[0], {
	attributes: true,
	attributeFilter: ['style', 'position']
});
})