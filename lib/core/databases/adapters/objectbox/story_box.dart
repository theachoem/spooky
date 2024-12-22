import 'package:flutter/foundation.dart';
import 'package:spooky/core/databases/adapters/objectbox/base_box.dart';
import 'package:spooky/core/databases/adapters/objectbox/entities.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/story_db_constructor_service.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/objectbox.g.dart';

class StoryBox extends BaseObjectBox<StoryObjectBox, StoryDbModel> {
  @override
  String get tableName => "stories";

  Future<Map<int, int>> getStoryCountsByYear() async {
    List<StoryObjectBox> stories = await box.getAllAsync();

    Map<int, int> storyCountsByYear = stories.fold<Map<int, int>>({}, (counts, story) {
      counts[story.year] = (counts[story.year] ?? 0) + 1;
      return counts;
    });

    return storyCountsByYear;
  }

  @override
  Future<StoryDbModel?> set(StoryDbModel record) async {
    await super.set(record);

    if (kDebugMode) {
      final saved = await find(record.id);
      print("🚧 StoryBox#set: ${saved?.rawChanges?.length}");
    }

    return record;
  }

  @override
  QueryBuilder<StoryObjectBox>? buildQuery({Map<String, dynamic>? filters}) {
    String? query = filters?["query"];
    String? type = filters?["type"];
    int? year = filters?["year"];
    int? month = filters?["month"];
    int? day = filters?["day"];
    int? tag = filters?["tag"];
    bool? starred = filters?["starred"];
    int? order = filters?["order"];
    bool priority = filters?["priority"] == true;
    List<int>? selectedYears = filters?["selected_years"];
    List<int>? yearsRange = filters?["years_range"];

    Condition<StoryObjectBox>? conditions = StoryObjectBox_.id.notNull();

    if (tag != null) conditions = conditions.and(StoryObjectBox_.tags.containsElement(tag.toString()));
    if (starred == true) conditions = conditions.and(StoryObjectBox_.starred.equals(true));
    if (type != null) conditions = conditions.and(StoryObjectBox_.type.equals(type));
    if (year != null) conditions = conditions.and(StoryObjectBox_.year.equals(year));
    if (month != null) conditions = conditions.and(StoryObjectBox_.month.equals(month));
    if (day != null) conditions = conditions.and(StoryObjectBox_.day.equals(day));

    if (query != null) {
      conditions = conditions.and(
        StoryObjectBox_.metadata.contains(
          query,
          caseSensitive: false,
        ),
      );
    }

    if (yearsRange != null && yearsRange.length == 2) {
      yearsRange.sort();
      conditions = conditions.and(
        StoryObjectBox_.year.between(
          yearsRange[0],
          yearsRange[1],
        ),
      );
    } else if (selectedYears != null) {
      conditions = conditions.and(StoryObjectBox_.year.oneOf(selectedYears));
    }

    QueryBuilder<StoryObjectBox> queryBuilder = box.query(conditions);
    if (priority) queryBuilder.order(StoryObjectBox_.starred, flags: Order.descending);

    queryBuilder
      ..order(StoryObjectBox_.year, flags: order ?? Order.descending)
      ..order(StoryObjectBox_.month, flags: order ?? Order.descending)
      ..order(StoryObjectBox_.day, flags: order ?? Order.descending)
      ..order(StoryObjectBox_.hour, flags: order ?? Order.descending)
      ..order(StoryObjectBox_.minute, flags: order ?? Order.descending);

    return queryBuilder;
  }

  @override
  Future<List<StoryDbModel>> itemsTransformer(
    List<StoryObjectBox> objects, [
    Map<String, dynamic>? options,
  ]) {
    return compute(_itemsTransformer, {'objects': objects});
  }

  @override
  Future<StoryObjectBox> objectConstructor(
    StoryDbModel object, [
    Map<String, dynamic>? options,
  ]) {
    return compute(_objectConstructor, object);
  }

  @override
  Future<StoryDbModel> objectTransformer(
    StoryObjectBox object, [
    Map<String, dynamic>? options,
  ]) {
    return compute(_objectTransformer, {'object': object});
  }

  static StoryDbModel _objectTransformer(Map<String, dynamic> map) {
    StoryObjectBox object = map['object'];

    Iterable<PathType> types = PathType.values.where((e) => e.name == object.type);
    return StoryDbModel(
      type: types.isNotEmpty ? types.first : PathType.docs,
      id: object.id,
      starred: object.starred,
      feeling: object.feeling,
      year: object.year,
      month: object.month,
      day: object.day,
      hour: object.hour ?? object.createdAt.hour,
      minute: object.minute ?? object.createdAt.minute,
      second: object.second ?? object.createdAt.second,
      updatedAt: object.updatedAt,
      createdAt: object.createdAt,
      tags: object.tags?.map((e) => int.tryParse(e)).whereType<int>().toList(),
      rawChanges: object.changes,
      movedToBinAt: object.movedToBinAt,
      latestChange: StoryDbConstructorService.rawChangesToChanges([object.changes.last]).first,
      allChanges: null,
    );
  }

  static List<StoryDbModel> _itemsTransformer(Map<String, dynamic> map) {
    List<StoryObjectBox> objects = map['objects'];

    List<StoryDbModel> docs = [];
    for (StoryObjectBox object in objects) {
      StoryDbModel json = _objectTransformer({'object': object});
      docs.add(json);
    }

    return docs;
  }

  static StoryObjectBox _objectConstructor(StoryDbModel story) {
    StoryObjectBox object = StoryObjectBox(
      id: story.id,
      version: story.version,
      type: story.type.name,
      year: story.year,
      month: story.month,
      day: story.day,
      hour: story.hour ?? story.createdAt.hour,
      minute: story.minute ?? story.createdAt.minute,
      second: story.second ?? story.createdAt.second,
      tags: story.tags?.map((e) => e.toString()).toList(),
      starred: story.starred,
      feeling: story.feeling,
      createdAt: story.createdAt,
      updatedAt: story.updatedAt,
      movedToBinAt: story.movedToBinAt,
      metadata: story.latestChange?.safeMetadata,
      changes: StoryDbConstructorService.changesToRawChanges(story),
    );
    return object;
  }
}
