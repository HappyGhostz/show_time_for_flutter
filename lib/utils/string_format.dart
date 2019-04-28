/**
 * @author zcp
 * @date 2019/3/29
 * @Description
 */

class StringUtils {
  static double ONE_MINUTE = 60000;
  static double ONE_HOUR = 3600000;
  static double ONE_DAY = 86400000;
  static double ONE_WEEK = 604800000;

  static String ONE_SECOND_AGO = "秒前";
  static String ONE_MINUTE_AGO = "分钟前";
  static String ONE_HOUR_AGO = "小时前";
  static String ONE_DAY_AGO = "天前";
  static String ONE_MONTH_AGO = "月前";
  static String ONE_YEAR_AGO = "年前";

  /**
   * 根据时间字符串获取描述性时间，如3分钟前，1天前
   *
   * @param dateString 时间字符串
   * @return
   */
  static String getDescriptionTimeFromDateString(String dateString) {
    if (dateString.isEmpty) {
      return "";
    }
    var dateTime = DateTime.parse(dateString);
    try {
      return getDescriptionTimeFromDate(dateTime);
    } catch (e) {
      e.printStackTrace();
    }
    return "";
  }

  String formatZhuiShuDateString(String dateString) =>
      dateString.replaceAll("T", " ").replaceAll("Z", "");

  static String getDescriptionTimeFromDate(DateTime parse) {
    var delta = DateTime
        .now()
        .difference(parse)
        .inMilliseconds
        .toDouble();
    if (delta < 1 * ONE_MINUTE) {
      var seconds = toSeconds(delta);
      return (seconds <= 0 ? 1 : seconds).toString() + ONE_SECOND_AGO;
    }
    if (delta < 45 * ONE_MINUTE) {
      var minutes = toMinutes(delta);
      return (minutes <= 0 ? 1 : minutes).toString() + ONE_MINUTE_AGO;
    }
    if (delta < 24 * ONE_HOUR) {
      var hours = toHours(delta);
      return (hours <= 0 ? 1 : hours).toString() + ONE_HOUR_AGO;
    }
    if (delta < 48 * ONE_HOUR) {
      return "昨天";
    }
    if (delta < 30 * ONE_DAY) {
      var days = toDays(delta);
      return (days <= 0 ? 1 : days).toString() + ONE_DAY_AGO;
    }
    if (delta < 12 * 4 * ONE_WEEK) {
      var months = toMonths(delta);
      return (months <= 0 ? 1 : months).toString() + ONE_MONTH_AGO;
    } else {
      var years = toYears(delta);
      return (years <= 0 ? 1 : years).toString() + ONE_YEAR_AGO;
    }
  }

  static int toSeconds(double date) => (date / 1000).ceil();

  static int toMinutes(double date) => (toSeconds(date) / 60).ceil();

  static int toHours(double date) => (toMinutes(date) / 60).ceil();

  static int toDays(double date) => (toHours(date) / 24).ceil();

  static int toMonths(double date) => (toDays(date) / 30).ceil();

  static int toYears(double date) => (toMonths(date) / 365).ceil();

  static String formatWordCount(int wordCount) {
    if (wordCount / 10000 > 0) {
      return (wordCount / 10000 + 0.5).toInt().toString() + "万字";
    } else if (wordCount / 1000 > 0) {
      return (wordCount / 1000 + 0.5).toInt().toString() + "千字";
    } else {
      return wordCount.toString() + "字";
    }
  }
  static String formatDuration(Duration d) {
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }
}