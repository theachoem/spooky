part of '../home_view.dart';

class _AppUpdateFloatingButton extends StatelessWidget {
  const _AppUpdateFloatingButton();

  @override
  Widget build(BuildContext context) {
    return Consumer<InAppUpdateProvider>(builder: (context, provider, child) {
      return Visibility(
        visible: provider.displayStatus != null,
        child: Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).padding.bottom + 16.0,
          child: SpFadeIn.fromBottom(
            child: Center(
              child: SpLoopAnimationBuilder(
                duration: Duration(seconds: 2),
                reverseDuration: Duration(seconds: 2),
                builder: (context, value, child) {
                  return FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Color.lerp(ColorScheme.of(context).bootstrap.info.color,
                          ColorScheme.of(context).bootstrap.danger.color, value),
                    ),
                    icon: provider.displayStatus?.loading == true
                        ? const SizedBox.square(dimension: 16.0, child: CircularProgressIndicator.adaptive())
                        : const Icon(Icons.system_update),
                    label: Text(provider.displayStatus?.label ?? ''),
                    onPressed: provider.displayStatus?.loading == true ? null : () => provider.update(),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
