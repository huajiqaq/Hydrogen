package com.jesse205.adapter;

import com.androlua.LuaAdapter;
import com.androlua.LuaContext;
import com.luajava.LuaTable;

public class MyLuaAdapter extends LuaAdapter {


    public MyLuaAdapter(LuaContext context, LuaTable layout) {
        super(context, layout);
    }

    public MyLuaAdapter(LuaContext context, LuaTable<Integer, LuaTable<String, Object>> data, LuaTable layout) {
        super(context, data, layout);
    }
}
