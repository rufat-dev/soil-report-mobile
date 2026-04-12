class ScopedAccessModel {
  String? scope;
  String? accessToken;
  String? refreshToken;

  ScopedAccessModel({this.scope, this.accessToken, this.refreshToken});

  bool get hasAccess => refreshToken != null;
}