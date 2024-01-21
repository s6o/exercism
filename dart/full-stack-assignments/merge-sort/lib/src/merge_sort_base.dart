/// In place, non-recursive merge sort with the tradeoff of higher memory usage.
List<int> mergeSort(List<int> items) {
  // List of index pairs (records) of slices aka sublists
  List<(int, int)> slices = [];

  switch (items.length) {
    case 0:
    case 1:
      return items;
    case 2:
      if (items.first <= items.last) {
        return items;
      } else {
        return items.reversed.toList();
      }
    default:
      // initial single item comparison and sort into pair item lists
      int count = items.length;
      int maxIndex = count.isEven ? count - 1 : count - 2;
      for (int i = 0; i <= maxIndex; i = i + 2) {
        slices.add((i, i + 1));
        if (items[i] > items[i + 1]) {
          int buffer = items[i];
          items[i] = items[i + 1];
          items[i + 1] = buffer;
        }
      }
      if (count.isOdd) {
        slices.add((count - 1, count - 1));
      }

      int lft = 0;
      int rgt = 1;
      while (true) {
        int li = slices[lft].$1;
        int ri = slices[rgt].$1;
        // sort/merge slice
        List<int> ordered = [];
        while (true) {
          // check if slice indexes are out of bounds - merge done
          if (li > slices[lft].$2 && ri > slices[rgt].$2) break;
          if (li <= slices[lft].$2 &&
              ri <= slices[rgt].$2 &&
              items[li] > items[ri]) {
            // when slice indexes are valid and pick from the right
            ordered.add(items[ri]);
            ri = ri + 1;
          } else {
            if (li <= slices[lft].$2) {
              // pick from the left, either because its the smaller item or right no longer has items
              ordered.add(items[li]);
              li = li + 1;
            } else {
              // the left no longer has items, check right for reminder
              if (ri <= slices[rgt].$2) {
                ordered.add(items[ri]);
                ri = ri + 1;
              }
            }
          }
        }
        // concat indexes into left slice, remove right slice
        slices[lft] = (slices[lft].$1, slices[rgt].$2);
        slices.removeAt(rgt);
        // copy ordered slice into original items
        for (var (i, v) in ordered.indexed) {
          items[slices[lft].$1 + i] = v;
        }
        if (slices.length == 1) break;
        // find new slice pair
        lft = rgt > slices.length - 1 ? 0 : rgt;
        if (lft < slices.length - 1) {
          rgt = lft + 1;
        } else {
          lft = 0;
          rgt = 1;
        }
      }

      break;
  }

  return items;
}
