part of hash_ring;

class HashRing<V> {

  /**
   * Mapping of hash ring position to node value`
   */
  Dictionary<int, V> _positionToValue;

  /**
   * Mapping of node values to node objects
   */
  Dictionary<V, HashRingNode<V>> _valueToNode;

  /**
   * The sorted set of we use as the sparse hash ring
   */
  SortedSet<int> _ring;

  /**
   * Typical constructor
   */
  HashRing() {
    this._positionToValue = new Dictionary<int, V>();
    this._valueToNode     = new Dictionary<V, HashRingNode<V>>();
    this._ring            = new SortedSet<int>((a, b) => a - b);
  }

  /**
   * Given an iterable of `HashRingNode`s this populates
   * the initial state of the hash ring
   *
   * @param {Iterable<HashRingNode<V>>} nodes - Initial nodes
   */
  HashRing.from(Iterable<HashRingNode<V>> nodes) {
    this._positionToValue = new Dictionary<int, V>();
    this._valueToNode     = new Dictionary<V, HashRingNode<V>>();
    this._ring            = new SortedSet<int>((a, b) => a - b);
    for (var node in nodes) {
      this.addNode(node);
    }
  }

  /**
   * Given a `HashRingNode` we add it to the hash ring
   *
   * @param {HashRingNode<V>} node - The node to add
   * @return {void}
   */
  void addNode(HashRingNode<V> node) {
    if (this._valueToNode.containsKey(node.value)) {
      throw "Node already exists in hash ring.";
    }
    this._valueToNode[node.value] = node;

    for (var position in node.positions) {
      this._positionToValue[position] = node.value;
      this._ring.add(position);
    }
  }

  /**
   * Given a `HashRingNode` remove it from the hash ring
   *
   * @param {HashRingNode<V>} node - The node to remove
   * @return {void}
   */
  void removeNode(HashRingNode<V> node) {
    if (this._valueToNode.containsKey(node.value)) {
      throw "Node not in hash ring.";
    }
    this._valueToNode.remove(node.value);

   for (var position in node.positions) {
      Option<V> offset  = this._positionToValue[position];
      Option<V> matched = offset.filter((v) => v == node.value);
      if (matched.nonEmpty()) {
        this._positionToValue.remove(position);
        this._ring.remove(position);
      }
    }
  }

  /**
   * Given a string based criteria this function returns the
   * appropriate node from the hash ring
   *
   * @param {String} criteria - The criteria to fetch from
   * @return {Option<V>}      - The optional node
   */
  Option<V> getNode(String criteria) {
    int hash             = CRC32.compute(criteria);
    Option<int> position = this._ring.getUpperBound(hash).orElse(() {
      return this._ring.min();
    });
    return position.flatMap((k) => this._positionToValue[k]);
  }

}