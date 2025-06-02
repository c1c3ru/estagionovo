# Project Structure

## lib/
```
├── app_module.dart                   # Main application module configuration
├── app_widget.dart                   # Root widget with theme and global providers
├── main.dart                         # Entry point
```

## Core Layer
```
├── core/                             # Core functionality
│   ├── constants/                    # App-wide constants
│   │   ├── app_constants.dart
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   ├── theme/                        # Theme configuration
│   │   ├── app_theme.dart
│   │   └── app_text_styles.dart
│   ├── utils/                        # Utility functions
│   │   ├── date_utils.dart
│   │   ├── validators.dart
│   │   └── logger_utils.dart
│   ├── errors/                       # Error handling
│   │   ├── app_exceptions.dart
│   │   └── error_handler.dart
│   └── widgets/                      # Reusable core widgets
│       ├── app_button.dart
│       ├── app_text_field.dart
│       └── loading_indicator.dart
```

## Data Layer
```
├── data/                             # Data layer
│   ├── models/                       # Data models
│   ├── repositories/                 # Data repositories
│   ├── datasources/                  # Data sources
│   │   ├── supabase/                # Supabase integration
│   │   └── local/                   # Local storage
│   └── dto/                         # Data transfer objects
```

## Domain Layer
```
├── domain/                           # Domain layer
│   ├── entities/                     # Business entities
│   ├── usecases/                     # Business logic 
│   │   ├── auth/
│   │   ├── student/
│   │   ├── supervisor/
│   │   └── contract/
│   └── repositories/                 # Repository interfaces
```

## Features Layer
```
└── features/                         # Application features
    ├── auth/                         # Authentication feature
    ├── student/                      # Student feature
    ├── supervisor/                   # Supervisor feature
    └── shared/                       # Shared components
        ├── widgets/
        └── animations/
```

# Implementation Status

## Core Layer
- ✅ All constants files
- ✅ Theme configuration
- ✅ Utility functions
- ✅ Error handling
- ✅ Core widgets
- ✅ Guards
- ✅ Enums

## Data Layer
- ✅ Models
- ✅ Repositories
- ✅ Data sources
- ❌ DTOs (using models instead)

## Domain Layer
- ✅ Entities
- ✅ Repository interfaces
- ✅ Use cases

## Features Layer
- ✅ Authentication
- ✅ Student features
- ✅ Supervisor features
- ✅ Shared components

# Pending Tasks
- [ ] Update enum imports
- [ ] Review AppModule bindings
- [ ] Create unit tests
- [ ] Enhance UI components
- [ ] Implement error handling in UI
- [ ] Test navigation flow
- [ ] Add specific features (online colleagues, student management)
- [ ] Consider i18n
- [ ] Add analytics
- [ ] Performance optimization



II. Camada Core (lib/core/)
core/constants/:

app_constants.dart (ID: core_layer_app_constants_dart)

app_colors.dart (ID: core_layer_app_colors_dart)

app_strings.dart (ID: core_layer_app_strings_dart)

core/theme/:

app_theme.dart (ID: core_layer_app_theme_dart)

app_text_styles.dart (ID: core_layer_app_text_styles_dart)

core/utils/:

date_utils.dart (ID: core_layer_date_utils_dart)

validators.dart (ID: core_layer_validators_dart)

logger_utils.dart (ID: core_layer_logger_utils_dart)

core/errors/:

app_exceptions.dart (ID: core_app_exceptions_dart)

error_handler.dart (ID: core_layer_error_handler_dart)

core/widgets/:

app_button.dart (ID: core_layer_app_button_dart)

app_text_field.dart (ID: core_layer_app_text_field_dart)

loading_indicator.dart (ID: core_layer_loading_indicator_dart)

core/guards/:

auth_guard.dart (ID: core_guard_auth_guard_dart)

role_guard.dart (ID: core_guard_role_guard_dart)

core/enums/:

user_role.dart (ID: core_enum_user_role_dart)

class_shift.dart (ID: core_enum_class_shift_dart)

internship_shift.dart (ID: core_enum_internship_shift_dart)

contract_status.dart (ID: core_enum_contract_status_dart)

III. Camada de Dados (lib/data/)
data/models/:

user_model.dart (ID: data_layer_user_model_dart)

student_model.dart (ID: data_layer_student_model_dart)

supervisor_model.dart (ID: data_layer_supervisor_model_dart)

time_log_model.dart (ID: data_layer_time_log_model_dart)

