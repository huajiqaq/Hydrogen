local ImageDialogBuilder={}
setmetatable(ImageDialogBuilder,ImageDialogBuilder)

function ImageDialogBuilder.setImage(self,id)
  self.image=id
  return self
end

function ImageDialogBuilder.show(self)
  import "android.graphics.drawable.ColorDrawable"
  local context=self.context
  local dialogBuilder=AlertDialog.Builder(context)
  local ids={}
  dialogBuilder.setView(loadlayout2(
  {
    CardView;
    layout_width="fill";
    layout_height="fill";
    {
      AppCompatImageView;
      layout_width="fill";
      layout_height="fill";
      id="imageView";
      imageResource=self.image;
      adjustViewBounds=true;
    };
  },ids))
  local dialog=dialogBuilder.show()
  dialog.getWindow().setBackgroundDrawable(ColorDrawable(0))
  return dialog
end

function ImageDialogBuilder.__call(self,context)
  self=table.clone(self)
  self.context=context
  return self
end
return ImageDialogBuilder
