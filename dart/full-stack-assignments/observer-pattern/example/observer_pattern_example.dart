import 'package:observer_pattern/observer_pattern.dart';

void main() {
  var _ = LottoNumbers(count: 7)..addObserver(ConsolePrint());
}
