package com.jesse205.adapter;

import com.androlua.LuaContext;
import com.androlua.LuaMultiAdapter;
import com.luajava.LuaTable;
import com.luajava.LuaException;

public class MyLuaMultiAdapter extends LuaMultiAdapter {


    public MyLuaMultiAdapter(LuaContext context, LuaTable layout) throws LuaException {
        super(context, layout);
    }
    
    public MyLuaMultiAdapter(LuaContext context, LuaTable<Integer, LuaTable<String, Object>> data, LuaTable<Integer, LuaTable> layout) throws LuaException {
        super(context, data, layout);
    }
}
