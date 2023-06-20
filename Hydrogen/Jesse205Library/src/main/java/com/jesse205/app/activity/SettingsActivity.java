package com.jesse205.app.activity;

import android.os.Bundle;

public class SettingsActivity extends com.jesse205.superlua.LuaActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
	    setCheckUpdate(true);
		super.onCreate(savedInstanceState);
    }

	@Override
	public String getLuaPath() {
		String path;
		if (updating) {
			path = "/";
		} else {
			// path = getLocalDir() + "/sub/Settings/main.lua";
			path = getLocalDir() + "/settings.lua";		
		}
		applyLuaDir(path);
		return path;
	}
}
