function sendZhihuWebAppCustomRequest(callbackData) {
    // 检查window.zhihuWebApp是否存在并调用callback方法
    if (window.zhihuWebApp && typeof window.zhihuWebApp.callback === 'function') {
        // 必须设置延迟 否则无效果
        setTimeout(function () {
            window.zhihuWebApp.callback(callbackData);
        }, 1);
    } else {
        console.error('Zhihu Web App API is not available.');
    }
}

function constructCallback(data) {
    // 构造新的params.values数组
    const values = data.params.paramKeys.map(key => ({ paramKey: key, value: "0" }));

    // 构建新的callback对象
    const callbackData = {
        id: data.callbackID,
        type: "success",
        params: {
            values: values
        }
    };

    sendZhihuWebAppCustomRequest(callbackData)

}

function notifySupportStatus(data) {
    const action = data.params.action
    const keywords = ['showAlert'];
    let isSupported = false
    if (keywords.some(keyword => action.includes(keyword))) {
        isSupported = true
    } else if (action == "handleAuthRequiredAction") {
        alert("执行操作失败 请检查是否处于登录状态 如果处于登录状态请尝试重新登录后执行该操作")
    }
    const callbackData = {
        id: data.callbackID,
        type: "success",
        params: { "isSupported": isSupported }
    };

    sendZhihuWebAppCustomRequest(callbackData)
}

function showConfirm(data) {
    const result = confirm(data.params.content);

    let callbackType = result ? "AFFIRM" : "DISMISS";
    const callbackData = {
        id: data.callbackID,
        type: "success",
        params: { "result": callbackType }
    };

    sendZhihuWebAppCustomRequest(callbackData)

}

function triggerZhihuWebAppSuccessCallback(data) {
    const callbackData = {
        id: data.callbackID,
        type: "success"
    };
    sendZhihuWebAppCustomRequest(callbackData)
}

// App段获取网页传入的分享类型
function setShareInfo(data) {
    // 不准备支持 或许后期会加上
    const values = Object.keys(data.params).map(key => (key));
    const callbackData = {
        id: data.callbackID,
        type: "success",
        params: {
            successType: values
        }
    };
    sendZhihuWebAppCustomRequest(callbackData)
}

// 网页段获取支持的分享类型
function checkSupportedShareType(data) {
    // 不准备支持 或许后期会加上
    const callbackData = {
        id: data.callbackID,
        type: "success",
        params: {
            QQ: false,
            Qzone: false,
            weibo: false,
            wechat: false
        }
    }
    sendZhihuWebAppCustomRequest(callbackData)
}

// 网页段分享按钮点击 例如 https://www.zhihu.com/appview/picture-share/p/698376677
function shareLongImage(data) {
    // 不准备支持 或许后期会加上
    alert("Hydrogen 暂不支持图片分享")
    triggerZhihuWebAppSuccessCallback(data)
}

// 网页端收藏 打印即可 App段接受打印数值
function showCollectionPanel(data) {
    console.log("收藏分割" + data.callbackID)
}


// 创建Proxy来代理zhihuNativeApp对象
window.zhihuNativeApp = new Proxy({}, {
    get(target, prop, receiver) {

        if (prop === 'sendToNative') {
            return function (arg) {

                const keywords = ['log', 'setAssetStatus'];
                const argObj = JSON.parse(arg)
                const action = argObj.action

                if (keywords.some(keyword => arg.includes(keyword))) {
                    return false
                }

                console.log("sendToNative被触发");
                console.log(argObj);

                const actionHandlers = {
                    "getZLabAbValues": constructCallback,
                    "supportAction": notifySupportStatus,
                    "showAlert": showConfirm,
                    // eslint-disable-next-line no-return-assign
                    "openURL": data => window.location.href = data.params.url,
                    "setShareInfo": setShareInfo,
                    "checkSupportedShareType": checkSupportedShareType,
                    "shareLongImage": shareLongImage,
                    "showCollectionPanel": showCollectionPanel,
                    // 暂不支持的操作
                    "showShareActionSheet": () => alert("Hydrogen 暂不支持在网页内分享"),
                    "closeCurrentPage": () => alert("Hydrogen 暂不支持在网页内返回"),
                    "askQuestion":  () => alert("Hydrogen 暂不支持在网页内提问"),
                    "writeAnswer": () => alert("Hydrogen 暂不支持在网页内回答"),
                };

                const handler = actionHandlers[action];
                if (typeof handler === 'function') {
                    handler(argObj);
                } else {
                    triggerZhihuWebAppSuccessCallback(argObj)
                }

            }
        }

        return function (...args) {
            console.log(prop + "被触发", args)
        }

    },
});