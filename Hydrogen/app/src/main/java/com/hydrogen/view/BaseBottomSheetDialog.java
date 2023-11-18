package com.hydrogen.view;

import com.google.android.material.bottomsheet.BottomSheetDialog;

import android.content.Context;
import androidx.annotation.NonNull;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import android.os.Bundle;
import android.view.ViewGroup;

 
public class BaseBottomSheetDialog extends BottomSheetDialog {

    public BaseBottomSheetDialog(@NonNull Context context) {
        super(context);
    }
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        BottomSheetBehavior behavior = getBehavior();
		//设置最大宽度
		behavior.setMaxWidth(ViewGroup.LayoutParams.MATCH_PARENT);
		//设置最大高度
		behavior.setMaxHeight(ViewGroup.LayoutParams.MATCH_PARENT);
    }

    @Override
    protected void onStart() {
        super.onStart();
        // for landscape mode
        BottomSheetBehavior behavior = getBehavior();
        behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
    }
}
