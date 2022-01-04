import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Socket extends StatefulWidget {
  const Socket({Key? key}) : super(key: key);

  final String title = "Socket";

  @override
  _SocketState createState() => _SocketState();
}

class _SocketState extends State<Socket> {
  final TextEditingController _textEditingController = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  void sendMessage() {
    if (_textEditingController.text.isNotEmpty) {
      _channel.sink.add(_textEditingController.text);
      _textEditingController.clear();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    filled: true,
                    fillColor: Colors.white60,
                    contentPadding: EdgeInsets.all(15.0),
                    hintText: 'Message')),
            const SizedBox(
              height: 20.0,
            ),
            OutlinedButton(
                onPressed: () {
                  if (_textEditingController.text.isEmpty) {
                    return;
                  }

                  sendMessage();
                },
                child: const Text('Send Message')),
            StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                  );
                })
          ],
        ),
      ),
    );
  }
}
