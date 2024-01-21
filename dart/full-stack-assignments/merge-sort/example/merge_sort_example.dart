import 'dart:math';
import 'package:merge_sort/merge_sort.dart';

void main() {
  var rng = Random();
  const count = 30;
  List<int> unsorted = List.generate(count, (_) => rng.nextInt(1000));
  print('Random $count item list:');
  print('\t$unsorted');
  print('Sorted $count item list:');
  print('\t${mergeSort(unsorted)}');
}
