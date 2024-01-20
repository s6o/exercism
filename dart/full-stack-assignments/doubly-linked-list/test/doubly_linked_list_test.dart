import 'package:doubly_linked_list/doubly_linked_list.dart';
import 'package:test/test.dart';

void main() {
  test('init Node', () {
    expect(Node<int>(data: 42).data, 42);
  });

  test('init Node, properties', () {
    Node node = Node<int>(data: 42);
    expect(node.isFirst, true);
    expect(node.isLast, true);
  });

  test('Empty list', () {
    DoublyLinkedList list = DoublyLinkedList();
    expect(list.toString(), '');
  });

  test('List with single element', () {
    DoublyLinkedList list = DoublyLinkedList(initial: Node(data: 42));
    expect(list.toString(), '42');
  });

  test('Adding to list', () {
    DoublyLinkedList listA = DoublyLinkedList()
      ..add(42)
      ..add(4)
      ..add(2);
    DoublyLinkedList listB = DoublyLinkedList(initial: Node(data: 42))
      ..add(4)
      ..add(2);
    expect(listA.toString(), '42 4 2');
    expect(listB.toString(), '42 4 2');
  });

  test('Removing from empty list', () {
    DoublyLinkedList list = DoublyLinkedList();
    bool wasRemoved = list.remove(42);
    expect(list.toString(), '');
    expect(wasRemoved, false);
  });

  test('Removing single item', () {
    DoublyLinkedList list = DoublyLinkedList(initial: Node(data: 42));
    bool wasRemoved = list.remove(42);
    expect(list.toString(), '');
    expect(wasRemoved, true);
  });

  test('Removing from the head', () {
    DoublyLinkedList list = DoublyLinkedList()
      ..add(42)
      ..add(4)
      ..add(2);
    expect(list.toString(), '42 4 2');
    bool wasRemoved = list.remove(42);
    expect(list.toString(), '4 2');
    expect(wasRemoved, true);
  });

  test('Removing from the tail', () {
    DoublyLinkedList list = DoublyLinkedList()
      ..add(2)
      ..add(4)
      ..add(24);
    expect(list.toString(), '2 4 24');
    bool wasRemoved = list.remove(24);
    expect(list.toString(), '2 4');
    expect(wasRemoved, true);
  });

  test('Removing from the middle', () {
    DoublyLinkedList list = DoublyLinkedList()
      ..add(2)
      ..add(4)
      ..add(24);
    expect(list.toString(), '2 4 24');
    bool wasRemoved = list.remove(4);
    expect(list.toString(), '2 24');
    expect(wasRemoved, true);
  });

  test('Add, remove, add, remove', () {
    DoublyLinkedList list = DoublyLinkedList()
      ..add(2)
      ..add(4)
      ..add(24)
      ..remove(4)
      ..add(42)
      ..add(36)
      ..add(100)
      ..remove(36);
    expect(list.toString(), '2 24 42 100');
  });
}
