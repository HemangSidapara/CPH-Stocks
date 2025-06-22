class ApiUrls {
  static const String baseUrl = 'https://mindwaveinfoway.com/';
  static const String imageBaseUrl = 'https://mindwaveinfoway.com/ClassicPVDHouse/AdminPanel/WebApi/';

  static const String _apiPath = 'ClassicPVDHouse/AdminPanel/WebApi/index.php?p=';

  /// Auth APIs
  static const String loginApi = '${_apiPath}Login';
  static const String checkTokenApi = '${_apiPath}checkToken';
  static const String inAppUpdateApi = '${_apiPath}inAppUpdate';
  static const String downloadBackupApi = '${_apiPath}downloadBackup';

  /// Order APIs
  static const String getOrdersApi = '${_apiPath}getOrders&status=';
  static const String createOrderApi = '${_apiPath}createOrder';
  static const String updateOrderApi = '${_apiPath}updateOrder';
  static const String deleteOrderApi = '${_apiPath}deleteOrder';
  static const String getOrderCyclesApi = '${_apiPath}getOrderCycles';
  static const String createOrderCycleApi = '${_apiPath}createOrderCycle';
  static const String deleteOrderCycleApi = '${_apiPath}deleteOrderCycle';
  static const String lastBilledCycleApi = '${_apiPath}lastBilledCycle';
  static const String isDispatchedApi = '${_apiPath}isDispatched';
  static const String getOrdersMetaApi = '${_apiPath}getOrdersMeta';
  static const String multipleLastBilledCycleApi = '${_apiPath}multipleLastBilledCycle';
  static const String getCategoriesApi = '${_apiPath}getCategories';
  static const String getRepairOrdersApi = '${_apiPath}getRepairOrders';
  static const String getOrderSequenceApi = '${_apiPath}getOrderSequence';

  /// Party APIs
  static const String getPartiesApi = '${_apiPath}getParties';
  static const String updatePartyApi = '${_apiPath}updateParty';
  static const String deletePartyApi = '${_apiPath}deleteParty';

  /// Challan APIs
  static const String getInvoicesApi = '${_apiPath}getInvoices';
  static const String generateInvoiceApi = '${_apiPath}generateInvoice';
  static const String deleteInvoicesApi = '${_apiPath}deleteInvoices';

  /// Account APIs
  static const String getLedgerInvoicesApi = '${_apiPath}getLedgerInvoices';
  static const String getPaymentLedgerInvoicesApi = '${_apiPath}getPaymentLedgerInvoices';
  static const String getPartyPaymentApi = '${_apiPath}getPartyPayment';
  static const String createPartyPaymentApi = '${_apiPath}createPartyPayment';
  static const String editPartyPaymentApi = '${_apiPath}editPartyPayment';
  static const String deletePartyPaymentApi = '${_apiPath}deletePartyPayment';
  static const String getAutomaticLedgerPaymentApi = '${_apiPath}getAutomaticLedgerPayment';
  static const String getLedgerPaymentApi = '${_apiPath}getLedgerPayment';

  /// Notes APIs
  static const String getNotesApi = '${_apiPath}getNotes';
  static const String editNotesApi = '${_apiPath}editNotes';

  /// Category APIs
  static const String createCategoryApi = '${_apiPath}createCategory';
  static const String getCategoryListApi = '${_apiPath}getCategoryList';
  static const String editCategoryApi = '${_apiPath}editCategory';
  static const String reorderCategoryApi = '${_apiPath}reorderCategory';

  /// Employee APIs
  static const String getNoOfEmployeesApi = '${_apiPath}getNoOfEmployees';
  static const String addNoOfEmployeesApi = '${_apiPath}addNoOfEmployees';
  static const String editNoOfEmployeesApi = '${_apiPath}editNoOfEmployees';
  static const String getReportApi = '${_apiPath}getReport';
}
