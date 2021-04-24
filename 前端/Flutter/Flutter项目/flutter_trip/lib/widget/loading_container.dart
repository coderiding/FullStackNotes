import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover;

  const LoadingContainer({Key key, @required this.isLoading, this.cover = false, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !cover?!isLoading?child:_loadingView: Stack(
      // cover的情况=先放child Widdget，然后判断是否loading，如果是就放loadingview
      children: <Widget>[
        child,
        isLoading ? _loadingView:null
      ],
    );
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
