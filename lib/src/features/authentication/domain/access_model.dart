class AccessModel{
  String? accessToken;
  String? refreshToken;

  AccessModel({this.refreshToken, this.accessToken});

  bool get hasAccess => refreshToken != null;
}