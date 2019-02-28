import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:show_time_for_flutter/widgets/drag_target_move.dart';

const int Trigger = 1;
const int Cancle = 2;
const int SelectAll = 3;
const int Delete = 4;
const int CurrentState = 5;

typedef OnItemBuild = void Function(Size size);

typedef ResultCallBack = bool Function();

typedef IndexCallBack = void Function(int index);

typedef OnActionFinished = int Function(
    List<int> indexes); // 进行数据清除工作，并返回当前list的length

typedef OnItemSelectedChanged = void Function(
    int index, bool isSelected); // 选中状态回调

class CustomDragGrid<T> extends StatefulWidget{
  final SliverGridDelegate delegate;
  final IndexedWidgetBuilder itemBuilder;
  final Function onActionCancled;
  final OnActionFinished onActionFinished;
  final IndexCallBack onItemPressed;
  int itemCount;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final Map<int, Function> actionToken;

  CustomDragGrid({
    Key key,
    @required this.delegate,
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.onActionCancled,
    @required this.onActionFinished,
    @required this.actionToken,
    this.onItemPressed,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() =>CustomDragGridState<T>();
}

class CustomDragGridState<T> extends State<CustomDragGrid<T>> with SingleTickerProviderStateMixin{

  final List<int> selectedItems = []; // 被选中的item的index集合
  final List<int> remainsItems = []; // 删除后将会保留的item的index集合

  Size _itemSize;

  StateSetter _deleteSheetState;

  AnimationController _slideController;
  AnimationController _deleteSheetController;
  Animation<Offset> _deleteSheetAnimation;

  int _oldItemCount;

  bool _needToAnimate = false; // 是否需要进行平移动画
  bool _readyToDelete = false; // 是否是删除状态
  bool _singleDelete = false; // 是否是单独删除状态，长按item触发

  bool _canAccept = false; // 长按删除时，是否移动到了指定位置

  @override
  void initState() {
    super.initState();
    initActionTokenes();
    _slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _deleteSheetController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _deleteSheetAnimation =
        Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(
            CurvedAnimation(
                parent: _deleteSheetController, curve: Curves.easeOut));
  }
  void initActionTokenes() {
    if (!widget.actionToken.containsKey(Trigger)) {
      widget.actionToken[Trigger] = triggerDeleteAction;
    }
    if (!widget.actionToken.containsKey(Cancle)) {
      widget.actionToken[Cancle] = cancleDeleteAction;
    }
    if (!widget.actionToken.containsKey(SelectAll)) {
      widget.actionToken[SelectAll] = selectAllItems;
    }
    if (!widget.actionToken.containsKey(Delete)) {
      widget.actionToken[Delete] = doDeleteAction;
    }
    if (!widget.actionToken.containsKey(CurrentState)) {
      widget.actionToken[CurrentState] = getCurrentState;
    }
  }
  bool getCurrentState() {
    return _readyToDelete;
  }
  @override
  void dispose() {
    super.dispose();
    widget.actionToken.clear();
    _slideController.dispose();
    _deleteSheetController.dispose();
  }
  // 拦截返回按键
  Future<bool> onBackPressed() async {
    if (_readyToDelete) {
      cancleDeleteAction();
      return false;
    }
    return true;
  }

  // 首次触发时，计算item所占空间的大小，用于计算位移动画的位置
  void itemBuildCallBack(Size size) {
    if (_itemSize == null) {
      _itemSize = size;
    }
  }

  // Item选中状态回调 --- 将其从选中item的list中添加或删除
  void onItemSelected(int index, bool isSelected) {
    if (isSelected) {
      selectedItems.add(index);
    } else {
      selectedItems.remove(index);
    }
  }

  // 长按Item触发底部删除条状态回调
  void triggerSingleDelete() {
    _deleteSheetState(() {
      _singleDelete = true;
      _deleteSheetController.forward();
    });
  }

  //未移动至底部删除条，取消单独删除状态
  bool cancleSingleDelete() {
    // 未移动到指定位置时，隐藏底部删除栏，并刷新item状态 --- 移动到指定位置时，只修改item的状态，不刷新布局
    if (!_canAccept) {
      _deleteSheetController.reverse().whenComplete(() {
        _deleteSheetState(() {
          _canAccept = false;
          _singleDelete = false;
        });
      });
    }
    return _canAccept;
  }
  // 移动至底部删除条，删除item，然后取消状态单独删除状态
  void doSingleDelete(int index) {
    _deleteSheetController.reverse().whenComplete(() {
      _deleteSheetState(() {
        _canAccept = false;
        _singleDelete = false;
        selectedItems.add(index);
      });
      doDeleteAction();
    });
  }

  // 触发删除状态，刷新布局，显示可选择的checkbox
  void triggerDeleteAction() {
    setState(() {
      _readyToDelete = true;
    });
  }

  // 将所有item设置为被选中状态
  void selectAllItems() {
    setState(() {
      if (selectedItems.length != widget.itemCount) {
        selectedItems.clear();
        for (int i = 0; i < widget.itemCount; i++) {
          selectedItems.add(i);
        }
      } else {
        selectedItems.clear();
      }
    });
  }

// 取消删除状态，刷新布局
  void cancleDeleteAction() {
    setState(() {
      _readyToDelete = false;
      selectedItems.clear();
      widget.onActionCancled();
    });
  }
  // 删除Item，执行动画，完成后重绘界面
  void doDeleteAction() {
    _readyToDelete = false;
    if (selectedItems.length == 0 || selectedItems.length == widget.itemCount) {
      // 未选中ite或选中了所有item --- 删除item，然后刷新布局，无动画效果
      setState(() {
        widget.itemCount =
            widget.onActionFinished(selectedItems.reversed.toList());
        selectedItems.clear();
      });
    } else {
      // 选中部分item --- 计算需要动画的item，刷新item布局，加入动画控件，然后统一执行动画，结束后刷新布局
      getRemainsItemsList();
      setState(() {
        _needToAnimate = true;
        widget.itemCount =
            widget.onActionFinished(selectedItems.reversed.toList());
      });
      _slideController.forward().whenComplete(() {
        setState(() {
          _slideController.value = 0.0;
          _needToAnimate = false;
          selectedItems.clear();
          remainsItems.clear();
        });
      });
    }
  }
  // 获取将会保留的item的index集合
  void getRemainsItemsList() {
    _oldItemCount = widget.itemCount;
    for (int i = 0; i < _oldItemCount; i++) {
      if (selectedItems.contains(i)) {
        continue;
      }
      remainsItems.add(i);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index){
          bool isSelected = selectedItems.contains(index);

          Animation<Offset> slideAnimation;
          // 需要动画时，添加一个位移动画
          if (_needToAnimate) {
            slideAnimation = createTargetItemSlideAnimation(index);
          }
          return GridItem<T>(
            index,
            _readyToDelete,
            widget.itemBuilder(context, index),
            onItemSelected,
            widget.onItemPressed,
            triggerSingleDelete,
            cancleSingleDelete,
            isSelected,
            slideAnimation,
            onItemBuild: itemBuildCallBack,
          );
        },
          childCount: widget.itemCount,
        ),
        gridDelegate: widget.delegate,
    );
  }
  // 创建指定item的位移动画
  Animation<Offset> createTargetItemSlideAnimation(int index) {
    int startIndex = remainsItems[index];
    if (startIndex != index) {
      Tween<Offset> tween = Tween(
          begin: getTargetOffset(remainsItems[index], index),
          end: Offset(0.0, 0.0));
      return tween.animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    }
    return null;
  }
  // 返回动画的位置
  Offset getTargetOffset(int startIndex, int endIndex) {
    SliverGridDelegateWithFixedCrossAxisCount delegate = widget.delegate;
    int horizionalSeparation = (startIndex % delegate.crossAxisCount) -
        (endIndex % delegate.crossAxisCount);
    int verticalSeparation = (startIndex ~/ delegate.crossAxisCount) -
        (endIndex ~/ delegate.crossAxisCount);

    double dx = (delegate.crossAxisSpacing + _itemSize.width) *
        horizionalSeparation /
        _itemSize.width;
    double dy = (delegate.mainAxisSpacing + _itemSize.height) *
        verticalSeparation /
        _itemSize.width;

    return Offset(dx, dy);
  }
}
class GridItem<T> extends StatefulWidget{
  final int index;

