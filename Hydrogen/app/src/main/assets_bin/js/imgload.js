(function () {
    var tags = document.getElementsByTagName("img");
    for (var i = 0; i < tags.length; i++) {
        if (tags[i].parentNode.className.includes("GifPlayer")) {
            tags[i].onclick = function (e) {
                if (this.parentNode.className.includes("isPlaying")) {
                    e.stopPropagation()
                } else {
                    const imageUrl = this.src
                    const newImageUrl = imageUrl.replace(/(\.\w+)(\?.*)?$/, ".gif$2");
                    this.src = newImageUrl;
                    this.dataset.original = newImageUrl;
                    e.stopPropagation()
                    this.parentNode.className = this.parentNode.className + " isPlaying"
                    for (var i = 0; i < this.parentNode.childNodes.length; i++) {
                        if (this.parentNode.childNodes[i].tagName != "IMG") {
                            console.log(this.parentNode.childNodes[i])
                            this.parentNode.childNodes[i].style.display = "none"
                            this.parentNode.childNodes[i].style.pointerEvents = "none"
                        }
                    }
                    return
                }
                var tag = document.getElementsByTagName("img");
                var t = {};
                for (var z = 0; z < tag.length; z++) {
                    if (tag[z].dataset.src) {
                        t[z] = tag[z].dataset.original || tag[z].dataset.src
                    } else {
                        t[z] = tag[z].src
                    }
                    if (tag[z].parentNode.className.includes("GifPlayer")) {
                        t[z] = t[z].replace(/(\.\w+)(\?.*)?$/, ".gif$2")
                    }
                    if (tag[z].src == this.src) {
                        t[tag.length] = z;
                    }
                };

                window.androlua.execute(JSON.stringify(t));
            }
            continue
        }
        tags[i].onclick = function () {
            var tag = document.getElementsByTagName("img");
            var t = {};
            for (var z = 0; z < tag.length; z++) {
                if (tag[z].dataset.src) {
                    t[z] = tag[z].dataset.original || tag[z].dataset.src
                } else {
                    t[z] = tag[z].src
                }
                if (tag[z].parentNode.className.includes("GifPlayer")) {
                    t[z] = t[z].replace(/(\.\w+)(\?.*)?$/, ".gif$2")
                }
                if (tag[z].src == this.src) {
                    t[tag.length] = z;
                }
            };

            window.androlua.execute(JSON.stringify(t));
        }
    };
    return tags.length;
})();