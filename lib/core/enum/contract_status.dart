// lib/core/enums/contract_status.dart
enum ContractStatus {
  active,
  pendingApproval,
  expired,
  terminated,
  completed,
  unknown;

  static ContractStatus fromString(String? statusString) {
    switch (statusString?.toLowerCase()) {
      case 'active':
        return ContractStatus.active;
      case 'pending_approval':
        return ContractStatus.pendingApproval;
      case 'expired':
        return ContractStatus.expired;
      case 'terminated':
        return ContractStatus.terminated;
      case 'completed':
        return ContractStatus.completed;
      default:
        return ContractStatus.unknown;
    }
  }

  String get value {
    switch (this) {
      case ContractStatus.active:
        return 'active';
      case ContractStatus.pendingApproval:
        return 'pending_approval';
      case ContractStatus.expired:
        return 'expired';
      case ContractStatus.terminated:
        return 'terminated';
      case ContractStatus.completed:
        return 'completed';
      default:
        return 'unknown';
    }
  }

   String get displayName {
    switch (this) {
      case ContractStatus.active:
        return 'Ativo';
      case ContractStatus.pendingApproval:
        return 'Pendente Aprovação';
      case ContractStatus.expired:
        return 'Expirado';
      case ContractStatus.terminated:
        return 'Rescindido';
      case ContractStatus.completed:
        return 'Concluído';
      default:
        return 'Desconhecido';
    }
  }
}
