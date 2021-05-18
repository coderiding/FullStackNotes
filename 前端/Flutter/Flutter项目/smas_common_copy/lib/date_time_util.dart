import 'package:intl/intl.dart';

class DateTimeUtil {
  static const String YMDHMS = 'yyyy/MM/dd HH:mm:ss';

  static DateTime formatterStringToDate(String date,{String dateFormat}) {
    if (null == date || date.isEmpty) {
      return null;
    }

    var myDateFormat = YMDHMS;
    if (null == dateFormat && date.length == 10) {
      myDateFormat = 'yyyy/MM/dd';
    }else if(null != dateFormat) {
      myDateFormat = dateFormat;
    }
    return new DateFormat(myDateFormat).parse(date);
  }

  static String formatterDateToString(DateTime date,{String dateFormat}) {
    if (null == date) {
      return null;
    }

    return new DateFormat (null == dateFormat ? 'yyyy/MM/dd HH:mm:ss' : dateFormat).format(date);
  }

  static int differenceSeconds(DateTime fromDate,DateTime toDate) {
    int seconds = toDate.difference(fromDate).inSeconds;
    return seconds;
  }
}
