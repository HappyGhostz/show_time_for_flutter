import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/rank/rank_book.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/ui/book/rank/rank_tab.dart';
import 'package:show_time_for_flutter/ui/book/rank/rank_other.dart';

/**
 * @author zcp
 * @date 2019/3/31
 * @Description
 */
class BookRankPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookRankPageState();
}

class BookRankPageState extends State<BookRankPage> with AutomaticKeepAliveClientMixin{
  BookService _bookService = BookService();

  List<Female> females;
  List<Female> expandFemales=[];

  List<Picture> pictures;
  List<Picture> expandPictures=[];

  List<Male> males;
  List<Male> expandMales=[];

  List<Epub> epubs;
  List<Epub> expandEpubs=[];

  RankBook rankBook;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    rankBook = await _bookService.getRanking();
    males = rankBook.male;
    for(int i=0;i<males.length;i++){
      var male = males[i];
      if(male.collapse){
        expandMales.add(male);
      }
    }
    females = rankBook.female;
    for(int i=0;i<females.length;i++){
      var female = females[i];
      if(female.collapse){
        expandFemales.add(female);
      }
    }
    pictures = rankBook.picture;
    for(int i=0;i<pictures.length;i++){
      var picture = pictures[i];
      if(picture.collapse){
        expandPictures.add(picture);
      }
    }
    epubs = rankBook.epub;
    for(int i=0;i<epubs.length;i++){
      var epub = epubs[i];
      if(epub.collapse){
        expandEpubs.add(epub);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (rankBook == null) {
      return LoadingAndErrorView(
        layoutStatus: LayoutStatus.loading,
        noDataTab: () {
          loadData();
        },
        retryTab: () {
          loadData();
        },
      );
    } else {
      return CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: <Widget>[
          _buildSliverToBoxAdapter("男生"),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            if ((index + 1) % 2 == 0) {
              return Container(
                margin: EdgeInsets.only(bottom: 2.0, top: 2.0),
                child: new Divider(
                  height: 1.0,
                  color: Colors.grey,
                ),
              );
            } else if (index ==(males.length-expandMales.length) * 2){
              return ExpansionTile(
                title: Container(
                  padding:EdgeInsets.only(top: 10.0,bottom: 10.0) ,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Image.asset("assets/images/ic_rank_collapse.png",width: 40.0,height: 40.0,),
                      Expanded(child:Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Text("其他排行榜"),
                      )
                      )
                    ],
                  ),
                ),
                children:
                _builderExpansion(),
              );
            } else {
              final i = index ~/ 2;
              var male = males[i];
              return _buildItem("male",i,IMG_BASE_URL + male.cover, male.title);
            }
          }, childCount: (males.length-expandMales.length) * 2+1)
          ),
          _buildSliverToBoxAdapter("女生"),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            if ((index + 1) % 2 == 0) {
              return Container(
                margin: EdgeInsets.only(bottom: 2.0, top: 2.0),
                child: new Divider(
                  height: 1.0,
                  color: Colors.grey,
                ),
              );
            } else if(index ==(females.length-expandFemales.length) * 2){
              return ExpansionTile(
                title: Container(
                  padding:EdgeInsets.only(top: 10.0,bottom: 10.0) ,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Image.asset("assets/images/ic_rank_collapse.png",width: 40.0,height: 40.0,),
                      Expanded(child:Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Text("其他排行榜"),
                      )
                      )
                    ],
                  ),
                ),
                children:
                _builderFemalsExpansion(),
              );
            } else {
              final i = index ~/ 2;
              var female = females[i];
              return _buildItem("female",i,IMG_BASE_URL + female.cover, female.title);
            }
          }, childCount: (females.length -expandFemales.length) * 2+1)
          ),
          _buildSliverToBoxAdapter("Picture"),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            if ((index + 1) % 2 == 0) {
              return Container(
                margin: EdgeInsets.only(bottom: 2.0, top: 2.0),
                child: new Divider(
                  height: 1.0,
                  color: Colors.grey,
                ),
              );
            } else {
              final i = index ~/ 2;
              var picture = pictures[i];
              return _buildItem("picture",i,IMG_BASE_URL + picture.cover, picture.title);
            }
          }, childCount: pictures.length * 2)
          ),
          _buildSliverToBoxAdapter("Epub"),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            if ((index + 1) % 2 == 0) {
              return Container(
                margin: EdgeInsets.only(bottom: 2.0, top: 2.0),
                child: new Divider(
                  height: 1.0,
                  color: Colors.grey,
                ),
              );
            } else {
              final i = index ~/ 2;
              var epub = epubs[i];
              return _buildItem("epub",i,IMG_BASE_URL + epub.cover, epub.title);
            }
          }, childCount: epubs.length * 2)
          ),
        ],
      );
    }
  }
  List<Widget> _builderExpansion() {
    List<Widget> widgets = [];
    if (expandMales == null || expandMales.length < 0) {
      widgets.add(Container());
      return widgets;
    }
    for (int i = 0; i < expandMales.length; i++) {
      var expandMale = expandMales[i];
      var gestureDetector = GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return RankOtherListPage(id: expandMale.id,title: expandMale.title);
          }));
        },
        child: Container(
          padding:EdgeInsets.all(15.0) ,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Text(
                      expandMale.title,
                      style: TextStyle(),
                    ),
                  ))
            ],
          ),
        ),
      );
      widgets.add(gestureDetector);
    }
    return widgets;
  }
  List<Widget> _builderFemalsExpansion() {
    List<Widget> widgets = [];
    if (expandFemales == null || expandFemales.length < 0) {
      widgets.add(Container());
      return widgets;
    }
    for (int i = 0; i < expandFemales.length; i++) {
      var expandFemale = expandFemales[i];
      var gestureDetector = GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return RankOtherListPage(id: expandFemale.id,title: expandFemale.title);
          }));
        },
        child: Container(
          padding:EdgeInsets.all(15.0) ,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Text(
                      expandFemale.title,
                      style: TextStyle(),
                    ),
                  ))
            ],
          ),
        ),
      );
      widgets.add(gestureDetector);
    }
    return widgets;
  }

  Widget _buildItem(String tag,int index,String iconPath, String title) {
    return GestureDetector(
      onTap: (){
        if(tag=="male"){
          var male = males[index];
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return RankTabPage(id: male.id,title: male.title,monthRank: male.monthRank,totalRank: male.totalRank,);
          }));
        }else if(tag=="female"){
          var female = females[index];
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return RankTabPage(id: female.id,title: female.title,monthRank: female.monthRank,totalRank: female.totalRank,);
          }));
        }else if(tag=="picture"){
          var picture = pictures[index];
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return RankOtherListPage(id: picture.id,title: picture.title);
          }));
        }else if(tag=="epub"){
          var epub = epubs[index];
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return RankOtherListPage(id: epub.id,title: epub.title);
          }));
        }
      },
      child: Container(
        padding:EdgeInsets.all(15.0) ,
        child: Row(
          children: <Widget>[
            Container(
              child: ImageUtils.showFadeImageForSize(
                  iconPath, 40, 40, BoxFit.cover),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 15.0),
              child: Text(
                title,
                style: TextStyle(),
              ),
            ))
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSliverToBoxAdapter(String name) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Text(name),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
