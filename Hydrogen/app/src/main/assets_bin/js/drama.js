window.onload = function () {

    if (document.querySelector(".TheaterToolbar-button")) {
        var style
        style = document.createElement('style');
        style.innerHTML = '.TheaterRoomHeader-temperature{display:none !important}'
        style.innerHTML += '.Theater-bottom{display:none !important}'
        style.innerHTML += '.Theater-bottom{display:none !important}'
        style.innerHTML += '.Sticky--holder{display:none !important}'
        document.head.appendChild(style)
        document.querySelector(".TheaterRoomHeader-actor").outerHTML = document.querySelector(".TheaterRoomHeader-actor").outerHTML

        document.querySelector(".LiveStreamPlayer-video").controls=true;

        document.querySelector(".TheaterRoomHeader-actor").childNodes[1].onclick = function () {
            console.log("查看用户")
        }
        
        let ele=document.querySelector(".TheaterRoomHeader-actor").childNodes[2]

        document.querySelector(".TheaterRoomHeader-actor").childNodes[2].onclick = function () {
            console.log("关注分割" + ele.innerText)
        }

    }

}