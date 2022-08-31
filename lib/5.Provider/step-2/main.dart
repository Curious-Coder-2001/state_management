import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

@immutable
class BaseObject {
  final String id;
  final String lastUpdated;

  BaseObject()
      : id = const Uuid().v4(),
        lastUpdated = DateTime.now().toIso8601String();

  @override
  bool operator ==(covariant BaseObject other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class ExpensiveObject extends BaseObject {}

@immutable
class CheapObject extends BaseObject {}

class ObjectProvider extends ChangeNotifier {
  late String id;
  late CheapObject _cheapObject;
  late StreamSubscription _cheapStreamSubs;
  late ExpensiveObject _expensiveObject;
  late StreamSubscription _expensiveStreamSubs;

  CheapObject get cheapObject => _cheapObject;
  ExpensiveObject get expensiveObject => _expensiveObject;

  void start() {
    _cheapStreamSubs = Stream.periodic(
      const Duration(seconds: 1),
    ).listen((event) {
      _cheapObject = CheapObject();
      notifyListeners();
    });
    _expensiveStreamSubs = Stream.periodic(
      const Duration(seconds: 5),
    ).listen((event) {
      _expensiveObject = ExpensiveObject();
      notifyListeners();
    });
  }

  void stop() {
    _cheapStreamSubs.cancel();
    _expensiveStreamSubs.cancel();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Bar Title'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}
