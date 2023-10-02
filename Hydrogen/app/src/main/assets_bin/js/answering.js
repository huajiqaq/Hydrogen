console.log("重新加载")
window.onload = function () {
  var style
  //去除顶栏知乎图标
  document.querySelector(".css-1g2nzan").childNodes[0].style.display = "none"
  //去除顶栏间隔
  document.querySelector(".css-1g2nzan").childNodes[1].style.display = "none"
  //防止编辑框宽度超过屏幕宽度
  document.querySelector(".css-arjme8").style.width = "unset"
  document.querySelector(".css-3uhrzt").style.display = "none"
  //防止顶栏宽度超过屏幕宽度
  document.querySelector(".css-1g2nzan").style.width = "unset"
  document.querySelector(".css-1g2nzan").style.padding = "unset"
  //去除图文回答与发布设置的间隔
  document.querySelector(".css-29tdoj").style.minHeight = "unset"


  //防止选择框宽度超过屏幕宽度
  style = document.createElement('style');
  style.innerHTML = '.Select-button{width:unset !important}'
  document.head.appendChild(style);

  //防止选择框高度不是一行
  style = document.createElement('style');
  style.innerHTML = '.css-1pfsia3{padding-right:unset !important}'
  document.head.appendChild(style);

  //优化卡片显示
  style = document.createElement('style');
  style.innerHTML = '.Modal--large{width:unset !important}'
  style.innerHTML += '.Modal{width:unset !important; max-height:-webkit-fill-available !important}'
  style.innerHTML += '.Modal-closeButton{position:unset !important}'
  document.head.appendChild(style);
  //占满宽度
  style = document.createElement('style');
  style.innerHTML = '.Modal--fullPage{width:100% !important}'
  document.head.appendChild(style);
  //优化历史显示
  style = document.createElement('style');
  style.innerHTML = '.DraftHistory-version{height:unset !important}'
  style.innerHTML += '.DraftHistory-main{flex:unset !important}'
  document.head.appendChild(style);

  //防止图片压缩
  style = document.createElement('style');
  style.innerHTML = 'img{max-width:unset !important}'
  document.head.appendChild(style);

  //防止图片栏压缩
  style = document.createElement('style');
  style.innerHTML = '.css-rj2dwy{display:block !important}'
  style.innerHTML += '.css-4cffwv{display:block !important}'
  style.innerHTML += '.css-zelv4t{min-width:unset !important}'
  style.innerHTML += '.css-ec1dnj{line-height:unset !important}'
  style.innerHTML += '.css-zzm66r{line-height:unset !important}'
  style.innerHTML += '.MaterialLibraryNav{width:unset !important}'
  document.head.appendChild(style);

  //导入视频页面防压缩
  style = document.createElement('style');
  style.innerHTML = '.css-10rx4cn{width:unset !important}'
  document.head.appendChild(style);

  //优化
  style = document.createElement('style');
  //防止有空隙
  style.innerHTML = 'div[role="listitem"]:empty{display: none; !important}'
  //防止上传视频页面的按钮显示不全
  style.innerHTML += '.css-jajnrr{width:unset !important}'
  //下方功能 防止内容超过屏幕
  style.innerHTML += '.css-1p9otau{padding-left:unset !important}'
  //图片个人素材按钮宽高
  style.innerHTML += '.css-1c5mg10{width:unset !important}'
  style.innerHTML += '.css-1c5mg10{height:unset !important}'
  document.head.appendChild(style);

  //防止按钮放的波
  style = document.createElement('style');
  style.innerHTML = '.Modal{box-shadow:unset !important}'
  document.head.appendChild(style);


  //点击问题详情的提示
  document.querySelectorAll(".css-gn5yqd")[0].addEventListener('click', function () {
    alert('右滑查看问题详情 关闭请右滑点击右边内容"X"手动关闭')
  })

  // 附件的对话框优化
  const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      //console.log(mutation)
      // 判断是否为div元素创建
      if (mutation.type === 'childList') {
        // 遍历所有iframe元素，获取其contentWindow
        mutation.addedNodes.forEach((addedNode) => {
          let childNodes_count = addedNode.childNodes.length
          if (childNodes_count > 0) {
            const iframe = addedNode.querySelector('iframe');
            if (iframe) {
              iframe.onload = function () {
                const contentWindow = iframe.contentWindow;
                let document = contentWindow.document;
                console.log(document)
                //附件卡片
                style = document.createElement('style');
                style.innerHTML = '.Modal{width:100% !important}'
                document.head.appendChild(style);
              }
            }
          }
        });
      }
    });
  });

  // 配置观察选项
  const config = { childList: true, subtree: true };
  // 开始监听document根节点及其子节点的变化
  observer.observe(document.body, config);

  console.log("加载完成")

}