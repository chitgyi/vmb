import 'dart:math';

import 'package:example/pages/news_page.dart';
import 'package:example/vmbs/home_vmb.dart';
import 'package:flutter/material.dart';
import 'package:vmb/vmb.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeVmb = HomeVmb<String>("HELLO");
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          homeVmb.value = String.fromCharCodes(
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
            homeVmb,
            builder: (context, vmb, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(vmb.value),
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
    final homeVmb = VmbProvider.of<HomeVmb<String>>(
      context,
    );
    return Text(homeVmb?.value ?? "Default Value");
  }
}
