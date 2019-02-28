import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/widgets/my_draggable.dart';
import 'package:flutter/rendering.dart';

typedef Widget WidgetMaker<T>(BuildContext context, T item);
typedef bool CanAccept(int oldIndex, int newIndex);
typedef void OnDragFinish(int oldIndex, int newIndex);
typedef WidgetAndDelegate WidgetMakerAndDelegate<T>(BuildContext context, T item);

//子widget和拖拽行为包装类
class WidgetAndDelegate {
  final Widget widget;
  final DraggableDelegate delegate;

  WidgetAndDelegate(this.widget, this.delegate);
}

class DragAndDropGridView<T> extends StatefulWidget{
  //数据源
  final List<T> rowsData;
  //子条目
  final WidgetMaker<T> itemBuilder;
  //自定义拖拽行为的子条目
  final WidgetMakerAndDelegate itemBuilderCustom;

  final CanAccept canBeDraggedTo;

  final OnDragFinish onDragFinish;
  final int crossAxisCount;

  final bool providesOwnDraggable;
  // dragElevation is only used if isItemsHaveCustomDraggableBehavior=false.
  // Otherwise, draggable items provide their own elevation/shadow.
  final double dragElevation;

  // Tilt is only used if isItemsHaveCustomDraggableBehavior=false.
  // Otherwise, draggable items provide their own draggable implementation.
  final double tilt;
  DragAndDropGridView({Key key,
    this.rowsData,
    @required this.itemBuilder,
    @required this.canBeDraggedTo,
    this.onDragFinish,
    this.dragElevation = 0.0,
    this.tilt = 0.0,
    @required this.crossAxisCount
  }):providesOwnDraggable=false,itemBuilderCustom=null,super(key : key);

  DragAndDropGridView.withCustomDraggableBehavior(this.rowsData,{
    Key key,@required this.itemBuilderCustom,
    @required this.canBeDraggedTo,
    this.onDragFinish,
    this.dragElevation = 0.0,
    this.tilt = 0.0,
    @required this.crossAxisCount
  }):providesOwnDraggable=false,itemBuilder=null,super(key : key);
  @override
  State<StatefulWidget> createState() =>DragAndDropGridViewState<T>();
}


class DragAndDropGridViewState<T> extends State<DragAndDropGridView<T>>{
  final double _kScrollThreshold = 160.0;
  List<Data<T>> rows = new List<Data<T>>();

  Data<T> draggedData;

  bool shouldScrollUp = false;
  bool shouldScrollDown = false;

  SliverMultiBoxAdaptorElement renderSliverContext;

  ScrollController scrollController = new ScrollController();
  // The height of the item being dragged
  double dragHeight;
  //Index of the item dragged
  int _currentDraggingIndex;
  bool didJustStartDragging = false;

  double _currentScrollPos = 0.0;
  // This corrects the case when the user grabs the card at the bottom, the system will always handle like grabbed on the middle to ensure correct behvior
  double middleOfItemInGlobalPosition = 0.0;

  double offsetToStartOfItem = 0.0;

  double sliverStartPos = 0.0;

  bool isScrolling = false;

