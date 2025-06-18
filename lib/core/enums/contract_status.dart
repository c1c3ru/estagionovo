enum ContractStatus {
  active,
  pending,
  completed,
  terminated;

  String get displayName {
    switch (this) {
      case ContractStatus.active:
        return 'Ativo';
      case ContractStatus.pending:
        return 'Pendente';
      case ContractStatus.completed:
        return 'Concluído';
      case ContractStatus.terminated:
        return 'Encerrado';
    }
  }

  String get value => name;

  static ContractStatus fromString(String value) {
    return ContractStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ContractStatus.pending,
    );
  }
}
