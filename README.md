Hash Ring
=========
A consistent hashing implementation in Dart.

Examples
--------
```dart
import "package:hash_ring/hash_ring.dart";

main() {

  var ring = new HashRing<String>.from([
    new HashRingNode("cache-prod001", 40),
    new HashRingNode("cache-prod002", 40),
    new HashRingNode("cache-prod003", 40),
    new HashRingNode("cache-prod004", 40),
    new HashRingNode("cache-prod005", 40)
  ]);

  print(ring.getNode("user:joseph").get());
  print(ring.getNode("user:carolina").get());
  print(ring.getNode("user:isaiah").get());

}
```

Public Interface
----------------
This libary exports two classes `HashRing` and `HashRingNode`.

HashRing Interface:
```dart
part of hash_ring;

class HashRing<V> {

  /**
   * Typical constructor
   */
  HashRing();

  /**
   * Given an iterable of `HashRingNode`s this populates
   * the initial state of the hash ring
   *
   * @param {Iterable<HashRingNode<V>>} nodes - Initial nodes
   */
  HashRing.from(Iterable<HashRingNode<V>> nodes);

  /**
   * Given a `HashRingNode` we add it to the hash ring
   *
   * @param {HashRingNode<V>} node - The node to add
   * @return {void}
   */
  void addNode(HashRingNode<V> node);

  /**
   * Given a `HashRingNode` remove it from the hash ring
   *
   * @param {HashRingNode<V>} node - The node to remove
   * @return {void}
   */
  void removeNode(HashRingNode<V> node);

  /**
   * Given a string based criteria this function returns the
   * appropriate node from the hash ring
   *
   * @param {String} criteria - The criteria to fetch from
   * @return {Option<V>}      - The optional node
   */
  Option<V> getNode(String criteria);

}
```

HashRingNode Interface:
```dart
class HashRingNode<V> {

  /**
   * Initailizing constructor
   *
   * @param {V} _value    - The nodes value
   * @param {int} _weight - The nodes weight
   */
  HashRingNode(this._value, this._weight);

  /**
   * Getter for the nodes value
   *
   * @return {V} - The nodes value
   */
  V get value => this._value;

  /**
   * Getter for the nodes weight
   *
   * @return {int} - The nodes weight
   */
  int get weight => this._weight;

  /**
   * Getter for the nodes positions
   *
   * @return {List<int>} - The list of positions
   */
  List<int> get positions => this._positions;

}
```