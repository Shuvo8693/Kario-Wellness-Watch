import 'difference_formation.dart';

class DateAgeFormation extends DifferenceFormation {
  String formatAge(DateTime dateTime) {
   Duration difference = formatDifference(dateTime);
    return formatContentAge(difference);
  }


  String formatContentAge(Duration difference) {
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes == 1) {
      return 'a minute ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago ';
    } else if (difference.inHours == 1) {
      return '1 hour ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 30) {
      return '1 month ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }
}