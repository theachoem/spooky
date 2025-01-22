import 'package:storypad/core/storages/base_object_storages/list_storage.dart';

class RecentlySelectedFontsStorage extends ListStorage<String> {
  Future<void> add(String value) async {
    List<String>? result = await readList();

    result ??= [];
    result.insert(0, value);
    result = result.toSet().toList();

    if (result.length > 3) {
      result = result.getRange(0, 3).toList();
    }

    await writeList(result);
  }
}
