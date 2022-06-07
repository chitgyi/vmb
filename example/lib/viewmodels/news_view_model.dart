import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:vmb/vmb.dart';

class NewsVmb extends BaseVmb<NewsState> {
  NewsVmb(super.value) {
    _loadNews();
  }

  @override
  void onDispose() {
    // no need to dispose for value which is NewsState
    debugPrint('on dispose');
    super.onDispose();
  }

  void _loadNews() async {
    await Future.delayed(const Duration(seconds: 2));
    final news = List.generate(50, (index) {
      final faker = Faker();
      return News(
        title: faker.person.name(),
        description: faker.lorem.sentence(),
        imageUrl: faker.image.image(
            width: 100, height: 100, keywords: ['news', 'world', 'google']),
      );
    });

    // generate random error
    if (Random().nextBool()) {
      value = NewsState.failed('An Error Occurred');
    } else {
      value = NewsState.success(news);
    }
  }
}

class News {
  final String title;
  final String description;
  final String imageUrl;

  News({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class NewsState {
  final List<News>? news;
  final String? errorMessage;
  final ViewState viewState;

  NewsState({
    this.news,
    this.errorMessage,
    this.viewState = ViewState.loading,
  });

  factory NewsState.loading() => NewsState(
        news: null,
        errorMessage: null,
        viewState: ViewState.loading,
      );

  factory NewsState.failed(String errorMessage) => NewsState(
        news: null,
        errorMessage: errorMessage,
        viewState: ViewState.failed,
      );

  factory NewsState.success(List<News> news) => NewsState(
        news: news,
        errorMessage: null,
        viewState: ViewState.success,
      );
}

enum ViewState { loading, failed, success }
