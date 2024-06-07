(function () {

    function init() {
        let jsonstr = document.getElementById("js-initialData").innerText
        let json = JSON.parse(jsonstr).initialState.briefs
        let id = Object.values(json.entityId2ContentIdMap)[0]
        let jsondata = json[id]
        let videodata = jsondata.video
        if (videodata) {
            if (videodata.playlist) {

                let element = document.querySelector(".RichText").childNodes[0];

                var style
                style = document.createElement('style');
                style.innerHTML = '.css-0 > *:first-child{padding-top:unset !important}'
                document.head.appendChild(style);


                let playurl = Object.values(videodata.playlist)[0].url

                var div = document.createElement('div');
                div.innerHTML = '<video controls="" style="width: 100%;height: 100%;"><source src="' + playurl + '" type="video/mp4"></video>'

                // 在目标元素之前插入新元素
                element.parentNode.insertBefore(div, element);

            }
        }
    }

    window.addEventListener("load", init)

})()