enum HublaRoute {
  login('/login', 'Login'),
  cities('/cities', 'Cities'),
  forecast('/cities/:cityId/forecast', 'Forecast'),
  ;

  const HublaRoute(this.path, this.screenName);

  final String path;
  final String screenName;

  static HublaRoute fromRouteName(String name) => HublaRoute.values.firstWhere((route) => route.name.toLowerCase() == name.toLowerCase());
}
