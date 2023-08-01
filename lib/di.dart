import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/features/common/data/source_local/manager/shared_prefs_manager_impl.dart';
import 'package:todo_app/features/common/domain/manager/shared_prefs_manager.dart';
import 'package:todo_app/features/common/presentation/riverpod/app_theme_provider.dart';
import 'package:todo_app/features/todo/data/converter/project_converter.dart';
import 'package:todo_app/features/todo/data/converter/todo_item_converter.dart';
import 'package:todo_app/features/todo/data/database/database_manager.dart';
import 'package:todo_app/features/todo/data/database/database_manager_impl.dart';
import 'package:todo_app/features/todo/data/device/notification_service.dart';
import 'package:todo_app/features/todo/data/repository/project_repository_impl.dart';
import 'package:todo_app/features/todo/data/repository/todo_repository_impl.dart';
import 'package:todo_app/features/todo/domain/repository/project_repository.dart';
import 'package:todo_app/features/todo/domain/repository/todo_repository.dart';
import 'package:todo_app/features/todo/domain/usecase/complete_todo_use_case.dart';
import 'package:todo_app/features/todo/domain/usecase/create_new_project_use_case.dart';
import 'package:todo_app/features/todo/domain/usecase/create_new_todo_use_case.dart';
import 'package:todo_app/features/todo/domain/usecase/delete_project_use_case.dart';
import 'package:todo_app/features/todo/domain/usecase/get_all_projects_use_case.dart';
import 'package:todo_app/features/todo/domain/usecase/get_completed_task_number_use_case.dart';
import 'package:todo_app/features/todo/domain/usecase/get_todos_for_project_use_case.dart';
import 'package:todo_app/features/todo/domain/usecase/send_notification_use_case.dart';
import 'package:todo_app/features/todo/presentation/riverpod/project_provider.dart';
import 'package:todo_app/features/todo/presentation/riverpod/todo_provider.dart';

/// ************ EXTERNAL LIBRARIES *************
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
);

final localNotificationProvider = Provider<FlutterLocalNotificationsPlugin>(
  (ref) => FlutterLocalNotificationsPlugin(),
);

final behaviorSubjectProvider = Provider<BehaviorSubject<String?>>(
  (ref) => BehaviorSubject<String?>(),
);

/// ************ SERVICE *************
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(
    ref.watch(localNotificationProvider),
    ref.watch(behaviorSubjectProvider),
  ),
);

/// ************ MANAGERS *************
final databaseManagerProvider = Provider<DatabaseManager>(
  (ref) => DatabaseManagerImpl(),
);

final sharedPrefsManagerProvider = Provider<SharedPrefsManager>(
  (ref) => SharedPrefsManagerImpl(ref.watch(sharedPreferencesProvider)),
);

/// ************ CONVERTERS *************
final todoItemObjectToEntityConverter = Provider<TodoItemObjectToEntityConverter>(
  (ref) => TodoItemObjectToEntityConverter(),
);

final todoItemEntityToObjectConverter = Provider<TodoItemEntityToObjectConverter>(
  (ref) => TodoItemEntityToObjectConverter(),
);

final projectObjectToEntityConverter = Provider<ProjectObjectToEntityConverter>(
  (ref) => ProjectObjectToEntityConverter(ref.watch(todoItemObjectToEntityConverter)),
);

final projectEntityToObjectConverter = Provider<ProjectEntityToObjectConverter>(
  (ref) => ProjectEntityToObjectConverter(ref.watch(todoItemEntityToObjectConverter)),
);

/// ************ REPOSITORIES *************
final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => ProjectRepositoryImpl(
    ref.watch(databaseManagerProvider),
    ref.watch(projectObjectToEntityConverter),
    ref.watch(projectEntityToObjectConverter),
  ),
);

final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepositoryImpl(
    ref.watch(databaseManagerProvider),
    ref.watch(todoItemObjectToEntityConverter),
    ref.watch(todoItemEntityToObjectConverter),
  ),
);

/// ************ PROVIDERS *************
final createNewProjectUseCaseProvider = Provider<CreateNewProjectUseCase>(
  (ref) => CreateNewProjectUseCase(ref.watch(projectRepositoryProvider)),
);

final createNewTodoUseCaseProvider = Provider<CreateNewTodoUseCase>(
  (ref) => CreateNewTodoUseCase(ref.watch(todoRepositoryProvider)),
);

final getAllProjectsUseCaseProvider = Provider<GetAllProjectsUseCase>(
  (ref) => GetAllProjectsUseCase(ref.watch(projectRepositoryProvider)),
);

final getTodosForProjectUseCaseProvider = Provider<GetTodosForProjectUseCase>(
  (ref) => GetTodosForProjectUseCase(ref.watch(todoRepositoryProvider)),
);

final getCompletedTodoNumberUseCaseProvider = Provider<GetCompletedTodoNumberUseCase>(
  (ref) => GetCompletedTodoNumberUseCase(ref.watch(projectRepositoryProvider)),
);

final completeTodoUseCaseProvider = Provider<CompleteTodoUseCase>(
  (ref) => CompleteTodoUseCase(ref.watch(todoRepositoryProvider)),
);

final deleteProjectUseCaseProvider = Provider<DeleteProjectUseCase>(
  (ref) => DeleteProjectUseCase(ref.watch(projectRepositoryProvider)),
);

final sendNotificationUseCaseProvider = Provider<SendNotificationUseCase>(
  (ref) => SendNotificationUseCase(ref.watch(notificationServiceProvider)),
);

/// ************ PROVIDERS *************
final projectProvider = ChangeNotifierProvider.autoDispose<ProjectProvider>(
  (ref) => ProjectProvider(
    ref.watch(getAllProjectsUseCaseProvider),
    ref.watch(createNewProjectUseCaseProvider),
    ref.watch(getCompletedTodoNumberUseCaseProvider),
    ref.watch(deleteProjectUseCaseProvider),
  ),
);

final todoProvider = ChangeNotifierProvider.family.autoDispose<TodoProvider, int>(
  (ref, projectId) => TodoProvider(
    ref.watch(getTodosForProjectUseCaseProvider),
    ref.watch(createNewTodoUseCaseProvider),
    ref.watch(completeTodoUseCaseProvider),
    ref.watch(sendNotificationUseCaseProvider),
    projectId,
  ),
);

final appThemeProvider = ChangeNotifierProvider.autoDispose<AppThemeProvider>(
  (ref) => AppThemeProvider(ref.watch(sharedPrefsManagerProvider)),
);
