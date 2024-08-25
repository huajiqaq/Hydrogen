(function () {

    function getsrc(doc) {
        if (isLocalPage()) return doc.src
        return doc.dataset && (doc.dataset.original || doc.dataset.src) || doc.src;
    }

    function getimg(ele_src) {
        var tag = document.getElementsByTagName("img");
        var t = {};
        for (var z = 0; z < tag.length; z++) {
            if (isZhihuPage() && tag[z].parentNode.className.includes("GifPlayer")) {
                t[z] = getsrc(tag[z]).replace(/(\.\w+)(\?.*)?$/, ".gif$2")
            } else {
                t[z] = getsrc(tag[z]);
            }
            if (tag[z].src == ele_src) {
                t[tag.length] = z;
            }
        };
        return t
    }

    function isZhihuPage() {
        return window.location.hostname.includes('zhihu.com');
    }

    function isLocalPage() {
        return window.location.href.startsWith("file://");
    }

    function checkClickTarget(event) {
        let target = event.target;

        if (target.tagName.toLowerCase() === 'div') {
            while (target && target.tagName.toLowerCase() !== 'body') {
                const parent = target.parentElement;

                if (parent && Math.abs(target.clientWidth - parent.clientWidth) <= 5 &&
                    Math.abs(target.clientHeight - parent.clientHeight) <= 5) {

                    const img = parent.querySelector('img:first-child');
                    if (img) {
                        return img;
                    }
                } else {
                    break;
                }

                target = target.parentElement;
            }
        }
        return event.target;
    }

    document.addEventListener('click', function (event) { // 判断点击的目标是否为img元素 
        let doc = event.target

        if (isZhihuPage() && doc.parentNode.className.includes("GifPlayer")) {
            // 禁止父元素接受事件
            doc.parentNode.style.pointerEvents = "none"
            doc.src = doc.src.replace(/(\.\w+)(\?.*)?$/, ".gif$2");
            doc.dataset.original = doc.src;
            event.stopPropagation()
            let children = doc.parentNode.children
            for (var i = 0; i < children.length; i++) {
                if (children[i].tagName != "IMG") {
                    children[i].style.display = "none"
                    children[i].style.pointerEvents = "none"
                }
            }
            return false
        }
        if (doc.tagName !== 'IMG') {
            doc = checkClickTarget(event)
        }
        if (doc.tagName === 'IMG') {
            window.androlua.execute(JSON.stringify(getimg(doc.src)));
        }
    }, true);

})();