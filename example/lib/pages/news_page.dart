import 'package:example/vmbs/news_vmb.dart';
import 'package:flutter/material.dart';
import 'package:vmb/vmb.dart';

class NewsPages extends StatelessWidget {
  const NewsPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsVmb = NewsVmb(NewsState.loading());
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
      ),
      body: VmbBuilder<NewsState, NewsVmb>(
        newsVmb,
        builder: (context, viewModel, child) {
          if (viewModel.value.viewState == ViewState.loading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (viewModel.value.viewState == ViewState.failed) {
            return const Center(
              child: Text("An Error Occurred"),
            );
          }
          final news = viewModel.value.news ?? [];
          return ListView.builder(
            itemCount: news.length,
            itemBuilder: (_, index) => ListTile(
              title: Text(news[index].title),
              subtitle: Text(news[index].description),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(news[index].imageUrl),
              ),
            ),
          );
        },
      ),
    );
  }
}
