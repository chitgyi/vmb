## VMB State Management Package

- This package is inspired by `ValueNotifier`, `InheritedWidget` and `ValueListenableBuilder`.

### Usage

`Vmb` abstract class is used to manage state same as `ChangeNotifier`.

##### Methods

```dart
- onInit() // Called when the widget is initialized.
- onDispose() // Called when the widget is disposed.
- notifyListeners() // notify to UI (optional when you assign to value)
```

If you want to update or notify to UI, you only need to assign to `value` variable that will be automatically updated your UI.

You can easily access your vmb through context.

```dart
// Example
final vmb = VmbProvider.of<NewsVmb>(context);
```

### Example VMB Class

```dart
class MyVmb extends Vmb<String>{
  MyVmb(super.value);

  @override
  void onInit() {
    print('on initialized');
  }

  @override
  void onDispose() {
    print('on dispose');
  }

  void changeValue(String newValue){
    value = newValue; // no need to call notifyListeners()
  }
}
```

![Screen Record](https://github.com/chitgyi/vmb/raw/main/screenshots/example.mp4 "Screen Record")

### Example One

```dart
class HomeVmb<T> extends Vmb<T> {
  HomeVmb(T value) : super(value);

  @override
  void onInit() {
    debugPrint('on init');
    super.onInit();
  }

  @override
  void onDispose() {
    debugPrint('on dispose');
    super.onDispose();
  }
}

// home vmb builder
final homeVmb = HomeVmb<String>("HELLO");
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
)
```

### Example Two

```dart
class NewsVmb extends Vmb<NewsState> {
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

// news vmb builder
 final newsVmb = NewsVmb(NewsState.loading());
VmbBuilder<NewsState, NewsVmb>(
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
)
```
