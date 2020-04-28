/*
 * Copyright (c) 2020 Cookytech Technologies Private Limited.
 * Licensed under the CTPL Shared Source License, Version 1.0 (the "License");
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 * https://gist.github.com/raveesh-me/304e0ff87646204559f08b6c70d7dff3
 */

import 'dart:async';

class NumberStream {
  /// Controller to send, periodically a number to the stream
  StreamController<int> _controller = StreamController();
  int i = 0;
  
  Stream<int> get numbers => _controller.stream;
  Timer timer;
  init(){
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer timer){
      i++;
      _controller.sink.add(i);
      if(i == 100) timer.cancel();
    });
  }
  cancel(){
    timer.cancel();
  }
  
  dispose(){
    _controller.close();
  }
}