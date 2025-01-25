import 'package:storypad/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:storypad/core/databases/models/tag_db_model.dart';
import 'package:storypad/core/types/path_type.dart';
import 'package:storypad/routes/base_route.dart';
import 'package:storypad/widgets/story_list/story_list.dart';

import 'show_tag_view_model.dart';

part 'show_tag_adaptive.dart';

class ShowTagRoute extends BaseRoute {
  ShowTagRoute({
    required this.tag,
    required this.storyViewOnly,
  });

  final TagDbModel tag;
  final bool storyViewOnly;

  @override
  bool get nestedRoute => true;

  @override
  Widget buildPage(BuildContext context) => ShowTagView(params: this);
}

class ShowTagView extends StatelessWidget {
  const ShowTagView({
    super.key,
    required this.params,
  });

  final ShowTagRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ShowTagViewModel>(
      create: (context) => ShowTagViewModel(params: params),
      builder: (context, viewModel, child) {
        return _ShowTagAdaptive(viewModel);
      },
    );
  }
}
