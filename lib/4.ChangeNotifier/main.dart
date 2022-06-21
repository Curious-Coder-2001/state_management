import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: SliderInheritedNotifer(
        sliderData: sliderData,
        child: Builder(builder: (context) {
          return Column(
            children: [
              Slider(
                value: SliderInheritedNotifer.of(context),
                onChanged: (value) {
                  sliderData.value = value;
                  print('!*!*!*!*!*!');
                },
              ),
              Row(
                children: [
                  Opacity(
                    opacity: SliderInheritedNotifer.of(context),
                    child: Container(
                      color: Colors.deepOrange,
                      height: 200,
                    ),
                  ),
                  Opacity(
                    opacity: SliderInheritedNotifer.of(context),
                    child: Container(
                      color: Colors.blueGrey[700],
                      height: 200,
                    ),
                  )
                ].expandAll().toList(),
              ),
            ],
          );
        }),
      ),
    );
  }
}

extension ExpandAll on Iterable<Widget> {
  Iterable<Widget> expandAll() {
    return map(
      (w) => Expanded(child: w),
    );
  }
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;
  double get value => _value;
  set value(double newValue) {
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

final sliderData = SliderData();

class SliderInheritedNotifer extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifer({
    Key? key,
    required SliderData sliderData,
    required Widget child,
  }) : super(
          child: child,
          key: key,
          notifier: sliderData,
        );

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SliderInheritedNotifer>()?.notifier?.value ?? 0.0;
}
