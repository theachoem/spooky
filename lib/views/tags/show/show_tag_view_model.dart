import 'package:flutter/material.dart';
import 'package:storypad/widgets/view/base_view_model.dart';
import 'package:storypad/core/databases/models/tag_db_model.dart';
import 'package:storypad/core/objects/search_filter_object.dart';
import 'package:storypad/views/search/filter/search_filter_view.dart';
import 'show_tag_view.dart';

class ShowTagViewModel extends BaseViewModel {
  final ShowTagRoute params;

  ShowTagViewModel({
    required this.params,
  });

  TagDbModel get tag => params.tag;

  late SearchFilterObject filter = SearchFilterObject(
    years: {},
    types: {},
    tagId: tag.id,
    filterTagModifiable: false,
    assetId: null,
  );

  Future<void> goToFilterPage(BuildContext context) async {
    final result = await SearchFilterRoute(initialTune: filter).push(context);

    if (result is SearchFilterObject) {
      filter = result;
      notifyListeners();
    }
  }
}
