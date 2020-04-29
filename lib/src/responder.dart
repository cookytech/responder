/*
 * Copyright (c) 2020 Cookytech Technologies Private Limited.
 * Licensed under the CTPL Shared Source License, Version 1.0 (the "License");
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 * https://gist.github.com/raveesh-me/304e0ff87646204559f08b6c70d7dff3
 */

import 'package:flutter/material.dart';

/// A [Builder] class that caches it's subtree and returns the last subtree
/// if the builder function returns null.
/// This is useful **if you want to return null from the build function**
///
/// If the child is null in the beginning, the initial child will automatically become a [Container]
class Responder extends StatefulWidget {
  /// Instance of [WidgetBuilder], a function that takes [BuildContext] and returns a [Widget]
  final WidgetBuilder builder;

  const Responder({
    Key key,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  @override
  _ResponderState createState() => _ResponderState();
}

/// State object corresponding to responder, will cache the subree in a `_child`,
/// and will return the result of:
/// ```
/// widget.builder() ?? _child ?? Container()
/// ```
class _ResponderState extends State<Responder> {
  Widget _child;

  WidgetBuilder get builder => widget.builder;

  @override
  Widget build(BuildContext context) {
    final temp = builder(context);
    if (temp != null)
      _child = temp;
    else if (_child == null) _child = Container();
    return _child;
  }
}
