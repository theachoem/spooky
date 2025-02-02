import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storypad/core/extensions/color_scheme_extensions.dart';
import 'package:storypad/core/services/google_drive/google_drive_service.dart';
import 'package:storypad/core/services/quill_service.dart';
import 'package:storypad/providers/backup_provider.dart';
import 'package:storypad/widgets/db_assets/db_image.dart';
import 'package:storypad/widgets/sp_gradient_loading.dart';

class SpImage extends StatelessWidget {
  const SpImage({
    super.key,
    required this.link,
    required this.width,
    required this.height,
    this.errorWidget,
  });

  final String link;
  final double? width;
  final double? height;
  final LoadingErrorWidgetBuilder? errorWidget;

  Future<void> showErrorAlert(BuildContext context, String? message) async {
    await showOkAlertDialog(
      context: context,
      title: "Oop!",
      message: message ?? link,
    );
  }

  double get defaultSize => 50;

  @override
  Widget build(BuildContext context) {
    if (link.startsWith("storypad://")) {
      return Consumer<BackupProvider>(builder: (context, provider, child) {
        return Image(
          key: ValueKey(provider.source.email),
          width: width,
          height: height,
          fit: BoxFit.cover,
          image: DbImage(assetLink: link, currentUser: GoogleDriveService.instance.googleSignIn.currentUser),
          errorBuilder: (context, error, strackTrace) =>
              errorWidget?.call(context, link, error) ??
              buildImageError(width ?? defaultSize, height ?? defaultSize, context, error),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SpGradientLoading(
              height: height ?? defaultSize,
              width: width ?? defaultSize,
            );
          },
        );
      });
    } else if (QuillService.isImageBase64(link)) {
      return Image.memory(
        base64.decode(link),
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (link.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: link,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return SpGradientLoading(
            height: height ?? defaultSize,
            width: width ?? defaultSize,
          );
        },
        errorWidget: errorWidget,
      );
    } else if (File(link).existsSync()) {
      return Image.file(
        File(link),
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else {
      return buildImageError(
        width ?? defaultSize,
        height ?? defaultSize,
        context,
        null,
      );
    }
  }

  Widget buildImageError(double width, double height, BuildContext context, Object? error) {
    String? message = error is StateError ? error.message : error?.toString();
    return Material(
      color: ColorScheme.of(context).readOnly.surface3,
      child: InkWell(
        onTap: () => showErrorAlert(context, message),
        child: SizedBox(
          width: width,
          height: height,
          child: Wrap(
            spacing: 8.0,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8.0,
            children: [
              const Icon(Icons.image_not_supported_outlined),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
