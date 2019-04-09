package com.zcp.showtimeforflutter

import android.content.Context
import android.provider.MediaStore
import android.net.Uri
import java.util.ArrayList




/**
 * @author zcp
 * @date 2019/3/21
 * @Description
 */
class LocalSongsPresent(context: Context) {
    var mContext: Context = context
    var song:Song?=null
    var songs:MutableList<Song>?=null
    public fun getLocalSongs():MutableList<Song>?{
        songs = ArrayList<Song>()
        val cursor = mContext.contentResolver.query(
                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, null, null,
                null, MediaStore.Audio.Media.DEFAULT_SORT_ORDER
        )
        if(cursor!=null){

            while (cursor.moveToNext()){
                var name = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DISPLAY_NAME))
                var id = cursor.getLong(cursor.getColumnIndexOrThrow(MediaStore.Audio.Media._ID))
                //歌曲的专辑名：MediaStore.Audio.Media.ALBUM
                val album = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.ALBUM))
                var singer = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ARTIST))
                var path = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA))
                var duration = cursor.getInt(cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION))
                var size = cursor.getLong(cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.SIZE))
                var albumId = cursor.getLong(cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM_ID))
                //list.add(song);
                //把歌曲名字和歌手切割开
                //song.setName(name);
                if (size > 1000 * 800) {
                    if (name.contains("-")) {
                        val str = name.split("-")
                        singer = str[0]
                        name = str[1]
                    }
                    var albumArt = getAlbumArt(albumId)
                    song = Song(id,name,album,singer,path,duration,size,albumId,albumArt)
                    songs!!.add(song!!)
                }
            }
        }
        return songs
    }
    private fun getAlbumArt(album_id: Long): String? {
        val mUriAlbums = "content://media/external/audio/albums"
        val projection = arrayOf("album_art")
        var cur = mContext.contentResolver.query(
                Uri.parse("$mUriAlbums/$album_id"),
                projection, null, null, null)
        var album_art: String? = null
        if (cur!!.count > 0 && cur.getColumnCount() > 0) {
            cur.moveToNext()
            album_art = cur.getString(0)
        }
        cur.close()
        return album_art
    }
}