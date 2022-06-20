library backups_details_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'backups_details_view_model.dart';

part 'backups_details_mobile.dart';
part 'backups_details_tablet.dart';
part 'backups_details_desktop.dart';

class BackupsDetailsView extends StatelessWidget {
  const BackupsDetailsView({
    Key? key,
    required this.destination,
  }) : super(key: key);

  final BaseBackupDestination destination;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BackupsDetailsViewModel>(
      create: (context) => BackupsDetailsViewModel(destination),
      onModelReady: (context, viewModel) {},
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _BackupsDetailsMobile(viewModel),
          desktop: _BackupsDetailsDesktop(viewModel),
          tablet: _BackupsDetailsTablet(viewModel),
        );
      },
    );
  }
}
