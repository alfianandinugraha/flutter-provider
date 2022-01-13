// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count = _count + 1;
    notifyListeners();
  }

  void decrement() {
    _count = _count - 1;
    notifyListeners();
  }
}

void main() {
  runApp(const Bootstrap());
}

class Bootstrap extends StatelessWidget {
  const Bootstrap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => Counter(),
      child: App()
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Rebuild Home...");

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<Counter>(builder: (context, data, child) {
              return Text(data._count.toString(), style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline3?.fontSize
              ));
            }),
            SizedBox(height: 21),
            CountHandler()
          ],
        ),
      ),
    );
  }
}

class CountHandler extends StatelessWidget {
  const CountHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Rebuild CounterHandler...");

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<Counter>(builder: (context, data, child) {
          return ElevatedButton(
            child: Text("Increment"),
            onPressed: () {
              data.increment();
            },
          );
        }),
        SizedBox(width: 10),
        ElevatedButton(
          child: Text("Decrement"), 
          onPressed: () {
            context.read<Counter>().decrement();    
          }
        )
      ],
    );
  }
}