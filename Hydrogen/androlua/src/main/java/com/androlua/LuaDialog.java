package com.androlua;

//import android.app.AlertDialog;
import androidx.appcompat.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayListAdapter;
import android.widget.Button;
import android.widget.ListAdapter;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.Arrays;

/**
 * Created by Administrator on 2017/02/04 0004.
 */

public class LuaDialog extends AlertDialog implements  DialogInterface.OnClickListener{
    private Context mContext;

    private ListView mListView;

    private String mMessage;

    private String mTitle;

    private View mView;
    private OnClickListener mOnClickListener;

    public LuaDialog(Context context) {
        super(context);
        mContext = context;
        mListView = new ListView(mContext);
    }

    public LuaDialog(Context context, int theme) {
        super(context, theme);
        mContext = context;
        mListView = new ListView(mContext);
    }

    public void setButton(CharSequence text) {
        setOkButton(text);
    }

    public void setButton1(CharSequence text) {
        setButton(DialogInterface.BUTTON_POSITIVE, text, this);
    }
    public void setButton2(CharSequence text) {
        setButton(DialogInterface.BUTTON_NEGATIVE, text, this);
    }
    public void setButton3(CharSequence text) {
        setButton(DialogInterface.BUTTON_NEUTRAL, text, this);
    }
    public void setPosButton(CharSequence text) {
        setButton(DialogInterface.BUTTON_POSITIVE, text, this);
    }
    public void setNegButton(CharSequence text) {
        setButton(DialogInterface.BUTTON_NEGATIVE, text, this);
    }
    public void setNeuButton(CharSequence text) {
        setButton(DialogInterface.BUTTON_NEUTRAL, text, this);
    }

    public void setOkButton(CharSequence text) {
        setButton(DialogInterface.BUTTON_POSITIVE, text, this);
    }

    public void setCancelButton(CharSequence text) {
        setButton(DialogInterface.BUTTON_NEGATIVE, text, this);
    }

    public void setOnClickListener(LuaDialog.OnClickListener listener) {
        mOnClickListener=listener;
    }

    public void setPositiveButton(CharSequence text, DialogInterface.OnClickListener listener) {
        setButton(DialogInterface.BUTTON_POSITIVE, text, listener);
    }

    public void setNegativeButton(CharSequence text, DialogInterface.OnClickListener listener) {
        setButton(DialogInterface.BUTTON_NEGATIVE, text, listener);
    }

    public void setNeutralButton(CharSequence text, DialogInterface.OnClickListener listener) {
        setButton(DialogInterface.BUTTON_NEUTRAL, text, listener);
    }

    public String getTitle() {
        return mTitle;
    }

    @Override
    public void setTitle(CharSequence title) {
        // TODO: Implement this method
        mTitle = title.toString();
        super.setTitle(title);
    }

    public String getMessage() {
        return mMessage;
    }

    @Override
    public void setMessage(CharSequence message) {
        // TODO: Implement this method
        mMessage = message.toString();
        super.setMessage(message);
    }

    @Override
    public void setIcon(Drawable icon) {
        // TODO: Implement this method
        super.setIcon(icon);
    }

    public View getView() {
        return mView;
    }

    @Override
    public void setView(View view) {
        // TODO: Implement this method
        mView = view;
        super.setView(view);
    }

    public void setItems(String[] items) {
        ArrayList<String> alist = new ArrayList<String>(Arrays.asList(items));
        ArrayListAdapter adp = new ArrayListAdapter<String>(mContext, android.R.layout.simple_list_item_1, alist);
        setAdapter(adp);
        mListView.setChoiceMode(ListView.CHOICE_MODE_NONE);
    }

    public void setAdapter(ListAdapter adp) {
        if (!mListView.equals(mView))
            setView(mListView);
        mListView.setAdapter(adp);
    }

    public void setSingleChoiceItems(CharSequence[] items){
        setSingleChoiceItems(items, 0);
    }

    public void setSingleChoiceItems(CharSequence[] items, int checkedItem){
        ArrayList<CharSequence> alist = new ArrayList<CharSequence>(Arrays.asList(items));
        ArrayListAdapter adp = new ArrayListAdapter<CharSequence>(mContext, android.R.layout.simple_list_item_single_choice, alist);
        setAdapter(adp);
        mListView.setChoiceMode(ListView.CHOICE_MODE_SINGLE);
        mListView.setItemChecked(checkedItem,true);
    }

    public void setMultiChoiceItems(CharSequence[] items){
        setMultiChoiceItems(items, new int[0]);
    }

    public void setMultiChoiceItems(CharSequence[] items, int[] checkedItems){
        ArrayList<CharSequence> alist = new ArrayList<CharSequence>(Arrays.asList(items));
        ArrayListAdapter adp = new ArrayListAdapter<CharSequence>(mContext, android.R.layout.simple_list_item_multiple_choice, alist);
        setAdapter(adp);
        mListView.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
        for (int i:checkedItems)
            mListView.setItemChecked(i,true);
    }

    public ListView getListView() {
        return mListView;
    }

    public void setOnItemClickListener(final AdapterView.OnItemClickListener listener) {
        mListView.setOnItemClickListener(listener);
    }

    public void setOnItemLongClickListener(final AdapterView.OnItemLongClickListener listener) {
        mListView.setOnItemLongClickListener(listener);
    }

    public void setOnItemSelectedListener(final AdapterView.OnItemSelectedListener listener) {
        mListView.setOnItemSelectedListener(listener);
    }

    @Override
    public void setOnCancelListener(DialogInterface.OnCancelListener listener) {
        // TODO: Implement this method
        super.setOnCancelListener(listener);
    }

    @Override
    public void setOnDismissListener(DialogInterface.OnDismissListener listener) {
        // TODO: Implement this method
        super.setOnDismissListener(listener);
    }

    @Override
    public void show() {
        super.show();
    }

    @Override
    public void hide() {
        super.hide();
    }


    @Override
    public boolean isShowing() {
        return super.isShowing();
    }

    @Override
    public void onClick(DialogInterface dialog, int which) {
        if(mOnClickListener!=null)
            mOnClickListener.onClick(this,getButton(which));
    }

    public interface OnClickListener{
        public void onClick(LuaDialog dlg,Button btn);
    }

/*
    public void close()
    {
        super.dismiss();
    }

    @Override
    public void dismiss()
    {
        // TODO: Implement this method
        super.hide();
    }*/

}
