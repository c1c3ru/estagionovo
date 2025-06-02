Documentação do Projeto: Gestão de Estágios e Bolsistas
Versão do Documento: 1.0
Data da Última Atualização: 2 de junho de 2025
Nome do Projeto: estagio (ou conforme definido no pubspec.yaml)

1. Visão Geral do Projeto
1.1. Propósito
O aplicativo "Gestão de Estagiários e Bolsistas" visa simplificar e otimizar o acompanhamento e gestão de programas de estágio e bolsa, oferecendo uma plataforma unificada para estudantes, supervisores e, potencialmente, administradores.

1.2. Metas Principais
Simplificar o gerenciamento: Fornecer uma interface intuitiva para registo de horas, acompanhamento de contratos e visualização de dados.

Aumentar a produtividade dos supervisores: Oferecer ferramentas de visualização, filtros e gestão para facilitar a tomada de decisões.

Melhorar a experiência dos estagiários: Interface moderna e amigável para registo de horários e consulta de informações contratuais.

Conformidade: Auxiliar no cumprimento das regulamentações de estágio (ex: Lei 11.788/2008 no Brasil).

1.3. Público-Alvo
Estudantes/Bolsistas: Utilizadores que precisam de registar as suas horas e acompanhar o seu progresso e contrato.

Supervisores: Profissionais responsáveis por acompanhar, gerir e aprovar as atividades e horas dos estudantes.

(Potencial) Administradores: Utilizadores com permissões para gerir configurações globais, outros supervisores, etc.

2. Arquitetura do Sistema
O projeto adota uma arquitetura em camadas, inspirada nos princípios da Clean Architecture, para promover a separação de responsabilidades, testabilidade e manutenibilidade.

2.1. Camadas Principais
Core (lib/core/): Contém funcionalidades transversais, independentes da lógica de negócio específica.

Constantes (cores, strings, valores fixos).

Temas (configuração visual da aplicação).

Utilitários (funções auxiliares genéricas, ex: formatação de data, validadores).

Tratamento de Erros (exceções personalizadas, handlers).

Widgets de UI base reutilizáveis (botões, campos de texto genéricos).

Guards de Rota (para flutter_modular).

Enums Globais.

Data (lib/data/): Responsável pela obtenção e armazenamento de dados.

Models: Representações dos dados como vêm da fonte (ex: JSON do Supabase). São os DTOs (Data Transfer Objects) da fonte de dados.

Datasources: Abstrações diretas sobre as fontes de dados (ex: Supabase API, SharedPreferences, Cache em memória). Lidam com a comunicação com o backend ou armazenamento local.

Repositories (Implementações): Implementam as interfaces definidas na camada de Domínio. Coordenam dados de um ou mais datasources, realizam o mapeamento entre Models (Data) e Entities (Domain), e tratam exceções específicas da fonte de dados, convertendo-as para falhas genéricas do domínio.

Domain (lib/domain/): O coração da aplicação, contendo a lógica de negócio e regras. É independente de qualquer framework de UI ou detalhes de implementação da camada de dados.

Entities: Representações puras dos objetos de negócio principais. Não contêm lógica de UI ou de acesso a dados.

Repositories (Interfaces): Contratos (interfaces abstratas) que definem as operações de dados que os casos de uso necessitam. As implementações estão na camada de Dados.

Usecases (Casos de Uso): Encapsulam lógicas de aplicação específicas. Coordenam o fluxo de dados entre a camada de apresentação (BLoCs) e os repositórios. Cada usecase representa uma ação atómica do sistema.

Features (lib/features/): Módulos funcionais da aplicação, organizados por funcionalidade (ex: auth, student, supervisor). Cada feature contém:

Presentation (BLoC/Cubit): Lógica de apresentação e gestão de estado (bloc/, event/, state/).

UI (Pages/Widgets): Telas (pages/) e widgets específicos da feature (widgets/).

Module (Flutter Modular): Configuração de rotas e injeção de dependências para a feature.

Shared (lib/features/shared/): Componentes de UI (widgets) e animações que são reutilizáveis por múltiplas features, mas que podem ter um pouco mais de contexto da aplicação do que os core/widgets.

