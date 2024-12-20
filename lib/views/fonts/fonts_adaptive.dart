part of 'fonts_view.dart';

class _FontsAdaptive extends StatelessWidget {
  const _FontsAdaptive(this.viewModel);

  final FontsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fonts"),
        bottom: buildSearchBar(themeProvider, context),
      ),
      body: buildBody(themeProvider, context),
    );
  }

  PreferredSize buildSearchBar(ThemeProvider themeProvider, BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0 + 12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SearchAnchor.bar(
          suggestionsBuilder: (context, controller) {
            final fuzzy = Fuzzy<String>(viewModel.fonts, options: FuzzyOptions(isCaseSensitive: false));
            List<Result<String>> result = fuzzy.search(controller.text.trim());
            result.sort((a, b) => a.score.compareTo(b.score));

            return result.map((fontFamily) {
              return buildFontFamilyTile(context, fontFamily.item, themeProvider);
            }).toList();
          },
        ),
      ),
    );
  }

  Widget buildBody(ThemeProvider themeProvider, BuildContext context) {
    if (viewModel.fontGroups == null) return const Center(child: CircularProgressIndicator.adaptive());
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0).copyWith(bottom: MediaQuery.of(context).padding.bottom),
      itemCount: viewModel.fontGroups!.length,
      itemBuilder: (context, index) {
        final fontGroup = viewModel.fontGroups![index];

        return StickyHeader(
          header: Container(
            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              spacing: 16.0,
              children: [
                Text(fontGroup.label, style: TextTheme.of(context).titleLarge),
                const Expanded(child: Divider(height: 1))
              ],
            ),
          ),
          content: Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: List.generate(fontGroup.fontFamilies.length, (index) {
                return buildFontFamilyTile(context, fontGroup.fontFamilies[index], themeProvider);
              }),
            ),
          ),
        );
      },
    );
  }

  Widget buildFontFamilyTile(
    BuildContext context,
    String fontFamily,
    ThemeProvider themeProvider,
  ) {
    return SpPopupMenuButton(
      dyGetter: (dy) => dy + 88.0,
      items: (BuildContext context) {
        return [
          SpPopMenuItem(
            title: "Use this font",
            subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            subtitleStyle: GoogleFonts.getFont(fontFamily),
            trailingIconData: Icons.keyboard_arrow_right,
            onPressed: () {
              themeProvider.setFontFamily(fontFamily);
              viewModel.saveToRecently(fontFamily);
            },
          )
        ];
      },
      builder: (open) {
        bool selected = themeProvider.theme.fontFamily == fontFamily;
        return ListTile(
          selected: themeProvider.theme.fontFamily == fontFamily,
          onTap: () => open(),
          title: Text(fontFamily),
          trailing: Visibility(
            visible: selected,
            child: SpFadeIn.fromBottom(
              child: Icon(
                Icons.check_circle_outline,
                color: ColorScheme.of(context).primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
