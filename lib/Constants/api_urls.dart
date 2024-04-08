class ApiUrls {
  static const String baseUrl = 'https://mindwaveinfoway.com/';
  static const String _apiPath = 'ClassicPVDHouse/AdminPanel/WebApi/index.php?p=';

  static const String loginApi = '${_apiPath}Login';
  static const String createOrderApi = '${_apiPath}createOrder';
  static const String getOrdersApi = '${_apiPath}getOrders';
  static const String getPartiesApi = '${_apiPath}getParties';
  static const String createOrderCycleApi = '${_apiPath}createOrderCycle';
  static const String getOrderCyclesApi = '${_apiPath}getOrderCycles';
  static const String getInvoicesApi = '${_apiPath}getInvoices';
  static const String updatePartyApi = '${_apiPath}updateParty';
  static const String deletePartyApi = '${_apiPath}deleteParty';
  static const String deleteOrderApi = '${_apiPath}deleteOrder';
  static const String inAppUpdateApi = '${_apiPath}inAppUpdate';
  static const String updateOrderApi = '${_apiPath}updateOrder';
  static const String deleteOrderCycleApi = '${_apiPath}deleteOrderCycle';
}
