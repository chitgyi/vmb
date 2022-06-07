import 'dart:math';

import 'package:example/pages/news_page.dart';
import 'package:example/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vmb/vmb.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = HomeVmb<String>("HELLO");
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.value = String.fromCharCodes(
            List.generate(
              10,
              (index) => Random().nextInt(index + 10),
            ),
          );
        },
        child: const Icon(Icons.message),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14.0),
        children: [
          VmbBuilder<String, HomeVmb<String>>(
            viewModel,
            builder: (context, viewModel, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(viewModel.value),
                ),
                const SizedBox(height: 14.0),
                const ReflectableTextWidget(),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Center(child: Text("Vmb State Management Example")),
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NewsPages(),
                ),
              ),
              child: const Text("News Page"),
            ),
          )
        ],
      ),
    );
  }
}

class ReflectableTextWidget extends StatelessWidget {
  const ReflectableTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = VmbProvider.of<HomeVmb<String>>(
      context,
    );
    return Text(viewModel?.value ?? "Default Value");
  }
}
