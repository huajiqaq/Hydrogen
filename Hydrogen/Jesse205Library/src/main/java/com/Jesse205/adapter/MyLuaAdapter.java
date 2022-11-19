package com.Jesse205.adapter;

import com.androlua.LuaAdapter;
import com.androlua.LuaContext;
import com.luajava.LuaException;
import com.luajava.LuaTable;

public class MyLuaAdapter extends LuaAdapter {


    public MyLuaAdapter(LuaContext context, LuaTable layout) {
        super(context, layout);
    }

    public MyLuaAdapter(LuaContext context, LuaTable data, LuaTable layout) {
        super(context, data, layout);
    }
}
