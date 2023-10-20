console.log("重新加载")
window.onload = function () {
    alert("常见问题在最右侧哦")

    //禁止缩放
    var metas = document.getElementsByTagName("meta");
    for (var i = 0; i < metas.length; i++) {
        if (metas[i].name == "viewport") {
            let content = metas[i].content
            if (content) {
                content = content + ",user-scalable=no"
            }
            else {
                content = "width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no"
            }
            metas[i].setAttribute("content", content);
            break;
        }
    }

    var style
    document.querySelector("header").style.display = "none"
    style = document.createElement('style');
    //全屏 去边距
    style.innerHTML += '.SettingsMain{width:100% !important; margin:unset}'
    style.innerHTML += '.SettingsMain-sideColumn{position:absolute !important;left:100% !important}'


    document.head.appendChild(style);

    //优化显示
    style = document.createElement('style');
    //绑定第三方账号 列表
    style.innerHTML = '.css-1alsiom{flex-wrap:wrap !important}'
    //绑定第三方账号 列表下元素
    style.innerHTML += '.css-60n72z{width:unset !important; flex:auto !important}'
    document.head.appendChild(style);

    //优化卡片显示
    style = document.createElement('style');
    style.innerHTML = '.Modal--large{width:unset !important}'
    style.innerHTML += '.Modal{width:unset !important; max-height:-webkit-fill-available !important}'
    style.innerHTML += '.Modal-closeButton{position:unset !important}'
    document.head.appendChild(style);


    //优化购买vip卡片显示
    style = document.createElement('style');
    //防止超出屏幕
    style.innerHTML = '.KfeCollection-PayModal-modal{width:100% !important}'
    //去除边距和边框
    style.innerHTML += '.KfeCollection-QrCodeCard{margin:unset !important; border:unset !important}'
    style.innerHTML += '.KfeCollection-QrCodeCard-qrCode{margin:unset !important; border:unset !important}'
    //防止超出屏幕
    style.innerHTML += '.KfeCollection-CouponCard{flex-wrap:wrap !important}'
    style.innerHTML += '.KfeCollection-CouponCard-selectInput-animation{min-width:unset !important}'
    style.innerHTML += '.KfeCollection-CouponCard-selectBox-animation{min-width:unset !important}'
    style.innerHTML += '.KfeCollection-AvatarCard-artwork{width:unset !important}'
    document.head.appendChild(style);


    style = document.createElement('style');
    //优化隐私卡片
    //防止超出屏幕
    style.innerHTML = '.css-p298d2{width:unset !important}'
    style.innerHTML += '.UserHeader-Info{flex-wrap:wrap !important}'
    //隐藏vip推荐卡片
    style.innerHTML += '.VipInterests{display:none !important}'
    //style.innerHTML += '.VipInterests{width:unset !important; height:unset !important}'
    //优化卡片贴纸按钮
    style.innerHTML += '.StickerSetBtn{flex-wrap:wrap !important}'
    style.innerHTML += '.StickerSetBtn-Left{width:unset !important; margin-right:unset !important}'
    //防止图片压缩
    style.innerHTML += 'img{min-width:unset !important}'
    //隐藏底部
    style.innerHTML += '#SettingsMain > div > div> footer{display:none !important}'
    document.head.appendChild(style);


    style = document.createElement('style');
    //优化左侧卡片
    style.innerHTML = '.SettingsNav-link{height:unset !important; padding-left:10px !important}'
    //优化左侧宽度
    style.innerHTML += '.SettingsNav{width:unset !important}'
    document.head.appendChild(style);


    //防止按钮放的波
    style = document.createElement('style');
    style.innerHTML = '.Modal{box-shadow:unset !important}'
    document.head.appendChild(style);


    //防止不占满全屏
    style = document.createElement('style');
    style.innerHTML = 'div.SettingsMain > div:first-child{min-height:100vh !important}'
    style.innerHTML += 'div.SettingsMain > div:first-child > div:first-child > div:first-child> div:nth-child(2){padding-bottom:unset !important}'
    document.head.appendChild(style);

    //屏蔽
    style = document.createElement('style');
    //去卡片边距
    style.innerHTML = '.css-188am9u{flex-wrap:wrap !important;}'
    style.innerHTML += '.UserPage-content{margin-left:unset !important; width:unset !important }'
    style.innerHTML += '.UserPageContent{width:unset !important }'
    style.innerHTML += '.UserPageContent .UserPageItem:nth-child(2n){margin-right:10px !important }'
    style.innerHTML += '.UserPageItem--withButton{width:unset !important }'
    style.innerHTML += '.Modal-content{max-width:100vw !important}'
    document.head.appendChild(style);
    
    //偏好设置 图片水印
    style = document.createElement('style');
    style.innerHTML = '.WatermarkPreferenceExamples-bg{display:none !important}'
    style.innerHTML += '.WatermarkPreferenceExamples{flex-wrap:wrap !important}'
    style.innerHTML += '.WatermarkPreferenceExamples-card{width:100% !important; background-color:#056DE8}'
    style.innerHTML += 'section.WatermarkPreferenceExamples > div{width:100% !important}'
    style.innerHTML += '.WatermarkPreferenceExamples{flex-wrap:wrap !important}'
    //优化文字高度
    style.innerHTML += '.SelectorField-title h4{height:unset !important}'
    document.head.appendChild(style);


    console.log("加载完成")
}  