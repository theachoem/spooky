part of '../edit_story_view.dart';

class _Editor extends StatelessWidget {
  final QuillController controller;
  final FocusNode focusNode;
  final ScrollController scrollController;
  final StoryContentDbModel? draftContent;

  const _Editor({
    required this.controller,
    required this.focusNode,
    required this.scrollController,
    required this.draftContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: buildPagesEditor(context)),
        _FocusNodeBuilder(
          focusNode: focusNode,
          child: buildBottomToolbar(context),
          builder: (context, focused, child) {
            return Visibility(
              maintainState: true,
              visible: focused,
              child: SpFadeIn.fromBottom(
                child: child!,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildBottomToolbar(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.medium1,
      curve: Curves.ease,
      color: getToolbarBackgroundColor(context),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: buildToolBar(context),
    );
  }

  Widget buildPagesEditor(BuildContext context) {
    return QuillEditor.basic(
      focusNode: focusNode,
      controller: controller,
      scrollController: PrimaryScrollController.maybeOf(context) ?? ScrollController(),
      config: QuillEditorConfig(
        paintCursorAboveText: false,
        scrollBottomInset: 88 + MediaQuery.of(context).viewPadding.bottom,
        scrollable: true,
        expands: true,
        placeholder: "...",
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
          top: 8.0,
          bottom: 88 + MediaQuery.of(context).viewPadding.bottom,
        ),
        autoFocus: true,
        enableScribble: true,
        showCursor: true,
        embedBuilders: [
          ImageBlockEmbed(fetchAllImages: () => QuillService.imagesFromContent(draftContent)),
          DateBlockEmbed(),
        ],
        unknownEmbedBuilder: UnknownEmbedBuilder(),
      ),
    );
  }

  Widget buildToolBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
          ),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Divider(height: 1),
        Padding(padding: const EdgeInsets.symmetric(vertical: 4.0), child: buildActualToolbar(context)),
        const Divider(height: 1),
      ]),
    );
  }

  Color? getToolbarBackgroundColor(BuildContext context) => ColorScheme.of(context).readOnly.surface1;

  Widget buildActualToolbar(BuildContext context) {
    return QuillSimpleToolbar(
      controller: controller,
      config: QuillSimpleToolbarConfig(
        color: getToolbarBackgroundColor(context),
        buttonOptions: QuillSimpleToolbarButtonOptions(
          color: QuillToolbarColorButtonOptions(childBuilder: (dynamic options, dynamic extraOptions) {
            extraOptions as QuillToolbarColorButtonExtraOptions;
            return SpQuillToolbarColorButton(
              controller: extraOptions.controller,
              isBackground: false,
              positionedOnUpper: false,
            );
          }),
          backgroundColor: QuillToolbarColorButtonOptions(childBuilder: (dynamic options, dynamic extraOptions) {
            extraOptions as QuillToolbarColorButtonExtraOptions;
            return SpQuillToolbarColorButton(
              controller: extraOptions.controller,
              isBackground: true,
              positionedOnUpper: false,
            );
          }),
        ),
        customButtons: [
          if (kStoryPad)
            QuillToolbarCustomButtonOptions(
              tooltip: FlutterQuillLocalizations.of(context)?.image,
              icon: Icon(Icons.image),
              onPressed: () async {
                ImagePickerService(controller: controller).showSheet(context);
              },
            ),
        ],
        multiRowsDisplay: false,
        showDividers: true,
        showFontFamily: false,
        showFontSize: false,
        showBoldButton: true,
        showItalicButton: true,
        showSmallButton: true,
        showUnderLineButton: true,
        showLineHeightButton: false,
        showStrikeThrough: true,
        showInlineCode: true,
        showColorButton: true,
        showBackgroundColorButton: true,
        showClearFormat: true,
        showAlignmentButtons: true,
        showLeftAlignment: true,
        showCenterAlignment: true,
        showRightAlignment: true,
        showJustifyAlignment: true,
        showHeaderStyle: false,
        showListNumbers: true,
        showListBullets: true,
        showListCheck: true,
        showCodeBlock: false,
        showQuote: true,
        showIndent: true,
        showLink: true,
        showUndo: true,
        showRedo: true,
        showDirection: false,
        showSearchButton: false,
        showSubscript: false,
        showSuperscript: false,
        showClipboardCut: false,
        showClipboardCopy: false,
        showClipboardPaste: false,
      ),
    );
  }
}
