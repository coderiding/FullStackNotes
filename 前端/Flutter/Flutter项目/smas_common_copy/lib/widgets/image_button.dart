import 'package:flutter/material.dart';

class ImageButton extends StatefulWidget {
  final Image normalImage;
  final Image pressedImage;
  final String title;
  final TextStyle normalStyle;
  final TextStyle pressedStyle;
  final Function onPressed;
  final double padding;

  const ImageButton({
    Key key,
    this.normalImage,
    this.pressedImage,
    this.title, this.normalStyle,
    this.pressedStyle,
    this.onPressed,
    this.padding
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}

class _ImageButtonState extends State<ImageButton> {
  var isPressed = false;

  @override
  Widget build(BuildContext context) {
    double padding = widget.padding == null ? 5 :widget.padding;

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (d){
        setState(() {
          isPressed = true;
        });
      },
      onTapCancel: (){
        setState(() {
          isPressed = false;
        });
      },
      onTapUp: (d) {
        setState(() {
          isPressed = false;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          isPressed ? widget.pressedImage:widget.normalImage,
          widget.title.isNotEmpty ? Padding(padding:EdgeInsets.fromLTRB(0, padding, 0, 0)):Container(),
          widget.title.isNotEmpty ? Text(widget.title,style: isPressed ? widget.pressedStyle : widget.normalStyle,):Container(),
        ],
      ),
    );
  }
}