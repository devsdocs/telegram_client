// ignore_for_file: non_constant_identifier_names

/// Update td for make update support raw, raw api, raw api light
class UpdateApi {
  Map query;
  Map update;
  String token_bot;
  Map client_option;

  /// Update td for make update support raw, raw api, raw api light
  UpdateApi({
    required this.query,
    required this.update,
    required this.client_option,
    required this.token_bot,
  });

  /// update api raw from api
  Map get raw {
    return update;
  }

  /// Update more pretty with minimalist
  Map get raw_api_light {
    return update;
  }

  /// Update more pretty with minimalist
  Map get raw_api {
    return update;
  }
}
