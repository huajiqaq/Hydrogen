package com.hydrogen.view;

import android.view.View.MeasureSpec;
import com.androlua.LuaActivity;
import com.androlua.LuaWebView;

public class NoScrollLuaWebView extends LuaWebView {
   public NoScrollLuaWebView(LuaActivity context) {
      super(context);
   }

   @Override
   protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
      int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST);
      super.onMeasure(widthMeasureSpec, expandSpec);
   }
}
