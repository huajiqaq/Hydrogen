import "android.view.inputmethod.InputMethodManager"
import "com.jesse205.layout.MyTitleEditLayout"
import "androidx.appcompat.view.ActionMode"

return function(config)
  local onActionItemClicked=config.onActionItemClicked
  local onTextChanged=config.onTextChanged
  local onEditorAction=config.onEditorActionfunction
  local onDestroyActionMode=config.onDestroyActionMode

  local onSearch=config.onSearch
  local onIndex=config.onIndex
  local onCancel=config.onCancel

  local ids={}
  local searchMenu,searchEdit
  local actionMode=ActionMode.Callback({
    onCreateActionMode=function(mode,menu)
      mode.setCustomView(MyTitleEditLayout.load({{
          hint=config.hint or activity.getString(R.string.abc_search_hint);
          text=config.text;
          showSoftInputOnFocus=true;
      }},ids))
      searchEdit=ids.searchEdit

      ClearContentHelper.setupEditor(searchEdit,ids.clearSearchBtn,theme.color.ActionBar.rippleColorPrimary)

      searchEdit.postDelayed(Runnable({
        run=function()
          searchEdit.requestFocus()--搜索框取得焦点
          inputMethodService.showSoftInput(searchEdit,InputMethodManager.SHOW_FORCED)
        end
      }),100)

      searchEdit.onEditorAction=function(view,actionId,event)
        if event then
          onSearch(tostring(view.text))
        end
        if onEditorAction then
          onEditorAction(view,actionId,event)
        end
      end

      searchEdit.addTextChangedListener({
        onTextChanged=function(text)
          if onIndex then
            onIndex(tostring(text))
          end
          if onTextChanged then
            onTextChanged(text)
          end
        end
      })

      searchMenu=menu.add(R.string.abc_searchview_description_search)
      searchMenu.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
      searchMenu.setIcon(R.drawable.ic_magnify)
      config.searchMenu=searchMenu

      if config.onCreateActionMode then
        return config.onCreateActionMode(mode,menu)
      end
      return true
    end,
    onActionItemClicked=function(mode,item)
      if item==searchMenu and onSearch then
        onSearch(tostring(searchEdit.text))
      end
      if onActionItemClicked then
        onActionItemClicked(mode,item)
      end
    end,
    onDestroyActionMode=function(mode)
      inputMethodService.hideSoftInputFromWindow(searchEdit.getWindowToken(), 0)
      if onCancel then
        onCancel()
      end
      if onDestroyActionMode then
        config.onDestroyActionMode(mode)
      end
    end,
  })
  activity.startSupportActionMode(actionMode)
  return ids
end