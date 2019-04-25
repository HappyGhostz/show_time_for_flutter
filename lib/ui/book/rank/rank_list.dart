import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/rank/rank_detial.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/ui/book/detail/book_detail.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';

/**
 * @author zcp
 * @date 2019/4/25
 * @Description
 */

class RankListPage extends StatefulWidget {
  RankListPage({
    Key key,
    @required this.id,
  }) : super(key: key);
  String id;

  @override
  State<StatefulWidget> createState() => RankListPageState();
}

class RankListPageState extends State<RankListPage> with AutomaticKeepAliveClientMixin{
  BookService _bookService = BookService();
  List<Books> books = [];
  Ranking ranking;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    RankDetail rankDetail = await _bookService.getRankingList(widget.id);
    ranking = rankDetail.ranking;
    if(ranking!=null){
      books = rankDetail.ranking.books;
    }else{
      books=null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    if (ranking==null&&books!= null) {
      return LoadingAndErrorView(
        layoutStatus: LayoutStatus.loading,
        noDataTab: () {
          loadData();
        },
        retryTab: () {
          loadData();
        },
      );
    } else if(ranking==null&&books== null){
      return LoadingAndErrorView(
        layoutStatus: LayoutStatus.noData,
        noDataTab: () {
          loadData();
        },
        retryTab: () {
          loadData();
        },
      );
    }
    else {
      return new RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: loadData,
        child: ListView.separated(
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) {
            Books book = books[index];
            return _BuildListItem(book);
          },
          separatorBuilder: (BuildContext context, int index) {
            return new Divider(
              height: 1.0,
              color: Colors.grey,
            );
          },
        ),
      );
    }
  }

  Widget _BuildListItem(Books book) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          return BookDetailPage(bookId: book.id,);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            ImageUtils.showFadeImageForSize(
                IMG_BASE_URL + book?.cover, 60.0, 45.0, BoxFit.cover),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(book.title,style: TextStyle(color: Color(0xff212121),fontSize: 16.0),overflow: TextOverflow.ellipsis,maxLines: 1,),
                      Container(
                        margin: EdgeInsets.only(top: 3.0),
                        child: Text("${book?.author == null? "未知" : book.author} | ${book?.majorCate == null?"未知": book.majorCate}",
                          style: TextStyle(color: Color(0xff727272),fontSize: 14.0),overflow: TextOverflow.ellipsis,maxLines: 1,),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3.0),
                        child: Text(book?.shortIntro ,
                          style: TextStyle(color: Color(0xff727272),fontSize: 14.0),overflow: TextOverflow.ellipsis,maxLines: 1,),
                      ),
                      Text("${book?.latelyFollower}人在追 | ${book?.retentionRatio == null?"0": book.retentionRatio}读者留存",
                        style: TextStyle(color: Color(0xff727272),fontSize: 14.0),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
