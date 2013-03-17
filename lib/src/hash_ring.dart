part of hash_ring;

class HashRing<V> {

  Dictionary<int, V> _nodes;
  Dictionary<V, int> _weights;
  SortedSet<int> _ring;

  /**
   * Typical constructor
   */
  HashRing() {
    this._nodes   = new Dictionary<int, V>();
    this._weights = new Dictionary<V, int>();
    this._ring    = new SortedSet<int>((a, b) => a - b);
  }

  /**
   * Given an iterable of `HashRingNode`s this populates
   * the initial state of the hash ring
   *
   * @param {Iterable<HashRingNode<V>>} nodes - Initial nodes
   */
  HashRing.from(Iterable<HashRingNode<V>> nodes) {
    this._nodes   = new Dictionary<int, V>();
    this._weights = new Dictionary<V, int>();
    this._ring    = new SortedSet<int>((a, b) => a - b);
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
    if (this._weights.containsKey(node.value)) {
      throw "Node already exists in hash ring.";
    }
    this._weights[node.value] = node.weight;

    var positions = this._generatePositions(node);
    for (var position in positions) {
      this._nodes[position] = node.value;
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
    if (this._weights.containsKey(node.value)) {
      throw "Node not in hash ring.";
    }
    this._weights.remove(node.value);

    var positions = this._generatePositions(node);
    for (var position in positions) {
      Option<V> offset  = this._nodes[position];
      Option<V> matched = offset.filter((v) => v == node.value);
      if (matched.nonEmpty()) {
        this._nodes.remove(position);
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
    return position.flatMap((k) => this._nodes[k]);
  }

  /**
   * Helper method for generating all the hash ring positions
   * for a given hash ring node
   *
   * @param {HashRingNode<V>} node - The node to get positions for
   * @return {List<int>}           - The list of positions
   */
  List<int> _generatePositions(HashRingNode<V> node) {
    var positions = new List<int>();
    for (int i = 0; i < node.weight; i++) {
      positions.add(CRC32.compute(node.value.concat(i.toString())));
    }
    return positions;
  }
}