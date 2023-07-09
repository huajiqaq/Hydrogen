window.onload = function() {
	(function() {
		var styleElem = null,
			doc = document,
			ie = doc.all,
			fontColor = 80,
			sel = "body,body *";
		styleElem = createCSS(sel, setStyle(fontColor), styleElem);

		function setStyle(fontColor) {
			var colorArr = [fontColor, fontColor, fontColor];
			return (
				"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB(" +
				colorArr.join("%,") +
				"%) !important;"
			);
		}

		function createCSS(sel, decl, styleElem) {
			var doc = document,
				h = doc.getElementsByTagName("head")[0],
				styleElem = styleElem;
			if (!styleElem) {
				s = doc.createElement("style");
				s.setAttribute("type", "text/css");
				styleElem = ie ?
					doc.styleSheets[doc.styleSheets.length - 1] :
					h.appendChild(s);
			}
			if (ie) {
				styleElem.addRule(sel, decl);
			} else {
				styleElem.innerHTML = "";
				styleElem.appendChild(doc.createTextNode(sel + " {" + decl + "}"));
			}
			return styleElem;
		}
	})();
}