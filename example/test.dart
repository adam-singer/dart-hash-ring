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