package com.Jesse205.superlua;
//Jesse205独立开发的软件只会有用来加载数据和等待软件启动的启动图片，不会有启动广告。

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.KeyEvent;
import androidx.appcompat.app.AppCompatActivity;
import com.Jesse205.R;
import com.Jesse205.superlua.Welcome;
import com.androlua.LuaApplication;
import com.androlua.LuaUtil;
import java.io.File;
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.exception.ZipException;

public class Welcome extends AppCompatActivity {

    private LuaApplication app;
    private String luaMdDir;
    private String localDir;
    //private long mLastTime;
    //private long mOldLastTime;

    private PackageInfo packageInfo;
    private long lastTime;
    private String versionName;
    private SharedPreferences info;
    private String oldVersionName;
    private long oldLastTime;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        try {
            packageInfo = getPackageManager().getPackageInfo(this.getPackageName(), 0);
            lastTime = packageInfo.lastUpdateTime;//更新时间
            info = getSharedPreferences("appInfo", 0);
            oldLastTime = info.getLong("lastUpdateTime", 0);

            app = (LuaApplication) getApplication();

            if (oldLastTime != lastTime) {
                oldVersionName = info.getString("versionName", "");
                versionName = packageInfo.versionName;//版本名
                luaMdDir = app.getMdDir();
                localDir = app.getLocalDir();
                this.setContentView(R.layout.layout_jesse205_welcome);
                new UpdateTask().execute();
            } else {
                startActivity(false);
            }

        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

    }


    public void startActivity(Boolean isUpdata) {
        Intent intent=null;


        if (isUpdata) {//只有在更新资源时候或者程序启动才应该调用welcome
            Intent mIntent=getIntent();
            Bundle mBundle=mIntent.getExtras();
            if (mBundle != null) {
                intent = (Intent) mBundle.get("newIntent");
            }
            if (intent == null)
                intent = new Intent(Welcome.this, Main.class);
            intent.putExtra("isVersionChanged", true);
            intent.putExtra("newVersionName", versionName);
            intent.putExtra("oldVersionName", oldVersionName);
        } else {
            intent = new Intent(Welcome.this, Main.class);
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
        startActivity(intent);
        //overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out                                                                                                                 );
        finish();

    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        return true;
    }

    @SuppressLint("StaticFieldLeak")
    private class UpdateTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String[] p1) {
            // TODO: Implement this method
            try {
                unApk("assets/", localDir);
                unApk("lua/", luaMdDir);
                if (!versionName.equals(oldVersionName)) {
                    SharedPreferences.Editor edit = info.edit();
                    edit.putString("versionName", versionName);
                    edit.apply();
                }
                SharedPreferences.Editor edit = info.edit();
                edit.putLong("lastUpdateTime", lastTime);
                edit.apply();
            } catch (ZipException e) {
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(String result) {
            startActivity(true);
        }

        private void unApk(String dir, String extDir) throws ZipException {
            File file=new File(extDir);
            String tempDir=getCacheDir().getPath();
            LuaUtil.rmDir(file);
            ZipFile zipFile = new ZipFile(getApplicationInfo().publicSourceDir);
            zipFile.extractFile(dir, tempDir);
            new File(tempDir + "/" + dir).renameTo(file);
        }

    }
}
