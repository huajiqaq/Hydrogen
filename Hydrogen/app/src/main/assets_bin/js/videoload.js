function setvideo() {
    if (document.getElementsByClassName("video-box").length > 0 && typeof (document.getElementsByClassName("video-box")[0].href) != "undefined") {
        for (i = 0; i < document.getElementsByClassName("video-box").length; i++) {
            (function (i) {
                var k = decodeURIComponent(document.getElementsByClassName("video-box")[i].href).match(/\/video\/(\S*)/)[1]
                var xhr = new XMLHttpRequest();
                var url = "https://lens.zhihu.com/api/v4/videos/" + k;
                xhr.open("get", url);
                xhr.onreadystatechange = function () {
                    if (xhr.readyState == 4) {
                        if (xhr.status == 200) {
                            videohtml = xhr.responseText
                            var getvideourlhtml = JSON.parse(videohtml);
                            try {
                                videourl = getvideourlhtml.playlist.SD.play_url
                            } catch (err) {				//抓住throw抛出的错误
                                if (getvideourlhtml.playlist.LD.play_url) {
                                    videourl = getvideourlhtml.playlist.LD.play_url
                                } else if (getvideourlhtml.playlist.HD.play_url) {
                                    videourl = getvideourlhtml.playlist.HD.play_url
                                }
                            }

                            document.getElementsByClassName("video-box")[i].outerHTML = '<div class="video-box"><video src=' + videourl + ' style="margin: auto;width: 100%;" controls=""></video></div>'
                        } else {
                        }
                    }
                };
                xhr.send(null);
            })(i);
        }
    }
}
waitForKeyElements(' [class="video-box"]', setvideo);