console.log("重新加载")

window.addEventListener("load", function () {
    var style
    style = document.createElement('style');
    //隐藏头部和底部
    style.innerHTML = 'header, .AppHeader{display:none !important}'
    //解决显示不全
    style.innerHTML += '.Creator{min-width:unset !important}'
    //自动换行
    style.innerHTML += '.css-0[role="list"] > div > div{flex-wrap:wrap !important}'
    //让标题独占一行
    style.innerHTML += '.css-0[role="list"] > div > div > div{flex-basis:100% !important;padding-right:unset !important}'
    //防止吸顶内容超出屏幕
    style.innerHTML += '.Sticky.is-fixed{top:0 !important;width:100% !important}'
    //隐藏回答按钮
    style.innerHTML += '.QuestionItem-footer--writeAnswerButton{display:none !important}'
    //去除下方内容最小宽度 防止超出屏幕 固定div名 后期可能需要维护
    style.innerHTML += '.css-1imun56{min-width:unset !important}'
    //美化标签排序 固定div名 后期可能需要维护
    style.innerHTML += '.css-1l7mefd{padding-right:unset !important}'
    document.head.appendChild(style);
    console.log("加载完成")

    const mstyle = document.createElement('style');
    document.head.appendChild(mstyle);

    function updateStyles(num) {
        //动态更新一行占用多少 下面因为少一个回答问题和标题 所以减二
        mstyle.innerHTML = `.Sticky div{flex-basis:${100 / num}% !important}`;
        mstyle.innerHTML += `.css-0[role="list"] > div > div > div:not(:first-child){flex-basis:${100 / (num - 2)}% !important}`;
        console.log(mstyle)
    }

    if (window.location.href.includes("/hour")) {
        updateStyles(7)
    } else {
        updateStyles(6)
    }

    document.querySelectorAll('a.StyledTab-Link').forEach((anchor, index) => {
        anchor.addEventListener('click', function (event) {
            updateStyles(index == 0 ? 7 : 6);
        });
    });

})