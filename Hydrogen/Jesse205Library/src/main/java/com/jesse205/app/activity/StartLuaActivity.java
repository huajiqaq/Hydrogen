package com.jesse205.app.activity;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import com.androlua.LuaApplication;
import com.jesse205.superlua.LuaActivity;

public class StartLuaActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent=getIntent();

        LuaApplication application=(LuaApplication) getApplication();
        String name=intent.getStringExtra("name");
        if (name != null && name.indexOf("..") == -1) {
            String luaPath=application.getLocalDir() + "/sub/" + name + "/main.lua";
            intent.putExtra("luaPath", luaPath);
            intent.putExtra("checkUpdate", true);
            intent.setClass(this, LuaActivity.class);
            intent.setData(Uri.parse("file://" + luaPath + "?documentId=0"));
            startActivity(intent);
            finish();
        }

    }

}