2.2. Tecnologias e Padrões
Linguagem: Dart

Framework: Flutter

Backend: Supabase (Autenticação, Base de Dados PostgreSQL, Realtime, Storage)

Gestão de Estado: BLoC/Cubit

Injeção de Dependência e Roteamento: Flutter Modular

Tratamento de Erros Funcional: Pacote dartz (para Either).

Imutabilidade: Uso de Equatable para entidades e estados, e classes com campos final.

3. Estrutura de Pastas Detalhada
lib/
├── app_module.dart        # Configuração principal do módulo da aplicação (Modular)
├── app_widget.dart        # Widget raiz da aplicação (MaterialApp.router)
├── main.dart              # Ponto de entrada da aplicação
│
├── core/                  # Funcionalidades e utilitários transversais
│   ├── constants/         # Constantes globais (cores, strings, etc.)
│   ├── enums/             # Enumerações globais (UserRole, Status, etc.)
│   ├── errors/            # Exceções personalizadas e handlers de erro
│   ├── guards/            # RouteGuards para Flutter Modular
│   ├── theme/             # Configuração de tema da aplicação
│   ├── utils/             # Funções utilitárias genéricas
│   └── widgets/           # Widgets de UI base e reutilizáveis
│
├── data/                  # Camada de acesso e manipulação de dados
│   ├── datasources/       # Abstração das fontes de dados
│   │   ├── local/         # Fontes de dados locais (SharedPreferences, Cache)
│   │   └── supabase/      # Fontes de dados do Supabase (interação com API)
│   ├── models/            # Modelos de dados (DTOs - como os dados vêm da fonte)
│   └── repositories/      # Implementações concretas dos repositórios do domínio
│
├── domain/                # Camada de lógica de negócio (independente de UI e dados)
│   ├── entities/          # Objetos de negócio puros
│   ├── repositories/      # Interfaces (contratos) dos repositórios
│   └── usecases/          # Casos de uso específicos da aplicação
│
├── features/              # Módulos funcionais da aplicação
│   ├── auth/              # Funcionalidade de autenticação
│   │   ├── presentation/
│   │   │   ├── bloc/      # BLoC, Eventos, Estados de autenticação
│   │   │   ├── pages/     # Telas de Login, Registo, etc.
│   │   │   └── widgets/   # Widgets específicos para formulários de auth
│   │   └── auth_module.dart # Módulo de autenticação (Modular)
│   ├── student/           # Funcionalidades do perfil de Estudante
│   │   ├── presentation/
│   │   │   ├── bloc/
│   │   │   ├── pages/
│   │   │   └── widgets/
│   │   └── student_module.dart
│   ├── supervisor/        # Funcionalidades do perfil de Supervisor
│   │   ├── presentation/
│   │   │   ├── bloc/
│   │   │   ├── pages/
│   │   │   └── widgets/
│   │   └── supervisor_module.dart
│   └── shared/            # Componentes reutilizáveis entre features
│       ├── animations/    # Animações Lottie, etc.
│       └── widgets/       # Widgets de UI compartilhados (ex: UserAvatar, StatusBadge)
│
└── (outras pastas como test/, assets/, etc. na raiz do projeto)

4. Esquema da Base de Dados (Supabase PostgreSQL)
As tabelas principais incluem:

users: Informações básicas de utilizador ligadas ao auth.users do Supabase, incluindo id, email, role, is_active, created_at, updated_at.

students: Detalhes específicos dos estudantes, como full_name, registration_number, course, datas de contrato, horas, etc. Ligada a users.id.

supervisors: Detalhes específicos dos supervisores, como full_name, department, position. Ligada a users.id.

time_logs: Registos de entrada/saída dos estudantes, incluindo student_id, log_date, check_in_time, check_out_time, hours_logged, approved, supervisor_id.

contracts: Informações sobre os contratos dos estudantes, como student_id, supervisor_id, start_date, end_date, status, contract_type.

