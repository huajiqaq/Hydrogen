(function () {
    function init() {

        var style
        style = document.createElement('style');
        // 优化figure下的figure
        style.innerHTML = '.RichText figure > figure{width:100% !important;margin:unset !important}'
        document.head.appendChild(style)

        // 返回找到的index
        function findMatchingTextIndexInSecondElement(dom, dom1) {
            let dom_children = [...dom.children];
            let dom1_children = [...dom1.children];

            // 确保两个元素都有子元素，且至少有两个子元素
            if (dom_children.length < 2 || dom1_children.length < 2) return -1; // 或者其他处理方式

            // 获取dom的倒数第二个子元素的文本内容
            let finalTextFromDom = dom_children[dom_children.length - 2].textContent.trim();

            // 计算finalTextFromDom在dom_children中的出现次数
            let occurrenceInDom = dom_children.filter(child => child.textContent.trim() === finalTextFromDom).length;

            // 在dom1_children中找到finalTextFromDom的第occurrenceInDom次出现的索引
            let indexInDom1 = dom1_children.findIndex(
                (child, index) => {
                    return child.textContent.trim() === finalTextFromDom && --occurrenceInDom === 0;
                },
                occurrenceInDom
            );

            // 如果找到了，则返回索引，否则返回-1或其他表示未找到的值
            return indexInDom1 !== -1 ? indexInDom1 : -1;
        }

        let richtext = document.getElementsByClassName("RichText")[0]
        let alldiv = richtext.getElementsByTagName("div")
        if (alldiv.length == 0) return
        let div = alldiv[alldiv.length - 1]
        let divtext = div.innerText
        if ((divtext.includes("App") || divtext.includes("app")) && divtext.includes("查看")) {

            var tip = document.createElement('div')
            tip.className = "ExtraInfo"
            tip.innerText = "该回答为付费回答"
            document.getElementsByClassName("ExtraInfo")[0].insertBefore(tip, document.getElementsByClassName("ExtraInfo")[0].firstChild);

            let a = div.querySelector("a")
            a.href = 'javascript:void(0);'
            a.textContent = "🔗立即加载"
            a.onclick = function () {

                if (a.textContent == "加载中...") {
                    return
                }

                a.textContent = "加载中..."

                let id = window.location.href.split("/")[window.location.href.split("/").length - 1]

                const url = 'https://www.zhihu.com/appview/v2/answer/' + id;

                // 使用fetch函数发起GET请求
                fetch(url)
                    .then(response => {
                        // 检查响应是否成功
                        if (!response.ok) {
                            throw new Error(`HTTP error! status: ${response.status}`);
                        }
                        // 解析JSON格式的响应数据
                        return response.text();
                    })
                    .then(data => {
                        window.data = data
                        // 创建一个新的html元素
                        let tempHtml = document.createElement('html');
                        window.tempHtml = tempHtml

                        tempHtml.innerHTML = data;
                        let tempRichtext = tempHtml.getElementsByClassName("RichText")[0]
                        let tempRichtext_children = tempRichtext.children

                        let richtext_children = richtext.children

                        // 减2略过App内查看元素
                        if (richtext_children[richtext_children.length - 2].textContent == tempRichtext_children[tempRichtext_children.length - 1].textContent) {
                            a.textContent = "🔗立即加载"
                            alert("获取失败 请检查是否开通会员或是否购买")
                            return
                        }

                        let index = findMatchingTextIndexInSecondElement(richtext, tempRichtext)

                        if (index == -1) {
                            throw "未找到元素"
                        }

                        // index 加一为没有的元素
                        for (let i = index + 1; i < tempRichtext_children.length; i++) {

                            const element = tempRichtext_children[i];
                            const add_ele = richtext.appendChild(element)
                            resolve_ele(add_ele)
                            i--
                        }

                        div.remove()

                    })
                    .catch(error => {
                        // 处理请求过程中可能出现的错误
                        console.error('There was a problem with the fetch operation:', error);
                        alert("出错了 请更新或反馈 错误信息" + error)
                        a.textContent = "🔗立即加载"
                    });
            }
        }
    }

    function resolve_ele(ele) {
        if (ele.tagName == "FIGURE") {

            // 软件加载网页不能使用懒加载 所以就不写懒加载
            let img = ele.querySelector("img")

            if (img == null) return

            const orisrc = img.src
            const loadsrc = img.dataset.original || img.dataset.src

            if (orisrc.slice(0, 10) === 'data:image') {

                const figure = (ele.children[0].tagName === "FIGURE") ? ele.children[0] : ele;
                figure.innerHTML += '<div class="ImageLoader-message">加载中...</div>'
                // 由于上面更改innerHTMl 为了防止img元素更改 重新获取
                img = ele.querySelector("img")
                const errortip = "加载失败，点击重试"
                const tip = ele.querySelector(".ImageLoader-message")
                tip.addEventListener("click", function () {
                    if (this.innerText != errortip) return
                    this.innerText = "加载中..."
                    img.src = loadsrc
                })

                img.addEventListener("load", function () {
                    if (img.src == orisrc) return
                    tip.remove()
                })
                img.addEventListener("error", function () {
                    img.src = orisrc
                    tip.innerText = errortip
                })

                img.src = loadsrc

            }

        }
    }

    window.addEventListener("load", function () {
        waitForKeyElements('.RichText', init)
    })

})()