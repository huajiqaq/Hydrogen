local gLLO=getLocalLangObj
permissionInformation={
  {
    icon=R.drawable.ic_file_outline,
    title=gLLO("存储","Storage");
    summary=gLLO("用于存储项目、编辑项目、调试项目等","Used to store items, edit items, debug items, etc");
    permissions={"android.permission.WRITE_EXTERNAL_STORAGE","android.permission.READ_EXTERNAL_STORAGE"};
  },
  {
    icon=R.drawable.ic_phone_outline,
    title=gLLO("电话","Phone");
    summary=gLLO("用于统计软件、调试项目","Used for statistics of software and debugging projects");
    permissions={"android.permission.READ_PHONE_STATE"};
  },
}
