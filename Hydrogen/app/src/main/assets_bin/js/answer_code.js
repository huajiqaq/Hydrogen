const allpre_element = document.querySelectorAll(".ztext pre")
// 防抖函数
function debounce(func, wait) {
    let timeout;
    return function (...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), wait);
    };
}

// 20毫秒不操作 且判断大于滑动宽度就自动判断为结束
const checkIfScrolledToEndDebounced = debounce(function (element) {
    const scrollWidth = element.scrollWidth;
    const clientWidth = element.clientWidth;
    const scrollLeft = element.scrollLeft;

    if ((scrollLeft + clientWidth) >= scrollWidth) {
        console.log('结束滑动');
    }
}, 20); // 防抖延迟时间（毫秒）



for (let index = 0; index < allpre_element.length; index++) {
    const element = allpre_element[index];

    element.addEventListener('touchstart', function (event) {
        console.log("开始滑动");
    });

    element.addEventListener('touchmove', function (event) {
        checkIfScrolledToEndDebounced(); // 触发防抖函数
    });

    element.addEventListener('touchend', function (event) {
        console.log("结束滑动");
    });

    element.addEventListener('touchcancel', function (event) {
        console.log("结束滑动");
    });

}