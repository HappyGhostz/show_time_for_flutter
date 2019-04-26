import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/widgets/load_more.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/utils/string_format.dart';
import 'package:show_time_for_flutter/modul/book/detail/hot_review.dart';
import 'package:show_time_for_flutter/ui/book/community/book_help.dart';

/**
 * @author zcp
 * @date 2019/4/25
 * @Description
 */

class BookCommunityListPage extends StatefulWidget {
  BookCommunityListPage({
    Key key,
    @required this.bookId,
  }) : super(key: key);
  String bookId;

  @override
  State<StatefulWidget> createState() => BookCommunityListPageState();
}

class BookCommunityListPageState extends State<BookCommunityListPage> with AutomaticKeepAliveClientMixin{
  ScrollController _scrollController = new ScrollController();
  BookService _bookService = BookService();
  BookHotReview _bookHotReview;
  List<Reviews> reviews=[];
  bool isPerformingRequest = false;
  int start =0;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
    loadData();
  }
  Future<void>  loadData() async {
    start =0;
    _bookHotReview = await _bookService.getBookDetailReviewList(widget.bookId,start,);
    reviews = _bookHotReview.reviews;
    start+=reviews.length;
    setState(() {
    });
  }
  getMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      BookHotReview bookHotReview = await _bookService.getBookDetailReviewList(
          widget.bookId, start);
      List<Reviews> reviewsMore = bookHotReview.reviews;
      start += reviewsMore.length;
      new Future.delayed(const Duration(microseconds: 500), () {
        if (reviewsMore.isEmpty) {
          double edge = 72;
          double offsetFromBottom = _scrollController.position.maxScrollExtent -
              _scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            _scrollController.animateTo(
                _scrollController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut);
          }
        }
        setState(() {
          reviews.addAll(reviewsMore);
          isPerformingRequest = false;
        });
      });
    }
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (reviews.length == 0) {
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
      return new RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: loadData,
        child: ListView.separated(
          itemCount: reviews.length + 1,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index == reviews.length) {
              return _buildLoadMore();
            } else {
              Reviews review = reviews[index];
              return _BuildListItem(review);
            }
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
  Widget _buildLoadMore() {
    return Opacity(
      opacity: isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }
  Widget _BuildListItem(Reviews review) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return BookHelpDetailPage(helpId: review.id,);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                right: 10.0,
              ),
              child: ClipOval(
                child: ImageUtils.showFadeImageForSize(
                    IMG_BASE_URL + review.author.avatar,
                    55.0,
                    55.0,
                    BoxFit.cover),
              ),
            ),
            Expanded(
                flex: 6,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              "${review?.author?.nickname}lv.${review?.author?.lv} ",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Color.fromARGB(225, 165, 141, 61)),
                            ),
                            Text(
                              StringUtils.getDescriptionTimeFromDateString(review?.created),
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xffB2B2B2)),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Text(
                          review?.title,
                          style: TextStyle(color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: _buildStarCount(review),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Text(
                          "${review?.content}",
                          style:
                          TextStyle(fontSize: 13.0, color: Color(0xff727272)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 5.0),
                                child: Image.asset(
                                  "assets/images/post_item_like.png",
                                  height: 13,
                                  width: 13,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "${review?.helpful?.yes}",
                                  style: TextStyle(
                                      fontSize: 13.0, color: Color(0xffB2B2B2)),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
  List<Widget> _buildStarCount(Reviews review) {
    List<Widget> widgets = [];
    for (int i = 0; i < 5; i++) {
      Icon icon;
      if (i <= review.rating - 1) {
        icon = Icon(
          Icons.star,
          color: Color(0xffF19149),
          size: 13.0,
        );
      } else {
        icon = Icon(
          Icons.star_border,
          color: Color(0xffF19149),
          size: 13.0,
        );
      }
      widgets.add(icon);
    }
    return widgets;
  }
  @override
  bool get wantKeepAlive => true;


}
