package com.jesse205.app;
import android.content.Context;
import android.content.res.Configuration;
import android.os.Build;
import android.view.Window;

public class ThemeUtil {
	static int SDK_INT=Build.VERSION.SDK_INT;

    public static boolean isSysNightMode(Context context) {
		return (context.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES;
	}
	
	public static boolean isGrayNavigationBarSystem() {
		if (SDK_INT == 24 || SDK_INT == 25) {
			try {
				Class.forName("androidhwext.R");
			} catch (ClassNotFoundException e) {
				return false;
			}
			return true;
		} else {
			return false;
		}
	}
	

}
