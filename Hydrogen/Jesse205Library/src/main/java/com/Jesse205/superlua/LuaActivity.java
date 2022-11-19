package com.Jesse205.superlua;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.view.ContextMenu;
import android.view.View;
import java.io.File;

public class LuaActivity extends com.androlua.LuaActivity {
    private long oldLastTime=0;
    private long lastTime=0;
    private boolean checkUpdate=false;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        if (checkUpdate) {
            try {
                PackageInfo packageInfo = getPackageManager().getPackageInfo(this.getPackageName(), 0);
                lastTime = packageInfo.lastUpdateTime;//更新时间
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
            SharedPreferences info = getSharedPreferences("appInfo", 0);
            oldLastTime = info.getLong("lastUpdateTime", 0);
            if (oldLastTime != lastTime){
                Intent intent = getIntent();
                intent.setData(Uri.parse("file:///"));
                setDebug(false);
            }
                //setDebug(false);
        }
        

        super.onCreate(savedInstanceState);

        if (checkUpdate && (oldLastTime != lastTime)) {
            Intent intent = new Intent(this, Welcome.class);
            intent.putExtra("newIntent", getIntent());
            intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
            startActivity(intent);
            finish();
        }

    }

    public void setCheckUpdate(boolean state) {
        checkUpdate = state;
    }


    @Override
    public void onSaveInstanceState(Bundle outState) {
        // TODO: Implement this method
        super.onSaveInstanceState(outState);
        runFunc("onSaveInstanceState", outState);
    }

    @Override
    public void onRestoreInstanceState(Bundle savedInstanceState) {
        // TODO: Implement this method
        super.onRestoreInstanceState(savedInstanceState);
        runFunc("onRestoreInstanceState", savedInstanceState);
    }

    @Override
    public void onCreateContextMenu(ContextMenu menu, View view, ContextMenu.ContextMenuInfo menuInfo) {
        // TODO: Implement this method
        super.onCreateContextMenu(menu, view, menuInfo);
        runFunc("onCreateContextMenu", menu, view, menuInfo);
    }
    
    public void newActivity(String path, boolean newDocument,int documentId) {
        newActivity(1, path, null, newDocument, documentId);
    }

    public void newActivity(String path, Object[] arg, boolean newDocument,int documentId) {
        newActivity(1, path, arg, newDocument, documentId);
    }
    
    @Override
    public void newActivity(int req, String path, Object[] arg, boolean newDocument) {
        newActivity(req, path, arg, newDocument, 0);
    }

    public void newActivity(int req, String path, Object[] arg, boolean newDocument, int documentId) {
        Intent intent = new Intent(this, LuaActivity.class);
        /*if (newDocument)
         intent = new Intent(this, LuaActivityX.class);*/

        intent.putExtra("name", path);
        if (path.charAt(0) != '/')//如果不是/开头，说明是相对路径
            path = this.getLuaDir() + "/" + path;
        File file = new File(path);
        if (file.isDirectory() && new File(path + "/main.lua").exists())
            path += "/main.lua";
        else if (!file.isDirectory() && !path.endsWith(".lua"))
            path += ".lua";
        intent.setData(Uri.parse("file://" + path + "?documentId=" + String.valueOf(documentId)));


        if (arg != null) 
            intent.putExtra("arg", arg);

        if (newDocument) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_DOCUMENT);
            //intent.addFlags(Intent.FLAG_ACTIVITY_MULTIPLE_TASK);
            startActivity(intent);
        } else
            startActivityForResult(intent, req);
    }


    @Override
    public void newActivity(int req, String path, int in, int out, Object[] arg, boolean newDocument) {
        newActivity(req, path, in, out, arg, newDocument, 0);
    }

    public void newActivity(int req, String path, int in, int out, Object[] arg, boolean newDocument, int documentId) {
        newActivity(req, path, arg, newDocument, documentId);
        overridePendingTransition(in, out);
    }

}
