enum CollectionMode { required, optional, notCollected }

class DataCollection {
  final CollectionMode email;
  final CollectionMode metadata;

  const DataCollection({
    this.email = CollectionMode.optional,
    this.metadata = CollectionMode.optional,
  });
}
