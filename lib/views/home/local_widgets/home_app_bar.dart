part of '../home_view.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: const [SizedBox()],
      automaticallyImplyLeading: false,
      pinned: true,
      floating: true,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      forceElevated: false,
      expandedHeight: viewModel.scrollInfo.appBar(context).getExpandedHeight(),
      flexibleSpace: _HomeFlexibleSpaceBar(viewModel: viewModel),
      bottom: buildTabBar(context),
    );
  }

  PreferredSize buildTabBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(viewModel.scrollInfo.appBar(context).getTabBarPreferredHeight()),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        enableFeedback: true,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        indicatorAnimation: TabIndicatorAnimation.linear,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.only(
          left: 14.0,
          right: 14.0,
          top: viewModel.scrollInfo.appBar(context).indicatorPaddingTop,
          bottom: viewModel.scrollInfo.appBar(context).indicatorPaddingBottom,
        ),
        indicator: RoundedIndicator.simple(
          height: viewModel.scrollInfo.appBar(context).indicatorHeight,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: (index) {
          viewModel.scrollInfo.moveToMonthIndex(
            months: viewModel.months,
            targetMonthIndex: index,
            context: context,
          );
        },
        splashBorderRadius: BorderRadius.circular(viewModel.scrollInfo.appBar(context).indicatorHeight / 2),
        tabs: viewModel.months.map((month) {
          return Container(
            height: viewModel.scrollInfo.appBar(context).indicatorHeight - 2,
            alignment: Alignment.center,
            child: Text(DateFormatService.MMM(DateTime(2000, month))),
          );
        }).toList(),
      ),
    );
  }
}

class _HomeFlexibleSpaceBar extends StatelessWidget {
  const _HomeFlexibleSpaceBar({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(
          left: 16.0 + MediaQuery.of(context).padding.left,
          right: 16.0 + MediaQuery.of(context).padding.left,
          bottom: viewModel.scrollInfo.appBar(context).getTabBarPreferredHeight() +
              viewModel.scrollInfo.appBar(context).contentsMarginBottom,
        ),
        child: Stack(
          children: [
            buildContents(context),
            buildYear(context),
          ],
        ),
      ),
    );
  }

  Widget buildContents(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: AppTheme.getDirectionValue(context, viewModel.scrollInfo.appBar(context).getYearSize().width + 8.0, 0.0),
      right: AppTheme.getDirectionValue(context, 0.0, viewModel.scrollInfo.appBar(context).getYearSize().width + 8.0),
      child: Container(
        alignment: AppTheme.getDirectionValue(context, Alignment.bottomRight, Alignment.bottomLeft),
        child: SpMeasureSize(
          onPerformLayout: (p0) {
            double actualHeight = p0.height;
            double caculatedHeight = viewModel.scrollInfo.appBar(context).getContentsHeight();

            // for adaptive text to font scaling, we precaculate the contents heights.
            // sometime when font is bigger, this question text render 2 line of text instead of 1.
            // our caculation is wrong because we only caculate for 1 line.
            //
            // because our render align all element to bottom, so it still responsive but just all text is getting near status bar or below it.
            // our solution is to just check how much we caculate wrong, add expanded height it a bit more.
            if (actualHeight > caculatedHeight && actualHeight - caculatedHeight > 1) {
              Future.microtask(() {
                viewModel.scrollInfo.setExtraExpandedHeight(actualHeight - caculatedHeight);
              });
            } else {
              Future.microtask(() {
                viewModel.scrollInfo.setExtraExpandedHeight(0);
              });
            }
          },
          child: Wrap(children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpTapEffect(
                  onTap: () => viewModel.changeName(context),
                  child: _HomeAppBarNickname(nickname: viewModel.nickname),
                ),
                SpTapEffect(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: const _HomeAppBarMessage(),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildYear(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + viewModel.scrollInfo.appBar(context).contentsMarginTop,
      bottom: 0,
      left: AppTheme.getDirectionValue(context, 0.0, null),
      right: AppTheme.getDirectionValue(context, null, 0.0),
      child: Container(
        alignment: AppTheme.getDirectionValue(context, Alignment.topLeft, Alignment.topRight),
        width: viewModel.scrollInfo.appBar(context).getYearSize().width,
        height: viewModel.scrollInfo.appBar(context).getYearSize().height,
        margin: viewModel.scrollInfo.extraExpandedHeight > 0 ? const EdgeInsets.only(bottom: 8.0) : null,
        child: SpTapEffect(
          effects: const [SpTapEffectType.touchableOpacity],
          onTap: () => openEndDrawer(context),
          child: FittedBox(
            child: Text(
              viewModel.year.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextTheme.of(context).displayLarge?.copyWith(color: Theme.of(context).disabledColor, height: 1.0),
              textAlign: TextAlign.end,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  void openEndDrawer(BuildContext context) {
    Scaffold.maybeOf(context)?.openEndDrawer();

    AnalyticsService.instance.logOpenHomeEndDrawer(
      year: viewModel.year,
    );
  }
}
