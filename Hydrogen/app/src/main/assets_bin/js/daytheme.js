; (function () {
    'use strict';

    let util = {

        addStyle(id, tag, css) {
            tag = tag || 'style';
            let doc = document, styleDom = doc.getElementById(id);
            if (styleDom) return;
            let style = doc.createElement(tag);
            style.rel = 'stylesheet';
            style.id = id;
            tag === 'style' ? style.innerHTML = css : style.href = css;
            doc.head.appendChild(style);
        },

        hover(ele, fn1, fn2) {
            ele.onmouseenter = function () {  //移入事件
                fn1.call(ele);
            };
            ele.onmouseleave = function () { //移出事件
                fn2.call(ele);
            };
        },

        addThemeColor(color) {
            let doc = document, meta = doc.getElementsByName('theme-color')[0];
            if (meta) return meta.setAttribute('content', color);
            let metaEle = doc.createElement('meta');
            metaEle.name = 'theme-color';
            metaEle.content = color;
            doc.head.appendChild(metaEle);
        },

        getThemeColor() {
            let meta = document.getElementsByName('theme-color')[0];
            if (meta) {
                return meta.content;
            }
            return '#ffffff';
        },

        removeElementById(eleId) {
            let ele = document.getElementById(eleId);
            ele && ele.parentNode.removeChild(ele);
        },

        hasElementById(eleId) {
            return document.getElementById(eleId);
        },

        filter: '-webkit-filter: url(#dark-mode-filter) !important; filter: url(#dark-mode-filter) !important;',
        reverseFilter: '-webkit-filter: url(#dark-mode-reverse-filter) !important; filter: url(#dark-mode-reverse-filter) !important;',
        firefoxReverseFilter: `filter: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg"><filter id="dark-mode-reverse-filter" color-interpolation-filters="sRGB"><feColorMatrix type="matrix" values="0.333 -0.667 -0.667 0 1 -0.667 0.333 -0.667 0 1 -0.667 -0.667 0.333 0 1 0 0 0 1 0"/></filter></svg>#dark-mode-reverse-filter') !important;`,
    };

    let main = {

        addExtraStyle() {
            try {
                return darkModeRule;
            } catch (e) {
                return '';
            }
        },



        createDayStyle() {
            util.addStyle('day-style', 'style', `
                @media screen {
                    img, 
                    .sr-backdrop {
                        ${this.isFirefox() ? util.firefoxReverseFilter : util.reverseFilter}
                    }                                                   
                }
            `);
        },


        isFirefox() {
            return /Firefox/i.test(navigator.userAgent);
        },


        init() {
            this.createDayStyle();
        }
    };
    main.init();
})();