import 'dart:async';
import 'dart:math';

/// In Dart classes are implicit interfaces.
abstract class Observer {
  void update<T>(T changed);
}

/// Provides the base implementation for an Observable.
class Subject {
  final List<Observer> _observers = [];

  /// Register an [Observer].
  void addObserver(Observer observer) {
    _observers.add(observer);
  }

  /// Remove an [Observer] and return removal status.
  bool removeObserver(Observer observer) {
    return _observers.remove(observer);
  }

  void notifyObservers<T>(T value) {
    for (var o in _observers) {
      o.update(value);
    }
  }
}

class ConsolePrint extends Observer {
  @override
  void update<T>(T changed) {
    print(changed.toString());
  }
}

class LottoNumbers extends Subject {
  final Random _rng;
  late final Timer _timer;
  int _total;
  final int count;

  LottoNumbers({required this.count})
      : _rng = Random(),
        _total = 0 {
    _timer = Timer.periodic(Duration(seconds: 1), _generateNumber);
  }

  void _generateNumber(Timer _) {
    notifyObservers(_rng.nextInt(100));
    _total = _total + 1;
    if (_total == count) {
      _timer.cancel();
    }
  }
}
