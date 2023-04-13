// ignore_for_file: non_constant_identifier_names

/// Update td for make update support raw, raw api, raw api light
class UpdateTd {
  Map update;
  int client_id;
  Map client_option;
  UpdateTd({
    required this.update,
    required this.client_id,
    required this.client_option,
  });

  /// return json update origin from api origin
  Map get raw {
    return update;
  }

  /// return type update
  String get type {
    return update["@type"];
  }
}
