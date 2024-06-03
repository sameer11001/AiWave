enum ResearchSource {
  arxiv('arxiv'),
  wikipedia('wiki');

  const ResearchSource(this.name);
  final String name;

  String toKey() => name.toString();

  static ResearchSource fromKey(String key) {
    return ResearchSource.values.firstWhere(
      (element) => element.toKey() == key,
      orElse: () => ResearchSource.arxiv,
    );
  }
}
