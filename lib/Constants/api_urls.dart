class ApiUrls {
  static const String baseUrl = 'https://mindwaveinfoway.com/';
  static const String _apiPath = 'ClassicPVDHouse/AdminPanel/WebApi/index.php?p=';

  static const String loginApi = '${_apiPath}Login';
  static const String createOrderApi = '${_apiPath}createOrder';
  static const String getOrdersApi = '${_apiPath}getOrders';
  static const String getPartiesApi = '${_apiPath}getParties';
  static const String createOrderCycleApi = '${_apiPath}createOrderCycle';
  static const String getOrderCyclesApi = '${_apiPath}getOrderCycles';
}
