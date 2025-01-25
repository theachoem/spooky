import 'package:storypad/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:storypad/core/databases/models/tag_db_model.dart';
import 'package:storypad/routes/base_route.dart';
import 'package:storypad/widgets/sp_text_inputs_page.dart';

import 'edit_tag_view_model.dart';

part 'edit_tag_adaptive.dart';

class EditTagRoute extends BaseRoute {
  EditTagRoute({
    required this.tag,
    required this.allTags,
  });

  final TagDbModel? tag;
  final List<TagDbModel> allTags;

  @override
  bool get nestedRoute => true;

  @override
  Map<String, String?> get analyticsParameters {
    return {
      'flow_type': tag == null ? 'new' : 'edit',
    };
  }

  @override
  Widget buildPage(BuildContext context) => EditTagView(params: this);
}

class EditTagView extends StatelessWidget {
  const EditTagView({
    super.key,
    required this.params,
  });

  final EditTagRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<EditTagViewModel>(
      create: (context) => EditTagViewModel(params: params),
      builder: (context, viewModel, child) {
        return _EditTagAdaptive(viewModel);
      },
    );
  }
}
