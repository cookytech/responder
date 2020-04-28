/*
 * Copyright (c) 2020 Cookytech Technologies Private Limited.
 * Licensed under the CTPL Shared Source License, Version 1.0 (the "License");
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 * https://gist.github.com/raveesh-me/304e0ff87646204559f08b6c70d7dff3
 */

import 'package:flutter/material.dart';

class Responder extends StatefulWidget {
  final WidgetBuilder builder;

  const Responder({
    Key key,
    @required this.builder,
  }) : super(key: key);

  @override
  _ResponderState createState() => _ResponderState();
}

class _ResponderState extends State<Responder> {
  Widget _child;

  WidgetBuilder get builder => widget.builder;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final temp = builder(context);
    if (temp != null)
      _child = temp;
    else if (_child == null) _child = Container();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}
