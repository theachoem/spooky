import 'package:storypad/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:storypad/core/objects/search_filter_object.dart';
import 'package:storypad/routes/base_route.dart';
import 'package:storypad/widgets/story_list/story_list.dart';

import 'show_asset_view_model.dart';

part 'show_asset_content.dart';

class ShowAssetRoute extends BaseRoute {
  ShowAssetRoute({
    required this.assetId,
    required this.storyViewOnly,
  });

  final int assetId;
  final bool storyViewOnly;

  @override
  Widget buildPage(BuildContext context) => ShowAssetView(params: this);

  @override
  bool get preferredNestedRoute => true;
}

class ShowAssetView extends StatelessWidget {
  const ShowAssetView({
    super.key,
    required this.params,
  });

  final ShowAssetRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ShowAssetViewModel>(
      create: (context) => ShowAssetViewModel(params: params),
      builder: (context, viewModel, child) {
        return _ShowAssetContent(viewModel);
      },
    );
  }
}
