const allpre_elements = document.querySelectorAll(".ztext pre");

document.querySelectorAll(".highlight").forEach(element => {
    element.style.touchAction = "none";
    element.style.overflow = "hidden";
});

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
    //禁止默认滑动操作
    element.style.touchAction = "none";

    if (checkIfScrolledToEnd(element)) {
        continue;
    }

    let startX;
    let isScrollingHorizontally;
    let initialScrollLeft;

    element.addEventListener('touchstart', function (event) {
        startX = event.touches[0].clientX;
        initialScrollLeft = element.scrollLeft;
        console.log("开始滑动");
    });

    element.addEventListener('touchmove', function (event) {

        const currentX = event.touches[0].clientX;
        isScrollingHorizontally = Math.abs(currentX - startX) > 4; // 设置一个阈值来判断是否为水平滑动

        if (isScrollingHorizontally === false) {
            console.log("结束滑动（非水平滑动）");
        } else {
            const diffX = startX - currentX;
            element.scrollLeft = initialScrollLeft + diffX;
        }
    });

    element.addEventListener('touchend', function (event) {
        isScrollingHorizontally = false;
        console.log("结束滑动");
        return true
    });

    element.addEventListener('touchcancel', function (event) {
        isScrollingHorizontally = false;
        console.log("结束滑动");
        return true
    });
}