package com.jesse205.util;

import android.annotation.SuppressLint;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;

public class FileInfoUtils {  
    /**
     * Android 4.4往后版本 ，其中区别在 8.0download目录报错修改，华为手机uri获取不到路径处理。
     */
    @SuppressLint("NewApi")
    public static String getPath(final Context context, final Uri uri) {
        // DocumentProvider
        final String authority=uri.getAuthority();
        if (DocumentsContract.isDocumentUri(context, uri)) {
            // ExternalStorageProvider
            final String docId = DocumentsContract.getDocumentId(uri);
            if (isExternalStorageDocument(authority)) {
                final String[] split = docId.split(":");
                final String type = split[0];
                if ("primary".equalsIgnoreCase(type)) {
                    return Environment.getExternalStorageDirectory() + "/" + split[1];
                }
            }
            // DownloadsProvider
            else if (isDownloadsDocument(authority)) {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O){//判断有没有超过android 8，区分开来，不然崩溃崩溃崩溃崩溃
                    final Uri contentUri = ContentUris.withAppendedId(
                        Uri.parse("content://downloads/public_downloads"), Long.parseLong(docId));
                    return getDataColumn(context, contentUri, null, null);
                }else{
                    final String[] split = docId.split(":");
                    if (split.length>=2){
                        return split[1];
                    }
                }
            }
            // MediaProvider
            else if (isMediaDocument(authority)) {
                final String[] split = docId.split(":");
                final String type = split[0];

                Uri contentUri = null;
                if ("image".equals(type)) {
                    contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                } else if ("video".equals(type)) {
                    contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                } else if ("audio".equals(type)) {
                    contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                }

                final String selection = "_id=?";
                final String[] selectionArgs = new String[]{split[1]};

                return getDataColumn(context, contentUri, selection, selectionArgs);
            }
        }
        // MediaStore (and general)
        else if ("content".equalsIgnoreCase(uri.getScheme())) {
            if (isHuaWeiUri(authority)) {
                String uriPath = uri.getPath();
                //content://com.huawei.hidisk.fileprovider/root/storage/emulated/0/Android/data/com.xxx.xxx/
                if (uriPath != null && uriPath.startsWith("/root")) {
                    return uriPath.replaceFirst("/root", "");
                }
            }
            return getDataColumn(context, uri, null, null);
        }
        // File
        else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }
        return null;
    }

    public static String getDataColumn(Context context, Uri uri, String selection,
                                       String[] selectionArgs) {
        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {column};
        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,
                                                        null);
            if (cursor != null && cursor.moveToFirst()) {
                final int column_index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(column_index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return null;

    }



    public static boolean isGooglePhotosUri(String authority) {
        return "com.google.android.apps.photos.content".equals(authority);
    }

    public static boolean isHuaWeiUri(String authority) {
        return "com.huawei.hidisk.fileprovider".equals(authority)||"com.huawei.filemanager.share.fileprovider".equals(authority);
    }


    public static boolean isExternalStorageDocument(String authority) {
        return "com.android.externalstorage.documents".equals(authority);

    }

    public static boolean isDownloadsDocument(String authority) {
        return "com.android.providers.downloads.documents".equals(authority);

    }

    public static boolean isMediaDocument(String authority) {
        return "com.android.providers.media.documents".equals(authority);

    }

    /**
     * 获取真实路径
     *
     */
    public static String getRealFilePath(Context context, final Uri uri) {
        if (null == uri)
            return null;
        final String scheme = uri.getScheme();
        String data = null;
        if (scheme == null)
            data = uri.getPath();
        else if (ContentResolver.SCHEME_FILE.equals(scheme)) {
            data = uri.getPath();
        } else if (ContentResolver.SCHEME_CONTENT.equals(scheme)) {
            Cursor cursor = context.getContentResolver().query(uri, new String[]{MediaStore.Images.ImageColumns.DATA}, null, null, null);
            if (null != cursor) {
                if (cursor.moveToFirst()) {
                    int index = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
                    if (index > -1) {
                        data = cursor.getString(index);
                    }
                }
                cursor.close();
            }
        }
        return data;
    }




    }

