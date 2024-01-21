import 'dart:math';
import 'package:merge_sort/merge_sort.dart';
import 'package:test/test.dart';

void main() {
  test('Empty list', () {
    expect(mergeSort([]), []);
  });

  test('Sigle element list', () {
    expect(mergeSort([7]), [7]);
  });

  test('Two element list', () {
    expect(mergeSort([1, 3]), [1, 3]);
    expect(mergeSort([3, 1]), [1, 3]);
  });

  test('Simple three element sort', () {
    var sorted = mergeSort([7, 3, 1]);
    expect(sorted, [1, 3, 7]);
  });

  test('Five element sort', () {
    var sorted = mergeSort([7, 3, 1, 11, 5]);
    expect(sorted, [1, 3, 5, 7, 11]);
  });

  test('Sort multiple items 1', () {
    var sorted = mergeSort([6, 5, 3, 1, 8, 7, 2, 4]);
    expect(sorted, [1, 2, 3, 4, 5, 6, 7, 8]);
  });

  test('Sort multiple items 2', () {
    var sorted = mergeSort([38, 27, 43, 3, 9, 82, 10]);
    expect(sorted, [3, 9, 10, 27, 38, 43, 82]);
  });

  test('Sort multiple items 3', () {
    var sorted = mergeSort([38, 26, 36, 27, 43, 3, 9, 82, 10, 11, 92]);
    expect(sorted, [3, 9, 10, 11, 26, 27, 36, 38, 43, 82, 92]);
  });

  test('Sort random items', () {
    const count = 50;
    var rng = Random();
    List<int> inputA = List.generate(count, (_) => rng.nextInt(1000));
    List<int> inputB = List.generate(count, (i) => inputA[i]);
    inputA.sort();
    expect(inputA, mergeSort(inputB));
  });
}
