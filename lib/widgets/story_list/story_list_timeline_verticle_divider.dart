import 'package:flutter/material.dart';
import 'package:spooky/app_theme.dart';
import 'package:spooky/widgets/story_list/story_tile.dart';

class StoryListTimelineVerticleDivider extends StatelessWidget {
  const StoryListTimelineVerticleDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: AppTheme.getDirectionValue(
        context,
        null,
        MediaQuery.of(context).padding.left + 16.0 + StoryTile.monogramSize / 2,
      ),
      right: AppTheme.getDirectionValue(
        context,
        MediaQuery.of(context).padding.left + 16.0 + StoryTile.monogramSize / 2,
        null,
      ),
      child: const VerticalDivider(
        width: 1,
      ),
    );
  }
}
