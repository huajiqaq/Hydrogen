import "com.Jesse205.layout.MyEditDialogLayout"
local EditDialogBuilder={}
local cannotBeEmptyStr=getString(R.string.Jesse205_edit_error_cannotBeEmpty)
setmetatable(EditDialogBuilder,EditDialogBuilder)

EditDialogBuilder.allowNull=true

function EditDialogBuilder.__call(self,context)
  self=table.clone(self)
  self.context=context
  self.checkNullButtons={}
  return self
end

function EditDialogBuilder:setTitle(text)
  self.title=text
  return self
end

function EditDialogBuilder:setText(text)
  self.text=text
  return self
end

function EditDialogBuilder:setHint(text)
  self.hint=text
  return self
end

function EditDialogBuilder:setHelperText(text)
  self.helperText=text
  return self
end

function EditDialogBuilder:setAllowNull(state)
  self.allowNull=state
  return self
end

local function setButton(self,text,func,defaultFunc,checkNull,buttonType)
  local onClick
  if func then
    function onClick()
      local dialog=self.dialog
      local text=self.ids.edit.text
      local editLay=self.ids.editLay
      if checkNull and not(self.allowNull) then
        if text=="" then
          editLay
          .setError(cannotBeEmptyStr)
          .setErrorEnabled(true)
          return true
        end
      end
      if not(func(dialog,text)) then
        editLay.setErrorEnabled(false)
        dialog.dismiss()
      end
    end
  end
  self[buttonType]={text,onClick,checkNull}
  if defaultFunc then
    self.defaultFunc=onClick
  end
  return self
end

function EditDialogBuilder:setPositiveButton(text,func,defaultFunc,checkNull)
  return setButton(self,text,func,defaultFunc,checkNull,"positiveButton")
end

function EditDialogBuilder:setNeutralButton(text,func,defaultFunc,checkNull)
  return setButton(self,text,func,defaultFunc,checkNull,"neutralButton")
end

function EditDialogBuilder:setNegativeButton(text,func,defaultFunc,checkNull)
  return setButton(self,text,func,defaultFunc,checkNull,"negativeButton")
end

function EditDialogBuilder:show()
  local ids={}
  self.ids=ids
  local context,checkNullButtons=self.context,self.checkNullButtons
  local positiveButton,neutralButton,negativeButton=self.positiveButton,self.neutralButton,self.negativeButton
  local text,hint,helperText=self.text,self.hint,self.helperText
  local defaultFunc=self.defaultFunc
  local dialogBuilder=AlertDialog.Builder(context)
  .setTitle(self.title)
  .setView(MyEditDialogLayout.load(nil,ids))

  if positiveButton then--设置文字
    dialogBuilder.setPositiveButton(positiveButton[1],nil)
  end
  if neutralButton then
    dialogBuilder.setNeutralButton(neutralButton[1],nil)
  end
  if negativeButton then
    dialogBuilder.setNegativeButton(negativeButton[1],nil)
  end
  local dialog=dialogBuilder.show()
  local textState=toboolean(text==nil or text=="")

  if positiveButton then--设置点击事件
    local button=dialog.getButton(AlertDialog.BUTTON_POSITIVE)
    if positiveButton[2] then
      button.onClick=positiveButton[2]
    end
    if positiveButton[3] then
      table.insert(checkNullButtons,button)
      if textState then
        button.setEnabled(false)
      end
    end
  end
  if neutralButton then
    local button=dialog.getButton(AlertDialog.BUTTON_NEUTRAL)
    if neutralButton[2] then
      button.onClick=neutralButton[2]
    end
    if neutralButton[3] then
      table.insert(checkNullButtons,button)
      if textState then
        button.setEnabled(false)
      end
    end
  end
  if negativeButton then
    local button=dialog.getButton(AlertDialog.BUTTON_NEGATIVE)
    if negativeButton[2] then
      button.onClick=negativeButton[2]
    end
    if negativeButton[3] then
      table.insert(checkNullButtons,button)
      if textState then
        button.setEnabled(false)
      end
    end
  end

  self.dialog=dialog

  local edit,editLay=ids.edit,ids.editLay
  edit.requestFocus()--输入框取得焦点
  inputMethodService.showSoftInput(edit,InputMethodManager.SHOW_FORCED)
  if helperText then
    if type(helperText)=="number" then
      helperText=context.getString(helperText)
    end
    editLay.setHelperText(helperText)
    editLay.setHelperTextEnabled(true)
  end
  if text then
    edit.setText(text)
    edit.setSelection(utf8.len(text))
  end
  if hint then
    if type(hint)=="number" then
      hint=context.getString(hint)
    end
    editLay.setHint(hint)
  end
  if defaultFunc then
    edit.onEditorAction=defaultFunc
  end
  if not(self.allowNull) then
    local oldErrorEnabled=textState
    edit.addTextChangedListener({
      onTextChanged=function(text,start,before,count)
        text=tostring(text)
        if text=="" and not(oldErrorEnabled) then--文件夹名不能为空
          editLay
          .setError(cannotBeEmptyStr)
          .setErrorEnabled(true)
          oldErrorEnabled=true
          for index,content in ipairs(checkNullButtons) do
            content.setEnabled(false)
          end
          return
         elseif oldErrorEnabled then
          editLay.setErrorEnabled(false)
          oldErrorEnabled=false
          for index,content in ipairs(checkNullButtons) do
            content.setEnabled(true)
          end
        end
      end
    })
  end
  return dialog
end


function EditDialogBuilder.settingDialog(adapter,views,key,data)
  local builder
  builder=EditDialogBuilder(activity)
  :setTitle(data.title)
  :setText(data.summary)
  :setHint(data.hint)
  :setHelperText(data.helperText)
  :setAllowNull(data.allowNull)
  :setPositiveButton(android.R.string.ok,function(dialog,text)
    data.summary=text
    setSharedData(key,text)
    adapter.notifyDataSetChanged()
  end,true,true)
  :setNegativeButton(android.R.string.no,nil)
  builder:show()
  return builder
end
return EditDialogBuilder