contract_model.dart (ID: data_layer_contract_model_dart)

data/repositories/ (Implementações Concretas):

auth_repository.dart (ID: data_repository_auth_dart)

student_repository.dart (ID: data_repository_student_dart_v2)

supervisor_repository.dart (ID: data_repository_supervisor_dart)

time_log_repository.dart (ID: data_repository_time_log_dart)

contract_repository.dart (ID: data_repository_contract_dart)

data/datasources/supabase/:

auth_datasource.dart (ID: data_datasource_auth_supabase_dart)

student_datasource.dart (ID: data_datasource_student_supabase_dart)

supervisor_datasource.dart (ID: data_datasource_supervisor_supabase_dart)

time_log_datasource.dart (ID: data_datasource_time_log_supabase_dart)

contract_datasource.dart (ID: data_datasource_contract_supabase_dart)

data/datasources/local/:

cache_manager.dart (ID: data_datasource_cache_manager_dart)

preferences_manager.dart (ID: data_datasource_preferences_manager_dart)

IV. Camada de Domínio (lib/domain/)
domain/entities/:

user_entity.dart (ID: domain_layer_user_entity_dart)

student_entity.dart (ID: domain_layer_student_entity_dart)

supervisor_entity.dart (ID: domain_layer_supervisor_entity_dart)

time_log_entity.dart (ID: domain_layer_time_log_entity_dart)

contract_entity.dart (ID: domain_layer_contract_entity_dart)

domain/repositories/ (Interfaces):

i_auth_repository.dart (ID: domain_layer_i_auth_repository_dart)

i_student_repository.dart (ID: domain_layer_i_student_repository_dart_v2)

i_supervisor_repository.dart (ID: domain_layer_i_supervisor_repository_dart)

i_time_log_repository.dart (ID: domain_layer_i_time_log_repository_dart)

i_contract_repository.dart (ID: domain_layer_i_contract_repository_dart)

domain/usecases/auth/:

login_usecase.dart (ID: domain_usecase_login_dart)

register_usecase.dart (ID: domain_usecase_register_dart)

logout_usecase.dart (ID: domain_usecase_logout_dart)

get_current_user_usecase.dart (ID: domain_usecase_get_current_user_dart)

reset_password_usecase.dart (ID: domain_usecase_reset_password_dart)

update_profile_usecase.dart (ID: domain_usecase_update_profile_dart)

get_auth_state_changes_usecase.dart (ID: domain_usecase_get_auth_state_changes_dart)

domain/usecases/student/:

get_student_details_usecase.dart (ID: domain_usecase_get_student_details_dart)

update_student_profile_usecase.dart (ID: domain_usecase_update_student_profile_dart)

check_in_usecase.dart (ID: domain_usecase_check_in_dart)

check_out_usecase.dart (ID: domain_usecase_check_out_dart)

get_student_time_logs_usecase.dart (ID: domain_usecase_get_student_time_logs_dart)

create_time_log_usecase.dart (ID: domain_usecase_create_time_log_dart)

update_time_log_usecase.dart (ID: domain_usecase_update_time_log_dart)

delete_time_log_usecase.dart (ID: domain_usecase_delete_time_log_dart)

domain/usecases/supervisor/:

get_supervisor_details_usecase.dart (ID: domain_usecase_get_supervisor_details_dart)

get_all_students_for_supervisor_usecase.dart (ID: domain_usecase_get_all_students_for_supervisor_dart)

get_student_details_for_supervisor_usecase.dart (ID: domain_usecase_get_student_details_for_supervisor_dart)

create_student_by_supervisor_usecase.dart (ID: domain_usecase_create_student_by_supervisor_dart)

update_student_by_supervisor_usecase.dart (ID: domain_usecase_update_student_by_supervisor_dart)

delete_student_by_supervisor_usecase.dart (ID: domain_usecase_delete_student_by_supervisor_dart)

get_all_time_logs_for_supervisor_usecase.dart (ID: domain_usecase_get_all_time_logs_for_supervisor_dart)

approve_or_reject_time_log_usecase.dart (ID: domain_usecase_approve_or_reject_time_log_dart)

domain/usecases/contract/:

create_contract_usecase.dart (ID: domain_usecase_create_contract_dart)

get_contract_by_id_usecase.dart (ID: domain_usecase_get_contract_by_id_dart)

get_contracts_for_student_usecase.dart (ID: domain_usecase_get_contracts_for_student_dart)

get_all_contracts_usecase.dart (ID: domain_usecase_get_all_contracts_dart)

