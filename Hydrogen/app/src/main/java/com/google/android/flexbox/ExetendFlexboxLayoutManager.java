package com.google.android.flexbox;

import android.content.Context;
import android.view.ViewGroup;
import androidx.recyclerview.widget.RecyclerView;
import com.google.android.flexbox.FlexboxLayoutManager;
import android.util.AttributeSet;

public class ExetendFlexboxLayoutManager extends FlexboxLayoutManager {
    public ExetendFlexboxLayoutManager(Context context) {
        super(context);
    }

    public ExetendFlexboxLayoutManager(Context context, int flexDirection) {
        super(context, flexDirection);
    }

    public ExetendFlexboxLayoutManager(Context context, int flexDirection, int flexWrap) {
        super(context, flexDirection, flexWrap);
    }

    public ExetendFlexboxLayoutManager(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }

	@Override
    public RecyclerView.LayoutParams generateLayoutParams(ViewGroup.LayoutParams layoutParams) {
        FlexboxLayoutManager.LayoutParams layoutParams2;
        if (layoutParams instanceof RecyclerView.LayoutParams) {
            layoutParams2 = new FlexboxLayoutManager.LayoutParams((RecyclerView.LayoutParams) layoutParams);
        } else if (layoutParams instanceof ViewGroup.MarginLayoutParams) {
            layoutParams2 = new FlexboxLayoutManager.LayoutParams((ViewGroup.MarginLayoutParams) layoutParams);
        } else {
            layoutParams2 = new FlexboxLayoutManager.LayoutParams(layoutParams);
        }
        return layoutParams2;
    }
}
