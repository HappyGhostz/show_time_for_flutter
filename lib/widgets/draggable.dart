import 'package:flutter/material.dart';

typedef DismissDirectionCallback = void Function(DismissDirection direction);
typedef DragTargetLeave<T> = void Function(T data);
typedef DragTargetWillAccept<T> = bool Function(T data);
typedef DragTargetAccept<T> = void Function(T data);
typedef VoidCallback = void Function();
typedef DraggableCanceledCallback = void Function(Velocity velocity, Offset offset);

class DraggableDecorator<T> extends StatefulWidget{
  DraggableDecorator({Key key, @required this.child,@required this.feedbackChild,
    this.data,this.isDismissable, this.dissMissKey,this.onDismissed,this.onLeave,
    this.onWillAccept,this.onAccept,this.childWhenDragging,this.onDragStarted,
    this.onDraggableCanceled,this.onDragCompleted}):super(key:key);
  T data;
  Widget child;
  Widget feedbackChild;
  Widget childWhenDragging;
  bool isDismissable;
  String dissMissKey;
  DismissDirectionCallback onDismissed;
  DragTargetLeave<T> onLeave;
  DragTargetWillAccept<T> onWillAccept;
  DragTargetAccept<T> onAccept;
  VoidCallback onDragStarted;
  DraggableCanceledCallback onDraggableCanceled;
  VoidCallback onDragCompleted;
  @override
  State<StatefulWidget> createState() =>DraggableDecoratorState();
}

class DraggableDecoratorState extends State<DraggableDecorator>{
  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: widget.data,
      child: DragTarget(
        builder: (context, candidateData, rejectedData){
          if(widget.isDismissable){
            return
              Dismissible(key: new Key(widget.dissMissKey),
                child: widget.child,
                background: new Container(
                  margin: EdgeInsets.all(12.0),
                  color: Colors.red,
                ),
                onDismissed: widget.onDismissed,
              );
          }else{
            return widget.child;
          }
        },
        onLeave: widget.onLeave,
        onWillAccept: widget.onWillAccept,
        onAccept: widget.onAccept,
      ),
      feedback: widget.feedbackChild,
      childWhenDragging:widget.childWhenDragging,
      onDragStarted: widget.onDragStarted,
      onDraggableCanceled: widget.onDraggableCanceled,
      onDragCompleted: widget.onDragCompleted,
    );
  }
}