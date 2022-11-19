package com.Jesse205.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View.MeasureSpec;
import android.widget.RelativeLayout;

public class SquareLayout extends RelativeLayout {
    protected void onMeasure(int i, int i2) {
        setMeasuredDimension(getDefaultSize(0, i), getDefaultSize(0, i2));
        int measuredWidth = getMeasuredWidth();
        getMeasuredHeight();
        measuredWidth = MeasureSpec.makeMeasureSpec(measuredWidth, 1073741824);
        super.onMeasure(measuredWidth, measuredWidth);
    }

    public SquareLayout(Context context) {
        super(context);
    }
}
