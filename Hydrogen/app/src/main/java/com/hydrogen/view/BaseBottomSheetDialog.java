package com.hydrogen.view;

import com.google.android.material.bottomsheet.BottomSheetDialog;

import android.content.Context;
import androidx.annotation.NonNull;
import android.os.Bundle;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import android.content.res.Configuration;

 
public class BaseBottomSheetDialog extends BottomSheetDialog {

    public BaseBottomSheetDialog(@NonNull Context context) {
        super(context);
    }
	
    @Override
    protected void onStart() {
        super.onStart();
        BottomSheetBehavior behavior = getBehavior();
        behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
    }
}
