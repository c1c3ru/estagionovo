enum ContractStatus {
  active('active', 'Ativo'),
  inactive('inactive', 'Inativo'),
  pending('pending', 'Pendente'),
  completed('completed', 'Concluído'),
  cancelled('cancelled', 'Cancelado');

  const ContractStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static ContractStatus fromString(String value) {
    return ContractStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ContractStatus.pending,
    );
  }

  @override
  String toString() => value;
}