  final bool readyToDelete;

  final Widget child;

  final OnItemSelectedChanged onItemSelectedChanged;

  final IndexCallBack onItemPressed;

  final Function singleDeleteStart;
  final ResultCallBack singleDeleteCancle;

  final Animation<Offset> slideAnimation;

  final OnItemBuild onItemBuild;

  bool _isSelected;

  GridItem(
      this.index,
      this.readyToDelete,
      this.child,
      this.onItemSelectedChanged,
      this.onItemPressed,
      this.singleDeleteStart,
      this.singleDeleteCancle,
      this._isSelected,
      this.slideAnimation,
      {this.onItemBuild});
  @override
  State<StatefulWidget> createState() =>GridItemState();
}

class GridItemState<T> extends State<GridItem<T>> with TickerProviderStateMixin{
  Size _size;

  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    // 获取当前控件的size属性,当渲染完成之后，自动回调,无需unregist
    WidgetsBinding.instance.addPostFrameCallback(onAfterRender);
  }
  @override
  void didUpdateWidget(GridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 获取当前控件的size属性,当渲染完成之后，自动回调,无需unregist
    WidgetsBinding.instance.addPostFrameCallback(onAfterRender);
  }

  void onAfterRender(Duration timeStamp) {
    _size = context.size;
    widget.onItemBuild(_size);
  }
  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<int>(
      data: widget.index,
      child: (_isDragging
          ? Material(
        color: Colors.transparent,
      )
          : buildItemChild()),
      feedback: StatefulBuilder(builder: (context, state) {
        return SizedBox.fromSize(size: _size, child: widget.child);
      }),
      onDragStarted: () {
        setState(() {
          _isDragging = true;
          widget.singleDeleteStart();
        });
      },
      onDragEnd: (details) {
        if (widget.singleDeleteCancle()) {
          _isDragging = false;
        } else {
          setState(() {
            _isDragging = false;
          });
        }
      },
      onDraggableCanceled: (velocity, offset) {
        setState(() {
          _isDragging = false;
          widget.singleDeleteCancle();
        });
      },
    );
  }
  // 若动画不为空，则添加动画控件
  Widget buildItemChild() {
    if (widget.slideAnimation != null) {
      return SlideTransition(
        position: widget.slideAnimation,
        child: widget.child,
      );
    }
    return DragTarget(
        builder: (BuildContext context, List<T> candidateData, List<dynamic> rejectedData){
          return widget.child;
    },
      onWillAccept: (data){
          return true;
      },
      onAccept: (data){
//        doSingleDelete(data);
      },
      onLeave: (data){
//        _canAccept = false;
      },
    );
  }
}