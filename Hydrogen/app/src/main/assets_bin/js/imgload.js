(function () {
    var tags = document.getElementsByTagName("img");
    for (var i = 0; i < tags.length; i++) {
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