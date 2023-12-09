window.onload = function () {

    if (document.querySelector(".MobileAppHeader")) {
        if (document.querySelector(".LiveStreamPlayer-video")) {
            document.querySelector(".LiveStreamPlayer-video").controls = true;
        }
        var style
        style = document.createElement('style');
        style.innerHTML = '.TheaterRoomHeader-temperature{pointer-events:none !important}'
        style.innerHTML += '.TheaterToolbar{display:none !important}'
        style.innerHTML += '.TheaterMessageList{margin-bottom:10px !important}'
        style.innerHTML += '.TheaterMessage{pointer-events:none !important}'
        style.innerHTML += '.Theater-core{max-height:unset !important; height:100vh !important}'
        document.head.appendChild(style)

        style = document.createElement('style');
        style.innerHTML = '.MobileAppHeader{display:none !important}'
        style.innerHTML += '.Sticky--holder{display:none !important}'
        document.head.appendChild(style)

        if (document.querySelector(".TheaterRoomHeader-actor")) {
            document.querySelector(".TheaterRoomHeader-actor").outerHTML = document.querySelector(".TheaterRoomHeader-actor").outerHTML

            if (document.querySelector(".TheaterRoomHeader-actor").childNodes[1]) {

                document.querySelector(".TheaterRoomHeader-actor").childNodes[1].addEventListener('click', function (e) {
                    console.log("查看用户")
                    e.stopPropagation();
                }, true);
            }

            if (document.querySelector(".TheaterRoomHeader-actor").childNodes[2]) {
                let ele = document.querySelector(".TheaterRoomHeader-actor").childNodes[2]

                document.querySelector(".TheaterRoomHeader-actor").childNodes[2].addEventListener('click', function (e) {
                    console.log("关注分割" + ele.innerText)
                });
            }
        }

        if (document.querySelector(".TheaterEndCard-actorCard")) {
            document.querySelector(".TheaterEndCard-actorCard").outerHTML = document.querySelector(".TheaterEndCard-actorCard").outerHTML

            if (document.querySelector(".TheaterEndCard-actorCard").childNodes[3]) {
                document.querySelector(".TheaterEndCard-actorCard").childNodes[3].addEventListener('click', function (e) {
                    console.log("查看用户")
                    e.stopPropagation();
                }, true);
            }

            if (document.querySelector(".TheaterEndCard-actorCard").childNodes[2]) {
                let ele = document.querySelector(".TheaterEndCard-actorCard").childNodes[2]
                document.querySelector(".TheaterEndCard-actorCard").childNodes[2].addEventListener('click', function (e) {
                    console.log("关注分割" + ele.innerText)
                });
            }
        }
        
    }
}