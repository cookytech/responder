/*
 * Copyright (c) 2020 Cookytech Technologies Private Limited.
 * Licensed under the CTPL Shared Source License, Version 1.0 (the "License");
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 * https://gist.github.com/raveesh-me/304e0ff87646204559f08b6c70d7dff3
 */

import 'package:flutter/material.dart';

class Responder extends StatefulWidget {
  final Widget childIfNull;
  final WidgetBuilder builder;

  const Responder({
    Key key,
    @required this.builder,
    @required this.childIfNull,
  }) : super(key: key);

  @override
  _ResponderState createState() => _ResponderState();
}

class _ResponderState extends State<Responder> {
  Widget _child;

  WidgetBuilder get builder => widget.builder;

  Widget get childIfNull => widget.childIfNull;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_child == null) _child ==

    return _child;
  }
}