  Offset _currentMiddle;
  //Index of the item currently accepting
  int _currentIndex;
  @override
  void initState() {
    super.initState();
    populateRowList();
  }
  @override
  void didUpdateWidget(DragAndDropGridView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    populateRowList();
  }
  populateRowList(){
    List data = widget.rowsData;
    rows = data.map((data){
      return new Data<T>(data);
    }).toList();
  }
  _maybeScroll(){
    if(isScrolling){
      return;
    }
    if(shouldScrollUp){
      if(scrollController.position.pixels==0.0){
        return;
      }
      isScrolling=true;
      var scrollTo = scrollController.offset-12.0;
      scrollController.animateTo(scrollTo, duration: Duration(milliseconds: 74),
          curve: Curves.linear)
      .then((it){
        updatePlaceholder();
        isScrolling=false;
        _maybeScroll();
      });
    }
    if(shouldScrollDown){
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
        return;
      }
      isScrolling=true;
      var scrollTo = scrollController.offset+12.0;
      scrollController.animateTo(scrollTo, duration: Duration(milliseconds: 75), curve: Curves.linear)
      .then((it){
        updatePlaceholder();
        isScrolling=false;
        _maybeScroll();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (BuildContext context3,constraints){
      return new GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: widget.crossAxisCount),
        itemBuilder: (BuildContext context2, int index){
          return _getDraggableGridItem(context2, index, context3);
        },
        controller: scrollController,
        itemCount: rows.length,
      );
    });
  }
  Widget _getDraggableGridItem(BuildContext context2, int index,BuildContext context3){
    WidgetAndDelegate widgetAndDelegate;
    if(widget.providesOwnDraggable){
      widgetAndDelegate = widget.itemBuilderCustom(context2,rows[index].data);
    }else{
      widgetAndDelegate = new WidgetAndDelegate(widget.itemBuilder(context2,rows[index].data), null );
    }
    var draggableListItem = new DraggableGridItem(
      child: widgetAndDelegate.widget,
      custom: widget.providesOwnDraggable,
      key: new ValueKey(rows[index]),
      data: rows[index],
      index: index,
      tilt: widget.tilt,
      delegate: widgetAndDelegate.delegate,
      dragElevation: widget.dragElevation,
      draggedHeight: dragHeight,
      onDragStarted: (double draggedHeight, double globalTopPositionOfDraggedItem){
        _currentDraggingIndex = index;
        RenderBox renderBox = context3.findRenderObject();
        double start = renderBox.localToGlobal(new Offset(0, 0)).dy;
        double end = renderBox.localToGlobal(new Offset(0.0, renderBox.semanticBounds.height)).dy;
        didJustStartDragging=true;
        _currentScrollPos = start;

        middleOfItemInGlobalPosition = globalTopPositionOfDraggedItem + draggedHeight / 2;
        sliverStartPos = start;
        draggedData = rows[index];
        renderSliverContext = context2;
        updatePlaceholder();
        dragHeight = draggedHeight;
        setState(() {
          rows.remove(index);
        });
      },
      onDragCompleted: (){
        _accept(index,draggedData);
      },
      onAccept: (Data data){
        _accept(index, data);
      },
      onMove: (Offset offset){
        if(didJustStartDragging){
          didJustStartDragging=false;
          offsetToStartOfItem = offset.dy-middleOfItemInGlobalPosition;
          _currentScrollPos = offset.dy -offsetToStartOfItem;
        }
        _currentScrollPos = offset.dy - offsetToStartOfItem;
        double screenHeight = MediaQuery.of(context).size.height;
        if(_currentScrollPos<_kScrollThreshold){
          shouldScrollUp=true;
        }else{
          shouldScrollUp=false;
        }
        if(_currentScrollPos>screenHeight-_kScrollThreshold){
          shouldScrollDown=true;
        }else{
          shouldScrollDown=false;
        }
        _maybeScroll();
        updatePlaceholder();
      },
      cancelCallback: (){
        _accept(_currentIndex, draggedData);
      },
    );
    return draggableListItem;
  }
  _accept(int index, Data data){
    if(_currentIndex==null||_currentMiddle==null){
      return;
    }
    setState(() {
      shouldScrollDown =false;
      shouldScrollUp =false;
      data.extraBot=0.0;
      data.extraTop=0.0;
      if(_currentMiddle.dy>_currentScrollPos){
        rows.insert(index, data);
        widget.onDragFinish(_currentDraggingIndex,index);
      }else{
        rows.insert(index+1,data);
        widget.onDragFinish(_currentDraggingIndex,index+1);
      }
      rows.forEach((it){
        it.extraTop=0.0;
        it.extraBot=0.0;
      });
    });
    _complete();
  }
  _complete(){
    shouldScrollDown =false;
    shouldScrollUp =false;
    _currentIndex=null;
    _currentScrollPos=0.0;
    _currentMiddle=null;
    _currentDraggingIndex=null;
    didJustStartDragging=false;
    offsetToStartOfItem=0.0;
    middleOfItemInGlobalPosition = 0.0;
  }
  updatePlaceholder(){
    if(renderSliverContext==null){
      return;
    }
    if(_currentDraggingIndex==null){
      return;
    }
    RenderSliverList it = renderSliverContext.findRenderObject();
    double buffer = sliverStartPos;
    RenderBox currentChild = it.firstChild;
    buffer+=it.childMainAxisPosition(currentChild)+currentChild.size.height;
    while(_currentScrollPos>buffer){
      if(currentChild!=null){
        var bufferChild = it.childAfter(currentChild);
        if(bufferChild==null){
          break;
        }
        currentChild = bufferChild;
        buffer = it.childMainAxisPosition(currentChild) + currentChild.size.height + sliverStartPos;
      }
    }

    assert(currentChild!=null);
    double middle = buffer-currentChild.size.height/2;

    int index = it.indexOf(currentChild);

    if(!widget.canBeDraggedTo(_currentDraggingIndex,index)){
      return;
    }
    _currentMiddle = new Offset(0.0, middle);
    _currentIndex = index;

    setState(() {
      rows.forEach((it){
        it.extraBot=0.0;
        it.extraTop=0.0;
      });
    });

    if(_currentIndex>=rows.length){
      return;
    }

    setState(() {
      if(_currentScrollPos>_currentMiddle.dy){
        rows[_currentIndex].extraBot=dragHeight;
        rows[_currentIndex].extraTop=0.0;
      }else{
        rows[_currentIndex].extraTop=dragHeight;
        rows[_currentIndex].extraBot=0.0;
      }
    });

  }
}

