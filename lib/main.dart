import 'dart:ffi';
import 'package:bloc_pattern/counter_bloc.dart';
import 'package:bloc_pattern/counter_event.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox('data');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _blocpattern = CounterBloc();
  @override
  Widget build(BuildContext context) {
    int idata = Hive.box('data').get(1);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: StreamBuilder(stream: _blocpattern.counter, initialData: idata,builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                    final contactsBox = Hive.box('data');
                    contactsBox.put(1,snapshot.data!=null?snapshot.data:0);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'You have pushed the button this many times:',
                        ),
                        Text(
                          '${contactsBox.get(1)}',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    );
                  })
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: ()=>_blocpattern.counterEventSink.add(IncrementEvent()),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(width: 10,),
          FloatingActionButton(
            onPressed: ()=>_blocpattern.counterEventSink.add(DecrementEvent()),
            tooltip: 'Increment',
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}