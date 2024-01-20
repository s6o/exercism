import 'package:doubly_linked_list/doubly_linked_list.dart';

void main() {
  final list = DoublyLinkedList()
    ..add(2)
    ..add(4)
    ..add(42);
  print('The initial list $list');
  list
    ..add(36)
    ..add(142);
  print('Appended 2 new elements, the list now is $list');
  list.remove(36);
  print('Removed 36');
  print('Removed an element, the list now is $list');
}
