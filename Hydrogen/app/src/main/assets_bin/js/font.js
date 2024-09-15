(function () {
    // 备用 当反馈时会加上 猜测可能在CSP内的网页
    function guessAllowedHostname() {
        // 提取<link>标签中的CSS文件的href属性
        const linkTags = document.getElementsByTagName('link');
        for (let i = 0; i < linkTags.length; i++) {
            const linkTag = linkTags[i];
            if (linkTag.rel === 'stylesheet') {
                const href = linkTag.href;
                if (href.startsWith('http')) {
                    try {
                        return new URL(href).hostname;
                    } catch (e) {
                        console.error(`Invalid URL: ${href}`);
                    }
                }
            }
        }

        // 提取<script>标签中的脚本文件的src属性
        const scriptTags = document.getElementsByTagName('script');
        for (let i = 0; i < scriptTags.length; i++) {
            const scriptTag = scriptTags[i];
            const src = scriptTag.src;
            if (src && src.startsWith('http')) {
                try {
                    return new URL(src).hostname;
                } catch (e) {
                    console.error(`Invalid URL: ${src}`);
                }
            }
        }

        // 提取<meta>标签中的CSP信息
        const metaTags = document.getElementsByTagName('meta');
        for (let i = 0; i < metaTags.length; i++) {
            const metaTag = metaTags[i];
            if (metaTag.getAttribute('http-equiv') === 'Content-Security-Policy') {
                const csp = metaTag.content;
                const regex = /connect-src\s+['"]?([^'";\s]+)/;
                const match = csp.match(regex);
                if (match) {
                    return match[1];
                }
            }
        }

        // 如果没有找到任何信息，则返回页面本身的hostname
        return window.location.hostname;
    }

    isNetWork = window.location.href.startsWith("http")

    function getStyle() {
        // 防止CSP 一般网页本身在CSP名单内 所以直接获取window.location.hostname
        let fontUrl
        if (isNetWork) {
            const allowedHostname = window.location.hostname;
            fontUrl = allowedHostname + "/myappfont"
        } else {
            fontUrl = "file://myappfont"
        }
        // 创建一个新的<style>标签
        var style = document.createElement("style");

        // 动态生成@font-face规则
        style.innerHTML = `
    @font-face {
        font-family: 'myappfont';
        src: url('${fontUrl}') format('truetype');
    }
    * {
        font-family: 'myappfont';
    }
`;
        // style中的网页由App拦截 
        return style
    }

    // 定义 一会要用

    const style = getStyle()
    // 判断是否在本地文件
    if (window.location.href.startsWith("http://") || window.location.href.startsWith("file://")) {
        document.head.appendChild(style)
        return
    }

    // 检查document.head是否存在，如果存在则立即执行，否则监听变化
    if (document.head) {
        document.head.appendChild(style)
    } else {
        // 使用MutationObserver监听document的变化
        const docObserver = new MutationObserver(() => {
            if (document.head) {
                document.head.appendChild(style)
                docObserver.disconnect()
            }
        });

        // 配置观察选项
        const config = { childList: true, subtree: true };

        // 开始观察document节点
        docObserver.observe(document, config);
    }
})()