update_contract_usecase.dart (ID: domain_usecase_update_contract_dart)

delete_contract_usecase.dart (ID: domain_usecase_delete_contract_dart)

V. Camada de Features (lib/features/)
features/auth/:

bloc/:

auth_bloc.dart (ID: feature_auth_bloc_dart)

auth_event.dart (ID: feature_auth_event_dart)

auth_state.dart (ID: feature_auth_state_dart)

pages/:

login_page.dart (ID: feature_auth_login_page_dart)

register_page.dart (ID: feature_auth_register_page_dart)

forgot_password_page.dart (ID: feature_auth_forgot_password_page_dart)

widgets/:

login_form.dart (ID: feature_auth_login_form_dart)

register_form.dart (ID: feature_auth_register_form_dart)

auth_module.dart (ID: feature_auth_module_dart)

features/student/:

bloc/:

student_bloc.dart (ID: feature_student_bloc_dart_v2)

student_event.dart (ID: feature_student_event_dart_v2)

student_state.dart (ID: feature_student_state_dart)

pages/:

student_home_page.dart (ID: feature_student_home_page_dart)

student_time_log_page.dart (ID: feature_student_time_log_page_dart)

student_profile_page.dart (ID: feature_student_profile_page_dart_v2)

widgets/:

time_tracker_widget.dart (ID: feature_student_time_tracker_widget_dart)

online_colleagues_widget.dart (ID: feature_student_online_colleagues_widget_dart)

student_module.dart (ID: feature_student_module_dart)

features/supervisor/:

bloc/:

supervisor_bloc.dart (ID: feature_supervisor_bloc_dart)

supervisor_event.dart (ID: feature_supervisor_event_dart)

supervisor_state.dart (ID: feature_supervisor_state_dart)

pages/:

supervisor_dashboard_page.dart (ID: feature_supervisor_dashboard_page_dart)

student_details_page.dart (ID: feature_supervisor_student_details_page_dart)

student_edit_page.dart (ID: feature_supervisor_student_edit_page_dart)

supervisor_time_approval_page.dart (ID: feature_supervisor_time_approval_page_dart)

widgets/:

dashboard_summary_cards.dart (ID: feature_supervisor_dashboard_summary_cards_dart)

student_list_widget.dart (ID: feature_supervisor_student_list_widget_dart)

contract_gantt_chart.dart (ID: feature_supervisor_contract_gantt_chart_dart)

supervisor_module.dart (ID: feature_supervisor_module_dart)

features/shared/:

widgets/:

supervisor_app_drawer.dart (ID: supervisor_app_drawer_dart_v2)

supervisor_bottom_nav_bar.dart (ID: supervisor_bottom_nav_bar_dart_v2)

student_app_drawer.dart (ID: student_app_drawer_dart)

student_bottom_nav_bar.dart (ID: student_bottom_nav_bar_dart)

user_avatar.dart (ID: feature_shared_user_avatar_dart)

status_badge.dart (ID: feature_shared_status_badge_dart)

animated_transitions.dart (ID: feature_shared_animated_transitions_dart)

animations/:

lottie_animations.dart (ID: feature_shared_lottie_animations_dart)

loading_animation.dart (ID: feature_shared_loading_animation_dart)

Arquivos Não Criados ou Pendentes (Conforme Checklist Original):

lib/data/datasources/supabase/supabase_client.dart - Decidimos injetar SupabaseClient diretamente.

lib/data/dto/user_dto.dart - Decidimos que os Models atuais servem como DTOs da fonte de dados.

lib/features/student/pages/check_in_out_page.dart - Funcionalidade incorporada em outras páginas/widgets.

lib/features/shared/widgets/user_avatar.dart - CRIADO (ID: feature_shared_user_avatar_dart)

lib/features/shared/widgets/status_badge.dart - CRIADO (ID: feature_shared_status_badge_dart)

lib/features/shared/widgets/animated_transitions.dart - CRIADO (ID: feature_shared_animated_transitions_dart)

lib/features/shared/animations/lottie_animations.dart - CRIADO (ID: feature_shared_lottie_animations_dart)

lib/features/shared/animations/loading_animation.dart - CRIADO (ID: feature_shared_loading_animation_dart)

Nota: A tarefa "Atualizar Imports dos Enums" ainda está pendente e precisa ser realizada manualmente em todos os arquivos que utilizam os enums, para que apontem para os novos caminhos em lib/core/enums/.