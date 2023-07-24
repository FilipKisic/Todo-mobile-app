import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/features/todo/domain/entity/todo_item.dart';
import 'package:todo_app/features/todo/domain/usecase/complete_todo_use_case.dart';
import 'package:todo_app/features/todo/domain/usecase/create_new_todo_use_case.dart';
import 'package:todo_app/features/todo/domain/usecase/get_todos_for_project_use_case.dart';

class TodoProvider extends ChangeNotifier {
  final GetTodosForProjectUseCase _getTodosForProjectUseCase;
  final CreateNewTodoUseCase _createNewTodoUseCase;
  final CompleteTodoUseCase _completeTodoUseCase;
  final int projectId;
  AsyncValue<List<TodoItem>>? todoListState;

  TodoProvider(
    this._getTodosForProjectUseCase,
    this._createNewTodoUseCase,
    this._completeTodoUseCase,
    this.projectId,
  ) {
    getAllTodosForProject(projectId);
  }

  void getAllTodosForProject(final int projectId) async {
    todoListState = const AsyncValue.loading();
    notifyListeners();

    todoListState = await AsyncValue.guard(() => _getTodosForProjectUseCase(projectId));
    notifyListeners();
  }

  Future<void> createNewTodo(
    final int projectId,
    final String todoTitle,
    final DateTime dueDate,
  ) async =>
      await _createNewTodoUseCase(projectId, todoTitle, dueDate);

  void completeTodo(final int projectId, final TodoItem todoItem) =>
      _completeTodoUseCase(projectId, todoItem);
}
