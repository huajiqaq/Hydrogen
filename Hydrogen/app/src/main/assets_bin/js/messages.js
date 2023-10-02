console.log("重新加载")
window.onload = function () {
    var style
    //隐藏头
    document.querySelector("header").style.display = "none"
    //隐藏底部
    document.querySelector(".Footer").style.display = "none"
    //去除距离
    document.querySelector(".Chat").style.margin = 0
    //隐藏滑动
    //document.querySelector(".ChatListGroup-SectionContent").style.overflowY = "hidden"
    //优化页面
    document.querySelector(".ChatSideBar").style.position = "unset"
    document.querySelector(".ChatSideBar").style.width = "unset"
    document.querySelector(".Chat").style.minHeight = "unset"
    document.querySelector(".Chat").style.maxHeight = "unset"
    document.querySelector(".Chat").style.minWidth = "unset"
    document.querySelector(".Chat").style.maxWidth = "unset"
    document.querySelector(".Chat").style.width = "100%"
    document.querySelector(".Chat").style.height = "100%"
    document.querySelector(".Chat").style.position = "fixed"
    //防止图片压缩
    style = document.createElement('style');
    style.innerHTML = 'img{max-width:unset !important}'
    document.head.appendChild(style);
    //防止知乎小管家卡片压缩
    style = document.createElement('style');
    style.innerHTML = '.CardMessage{width:unset !important}'
    //知乎小管家卡片子项
    style.innerHTML += '.css-1snk75c{height:unset !important}'
    document.head.appendChild(style);

    var ismessage_str = null

    function ismessage(ischeck) {
        var messagemode

        if (ismessage_str) {
            ismessage_str = null
            return ismessage_str
        }

        if (ischeck) {
            if (document.querySelector('.Chat').childNodes[1].style.display == "none") {
                messagemode = false
            } else {
                messagemode = true
            }
        } else {
            var path = window.location.pathname.split("/");
            if (path[1] == "messages") {
                //检测message后是否有/
                if (path.length > 2) {
                    messagemode = true
                } else {
                    messagemode = false
                }
            }
        }
        return messagemode
    }

    function handleChildChange() {
        oristyle = document.querySelector(".ChatListGroup-SectionContent").style.cssText
        if (!ismessage_str) {
            document.querySelector('.Chat').childNodes[0].style.display = "none"
            document.querySelector('.Chat').childNodes[1].style.display = "flex"
            document.querySelector('.Chat').childNodes[1].style.minHeight = "unset"
            document.querySelector('.Chat').childNodes[1].style.maxHeight = "unset"
            document.querySelector('.Chat').childNodes[1].style.minWidth = "unset"
            document.querySelector('.Chat').childNodes[1].style.maxWidth = "unset"
            document.querySelector('.Chat').childNodes[1].childNodes[0].children[0].style.margin = "0 auto"
            ismessage_str = null
        }
        if (document.querySelector("#myback") == null) {
            var button = document.createElement("button");
            button.id = "myback"
            button.style.ariaLabel = "返回"
            button.style.type = "butoon"
            button.innerHTML = '<svg t="1688284732470" width="24" height="24" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="6142"><path d="M879.476364 470.341818H244.829091L507.112727 209.454545a41.658182 41.658182 0 0 0-58.88-58.88L114.967273 482.676364a41.890909 41.890909 0 0 0 0 58.88l333.265454 333.032727a41.658182 41.658182 0 0 0 58.88 0 41.890909 41.890909 0 0 0 0-58.88L244.829091 553.658182h634.647273a41.658182 41.658182 0 1 0 0-83.316364z" p-id="6143" fill="#056de8"></path></svg>'
            var chatBoxTitle = document.querySelector('.Chat').childNodes[1].childNodes[0]
            chatBoxTitle.insertBefore(button, chatBoxTitle.firstChild)
            button.onclick = function () {
                //location.replace("https://www.zhihu.com/messages")
                //console.log("重新加载")
                ismessage_str = false
                console.log(document.querySelector('.Chat'))
                console.log(document.querySelector('.Chat').childNodes)
                document.querySelector('.Chat').childNodes[0].style.display = "unset"
                document.querySelector('.Chat').childNodes[1].style.display = "none"

                //精准计算高度 防止某些情况下高度设置不正确
                let ChatListGroup = document.querySelector('.Chat').childNodes[0].childNodes[1]
                let height = ChatListGroup.clientHeight - ChatListGroup.childNodes[0].childNodes[0].clientHeight
                document.querySelector('.ChatListGroup-SectionContent').style.height = height.toString() + "px"

                button.remove()
                history.pushState(null, null, '/messages');
                console.log(document.querySelector('.Chat').childNodes[0].style.display)

            }
        }
    }

    function addbutton() {
        //因为返回按钮点击会打开messages页 不是直接打开 所以只需修改一次
        console.log(document.querySelector("#myback"))
        /*
        document.querySelector('.Chat').removeEventListener('DOMSubtreeModified', handleChildChange, true)
        document.querySelector('.Chat').addEventListener('DOMSubtreeModified', handleChildChange, true);
        */
        const observer = new MutationObserver(handleChildChange);
        observer.observe(document.querySelector('.Chat'), { childList: true });
    }


    if (ismessage()) {
        document.querySelector('.Chat').childNodes[0].style.display = "none"
        handleChildChange()
    } else {
        document.querySelector('.Chat').childNodes[1].style.display = "none"
    }

    addbutton()

    const div = document.querySelector(".ChatListGroup-SectionContent");

    div.addEventListener("click", function (e) {
        console.log(e)
        var clickdoc = e.target
        var isclick = clickdoc.closest('.Chat-ActionMenuPopover-Button')
        var isChild = clickdoc.closest('.ChatUserListItem')

        console.log(ismessage_str)
        if (ismessage_str == null) {
            ismessage_str = ismessage(true)
        }

        if (isclick) {
            return false
        }
        if (isChild) {
            handleChildChange()
        } else {
            console.log(clickdoc)
        }

    }, false);

    console.log("加载完成")


}