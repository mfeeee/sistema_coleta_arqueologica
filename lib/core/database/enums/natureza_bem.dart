enum NaturezaBem {
  bemArqueologico('Bem Arqueológico'),
  bemPaleontologico('Bem Paleontológico');

  const NaturezaBem(this.label);
  final String label;

  static NaturezaBem fromString(String value) =>
      NaturezaBem.values.firstWhere((e) => e.name == value);
}
