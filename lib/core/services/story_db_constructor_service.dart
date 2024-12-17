import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:spooky_mb/core/databases/models/story_content_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_db_model.dart';

List<StoryContentDbModel> _changesConstructor(List<String> rawChanges) {
  return StoryDbConstructorService.strsToChanges(rawChanges);
}

class StoryDbConstructorService {
  static List<String> storyToRawChanges(StoryDbModel story) {
    List<String> changes = [];

    if (story.useRawChanges) {
      List<String> rawChanges = story.rawChanges ?? [];
      Iterable<int> changeIds = story.changes.map((e) => e.id);

      String decoded = HtmlCharacterEntities.decode(rawChanges.last);
      dynamic last = jsonDecode(decoded);

      if (last is Map<String, dynamic>) {
        int? lastId = int.tryParse("${last['id']}");
        if (changeIds.contains(lastId)) {
          rawChanges.removeLast();
        }
      }

      changes = [
        ...rawChanges,
        ...changesToStrs(story.changes),
      ];
    } else {
      changes = changesToStrs(story.changes);
    }

    return changes;
  }

  static List<StoryContentDbModel> strsToChanges(List<String> changes) {
    Map<String, StoryContentDbModel> items = {};
    for (String str in changes) {
      String decoded = HtmlCharacterEntities.decode(str);
      dynamic json = jsonDecode(decoded);
      String id = json['id'].toString();
      items[id] ??= StoryContentDbModel.fromJson(json);
    }
    return items.values.toList();
  }

  static List<String> changesToStrs(List<StoryContentDbModel> changes) {
    return changes.map((e) {
      Map<String, dynamic> json = e.toJson();
      String encoded = jsonEncode(json);
      return HtmlCharacterEntities.encode(encoded);
    }).toList();
  }

  static Future<StoryDbModel> loadChanges(StoryDbModel story) async {
    if (story.rawChanges != null) {
      List<StoryContentDbModel> changes = await compute(_changesConstructor, story.rawChanges!);
      story = story.copyWith(changes: changes);
    }
    return story;
  }
}
