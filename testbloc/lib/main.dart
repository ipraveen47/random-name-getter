import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Ensure to import this package
import 'dart:math' as math show Random;

void main() {
  runApp(
    MaterialApp(
      title: 'flutter demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    ),
  );
}

const names = ['foo', 'bar', 'baz'];

// extension to generate random element from a list

extension RandomElement<T> on Iterable<T> {
  T get randomElement => elementAt(math.Random().nextInt(length));
}

// cubit to get random name

class GetName extends Cubit<String?> {
  GetName() : super(null);
  void pickRandomName() => emit(names.randomElement);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final GetName cubit;

  @override
  void initState() {
    super.initState();
    cubit = GetName();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random name Generator using cubit'),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final button = TextButton(
            onPressed: () {
              cubit.pickRandomName();
            },
            child: const Text('Pick a random Name'),
          );

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data ?? ''),
                  button,
                ],
              );
            case ConnectionState.done:
              return button;
            default:
              return button;
          }
        },
      ),
    );
  }
}
