package com.jesse205.widget;

import android.content.Context;
import android.widget.RelativeLayout;

public class SquareLayout extends RelativeLayout {
    protected void onMeasure(int i, int i2) {
        setMeasuredDimension(getDefaultSize(0, i), getDefaultSize(0, i2));
        int measuredWidth = getMeasuredWidth();
        getMeasuredHeight();
        measuredWidth = MeasureSpec.makeMeasureSpec(measuredWidth, MeasureSpec.EXACTLY);
        //noinspection SuspiciousNameCombination
        super.onMeasure(measuredWidth, measuredWidth);
    }

    public SquareLayout(Context context) {
        super(context);
    }
}
