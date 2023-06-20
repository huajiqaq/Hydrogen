package com.jesse205.app.activity;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;
import android.widget.TextView;
import com.jesse205.superlua.LuaActivity;
import com.jesse205.util.StringUtil;

public class RunActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
		try {
			ApplicationInfo info = this.getPackageManager().getApplicationInfo(getPackageName(), PackageManager.GET_META_DATA);
			String keyMd5 = info.metaData.getString("AideLua_KEY_MD5");//获取正确的MD5
			Intent intent = getIntent();
			String key=intent.getStringExtra("key");//获取key，待会儿比对MD5
			if (key!=null && StringUtil.getMd5(key).equals(keyMd5)){//MD5相同，则允许运行文件
				Intent newIntent = new Intent(this,LuaActivity.class);
				newIntent.putExtra("arg",intent.getStringExtra("arg"));//参数
				newIntent.putExtra("name",intent.getStringExtra("name"));//名称
				newIntent.putExtra("luaPath",intent.getData().getPath());//运行对应文件
				newIntent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
				startActivity(newIntent);
				finish();
			}else{
				TextView textView=new TextView(this);
				setContentView(textView);
				textView.setText(String.format("key=%s, trueMd5=%s", key, keyMd5));//将文字显示在屏幕上，方便对比值
			}
		} catch (NameNotFoundException e) {
			e.printStackTrace();
			TextView textView=new TextView(this);
			setContentView(textView);
			textView.setText(e.toString());
		}
    }
	
}
