/*
 * Copyright (c) 2020 Cookytech Technologies Private Limited.
 * Licensed under the CTPL Shared Source License, Version 1.0 (the "License");
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 * https://gist.github.com/raveesh-me/304e0ff87646204559f08b6c70d7dff3
 */

library responder;

import 'package:responder/src/responder.dart';
import 'package:responder/src/stream_responder.dart';

/// This library contains [Responder] and [StreamResponder]
/// Use `Responder` where you want to return a null from within a build function
///
/// Use `StreamResponder` instead of StreamBuilder and it will cache and handle null likewise.
///
/// `StreamResponder` can inhibit calls to build when null is returned, `Responder` has no way to do so.
export 'src/stream_responder.dart';
export 'src/responder.dart';