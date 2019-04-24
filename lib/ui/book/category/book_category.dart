import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/book_category.dart';
import 'package:show_time_for_flutter/ui/book/category/category_list.dart';

/**
 * @author zcp
 * @date 2019/3/29
 * @Description
 */
class BookCategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookCategoryPageState();
}

class BookCategoryPageState extends State<BookCategoryPage>
    with AutomaticKeepAliveClientMixin {
  BookService _bookService = BookService();
  List<Male> male = [];
  List<Female> female = [];
  List<Picture> picture = [];
  List<Press> press = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    BookCategory bookCategory = await _bookService.getCategoryList();
    male = bookCategory.male;
    female = bookCategory.female;
    picture = bookCategory.picture;
    press = bookCategory.press;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.width / 6;
    final double itemWidth = size.width / 3;
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: <Widget>[
        _buildSliverToBoxAdapter("男生"),
        SliverGrid(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              var maleItem = male[index];
              return _buildGridItem("male",
                  index, male.length, maleItem.name, maleItem.bookCount);
            }, childCount: male.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: (itemWidth / itemHeight))),
        _buildSliverToBoxAdapter("女生"),
        SliverGrid(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              var femaleItem = female[index];
              return _buildGridItem("female",
                  index, female.length, femaleItem.name, femaleItem.bookCount);
            }, childCount: female.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: (itemWidth / itemHeight))),
        _buildSliverToBoxAdapter("Picture"),
        SliverGrid(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              var pictureItem = picture[index];
              return _buildGridItem("picture",index, picture.length, pictureItem.name,
                  pictureItem.bookCount);
            }, childCount: picture.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: (itemWidth / itemHeight))),
        _buildSliverToBoxAdapter("Press"),
        SliverGrid(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              var pressItem = press[index];
              return _buildGridItem("press",
                  index, press.length, pressItem.name, pressItem.bookCount);
            }, childCount: press.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: (itemWidth / itemHeight))),
      ],
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

  Widget _buildGridItem(String category,int index, int length, String name, int bookCount) {
    final BorderSide side =
        BorderSide(color: Colors.grey, width: 1.0, style: BorderStyle.solid);
    Border border;
    var i = length % 3;
    if (i == 0) {
      i = 3;
    }
    if (index < length && index >= length - i) {
      border = Border(
          top: BorderSide.none,
          right: side,
          bottom: BorderSide.none,
          left: BorderSide.none);
    } else {
      border = Border(
          top: BorderSide.none,
          right: side,
          bottom: side,
          left: BorderSide.none);
    }
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return BookCategoryList(categoryType: category,categoryName: name,);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          border: border,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  name,
                  style: TextStyle(
                      color: Color.fromARGB(255, 33, 33, 33), fontSize: 16.0),
                ),
              ),
              Container(
                child: Text(
                  "$bookCount本",
                  style: TextStyle(
                      color: Color.fromARGB(
                        255,
                        114,
                        114,
                        114,
                      ),
                      fontSize: 12.0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
