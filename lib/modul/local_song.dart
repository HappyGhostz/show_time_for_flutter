
List<Song> getSongList(List<dynamic> list){
  List<Song> result = [];
  list.forEach((item){
    result.add(Song.fromJson(item));
  });
  return result;
}


class Song {
  int id;
  String singer;
  String title;
  int size;
  int albumId;
  int duration;
  String url;
  String album;
  String albumArt;

  Song(this.id, this.singer, this.title, this.album, this.albumId,
      this.duration, this.url,this.size, this.albumArt);
  Song.fromJson(Map<String, dynamic> m) {
    id = m["id"];
    singer = m["singer"];
    title = m["tilte"];
    album = m["album"];
    albumId = m["albumId"];
    duration = m["duration"];
    url = m["url"];
    size = m["size"];
    albumArt = m["albumArt"];
  }
}