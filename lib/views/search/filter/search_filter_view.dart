import 'package:storypad/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:storypad/core/databases/models/tag_db_model.dart';
import 'package:storypad/core/extensions/color_scheme_extensions.dart';
import 'package:storypad/core/objects/search_filter_object.dart';
import 'package:storypad/core/types/path_type.dart';
import 'package:storypad/routes/base_route.dart';

import 'search_filter_view_model.dart';

part 'search_filter_adaptive.dart';
part 'local_widgets/bottom_nav.dart';
part 'local_widgets/scrollable_choice_chips.dart';

class SearchFilterRoute extends BaseRoute {
  SearchFilterRoute({
    required this.initialTune,
  });

  final SearchFilterObject? initialTune;

  @override
  bool get preferredNestedRoute => true;

  @override
  Widget buildPage(BuildContext context) => SearchFilterView(params: this);
}

class SearchFilterView extends StatelessWidget {
  const SearchFilterView({
    super.key,
    required this.params,
  });

  final SearchFilterRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SearchFilterViewModel>(
      create: (context) => SearchFilterViewModel(params: params),
      builder: (context, viewModel, child) {
        return _SearchFilterAdaptive(viewModel);
      },
    );
  }
}
