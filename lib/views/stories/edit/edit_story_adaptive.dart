part of 'edit_story_view.dart';

class _EditStoryAdaptive extends StatelessWidget {
  const _EditStoryAdaptive(this.viewModel);

  final EditStoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: viewModel.story == null
            ? const SizedBox.shrink()
            : SpTapEffect(
                onTap: () => viewModel.changeTitle(context),
                child: Text(viewModel.currentContent?.title ?? 'Title...'),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => viewModel.save(context),
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (viewModel.quillControllers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else {
      return PageView.builder(
        controller: viewModel.pageController,
        itemCount: viewModel.quillControllers.length,
        itemBuilder: (context, index) {
          return _Editor(
            controller: viewModel.quillControllers[index]!,
            showToolbarOnTop: viewModel.showToolbarOnTop,
            showToolbarOnBottom: viewModel.showToolbarOnBottom,
            toggleToolbarPosition: viewModel.toggleToolbarPosition,
          );
        },
      );
    }
  }
}