typedef void OnDragStarted(double height, double topPosition);

class DraggableGridItem extends StatelessWidget{
  final Data data;
  final int index;
  final OnDragStarted onDragStarted;
  final VoidCallback onDragCompleted;
  final MyDragTargetAccept<Data> onAccept;
  final ValueChanged<Offset> onMove;
  final VoidCallback cancelCallback;
  final double draggedHeight;
  final Widget child;
  final double tilt;
  final double dragElevation;
  Key myKey;


  final DraggableDelegate delegate;
  final bool custom;
  DraggableGridItem({
    Key key,
    this.data,
    this.index,
    this.onDragStarted,
    this.onDragCompleted,
    this.onAccept,
    this.onMove,
    this.cancelCallback,
    this.draggedHeight,
    this.child,
    this.tilt,
    this.dragElevation,
    this.delegate,
    this.custom
  }):super(key:key);
  @override
  Widget build(BuildContext context) {
    if(custom){
      if(delegate!=null){
        delegate.onMove(onMove);
        delegate.onDragStarted((){
          RenderBox it = context.findRenderObject()as RenderBox;
          onDragStarted(it.size.height,it.localToGlobal(it.semanticBounds.topCenter).dy);
        });
        delegate.onComplete(onDragCompleted);
        delegate.onCancel(cancelCallback);
      }
      return _getGridChild(context);
    }else{
      return new LongPressMyDraggable(
          child: _getGridChild(context),
          key: myKey,
          feedback: _getFeedback(index, context),
          data: data,
          onMove: onMove,
          onDragStarted: (){
            RenderBox it = context.findRenderObject() as RenderBox;
            onDragStarted(it.size.height, it.localToGlobal(it.semanticBounds.topCenter).dy);
          },
          onDragCompleted: onDragCompleted,
          onMyDraggableCanceled: (_,_2){
            cancelCallback();
          },
      );
    }
  }
  Widget _getGridChild(BuildContext context){
    return new MyDragTarget(builder: (BuildContext context, List candidateData, List rejectedData){
      return new Column(
        children: <Widget>[
          SizedBox(
            height: data.extraTop,
          ),
          child,
          SizedBox(
            height: data.extraBot,
          )
        ],
      );
    },
      onAccept: onAccept,
      onWillAccept: (data){
         return true;
      },
    );
  }
  Widget _getFeedback(int index, BuildContext context){
    var maxWidth = MediaQuery.of(context).size.width;
    return new ConstrainedBox(
      constraints: new BoxConstraints(maxWidth: maxWidth),
      child: new Transform(
          transform: new Matrix4.rotationZ(tilt),
          alignment: FractionalOffset.bottomRight,
          child: new Material(
            child: child,
            elevation: dragElevation,
            color: Colors.transparent,
            borderRadius: BorderRadius.zero,
          ),
      ),
    );
  }
}

class Data<T> {
  final T data;
  Color color = Colors.white;

  double extraTop;
  double extraBot;

  Data(this.data, {this.color, this.extraTop = 0.0, this.extraBot = 0.0});
}

class DraggableDelegate {
  VoidCallback onDragStartedListener;

  ValueChanged<Offset> onMoveListener;

  VoidCallback onDragCompleted;

  VoidCallback onCancelListener;

  void cancel() {
    if (onCancelListener != null) {
      onCancelListener();
    }
  }

  void onCancel(VoidCallback listener) {
    onCancelListener = listener;
  }

  void complete() {
    if (onDragCompleted != null) {
      onDragCompleted();
    }
  }

  void onComplete(VoidCallback listener) {
    onDragCompleted = listener;
  }

  void move(Offset offset) {
    if (onMoveListener != null) {
      onMoveListener(offset);
    }
  }

  void onMove(ValueChanged<Offset> listener) {
    onMoveListener = listener;
  }

  void startDrag() {
    if (onDragStartedListener != null) {
      onDragStartedListener();
    }
  }

  void onDragStarted(VoidCallback listener) {
    onDragStartedListener = listener;
  }
}