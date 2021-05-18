import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smas_common_copy/widgets/image_button.dart';

class SimpleImageButton extends StatefulWidget {
  final String normalImage;
  final String pressedImage;
  final Function onPressed;
  final double width;
  final String title;

  const SimpleImageButton({Key key, this.normalImage, this.pressedImage, this.onPressed, this.width, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _SimpleImageButtonState extends State<SimpleImageButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ImageButton(
      normalImage: Image(
        image: AssetImage(widget.normalImage),
        width: widget.width,
        height: widget.width,
        fit: BoxFit.fitWidth,
      ),
      pressedImage: Image(
        image: AssetImage(widget.pressedImage),
        width: widget.width,
        height: widget.width,
        fit: BoxFit.fitWidth,
      ),
      title: widget.title == null ? '':widget.title,
      normalStyle: TextStyle(
        color: Colors.black,fontSize: 14,decoration: TextDecoration.none),
      pressedStyle: TextStyle(
        color: Colors.black,fontSize: 14,decoration: TextDecoration.none),
      onPressed: widget.onPressed,
    );
  }
}
