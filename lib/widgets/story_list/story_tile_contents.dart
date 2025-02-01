part of 'story_tile.dart';

class _StoryTileContents extends StatelessWidget {
  const _StoryTileContents({
    required this.story,
    required this.viewOnly,
    required this.listContext,
    required this.hasTitle,
    required this.content,
    required this.hasBody,
  });

  final StoryDbModel story;
  final bool viewOnly;
  final BuildContext listContext;
  final bool hasTitle;
  final StoryContentDbModel? content;
  final bool hasBody;

  @override
  Widget build(BuildContext context) {
    final images = content != null ? QuillService.imagesFromContent(content) : null;

    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (hasTitle)
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: Text(
              content!.title!,
              style: TextTheme.of(context).titleMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (hasBody)
          Container(
            width: double.infinity,
            margin: hasTitle
                ? EdgeInsets.only(top: MediaQuery.textScalerOf(context).scale(6.0))
                : AppTheme.getDirectionValue(
                    context,
                    const EdgeInsets.only(left: 24.0),
                    const EdgeInsets.only(right: 24.0),
                  ),
            child: SpMarkdownBody(body: content!.displayShortBody!),
          ),
        SpStoryLabels(
          story: story,
          fromStoryTile: true,
          margin: EdgeInsets.only(top: MediaQuery.textScalerOf(context).scale(8)),
          onToggleShowDayCount: viewOnly
              ? null
              : () async {
                  await StoryTileActions(story: story, listContext: listContext).toggleShowDayCount();
                  if (context.mounted) Navigator.maybePop(context);
                },
        ),
        if (images?.isNotEmpty == true) ...[
          SizedBox(height: MediaQuery.textScalerOf(context).scale(12)),
          _StoryTileImages(images: images!),
          if (story.inArchives) SizedBox(height: MediaQuery.textScalerOf(context).scale(4)),
        ],
        if (story.inArchives) ...[
          Container(
            margin: EdgeInsets.only(top: MediaQuery.textScalerOf(context).scale(8.0)),
            child: RichText(
              textScaler: MediaQuery.textScalerOf(context),
              text: TextSpan(
                style: TextTheme.of(context).labelMedium,
                children: const [
                  WidgetSpan(child: Icon(Icons.archive_outlined, size: 16.0), alignment: PlaceholderAlignment.middle),
                  TextSpan(text: ' Archived'),
                ],
              ),
            ),
          ),
        ]
      ]),
    );
  }
}
