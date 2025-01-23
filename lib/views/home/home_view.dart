import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:storypad/app_theme.dart';
import 'package:storypad/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:storypad/core/databases/models/story_db_model.dart';
import 'package:storypad/core/extensions/color_scheme_extensions.dart';
import 'package:storypad/core/services/date_format_service.dart';
import 'package:storypad/core/services/google_drive/google_drive_service.dart';
import 'package:storypad/core/types/path_type.dart';
import 'package:storypad/providers/in_app_update_provider.dart';
import 'package:storypad/providers/backup_provider.dart';
import 'package:storypad/providers/local_auth_provider.dart';
import 'package:storypad/providers/theme_provider.dart';
import 'package:storypad/views/home/local_widgets/backup_tile.dart';
import 'package:storypad/views/home/local_widgets/home_years_view.dart';
import 'package:storypad/views/home/local_widgets/rounded_indicator.dart';
import 'package:storypad/views/archives/archives_view.dart';
import 'package:storypad/views/search/search_view.dart';
import 'package:storypad/views/tags/tags_view.dart';
import 'package:storypad/views/theme/theme_view.dart';
import 'package:storypad/widgets/sp_cross_fade.dart';
import 'package:storypad/widgets/sp_end_drawer_theme.dart';
import 'package:storypad/widgets/sp_fade_in.dart';
import 'package:storypad/widgets/sp_measure_size.dart';
import 'package:storypad/widgets/sp_nested_navigation.dart';
import 'package:storypad/widgets/sp_tap_effect.dart';
import 'package:storypad/widgets/story_list/story_list_timeline_verticle_divider.dart';
import 'package:storypad/widgets/story_list/story_listener_builder.dart';
import 'package:storypad/widgets/story_list/story_tile_list_item.dart';

import 'home_view_model.dart';

part 'home_adaptive.dart';
part 'local_widgets/home_end_drawer.dart';
part 'local_widgets/home_scaffold.dart';
part 'local_widgets/home_app_bar.dart';
part 'local_widgets/home_app_bar_nickname.dart';
part 'local_widgets/home_app_bar_message.dart';
part 'local_widgets/home_empty.dart';
part 'local_widgets/app_update_floating_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>(
      create: (context) => HomeViewModel(context),
      builder: (context, viewModel, child) {
        return _HomeAdaptive(viewModel);
      },
    );
  }
}
