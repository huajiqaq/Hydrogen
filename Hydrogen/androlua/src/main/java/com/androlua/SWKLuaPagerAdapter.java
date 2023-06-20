package com.androlua;

import android.view.View;
import android.view.ViewGroup;
import androidx.viewpager.widget.PagerAdapter;
import java.util.ArrayList;

public class SWKLuaPagerAdapter extends PagerAdapter {
	//1. 返回可以滑动的View的个数
	ArrayList<View> viewContainter = new ArrayList<View>();
	 
	public void add(View view){
		viewContainter.add(view);
	}
	
	@Override
	public int getCount() {
		return viewContainter.size();
	}
	//2. 滑动切换时销毁当前View
	@Override
	public void destroyItem(ViewGroup container, int position, Object object) {
		container.removeView(viewContainter.get(position));
	}
	//3. 将当前View添加到父容器中，并且返回当前View
	@Override
	public Object instantiateItem(ViewGroup container, int position) {
		container.addView(viewContainter.get(position));
		return viewContainter.get(position);
	}
	//4. 确认"第三步"instantiateItem返回的Object与页面View是否是同一个
	@Override
	public boolean isViewFromObject(View view, Object object) {
		//5. 官方推荐直接 `view == object`
		return view == object;
	}
    
}
