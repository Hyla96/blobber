import 'dart:async';

class ViewModel {
  final List<StreamSubscription> subscriptions = [];

  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
  }
}
