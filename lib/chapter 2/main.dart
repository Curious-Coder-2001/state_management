import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: ApiProvider(
      api: Api(),
      child: const HomePage(),
    ),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueKey textKey = const ValueKey<String?>(null);

  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context).api;
    return Scaffold(
      appBar: AppBar(
        title: Text(api.dateAndTime ?? ''),
      ),
      body: InkWell(
        onTap: () async {
          final dateAndTime = await api.getDateAndTime();
          setState(() {
            textKey = ValueKey(dateAndTime);
          });
        },
        child: SizedBox.expand(
          child: Container(
            color: Colors.blueGrey[900],
            child: DateTimeWidget(key: textKey),
          ),
        ),
      ),
    );
  }
}

class Api {
  String? dateAndTime;

  Future<String> getDateAndTime() {
    return Future.delayed(
      const Duration(seconds: 1),
      () => DateTime.now().toIso8601String(),
    ).then((value) {
      dateAndTime = value;
      return value;
    });
  }
}

class ApiProvider extends InheritedWidget {
  final Api api;
  final String uuid;

  ApiProvider({Key? key, required this.api, required Widget child})
      : uuid = const Uuid().v4(),
        super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    return uuid != oldWidget.uuid;
  }

  static ApiProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        ApiProvider.of(context).api.dateAndTime ?? "Tap on the screen to see magic!)))",
      ),
    );
  }
}
