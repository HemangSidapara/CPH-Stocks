import 'dart:developer';

/// NOTES : Refer utils class and extension functions for common resource uses

class Logger {
  static var tag = '';
  static var cloud = '☁️';
  static var success = '✅';
  static var info = '💡️';
  static var warning = '🃏️  ';
  static var error = '💔️  ';
  static var timer = '⏲️';

  static var logIcon = '✏️';

  static void printLog({var tag = 'CPH Stocks', var printLog = '', var logIcon = 'ℹ️', bool isTimer = false}) {
    if (isTimer) {
      Logger.logIcon = timer;
      log('|------------------------------>${Logger.logIcon} Response Time: $printLog seconds ${Logger.logIcon}<------------------------------|');
    } else if (true) {
      Logger.logIcon = logIcon;
      Logger.tag = tag;
      log('|---------->${Logger.logIcon} ${tag.contains('JSON METHOD') ? 'Request Data Start' : 'Response Data Start'} ${Logger.logIcon}<----------|');
      log('${tag + '\t : ' + printLog}', level: 2000);
      log('|------------------------------>${Logger.logIcon} ${tag.contains('JSON METHOD') ? 'Request Data End' : 'Response Data End'} ${Logger.logIcon}<------------------------------|');
    }
  }
}
