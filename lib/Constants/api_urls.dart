class ApiUrls {
  static const String baseUrl = 'https://rftv.wtf/';
  static const String _apiPath = 'tp/';

  static const String getChannelsApi = '${_apiPath}sling.json';
  static const String getChannelsEncryptedApi = '${_apiPath}wc/encrypt.php';
  static const String appLiveCheckerApi = 'https://redjoytv-checker.appchecker.workers.dev/';
  static const String getApkLinkApi = 'https://api.dropboxapi.com/2/files/get_temporary_link';
}
