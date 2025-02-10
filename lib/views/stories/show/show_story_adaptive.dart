part of 'show_story_view.dart';

class _ShowStoryAdaptive extends StatelessWidget {
  const _ShowStoryAdaptive(this.viewModel);

  final ShowStoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: viewModel.story != null
          ? TagsEndDrawer(
              onUpdated: (tags) => viewModel.setTags(tags),
              initialTags: viewModel.story?.validTags ?? [],
            )
          : null,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleSpacing: 0.0,
        actions: buildAppBarActions(context),
      ),
      body: bodyBody(context),
    );
  }

  Widget bodyBody(BuildContext context) {
    if (viewModel.quillControllers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else {
      return PageView.builder(
        controller: viewModel.pageController,
        itemCount: viewModel.quillControllers.length,
        itemBuilder: (context, index) {
          return PrimaryScrollController(
            controller: viewModel.scrollControllers[index]!,
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, _) {
                return [
                  if (viewModel.story != null && viewModel.draftContent != null)
                    SliverToBoxAdapter(
                      child: StoryHeader(
                        paddingTop: MediaQuery.of(context).padding.top + 8.0,
                        story: viewModel.story!,
                        setFeeling: viewModel.setFeeling,
                        onToggleShowDayCount: viewModel.toggleShowDayCount,
                        draftContent: viewModel.draftContent!,
                        readOnly: true,
                        onSetDate: null,
                      ),
                    ),
                ];
              },
              body: Builder(builder: (context) {
                return buildEditor(
                  index: index,
                  context: context,
                  scrollController: PrimaryScrollController.maybeOf(context) ?? ScrollController(),
                );
              }),
            ),
          );
        },
      );
    }
  }

  Widget buildEditor({
    required int index,
    required BuildContext context,
    required ScrollController scrollController,
  }) {
    return QuillEditor.basic(
      controller: viewModel.quillControllers[index]!,
      scrollController: scrollController,
      config: QuillEditorConfig(
        scrollBottomInset: 88 + MediaQuery.of(context).viewPadding.bottom,
        scrollable: true,
        expands: true,
        placeholder: "...",
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
          top: 8.0,
          bottom: 88 + MediaQuery.of(context).viewPadding.bottom,
        ),
        checkBoxReadOnly: false,
        autoFocus: false,
        enableScribble: false,
        showCursor: false,
        embedBuilders: [
          ImageBlockEmbed(fetchAllImages: () => QuillService.imagesFromContent(viewModel.draftContent)),
          DateBlockEmbed(),
        ],
        unknownEmbedBuilder: UnknownEmbedBuilder(),
      ),
    );
  }

  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      if (viewModel.draftContent?.pages?.length != null && viewModel.draftContent!.pages!.length > 1) ...[
        buildPageIndicator(),
        const SizedBox(width: 12.0),
      ],
      IconButton(
        onPressed: () => viewModel.goToEditPage(context),
        icon: const Icon(Icons.edit_outlined),
      ),
      Builder(builder: (context) {
        return IconButton(
          icon: const Icon(Icons.sell_outlined),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        );
      }),
      SpPopupMenuButton(
        items: (context) {
          return [
            SpPopMenuItem(
              leadingIconData: Icons.history_sharp,
              title: "Changes History",
              subtitle: "${viewModel.story?.rawChanges?.length}",
              onPressed: () => viewModel.goToChangesPage(context),
            ),
            SpPopMenuItem(
              leadingIconData: Icons.info,
              title: "Info",
              onPressed: () => StoryInfoSheet(story: viewModel.story!).show(context),
            ),
          ];
        },
        builder: (callback) {
          return IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: callback,
          );
        },
      )
    ];
  }

  Widget buildPageIndicator() {
    return Container(
      height: 48.0,
      alignment: Alignment.center,
      child: ValueListenableBuilder<double>(
        valueListenable: viewModel.currentPageNotifier,
        builder: (context, currentPage, child) {
          return Text('${viewModel.currentPage + 1} / ${viewModel.draftContent?.pages?.length}');
        },
      ),
    );
  }
}

class UnknownEmbedBuilder extends EmbedBuilder {
  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return const Text("Unknown");
  }

  @override
  String get key => "unknown";
}
