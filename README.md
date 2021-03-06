# Responder
Stateful builders that accept null returns and avoid rebuild. Useful for listening to streams or providers for things other than builds. Like pushing routes, showing a dialog, etc


## Prologue
It all began when we wanted to show a snackbar in response to a `Stream` event. We were greeted with red screens of death.
Apparently we can not show snackbars when widgets are building, but we did not want to build/rebuild the widget tree.
We just wanted to show the snackbar.


## Method
We took the code from `StreamBuilder` and modified the subscription to call setState only when something changes.
We also cached the subtree so if builder returns null, we do nothing and inhibit the build. This resulted in a working as expected `StreamResponder` widget.

We use provider package a lot and wanted to use the same things with StreamProvider, we have not yet been able to acheive the same results with
`Responder` widget.


### `Responder` -- Not Very Useful at the moment
For the Responder class, we use it just like a `Builder` widget, if we return null from the 
WidgetBuilder, the `Responder`  widget handles it properly.

Follow: (responder_example)[./responder_example] for a simple project

```dart
body: Responder(
        builder: (context) {
          if (i % 10 == 0) {
            return null;
          } else
            return WidgetBody(number: i);
        },
      ),
```

### `StreamResponder` -- Working as Expected, Use with Caution
It all began when we wanted to show a snackbar in response to a `Stream` event. We were greeted with red screens of death.
Apparently we can not show snackbars when widgets are building, but we did not want to build/rebuild the widget tree.
We just wanted to show the snackbar.

Follow: (stream_responder_example)[./stream_responder_example] for a simple project.
```dart
return Scaffold(
      body: StreamResponder(
        initialData: 1,
        stream: numberStream.numbers,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data % 12 == 0) {
            numberStream.cancel();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: Center(
                    child: Text(snapshot.data.toString()),
                  ),
                ),
              ),
            );
            return null;
          }
          return Center(child: Text(snapshot.data.toString()));
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        numberStream.init();
      }),
    );
```

* Use it like you would a StreamBuilder, we have designed the api as close as possible
* You can return a Widget like a normal StreamBuilder and everything will work as expected
* You can return null from the builder, or a `Widget` doing so will inhibit the build, so you can call things related to context 
* **NOTE** Be careful not to call context based things and return a Widget at the same time. We still can not get over the platform rules.
