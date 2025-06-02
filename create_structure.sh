#!/bin/bash

# Cria a estrutura de diretórios e arquivos para o projeto Flutter
mkdir -p lib/core/{constants,theme,utils,errors,widgets}
mkdir -p lib/data/{models,repositories,datasources/{supabase,local},dto}
mkdir -p lib/domain/{entities,usecases/{auth,student,supervisor,contract},repositories}
mkdir -p lib/features/{auth/{bloc,pages,widgets},student/{bloc,pages,widgets},supervisor/{bloc,pages,widgets},shared/{widgets,animations}}

# Arquivos raiz
touch lib/app_module.dart
touch lib/app_widget.dart
touch lib/main.dart

# Core
touch lib/core/constants/{app_constants.dart,app_colors.dart,app_strings.dart}
touch lib/core/theme/{app_theme.dart,app_text_styles.dart}
touch lib/core/utils/{date_utils.dart,validators.dart,logger_utils.dart}
touch lib/core/errors/{app_exceptions.dart,error_handler.dart}
touch lib/core/widgets/{app_button.dart,app_text_field.dart,loading_indicator.dart}

# Data Layer
touch lib/data/models/{user_model.dart,student_model.dart,supervisor_model.dart,time_log_model.dart,contract_model.dart}
touch lib/data/repositories/{auth_repository.dart,student_repository.dart,supervisor_repository.dart,time_log_repository.dart,contract_repository.dart}
touch lib/data/datasources/supabase/{supabase_client.dart,auth_datasource.dart,student_datasource.dart,supervisor_datasource.dart,time_log_datasource.dart,contract_datasource.dart}
touch lib/data/datasources/local/{cache_manager.dart,preferences_manager.dart}
touch lib/data/dto/user_dto.dart

# Domain Layer
touch lib/domain/entities/{user.dart,student.dart,supervisor.dart,time_log.dart,contract.dart}
touch lib/domain/usecases/auth/{login_usecase.dart,register_usecase.dart,logout_usecase.dart}
touch lib/domain/usecases/student/{get_student_usecase.dart,update_student_usecase.dart,check_in_usecase.dart,check_out_usecase.dart}
touch lib/domain/usecases/supervisor/{get_all_students_usecase.dart,filter_students_usecase.dart,manage_student_usecase.dart}
touch lib/domain/usecases/contract/{get_contracts_usecase.dart,update_contract_usecase.dart}
touch lib/domain/repositories/{i_auth_repository.dart,i_student_repository.dart,i_supervisor_repository.dart,i_time_log_repository.dart,i_contract_repository.dart}

# Features
touch lib/features/auth/{auth_module.dart}
touch lib/features/auth/bloc/{auth_bloc.dart,auth_event.dart,auth_state.dart}
touch lib/features/auth/pages/{login_page.dart,register_page.dart,forgot_password_page.dart}
touch lib/features/auth/widgets/{login_form.dart,register_form.dart}

touch lib/features/student/{student_module.dart}
touch lib/features/student/bloc/{student_bloc.dart,student_event.dart,student_state.dart}
touch lib/features/student/pages/{student_home_page.dart,check_in_out_page.dart,student_profile_page.dart}
touch lib/features/student/widgets/{time_tracker_widget.dart,online_colleagues_widget.dart}

touch lib/features/supervisor/{supervisor_module.dart}
touch lib/features/supervisor/bloc/{supervisor_bloc.dart,supervisor_event.dart,supervisor_state.dart}
touch lib/features/supervisor/pages/{supervisor_dashboard_page.dart,student_details_page.dart,student_edit_page.dart}
touch lib/features/supervisor/widgets/{dashboard_summary_cards.dart,student_list_widget.dart,contract_gantt_chart.dart}

touch lib/features/shared/widgets/{user_avatar.dart,status_badge.dart,animated_transitions.dart}
touch lib/features/shared/animations/{lottie_animations.dart,loading_animation.dart}

echo "Estrutura de arquivos criada com sucesso!"
