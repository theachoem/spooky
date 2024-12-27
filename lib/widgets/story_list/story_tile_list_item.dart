import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/widgets/story_list/story_tile.dart';

part 'story_month_header.dart';

class StoryTileListItem extends StatelessWidget {
  const StoryTileListItem({
    super.key,
    required this.stories,
    required this.index,
    required this.showYear,
    required this.onTap,
    this.viewOnly = false,
  });

  final int index;
  final CollectionDbModel<StoryDbModel> stories;
  final bool showYear;
  final void Function() onTap;
  final bool viewOnly;

  @override
  Widget build(BuildContext context) {
    StoryDbModel? previousStory = index - 1 >= 0 ? stories.items[index - 1] : null;
    StoryDbModel story = stories.items[index];

    bool showMonogram = previousStory == null || !previousStory.sameDayAs(story);

    if (previousStory?.month != story.month) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StoryMonthHeader(index: index, context: context, story: story, showYear: showYear),
          StoryTile(
            story: story,
            showMonogram: showMonogram,
            viewOnly: viewOnly,
            onTap: onTap,
          ),
        ],
      );
    } else {
      return StoryTile(
        story: story,
        showMonogram: showMonogram,
        viewOnly: viewOnly,
        onTap: onTap,
      );
    }
  }
}
