const allpre_elements = document.querySelectorAll(".ztext pre");

function checkIfScrolledToEnd(element) {
    const scrollWidth = element.scrollWidth;
    const clientWidth = element.clientWidth;
    const scrollLeft = element.scrollLeft;

    if ((scrollLeft + clientWidth) >= scrollWidth) {
        console.log('已滑动至底部');
        return true;
    }
    return false;
}

for (let index = 0; index < allpre_elements.length; index++) {
    const element = allpre_elements[index];

    if (checkIfScrolledToEnd(element)) {
        continue;
    }

    let startX;
    let isScrollingHorizontally = false;
    let initialScrollLeft = element.scrollLeft;
    let lastTimestamp;

    function step(currentX, timestamp) {
        if (!lastTimestamp) {
            lastTimestamp = timestamp;
        }

        const diffX = startX - currentX;
        const timeDelta = timestamp - lastTimestamp;
        const scrollSpeed = diffX / timeDelta; // 计算单位时间内滚动的速度

        element.scrollLeft = initialScrollLeft + diffX;

        if (isScrollingHorizontally && !checkIfScrolledToEnd(element)) {
            window.requestAnimationFrame((timestamp) => step(event.touches[0].clientX, timestamp));
        }
    }

    element.addEventListener('touchstart', function (event) {
        startX = event.touches[0].clientX;
        initialScrollLeft = element.scrollLeft;
        lastTimestamp = null;
        console.log("开始滑动");
        element.focus();
    });

    element.addEventListener('touchmove', function (event) {
        const currentX = event.touches[0].clientX;
        isScrollingHorizontally = Math.abs(currentX - startX) > 5; // 设置一个阈值来判断是否为水平滑动

        if (isScrollingHorizontally === false) {
            console.log("结束滑动（非水平滑动）");
        } else {
            event.preventDefault(); // 阻止默认的滚动行为
            window.requestAnimationFrame((timestamp) => step(currentX, timestamp));
        }
    });

    element.addEventListener('touchend', function (event) {
        isScrollingHorizontally = false;
        
        console.log("结束滑动");
    });

    element.addEventListener('touchcancel', function (event) {
        isScrollingHorizontally = false;
        console.log("结束滑动");
    });
}