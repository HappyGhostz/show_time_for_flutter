/**
 * @author zcp
 * @date 2019/3/29
 * @Description
 */

class MusicSearchList {
  /**
   * query : 爱我还是他
   * is_artist : 0
   * is_album : 0
   * rs_words :
   * pages : {"total":"2","rn_num":"2"}
   * song_list : [{"title":"爱我还是他","song_id":"31197196","author":"洪卓立","artist_id":"913","all_artist_id":"913","album_title":"Neway Music Live X 洪卓立音乐会","appendix":"现场","album_id":"31199665","lrclink":"/data2/lrc/65425384/65425384.lrc","resource_type":"0","content":"","relate_status":0,"havehigh":2,"copy_type":"1","del_status":"0","all_rate":"24,64,128,192,256,320,flac","has_mv":0,"has_mv_mobile":0,"mv_provider":"0000000000","charge":0,"toneid":"0","info":"","data_source":0,"learn":0},{"title":"爱我还是他","song_id":"2109208","author":"群星","artist_id":"313607","all_artist_id":"313607","album_title":"LOVE 国语情歌集","appendix":"","album_id":"7311955","lrclink":"/data2/lrc/13910062/13910062.lrc","resource_type":"0","content":"","relate_status":1,"havehigh":2,"copy_type":"0","del_status":"0","all_rate":"64,128,256,320","has_mv":0,"has_mv_mobile":1,"mv_provider":"1100000000","charge":0,"toneid":"0","info":"","data_source":0,"learn":1},{"title":"空气稀薄","song_id":"13903108","author":"杨杰荃","artist_id":"13903099","all_artist_id":"13903099","album_title":"新新人类","appendix":"","album_id":"13903112","lrclink":"/data2/lrc/241835653/241835653.lrc","resource_type":"0","content":"遇到分岔\n是爱我还是他\n不要再用双眼泛起的泪光\n当作是你的回答\n\n空气稀薄吗\n怎么连见面都变得尴尬\n满腮的胡渣\n是我太过潇洒\n还是太邋遢OHYEYE\n\n紧随的步伐\n经不起风沙\n在中途就","relate_status":0,"havehigh":2,"copy_type":"0","del_status":"0","all_rate":"128","has_mv":0,"has_mv_mobile":0,"mv_provider":"0000000000","charge":0,"toneid":"","info":"","data_source":0,"learn":0},{"title":"累了就散了","song_id":"116791887","author":"王惠杰","artist_id":"116789723","all_artist_id":"116789723","album_title":"","appendix":"","album_id":"0","lrclink":"/data2/lrc/116791806/116791806.txt","resource_type":"0","content":"谎话\n你到底爱我还是他\n你爱我还是他\n啊可笑可笑可笑吧\n我值得值得我值得吗\n我是对了还是错了吗\n谁能给我个回答\n谁能给我个回答\n给我个回答\n啊散了散了散了吧\n我忘了忘了我忘","relate_status":1,"havehigh":2,"copy_type":"1","del_status":"0","all_rate":"128","has_mv":0,"has_mv_mobile":0,"mv_provider":"0000000000","charge":0,"toneid":"","info":"","data_source":0,"learn":0},{"title":"我我我他他他","song_id":"32996797","author":"王绎龙","artist_id":"1810","all_artist_id":"1810","album_title":"DJ万万岁","appendix":"混音","album_id":"32996738","lrclink":"/data2/lrc/65430904/65430904.lrc","resource_type":"0","content":"诉我你到底爱我还是他\n为何心里明明有他还要对我说那些情话\n现在请你不要犹豫说你心里真实的回答\n离开的人是我还是他Please Baby\n你爱的人是我我我我吗\n别再说爱着他他他的话\n你","relate_status":0,"havehigh":2,"copy_type":"0","del_status":"0","all_rate":"128","has_mv":0,"has_mv_mobile":0,"mv_provider":"0000000000","charge":0,"toneid":"","info":"","data_source":0,"learn":0}]
   */

  String query;
  int is_artist;
  int is_album;
  String rs_words;
  PagesBean pages;
  List<SongListBean> song_list;
  MusicSearchList(
      this.query,
      this.is_artist,
      this.is_album,
      this.rs_words,
      this.pages,
      this.song_list,
      );
  factory MusicSearchList.fromJson(Map<String,dynamic>json){
    var pagesJson = json["pages"];
    PagesBean pagesBean = PagesBean.fromJson(pagesJson);
    return MusicSearchList(
      json["query"],
      json["is_artist"],
      json["is_album"],
      json["rs_words"],
        pagesBean,
      (json["song_list"] as List)
          ?.map((e) => e == null
          ? null
          : SongListBean.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }
}

class PagesBean {
  /**
   * total : 2
   * rn_num : 2
   */

  String total;
  String rn_num;
  PagesBean(this.total,this.rn_num);
  factory PagesBean.fromJson(Map<String,dynamic>json){
    return PagesBean(
      json["total"],
      json["rn_num"],
    );
  }
}

class SongListBean {
  /**
   * title : 爱我还是他
   * song_id : 31197196
   * author : 洪卓立
   * artist_id : 913
   * all_artist_id : 913
   * album_title : Neway Music Live X 洪卓立音乐会
   * appendix : 现场
   * album_id : 31199665
   * lrclink : /data2/lrc/65425384/65425384.lrc
   * resource_type : 0
   * content :
   * relate_status : 0
   * havehigh : 2
   * copy_type : 1
   * del_status : 0
   * all_rate : 24,64,128,192,256,320,flac
   * has_mv : 0
   * has_mv_mobile : 0
   * mv_provider : 0000000000
   * charge : 0
   * toneid : 0
   * info :
   * data_source : 0
   * learn : 0
   */

  String title;
  String song_id;
  String author;
  String artist_id;
  String all_artist_id;
  String album_title;
  String appendix;
  String album_id;
  String lrclink;
  String resource_type;
  String content;
  int relate_status;
  int havehigh;
  String copy_type;
  String del_status;
  String all_rate;
  int has_mv;
  int has_mv_mobile;
  String mv_provider;
  int charge;
  String toneid;
  String info;
  int data_source;
  int learn;

  SongListBean(
    this.title,
    this.song_id,
    this.author,
    this.artist_id,
    this.all_artist_id,
    this.album_title,
    this.appendix,
    this.album_id,
    this.lrclink,
    this.resource_type,
    this.content,
    this.relate_status,
    this.havehigh,
    this.copy_type,
    this.del_status,
    this.all_rate,
    this.has_mv,
    this.has_mv_mobile,
    this.mv_provider,
    this.charge,
    this.toneid,
    this.info,
    this.data_source,
    this.learn,
  );

  factory SongListBean.fromJson(Map<String, dynamic> json) {
    return SongListBean(
      json["title"],
      json["song_id"],
      json["author"],
      json["artist_id"],
      json["all_artist_id"],
      json["album_title"],
      json["appendix"],
      json["album_id"],
      json["lrclink"],
      json["resource_type"],
      json["content"],
      json["relate_status"],
      json["havehigh"],
      json["copy_type"],
      json["del_status"],
      json["all_rate"],
      json["has_mv"],
      json["has_mv_mobile"],
      json["mv_provider"],
      json["charge"],
      json["toneid"],
      json["info"],
      json["data_source"],
      json["learn"],
    );
  }
}
