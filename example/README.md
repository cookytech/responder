## Examples
Examples for using the Respoder package within your flutter application.


### `Responder`
For the Responder class, we use it just like a `Builder` widget, if we return null from the 
WidgetBuilder, the `Responder`  widget handles it properly.

Follow: [responder_example](./responder_example) for a simple project

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

### `StreamResponder`
It all began when we wanted to show a snackbar in response to a `Stream` event. We were greeted with red screens of death.
Apparently we can not show snackbars when widgets are building, but we did not want to build/rebuild the widget tree.
We just wanted to show the snackbar.

Follow: [stream_responder_example](./stream_responder_example) for a simple project.
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