Segurança: São utilizadas Políticas de Segurança em Nível de Linha (RLS) para controlar o acesso aos dados com base no auth.uid() e no role do utilizador.

(Para o esquema SQL detalhado, consulte o artefato schema_sql_completo_v2)

5. Funcionalidades Principais
5.1. Para Estudantes
Autenticação (Login, Registo, Recuperação de Senha).

Dashboard com resumo do progresso, horas, contrato.

Registo de Ponto (Check-in/Check-out).

Visualização e gestão manual de Registos de Tempo.

Visualização e edição do Perfil.

(Potencial) Visualização de colegas online.

5.2. Para Supervisores
Autenticação.

Dashboard com estatísticas gerais, lista de estudantes e visualização de contratos (Gantt).

Filtros para a lista de estudantes.

Visualização de detalhes de cada estudante (perfil, logs, contratos).

Criação e edição de perfis de estudantes.

Aprovação/Rejeição de Registos de Tempo dos estudantes.

(Potencial) Gestão de Contratos (criar, editar).

6. Configuração do Ambiente de Desenvolvimento
Flutter SDK: Certifique-se de ter o Flutter SDK instalado numa versão compatível (ver environment: sdk: no pubspec.yaml).

IDE: Android Studio ou Visual Studio Code com as extensões Flutter e Dart.

Supabase Account: Crie uma conta e um projeto no Supabase.

Supabase CLI (Opcional, mas recomendado): Para gestão de migrações de base de dados e desenvolvimento local.

Variáveis de Ambiente Supabase:

Obtenha a URL do projeto e a ANON KEY do seu projeto Supabase.

Forneça estas chaves ao executar a aplicação via --dart-define:

flutter run --dart-define=SUPABASE_URL=SUA_URL_AQUI --dart-define=SUPABASE_ANON_KEY=SUA_CHAVE_ANON_AQUI

Para builds de produção, configure estas variáveis de ambiente no seu sistema de CI/CD.

Dependências Flutter: Execute flutter pub get na raiz do projeto para instalar todas as dependências listadas no pubspec.yaml.

Esquema da Base de Dados: Execute o script SQL (artefato schema_sql_completo_v2) no editor SQL do seu projeto Supabase para criar as tabelas, funções e políticas RLS.

7. Pontos de Integração com API (Supabase)
Autenticação: Utiliza supabase.auth.signInWithPassword, supabase.auth.signUp, supabase.auth.signOut, supabase.auth.resetPasswordForEmail, supabase.auth.updateUser, supabase.auth.onAuthStateChange.

Base de Dados: Utiliza supabase.from('nome_tabela').select(), .insert(), .update(), .delete(), .eq(), .ilike(), .maybeSingle(), .single(), etc., para operações CRUD nas tabelas.

Realtime (Potencial): Para funcionalidades como "colegas online", pode usar supabase.channel(...).on(...).subscribe().

8. Documentação de Código (DartDoc)
Recomenda-se o uso extensivo de comentários DartDoc (///) para documentar classes, métodos, parâmetros e propriedades importantes em todo o código. Isso facilita a compreensão e a manutenção do projeto.
Exemplo:

/// Representa uma entidade de utilizador no domínio da aplicação.
class UserEntity extends Equatable {
  final String id;

  /// Cria uma instância de [UserEntity].
  ///
  /// O [id] é obrigatório e representa o identificador único do utilizador.
  const UserEntity({required this.id, /* ... */});
}

9. Considerações Futuras e Pontos em Aberto (Baseado no PRD)
Notificações Push: Para lembretes de expiração de contrato, ações do supervisor (requer integração com FCM ou similar).

Geração de Relatórios: Exportação de relatórios de horas ou status de contrato para supervisores.

Migração de Dados: Se estiver a substituir um sistema existente.

Suporte Multi-idioma (i18n).

Analytics de Uso da Aplicação.

Validação de Geolocalização para registo de ponto.

Integração com Sistemas Acadêmicos.

Níveis de Acesso de Supervisor mais granulares.

Requisitos de Conformidade Legal detalhados para relatórios.

Este documento deve ser mantido atualizado à medida que o projeto evolui.
