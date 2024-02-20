const allpre_elements = document.querySelectorAll(".ztext pre");

// 防抖函数
function debounce(func, wait) {
    let timeout;
    return function (...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), wait);
    };
}

function checkIfScrolledToEnd(element) {
    const scrollWidth = element.scrollWidth;
    const clientWidth = element.clientWidth;
    const scrollLeft = element.scrollLeft;

    if ((scrollLeft + clientWidth) >= scrollWidth) {
        console.log('结束滑动');
    }
    return scrollWidth <= clientWidth;
}

const debouncedCheckIfScrolledToEnd = debounce(checkIfScrolledToEnd, 20);

for (let index = 0; index < allpre_elements.length; index++) {
    const element = allpre_elements[index];

    if (checkIfScrolledToEnd(element)) {
        continue;
    }

    let startX;

    element.addEventListener('touchstart', function (event) {
        startX = event.touches[0].clientX;
        console.log("开始滑动");
    });

    element.addEventListener('touchmove', function (event) {
        const currentX = event.touches[0].clientX;
        const isScrollingHorizontally = Math.abs(currentX - startX) > 5; // 设置一个阈值来判断是否为水平滑动

        if (isScrollingHorizontally === false) {
            console.log("结束滑动（非水平滑动）");
        } else {
            debouncedCheckIfScrolledToEnd(element); // 触发防抖函数
        }
    });

    element.addEventListener('touchend', function (event) {
        console.log("结束滑动");
    });

    element.addEventListener('touchcancel', function (event) {
        console.log("结束滑动");
    });
}