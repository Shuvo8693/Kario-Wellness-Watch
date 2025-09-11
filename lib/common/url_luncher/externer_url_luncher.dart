import 'package:url_launcher/url_launcher.dart';

class ExternalUrlLauncher{

 static lunchUrl(String url)async{
   bool canLaunch= await canLaunchUrl(Uri.parse(url));
    if(canLaunch){
      await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
    }else{
      throw 'Could not launch $url';
    }
  }
}