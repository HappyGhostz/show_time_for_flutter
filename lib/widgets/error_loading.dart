import 'package:flutter/material.dart';

typedef RetryTab =Function();
typedef NoDataTab =Function();

enum LayoutStatus {

  loading,


  noData,

  error,

}

class LoadingAndErrorView extends StatefulWidget{
  LoadingAndErrorView({
    Key key,
    @required this.layoutStatus,
    this.noDataTab,
    this.retryTab
  }):super(key:key);
  final LayoutStatus layoutStatus;
  final NoDataTab noDataTab;
  final RetryTab retryTab;
  @override
  State<StatefulWidget> createState() =>LoadingAndErrorViewState();
}

class LoadingAndErrorViewState extends State<LoadingAndErrorView>{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Stack(
        children: <Widget>[
          _buildLoading(),
        ],
      ),
    );
  }
  Widget _buildLoading(){
    if(widget.layoutStatus==LayoutStatus.loading){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Image.asset("assets/images/loading.gif",
            width: 100,
            height: 100,
            fit: BoxFit.contain,),
          Text('加载中...')
        ],
      );
    }else if(widget.layoutStatus==LayoutStatus.noData){
      return GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/ic_chat_empty.png",
              width: 100,
              height: 100,
              fit: BoxFit.contain,),
            Text('加载失败,请重试!',style: TextStyle(color: Colors.red),)
          ],
        ),
        onTap: widget.retryTab,
      );
    }else if(widget.layoutStatus==LayoutStatus.error){
      return GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/disk_file_no_data.png",
              width: 100,
              height: 100,
              fit: BoxFit.contain,),
            Text('啥也木有,在试一次!',style: TextStyle(color: Colors.blue),)
          ],
        ),
        onTap: widget.noDataTab,
      );
    }

  }
}