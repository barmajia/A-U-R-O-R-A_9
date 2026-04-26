import 'package:flutter/foundation.dart';

enum LoadingState { idle, loading, loaded, error }

class LoadingController extends ChangeNotifier {
  LoadingState _state = LoadingState.idle;
  String? _errorMessage;
  dynamic _data;

  LoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  dynamic get data => _data;
  bool get isLoading => _state == LoadingState.loading;
  bool get hasError => _state == LoadingState.error;
  bool get hasData => _data != null;

  void setLoading() {
    _state = LoadingState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void setLoaded(dynamic data) {
    _state = LoadingState.loaded;
    _data = data;
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String message) {
    _state = LoadingState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void reset() {
    _state = LoadingState.idle;
    _data = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> runAsync(Future<dynamic> Function() action) async {
    try {
      setLoading();
      final result = await action();
      setLoaded(result);
    } catch (e) {
      setError(e.toString());
    }
  }
}

class AsyncValue<T> {
  final T? data;
  final String? error;
  final bool isLoading;

  const AsyncValue._({this.data, this.error, this.isLoading = false});

  factory AsyncValue.loading() => const AsyncValue._(isLoading: true);

  factory AsyncValue.data(T data) => AsyncValue._(data: data);

  factory AsyncValue.error(String error) => AsyncValue._(error: error);

  bool get hasData => data != null;
  bool get hasError => error != null;
  bool get isIdle => !isLoading && data == null && error == null;

  R when<R>({
    required R Function(T data) data,
    required R Function(String error) error,
    required R Function() loading,
    R Function()? idle,
  }) {
    if (isLoading) return loading();
    if (hasError) return error(this.error!);
    if (hasData) return data(this.data as T);
    return idle?.call() ?? loading();
  }
}