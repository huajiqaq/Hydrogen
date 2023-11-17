(function () {
    var tags = document.getElementsByTagName("img");
    for (var i = 0; i < tags.length; i++) {
        if (tags[i].className.includes("GifPlayer-gif2mp4Image")) {
            const imageUrl = tags[i].src
            const newImageUrl = imageUrl.replace(/(\.\w+)(\?.*)?$/, ".gif$2");
            tags[i].src = newImageUrl;
        }
        tags[i].onclick = function () {
            var tag = document.getElementsByTagName("img");
            var t = {};
            for (var z = 0; z < tag.length; z++) {
                t[z] = tag[z].src;
                if (tag[z].src == this.src) {
                    t[tag.length] = z;
                }
            };

            window.androlua.execute(JSON.stringify(t));
        }
    };
    return tags.length;
})();