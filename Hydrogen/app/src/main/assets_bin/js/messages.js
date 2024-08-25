(function () {

    console.log("重新加载")
    function init() {
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


        function isInMessagePage() {
            let path = window.location.pathname.split("/");
            if (path[1] == "messages") {
                //检测message后是否有/
                if (path.length > 2 && path[2] != "") {
                    return true
                } else {
                    return false
                }
            }
        }

        function addbutton() {
            // 居中
            document.querySelector('.Chat').childNodes[1].childNodes[0].children[0].style.margin = "0 auto"
            // 防止页面被压缩
            document.querySelector('.Chat').childNodes[1].style.maxHeight = "unset"
            document.querySelector('.Chat').childNodes[1].style.maxWidth = "unset"
            document.querySelector('.Chat').childNodes[1].style.minHeight = "unset"
            document.querySelector('.Chat').childNodes[1].style.minWidth = "unset"
            // 页面的隐藏以及禁止点击
            // 使用visibility而不是display 因为display会导致clientHeight、clientWidth 等尺寸属性返回 0 导致网页错误设置列表高度
            document.querySelector('.Chat').childNodes[0].style.visibility = "hidden"
            document.querySelector('.Chat').childNodes[0].style.pointerEvents = "none"
            document.querySelector('.Chat').childNodes[1].style.visibility = "unset"
            document.querySelector('.Chat').childNodes[1].style.pointerEvents = "unset"

            let button = document.createElement("button");
            button.style.ariaLabel = "返回"
            button.style.type = "butoon"
            button.innerHTML = '<svg t="1688284732470" width="24" height="24" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="6142"><path d="M879.476364 470.341818H244.829091L507.112727 209.454545a41.658182 41.658182 0 0 0-58.88-58.88L114.967273 482.676364a41.890909 41.890909 0 0 0 0 58.88l333.265454 333.032727a41.658182 41.658182 0 0 0 58.88 0 41.890909 41.890909 0 0 0 0-58.88L244.829091 553.658182h634.647273a41.658182 41.658182 0 1 0 0-83.316364z" p-id="6143" fill="#056de8"></path></svg>'
            let chatBoxTitle = document.querySelector('.Chat').childNodes[1].childNodes[0]
            chatBoxTitle.insertBefore(button, chatBoxTitle.firstChild)
            button.onclick = function () {
                //location.replace("https://www.zhihu.com/messages")
                //console.log("重新加载")
                document.querySelector('.Chat').childNodes[0].style.visibility = "unset"
                document.querySelector('.Chat').childNodes[0].style.pointerEvents = "unset"
                document.querySelector('.Chat').childNodes[1].style.visibility = "hidden"
                document.querySelector('.Chat').childNodes[1].style.pointerEvents = "none"

                button.remove()
                history.pushState(null, null, '/messages');
            }
        }

        if (isInMessagePage()) {
            document.querySelector('.Chat').childNodes[0].style.visibility = "hidden"
            addbutton()
        } else {
            document.querySelector('.Chat').childNodes[1].style.visibility = "hidden"
        }

        const div = document.querySelector(".ChatListGroup");

        div.addEventListener("click", function (event) {
            let doc = event.target
            // closest 会直接返回最近的包含ChatListGroup-SectionContent类的祖先元素
            let isChildOfChatListGroupSectionContent = doc.closest('.ChatUserListItem')

            if (isChildOfChatListGroupSectionContent) {
                addbutton()
            }

        });

        const observer = new MutationObserver(addbutton);
        observer.observe(document.querySelector('.Chat'), { childList: true });

        console.log("加载完成")


    }

    window.addEventListener("load", init)

})()