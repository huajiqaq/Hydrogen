local base = {
  isCached=false,
}
function base:getZemoji()

  if !self.isCached then
    if File(activity.getExternalCacheDir().getPath().."/zemoji/doge.png").exists() then
     else
      pcall(function()LuaUtil.unZip(srcLuaDir.."/res/zemoji.zip",activity.getExternalCacheDir().getPath())end,function()提示("ZEMOJI解压失败")end)
    end

    zemoji = {
      握手 = [[https://pic2.zhimg.com/v2-f5aa165e86b5c9ed3b7bee821da59365.png]];
      打招呼 = [[https://picx.zhimg.com/v2-95c560d0c9c0491f6ef404cc010878fc.png]];
      哇 = [[https://picx.zhimg.com/v2-6a766571a6d6d3a4d8d16f433e5b284c.png]];
      感谢 = [[https://pic1.zhimg.com/v2-694cac2ec9f3c63f774e723f77d8c840.png]];
      知乎益蜂 = [[https://pica.zhimg.com/v2-11d9b8b6edaae71e992f95007c777446.png]];
      百分百赞 = [[https://picx.zhimg.com/v2-27521d5ba23dfc1ea58fd9ebb220e304.png]];
      为爱发乎 = [[https://pic1.zhimg.com/v2-609b1f168acfa22d59fa09d3cb0846ee.png]];
      脑爆 = [[https://pica.zhimg.com/v2-b6f53e9726998343e7713f564a422575.png]];
      暗中学习 = [[https://pica.zhimg.com/v2-5dc88b4f8cbc58d7597e2134a384e392.png]];
      匿了 = [[https://pic1.zhimg.com/v2-c1e799b8357888525ec45793e8270306.png]];
      谢邀 = [[https://pic2.zhimg.com/v2-6fe2283baa639ae1d7c024487f1d68c7.png]];
      赞同 = [[https://pic2.zhimg.com/v2-419a1a3ed02b7cfadc20af558aabc897.png]];
      蹲 = [[https://pic4.zhimg.com/v2-66e5de3da039ac969d3b9d4dc5ef3536.png]];
      爱 = [[https://pic1.zhimg.com/v2-0942128ebfe78f000e84339fbb745611.png]];
      害羞 = [[https://pic4.zhimg.com/v2-52f8c87376792e927b6cf0896b726f06.png]];
      好奇 = [[https://pic2.zhimg.com/v2-72b9696632f66e05faaca12f1f1e614b.png]];
      思考 = [[https://pic4.zhimg.com/v2-bffb2bf11422c5ef7d8949788114c2ab.png]];
      酷 = [[https://pic4.zhimg.com/v2-c96dd18b15beb196b2daba95d26d9b1c.png]];
      大笑 = [[https://pic1.zhimg.com/v2-3ac403672728e5e91f5b2d3c095e415a.png]];
      微笑 = [[https://pic1.zhimg.com/v2-3700cc07f14a49c6db94a82e989d4548.png]];
      捂脸 = [[https://pic1.zhimg.com/v2-b62e608e405aeb33cd52830218f561ea.png]];
      捂嘴 = [[https://pic4.zhimg.com/v2-0e26b4bbbd86a0b74543d7898fab9f6a.png]];
      飙泪笑 = [[https://pic4.zhimg.com/v2-3bb879be3497db9051c1953cdf98def6.png]];
      耶 = [[https://pic2.zhimg.com/v2-f3b3b8756af8b42bd3cb534cbfdbe741.png]];
      可怜 = [[https://pic1.zhimg.com/v2-aa15ce4a2bfe1ca54c8bb6cc3ea6627b.png]];
      惊喜 = [[https://pic2.zhimg.com/v2-3846906ea3ded1fabbf1a98c891527fb.png]];
      流泪 = [[https://pic4.zhimg.com/v2-dd613c7c81599bcc3085fc855c752950.png]];
      大哭 = [[https://pic1.zhimg.com/v2-41f74f3795489083630fa29fde6c1c4d.png]];
      生气 = [[https://pic4.zhimg.com/v2-6a976b21fd50b9535ab3e5b17c17adc7.png]];
      惊讶 = [[https://pic4.zhimg.com/v2-0d9811a7961c96d84ee6946692a37469.png]];
      调皮 = [[https://pic1.zhimg.com/v2-76c864a7fd5ddc110965657078812811.png]];
      衰 = [[https://pic1.zhimg.com/v2-d6d4d1689c2ce59e710aa40ab81c8f10.png]];
      发呆 = [[https://pic2.zhimg.com/v2-7f09d05d34f03eab99e820014c393070.png]];
      机智 = [[https://pic1.zhimg.com/v2-4e025a75f219cf79f6d1fda7726e297f.png]];
      嘘 = [[https://pic4.zhimg.com/v2-f80e1dc872d68d4f0b9ac76e8525d402.png]];
      尴尬 = [[https://pic3.zhimg.com/v2-b779f7eb3eac05cce39cc33e12774890.png]];
      小情绪 = [[https://pic3.zhimg.com/v2-b779f7eb3eac05cce39cc33e12774890.png]];
      为难 = [[https://pic1.zhimg.com/v2-132ab52908934f6c3cd9166e51b99f47.png]];
      吃瓜 = [[https://pic4.zhimg.com/v2-74ecc4b114fce67b6b42b7f602c3b1d6.png]];
      语塞 = [[https://pic2.zhimg.com/v2-58e3ec448b58054fde642914ebb850f9.png]];
      看看你 = [[https://pic3.zhimg.com/v2-4e4870fc6e57bb76e7e5924375cb20b6.png]];
      撇嘴 = [[https://pic2.zhimg.com/v2-1043b00a7b5776e2e6e1b0af2ab7445d.png]];
      魔性笑 = [[https://pic2.zhimg.com/v2-e6270881e74c90fc01994e8cd072bd3a.png]];
      潜水 = [[https://pic1.zhimg.com/v2-99bb6a605b136b95e442f5b69efa2ccc.png]];
      口罩 = [[https://pic4.zhimg.com/v2-6551348276afd1eaf836551b93a94636.png]];
      开心 = [[https://pic2.zhimg.com/v2-c99cdc3629ff004f83ff44a952e5b716.png]];
      滑稽 = [[https://pic4.zhimg.com/v2-8a8f1403a93ddd0a458bed730bebe19b.png]];
      笑哭 = [[https://pic4.zhimg.com/v2-ca0015e8ed8462cfce839fba518df585.png]];
      白眼 = [[https://pic2.zhimg.com/v2-d4f78d92922632516769d3f2ce055324.png]];
      红心 = [[https://pic2.zhimg.com/v2-9ab384e3947547851cb45765e6fc1ea8.png]];
      柠檬 = [[https://pic4.zhimg.com/v2-a8f46a21217d58d2b4cdabc4568fde15.png]];
      拜托 = [[https://pic2.zhimg.com/v2-3e36d546a9454c8964fbc218f0db1ff8.png]];
      握手 = [[https://pic2.zhimg.com/v2-f5aa165e86b5c9ed3b7bee821da59365.png]];
      赞 = [[https://pic1.zhimg.com/v2-c71427010ca7866f9b08c37ec20672e0.png]];
      发火 = [[https://pic1.zhimg.com/v2-d5c0ed511a09bf5ceb633387178e0d30.png]];
      不抬杠 = [[https://pic4.zhimg.com/v2-395d272d5635143119b1dbc0b51e05e4.png]];
      种草 = [[https://pic2.zhimg.com/v2-cb191a92f1296e33308b2aa16f61bfb9.png]];
      抱抱 = [[https://pic2.zhimg.com/v2-b2e3fa9e0b6f431bd18d4a9d5d3c6596.png]];
      doge = [[https://pic4.zhimg.com/v2-501ff2e1fb7cf3f9326ec5348dc8d84f.png]];
    }
    for i,url in pairs(zemoji) do
      local drawable = getImageDrawable(表情(i))
      -- 设置Drawable的图片的高度和宽度。 后面注释是获取设置图片原来的高度和宽度
      zemoji[i]= drawable.setBounds(0, 0, sp2px(20), sp2px(20))--drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight())
    end
    self.zemoji=zemoji
    self.isCached=true

  end
  return self
end

return base