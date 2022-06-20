import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:developer' as devTools show log;

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color color1 = Colors.amber;
  Color color2 = Colors.deepOrange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: AvailableColorsWidget(
        color2: color2,
        color1: color1,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      color1 = colors.getRandomElement();
                    });
                  },
                  child: const Text('Change color 1'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      color2 = colors.getRandomElement();
                    });
                  },
                  child: const Text('Change color 2'),
                ),
              ],
            ),
            const ColorWidget(color: AvailableColors.one),
            const ColorWidget(color: AvailableColors.two)
          ],
        ),
      ),
    );
  }
}

enum AvailableColors { one, two }

class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final Color color1;
  final Color color2;

  AvailableColorsWidget({
    Key? key,
    required this.color1,
    required this.color2,
    required Widget child,
  }) : super(child: child, key: key);

  static AvailableColorsWidget of(
    BuildContext context,
    AvailableColors aspect,
  ) =>
      InheritedModel.inheritFrom<AvailableColorsWidget>(context, aspect: aspect)!;

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    devTools.log('updateShouldNotify');
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorsWidget oldWidget, Set<AvailableColors> dependencies) {
    devTools.log('updateShouldNotifyDependent');

    if (dependencies.contains(AvailableColors.one) && color1 != oldWidget.color1) {
      return true;
    }

    if (dependencies.contains(AvailableColors.one) && color2 != oldWidget.color2) {
      return true;
    }

    return false;
  }
}

class ColorWidget extends StatelessWidget {
  const ColorWidget({Key? key, required this.color}) : super(key: key);

  final AvailableColors color;

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devTools.log('COLOR 1');
        break;
      case AvailableColors.two:
        devTools.log('COLOR 2');
        break;
    }

    final provider = AvailableColorsWidget.of(context, color);

    return Container(
      height: 150,
      color: color == AvailableColors.one ? provider.color1 : provider.color2,
    );
  }
}

List<Color> colors = [
  Colors.amber,
  Colors.black45,
  Colors.blue,
  Colors.brown,
  Colors.deepOrange,
  Colors.green,
  Colors.indigo,
  Colors.lime,
  Colors.red,
  Colors.teal,
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() {
    return elementAt(Random().nextInt(length));
  }
}
