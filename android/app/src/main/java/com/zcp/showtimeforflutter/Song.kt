package com.zcp.showtimeforflutter

/**
 * @author zcp
 * @date 2019/3/21
 * @Description
 */
//val id = cursor.getInt(cursor.getColumnIndex(MediaStore.Audio.Media._ID))
////歌曲标题
//val tilte
////歌曲的专辑名：MediaStore.Audio.Media.ALBUM
//val album
////歌曲的歌手名： MediaStore.Audio.Media.ARTIST
//val singer
////歌曲文件的路径 ：MediaStore.Audio.Media.DATA
//val url
////歌曲的总播放时长 ：MediaStore.Audio.Media.DURATION
//val duration
////歌曲文件的大小 ：MediaStore.Audio.Media.SIZE
//val size
//val albumId
//val albumArt
data class Song (var id:Long,var tilte:String,var album:String?,var singer:String?,
                 var url:String,var duration:Int,var size:Long?,var albumId:Long?,
                 var albumArt:String?)