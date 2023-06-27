//原代码取自 https://blog.csdn.net/qq_38431616/article/details/128014877
//原作者信息
/*************************
 * @Machine: RedmiBook Pro 15 Win11
 //这里其实错了 应该是
 * @Path: app/src/main/java/com/crow/laser/view/component
 * @Path: app/src/main/java/com/crow/laser/view/customviews
 * @Time: 2022/11/20 20:02
 * @Author: Crow
 * @Description: CustomSwiper 使用时全部反射属性仅作一次延迟初始化，减少在启动时的开销
 * @formatter:off
 **************************/
//原作者信息结束
package com.hydrogen.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;

import androidx.swiperefreshlayout.widget.CircularProgressDrawable;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import java.lang.reflect.Method;
import java.lang.reflect.Field;

public class CustomSwipeRefresh extends SwipeRefreshLayout {

    public CustomSwipeRefresh(Context context) {
        super(context);
    }

    public CustomSwipeRefresh(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    // 通过反射获取父类  
    private Class <? > superClazz = getClass().getSuperclass();

    // 反射获取父类进度条
    private CircularProgressDrawable mProgress; {
        try {
            Field field = superClazz.getDeclaredField("mProgress");
            field.setAccessible(true);
            mProgress = (CircularProgressDrawable) field.get(this);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 反射获取ScaleDownMethod
    private Method mScaleDownFunc; {
        try {
            Method method = superClazz.getDeclaredMethod("startScaleDownAnimation", AnimationListener.class);
            method.setAccessible(true);
            mScaleDownFunc = method;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 反射获取动画监听 
    private AnimationListener mRefreshListener; {
        try {
            Field field = superClazz.getDeclaredField("mRefreshListener");
            field.setAccessible(true);
            mRefreshListener = (AnimationListener) field.get(this);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // -0.125f是进度条拖动到顶部的一个临界值 经过调试打印得到的。 
    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        if (ev != null && ev.getAction() == MotionEvent.ACTION_UP && mProgress.getProgressRotation() == -0.125f) {
            try {
                mScaleDownFunc.invoke(this, mRefreshListener);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return super.dispatchTouchEvent(ev);
    }
}