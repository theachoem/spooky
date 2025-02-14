import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:storypad/providers/theme_provider.dart';
import 'package:storypad/widgets/sp_pop_up_menu_button.dart';

class FontWeightTile extends StatelessWidget {
  const FontWeightTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);

    return SpPopupMenuButton(
      smartDx: true,
      dyGetter: (dy) => dy + 44.0,
      items: (context) => FontWeight.values.map((fontWeight) {
        final descriptions = {
          100: tr("general.font_weight.thin"),
          200: tr("general.font_weight.extra_light"),
          300: tr("general.font_weight.light"),
          400: tr("general.font_weight.normal"),
          500: tr("general.font_weight.medium"),
          600: tr("general.font_weight.semi_bold"),
          700: tr("general.font_weight.bold"),
          800: tr("general.font_weight.extra_bold"),
          900: tr("general.font_weight.black"),
        };

        return SpPopMenuItem(
          selected: fontWeight == provider.theme.fontWeight,
          title: "${fontWeight.value} - ${descriptions[fontWeight.value]}",
          onPressed: () => provider.setFontWeight(fontWeight),
        );
      }).toList(),
      builder: (open) {
        return ListTile(
          leading: const Icon(Icons.format_size_outlined),
          title: Text(tr("list_tile.font_weight.title")),
          subtitle: Text(provider.theme.fontWeight.value.toString()),
          onTap: () => open(),
        );
      },
    );
  }
}
