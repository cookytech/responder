/*
 * Copyright (c) 2020 Cookytech Technologies Private Limited.
 * Licensed under the CTPL Shared Source License, Version 1.0 (the "License");
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 * https://gist.github.com/raveesh-me/304e0ff87646204559f08b6c70d7dff3
 */

library responder;

import 'dart:async';
import 'package:flutter/material.dart';

abstract class _StreamResponderBase<T, S> extends StatefulWidget {
  /// Creates a [StreamResponderBase] connected to the specified [stream].
  const _StreamResponderBase({Key key, this.stream}) : super(key: key);

  /// The asynchronous computation to which this builder is currently connected,
  /// possibly null. When changed, the current summary is updated using
  /// [afterDisconnected], if the previous stream was not null, followed by
  /// [afterConnected], if the new stream is not null.
  final Stream<T> stream;

  /// Returns the initial summary of stream interaction, typically representing
  /// the fact that no interaction has happened at all.
  ///
  /// Sub-classes must override this method to provide the initial value for
  /// the fold computation.
  S initial();

  /// Returns an updated version of the [current] summary reflecting that we
  /// are now connected to a stream.
  ///
  /// The default implementation returns [current] as is.
  S afterConnected(S current) => current;

  /// Returns an updated version of the [current] summary following a data event.
  ///
  /// Sub-classes must override this method to specify how the current summary
  /// is combined with the new data item in the fold computation.
  S afterData(S current, T data);

  /// Returns an updated version of the [current] summary following an error.
  ///
  /// The default implementation returns [current] as is.
  S afterError(S current, Object error) => current;

  /// Returns an updated version of the [current] summary following stream
  /// termination.
  ///
  /// The default implementation returns [current] as is.
  S afterDone(S current) => current;

  /// Returns an updated version of the [current] summary reflecting that we
  /// are no longer connected to a stream.
  ///
  /// The default implementation returns [current] as is.
  S afterDisconnected(S current) => current;

  /// Returns a Widget based on the [currentSummary].
  Widget build(BuildContext context, S currentSummary);

  @override
  State<_StreamResponderBase<T, S>> createState() =>
      _StreamResponderBaseState<T, S>();
}

/// State for [StreamResponderBase].
class _StreamResponderBaseState<T, S> extends State<_StreamResponderBase<T, S>> {
  StreamSubscription<T> _subscription;
  S _summary;
  Widget _child;

  @override
  void initState() {
    super.initState();
    _summary = widget.initial();
    _child = widget.build(context, _summary);
    _subscribe();
  }

  @override
  void didUpdateWidget(_StreamResponderBase<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribe();
        _summary = widget.afterDisconnected(_summary);
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => _child;

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.stream != null) {
      _subscription = widget.stream.listen((T data) {
        _summary = widget.afterData(_summary, data);
        final _tempValue = widget.build(context, _summary);
        if (_tempValue == null) return;
        setState(() {
          _child = _tempValue;
        });
      }, onError: (Object error) {
        _summary = widget.afterError(_summary, error);
        final _tempValue = widget.build(context, _summary);
        if (_tempValue == null) return;
        setState(() {
          _child = _tempValue;
        });
      }, onDone: () {
        _summary = widget.afterDone(_summary);
        final _tempValue = widget.build(context, _summary);
        if (_tempValue == null) return;
        setState(() {
          _child = _tempValue;
        });
      });
      _summary = widget.afterConnected(_summary);
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}


/// A substitute to [StreamBuilder] that inhibits build when `null` is returned from
/// the [AsyncWidgetBuilder]. This allows for a plethora of use cases like:
///
/// * Just doing nothing for a certain stream event
/// * Showing a snackbar as a result of a stream event
/// * Showing a dialog as a result of a stream event
/// * Navigating to a new screen as a result of a stream event
/// * Executing a function as a result of a stream event
///
/// From within the build specification of the builder
class StreamResponder<T> extends _StreamResponderBase<T, AsyncSnapshot<T>> {
  /// Creates a new [StreamResponder] that builds itself based on the latest
  /// snapshot of interaction with the specified [stream] and whose build
  /// strategy is given by [builder].
  ///
  /// The [initialData] is used to create the initial snapshot.
  ///
  /// The [builder] must not be null.
  const StreamResponder({
    Key key,
    this.initialData,
    Stream<T> stream,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key, stream: stream);

  /// The build strategy currently used by this builder.
  /// This can return null. Every time this returns null, a build will not take place.
  final AsyncWidgetBuilder<T> builder;

  /// The data that will be used to create the initial snapshot.
  ///
  /// Providing this value (presumably obtained synchronously somehow when the
  /// [Stream] was created) ensures that the first frame will show useful data.
  /// Otherwise, the first frame will be built with the value null, regardless
  /// of whether a value is available on the stream: since streams are
  /// asynchronous, no events from the stream can be obtained before the initial
  /// build.
  final T initialData;

  @override
  AsyncSnapshot<T> initial() =>
      AsyncSnapshot<T>.withData(ConnectionState.none, initialData);

  @override
  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.waiting);

  @override
  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    return AsyncSnapshot<T>.withData(ConnectionState.active, data);
  }

  @override
  AsyncSnapshot<T> afterError(AsyncSnapshot<T> current, Object error) {
    return AsyncSnapshot<T>.withError(ConnectionState.active, error);
  }

  @override
  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.done);

  @override
  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.none);

  @override
  Widget build(BuildContext context, AsyncSnapshot<T> currentSummary) =>
      builder(context, currentSummary);
}
