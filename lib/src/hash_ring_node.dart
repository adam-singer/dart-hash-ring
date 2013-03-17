part of hash_ring;

class HashRingNode<V> {

  final V         _value;
  final int       _weight;
  List<int>       _positions;

  /**
   * Initailizing constructor
   *
   * @param {V} _value    - The nodes value
   * @param {int} _weight - The nodes weight
   */
  HashRingNode(this._value, this._weight) {
    this._positions = new List<int>();
    for (int i = 0; i < this._weight; i++) {
      this._positions.add(CRC32.compute(this._value.concat(i.toString())));
    }
  }

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