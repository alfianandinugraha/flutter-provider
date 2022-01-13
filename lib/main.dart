// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter extends ChangeNotifier {
  int _count = 0;
  bool _status = false;

  int get count => _count;
  bool get status => _status;

  void increment() {
    _count = _count + 1;
    notifyListeners();
  }

  void decrement() {
    _count = _count - 1;
    notifyListeners();
  }

  void toggle() {
    _status = !_status;
    notifyListeners();
  }
}

class ThemeModeProvider extends ChangeNotifier {
  ThemeMode _isDark = ThemeMode.dark;

  ThemeMode get isDark => _isDark;

  void toggle() {
    _isDark = _isDark == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => Counter()),
        ChangeNotifierProvider(create: (BuildContext context) => ThemeModeProvider()),
      ],
      child: const App(),  
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Rebuild App");
    return Selector<ThemeModeProvider, ThemeMode>(
      builder: (context, data, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          themeMode: data,
          darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          home: const Home(),
        );
      }, 
      selector: (context, data) => data.isDark
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
            const Count(),
            const SizedBox(height: 21),
            const CountHandler(),
            const SizedBox(height: 21),
            ElevatedButton(
              onPressed: () {
                context.read<Counter>().toggle();
              }, 
              child: Selector<Counter, bool>(
                builder: (context, data, child) {
                  return Text(data ? 'Disabled' : 'Enabled');
                }, 
                selector: (context, data) => data.status
              )
            ),
            SizedBox(height: 21),
            Consumer<ThemeModeProvider>(
              builder: (context, data, child) {
                return OutlinedButton(
                  onPressed: () {
                    context.read<ThemeModeProvider>().toggle();
                    print("Change mode...");
                  },
                  child: const Text("Toggle Theme")
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

class Count extends StatelessWidget {
  const Count({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Rebuild Count...");
    return Text(context.select<Counter, int>((value) => value.count).toString(), style: TextStyle(
      fontSize: Theme.of(context).textTheme.headline3?.fontSize
    ));
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
            onPressed: !data._status ? null : () {
              data.increment();
            },
          );
        }),
        SizedBox(width: 10),
        ElevatedButton(
          child: Text("Decrement"), 
          onPressed: !context.select<Counter, bool>((value) => value.status) ? null : () {
            context.read<Counter>().decrement();    
          }
        )
      ],
    );
  }
}