part of 'home_view.dart';

class _HomeAdaptive extends StatelessWidget {
  const _HomeAdaptive(this.viewModel);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: viewModel.months.length,
      child: _HomeScaffold(
        viewModel: viewModel,
        endDrawer: _HomeEndDrawer(viewModel),
        appBar: HomeAppBar(viewModel: viewModel),
        body: buildBody(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () => viewModel.goToNewPage(context),
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    if (viewModel.stories == null) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    if (viewModel.stories!.items.isEmpty) {
      return SliverFillRemaining(
        child: _HomeEmpty(viewModel: viewModel),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.only(
        top: 16.0,
        left: MediaQuery.of(context).padding.left,
        right: MediaQuery.of(context).padding.right,
        bottom: kToolbarHeight + MediaQuery.of(context).padding.bottom,
      ),
      sliver: SliverList.builder(
        itemCount: viewModel.stories?.items.length ?? 0,
        itemBuilder: (context, index) {
          final story = viewModel.stories!.items[index];

          return StoryListenerBuilder(
            key: ValueKey(story.id),
            story: story,
            onChanged: (StoryDbModel updatedStory) {
              if (updatedStory.type != PathType.docs) {
                viewModel.stories = viewModel.stories?.removeElement(updatedStory);
              } else {
                viewModel.stories = viewModel.stories?.replaceElement(updatedStory);
              }
              viewModel.notifyListeners();
            },
            // onDeleted only happen when reloaded story is null which not frequently happen. We just reload in this case.
            onDeleted: () => viewModel.load(),
            builder: (context) {
              return StoryTileListItem(
                showYear: false,
                index: index,
                stories: viewModel.stories!,
                onTap: () => viewModel.goToViewPage(context, story),
              );
            },
          );
        },
      ),
    );
  }
}
