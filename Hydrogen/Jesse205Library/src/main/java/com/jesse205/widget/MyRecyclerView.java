package com.jesse205.widget;
import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.AdapterView;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

/**
 * 实现内容菜单支持的RecyclerView
 * @author Jesse205
 */

public class MyRecyclerView extends RecyclerView {

    private AdapterView.AdapterContextMenuInfo contextMenuInfo;
    public MyRecyclerView(Context context) {
        super(context);
    }

    public MyRecyclerView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
    }

    public MyRecyclerView(Context context, @Nullable AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    public AdapterView.AdapterContextMenuInfo getContextMenuInfo() {
        return contextMenuInfo;
    }

    @Override
    public boolean showContextMenuForChild(View originalView) {
		try {
			int position = getChildAdapterPosition(originalView);
			long longId = getChildItemId(originalView);
			contextMenuInfo = new AdapterView.AdapterContextMenuInfo(originalView, position, longId);
		} catch (ClassCastException e) {
			contextMenuInfo=null;
		}
        return super.showContextMenuForChild(originalView);
    }

}
