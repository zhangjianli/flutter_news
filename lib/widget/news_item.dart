import 'package:flutter/material.dart';
import 'package:flutter_news/model/news.dart';

class NewsItem extends StatelessWidget {
  final News news;
  final bool enabled;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final bool selected;

  const NewsItem({Key key,
    this.news,
    this.enabled: true,
    this.onTap,
    this.onLongPress,
    this.selected: false,})
      : assert(news != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      child: new Semantics(
        selected: selected,
        enabled: enabled,
        child: new ConstrainedBox(
            constraints: new BoxConstraints(minHeight: 88.0),
            child: new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: new UnconstrainedBox(
                constrainedAxis: Axis.horizontal,
                child: new SafeArea(
                  top: false,
                  bottom: false,
                  child: new Row(children: children),
                ),
              ),
            )
        ),
      ),
    );
  }
}
