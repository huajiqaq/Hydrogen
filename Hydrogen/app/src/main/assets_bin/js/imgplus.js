function debounce(func, wait) {
    let timeout;
    return function(...args) {
        const context = this;
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(context, args), wait);
    };
}

function addStyle(css) {
    const style = document.createElement('style');
    style.type = 'text/css';
    if (style.styleSheet) {
        style.styleSheet.cssText = css; // For IE
    } else {
        style.appendChild(document.createTextNode(css));
    }
    document.head.appendChild(style);
    return style;
}

function removeStyle(style) {
    if (style && style.parentNode) {
        style.parentNode.removeChild(style);
    }
}

function createImageStyleManager() {
    let styleElement = null;

    function updateImageStyles(isLandscape) {
        const landscapeCSS = `
            img {
                max-height: 100vmin !important;
                width: auto !important;
            }
        `;

        if (isLandscape) {
            if (!styleElement) {
                styleElement = addStyle(landscapeCSS);
            }
        } else {
            if (styleElement) {
                removeStyle(styleElement);
                styleElement = null;
            }
        }
    }

    function onOrientationChange() {
        const isLandscape = window.matchMedia("(orientation: landscape)").matches;
        console.log(isLandscape)
        updateImageStyles(isLandscape);
    }

    // 使用防抖函数包装 onOrientationChange
    const debouncedOnOrientationChange = debounce(onOrientationChange, 50);

    // 监听设备方向变化
    window.addEventListener('orientationchange', debouncedOnOrientationChange);

    // 页面加载时也检查一次
    onOrientationChange();

    return {
        updateImageStyles: updateImageStyles
    };
}

const imageStyleManager = createImageStyleManager();