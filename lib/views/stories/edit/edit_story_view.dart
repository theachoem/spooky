import 'package:flutter_quill/flutter_quill.dart';
import 'package:storypad/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:storypad/core/databases/models/story_content_db_model.dart';
import 'package:storypad/core/databases/models/story_db_model.dart';
import 'package:storypad/core/extensions/color_scheme_extensions.dart';
import 'package:storypad/core/services/quill_image_service.dart';
import 'package:storypad/core/services/quill_service.dart';
import 'package:storypad/routes/base_route.dart';
import 'package:storypad/views/stories/local_widgets/story_header.dart';
import 'package:storypad/views/stories/local_widgets/tags_end_drawer.dart';
import 'package:storypad/views/stories/show/show_story_view.dart';
import 'package:storypad/widgets/custom_embed/date_block_embed.dart';
import 'package:storypad/widgets/custom_embed/image_block_embed.dart';
import 'package:storypad/widgets/sp_animated_icon.dart';
import 'package:storypad/widgets/sp_fade_in.dart';
import 'package:storypad/widgets/sp_quill_toolbar_color_button.dart';

import 'edit_story_view_model.dart';

part 'edit_story_adaptive.dart';
part 'local_widgets/editor.dart';

class EditStoryRoute extends BaseRoute {
  final int? id;
  final int? initialYear;
  final int initialPageIndex;
  final Map<int, QuillController>? quillControllers;
  final StoryDbModel? story;

  EditStoryRoute({
    this.id,
    this.initialYear,
    this.initialPageIndex = 0,
    this.quillControllers,
    this.story,
  }) : assert(initialYear == null || id == null);

  @override
  Map<String, String?> get analyticsParameters {
    return {
      'flow_type': id == null ? 'new' : 'edit',
    };
  }

  @override
  Widget buildPage(BuildContext context) => EditStoryView(params: this);
}

class EditStoryView extends StatelessWidget {
  const EditStoryView({
    super.key,
    required this.params,
  });

  final EditStoryRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<EditStoryViewModel>(
      create: (context) => EditStoryViewModel(params: params),
      builder: (context, viewModel, child) {
        return _EditStoryAdaptive(viewModel);
      },
    );
  }
}
