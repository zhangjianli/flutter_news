import 'package:flutter/material.dart';

class LoadingFooter extends StatelessWidget {
  static const int IDLE = 0;
  static const int LOADING = 1;
  static const int ERROR = 3;

  final int state;

  final VoidCallback retry;

  const LoadingFooter({Key key, this.state: 0, this.retry}) : super(key: key);

  void _handleTab() {
    if (state == ERROR) {
      retry();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _handleTab,
        child: Container(
          child: Center(
            child: state == LOADING
                ? CircularProgressIndicator()
                : Text(state == IDLE ? "" : "Retry"),
          ),
          height: 64.0,
        ));
  }
}
