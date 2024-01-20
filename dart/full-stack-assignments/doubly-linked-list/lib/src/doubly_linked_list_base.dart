/// A generic list item aka Node, which wrappes a `data` payload.
class Node<T> {
  final T data;
  Node? _next;
  Node? _previous;

  /// Create a free/unbound Node
  Node({required this.data})
      : _next = null,
        _previous = null;

  bool get isFirst => _previous == null;
  bool get isLast => _next == null;
}

/// The doubly-linked list.
class DoublyLinkedList {
  Node? _head;
  Node? _tail;

  DoublyLinkedList({Node? initial})
      : _head = initial,
        _tail = initial;

  /// Create a new [Node] and append it to the list
  void add<T>(T data) {
    if (_head == null) {
      _head = Node(data: data);
      _tail = _head;
    } else {
      final newTail = Node(data: data);
      newTail._previous = _tail;
      _tail!._next = newTail;
      _tail = newTail;
    }
  }

  /// Search for sepecified data from the list's head, remove the first found instance.
  /// Return `true` if a Node was found and removed, otherwise return `false`.
  bool remove<T>(T data) {
    if (_head != null) {
      Node? inspected = _head;
      while (true) {
        // non-POD instances of `T` should implement [Equatable](https://pub.dev/packages/equatable)
        if (inspected!.data == data) {
          if (inspected.isFirst) {
            _head = inspected._next;
            _head?._previous = null;
          }
          if (inspected.isLast) {
            _tail = inspected._previous;
            _tail?._next = null;
          }
          inspected._previous?._next = inspected._next;
          inspected = null;
          return true;
        } else {
          if (inspected._next == null) return false;
          inspected = inspected._next;
        }
      }
    } else {
      return false;
    }
  }

  void printList() => toString();

  @override
  String toString() {
    final List<String> items = [];
    Node? inspected = _head;
    while (inspected != null) {
      items.add(inspected.data.toString());
      inspected = inspected._next;
    }
    return items.join(' ');
  }
}
