part of 'story_details_view.dart';

class _StoryDetailsAdaptive extends StatelessWidget {
  const _StoryDetailsAdaptive(this.viewModel);

  final StoryDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.currentStoryContent?.title ?? 'Click to add title...'),
        actions: [
          ValueListenableBuilder<double>(
            valueListenable: viewModel.currentPageNotifier,
            builder: (context, currentPage, child) {
              return Text('${viewModel.currentPage + 1} / ${viewModel.currentStoryContent?.pages?.length}');
            },
          ),
          const SizedBox(width: 12.0),
          IconButton(
            onPressed: () => viewModel.createNewPage(context),
            icon: const Icon(Icons.insert_page_break_outlined),
          ),
          IconButton(
            onPressed: () => viewModel.goToEditPage(context),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: PageView.builder(
        controller: viewModel.pageController,
        itemCount: viewModel.currentStoryContent?.pages?.length ?? 0,
        itemBuilder: (context, index) {
          final pageDocuments = viewModel.currentStoryContent!.pages![index];
          return PageReader(
            pageDocuments: pageDocuments,
            onSelectionChanged: (TextSelection selection) => viewModel.currentTextSelection = selection,
          );
        },
      ),
    );
  }
}
