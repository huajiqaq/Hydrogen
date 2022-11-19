package com.Jesse205.superlua;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import com.androlua.LuaApplication;


public class Main extends LuaActivity
{
    String luaDir;
    LuaApplication app;
    
	@Override
	public void onCreate(Bundle savedInstanceState) {
		app = (LuaApplication) getApplication();
        luaDir=app.getLocalDir() + "/main.lua";
        Intent intent = getIntent();
        intent.setData(Uri.parse("file://" + luaDir));
        setCheckUpdate(true);
		super.onCreate(savedInstanceState);
		if(getIntent().getBooleanExtra("isVersionChanged",false) && (savedInstanceState==null)){
			onVersionChanged(getIntent().getStringExtra("newVersionName"),getIntent().getStringExtra("oldVersionName"));
		}
	}

	@Override
	protected void onNewIntent(Intent intent)
	{
		// TODO: Implement this method
		runFunc("onNewIntent", intent);
		super.onNewIntent(intent);
	}
    
	private void onVersionChanged(String newVersionName, String oldVersionName) {
		// TODO: Implement this method
		runFunc("onVersionChanged", newVersionName, oldVersionName);

	}



}
