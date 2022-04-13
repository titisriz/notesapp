import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';
import 'package:notes_ddd/domain/core/value_object.dart';
import 'package:notes_ddd/domain/notes/note.dart';
import 'package:notes_ddd/domain/notes/todo_item.dart';
import 'package:notes_ddd/domain/notes/value_objects.dart';

part 'note_dtos.freezed.dart';
part 'note_dtos.g.dart';

@freezed
abstract class NoteDto implements _$NoteDto {
  const factory NoteDto({
    @JsonKey(ignore: true) String? id,
    required String body,
    required int color,
    required List<TodoItemDto> todos,
    @ServerTimestampConverter() required FieldValue serverTime,
  }) = _NoteDto;

  const NoteDto._();

  factory NoteDto.fromDomain(Note note) {
    return NoteDto(
        id: note.id.getOrCrash(),
        body: note.body.getOrCrash(),
        color: note.color.getOrCrash().value,
        todos: note.todos
            .getOrCrash()
            .map(
              (e) => TodoItemDto.fromDomain(e),
            )
            .asList(),
        serverTime: FieldValue.serverTimestamp());
  }

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  factory NoteDto.fromFireStore(QueryDocumentSnapshot doc) {
    return NoteDto.fromJson(doc as Map<String, dynamic>);
  }
  Note toDomain() {
    return Note(
        id: UniqueId.fromUniqueString(id!),
        body: NoteBody(body),
        color: NoteColor(Color(color)),
        todos: List3(todos.map((e) => e.toDomain()).toImmutableList()));
  }
}

class ServerTimestampConverter implements JsonConverter<FieldValue, Object> {
  const ServerTimestampConverter();

  @override
  fromJson(json) {
    return FieldValue.serverTimestamp();
  }

  @override
  toJson(FieldValue fieldValue) => fieldValue;
}

@freezed
abstract class TodoItemDto implements _$TodoItemDto {
  const TodoItemDto._();

  const factory TodoItemDto({
    required String id,
    required String name,
    required bool done,
  }) = _TodoItemDto;

  factory TodoItemDto.fromDomain(TodoItem todoItem) {
    return TodoItemDto(
      id: todoItem.uniqueId.getOrCrash(),
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      uniqueId: UniqueId.fromUniqueString(id),
      name: TodoName(name),
      done: done,
    );
  }

  factory TodoItemDto.fromJson(Map<String, dynamic> json) =>
      _$TodoItemDtoFromJson(json);
}
