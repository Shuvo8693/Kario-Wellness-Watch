import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/custom_appbar/custom_appbar.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:kario_wellness_watch/common/widgets/custom_text_field.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({super.key});

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  final alarmTEC = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool vibrate = true;
  bool loopAudio = true;
  String alarmLabel = 'Wake up';
  List<AlarmSettings> alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final loadedAlarms = await Alarm.getAlarms();
    setState(() {
      alarms = loadedAlarms;
    });
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.cyan,
              surface: Colors.grey[900]!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _setAlarm() async {
    final now = DateTime.now();
    var alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // If selected time is before now, set it for tomorrow
    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      dateTime: alarmDateTime,
      assetAudioPath: 'assets/alarm-327234.mp3',
      // Make sure to add this asset
      loopAudio: loopAudio,
      vibrate: vibrate,
      volumeSettings: VolumeSettings.fixed(volume: 1.0),
      notificationSettings: NotificationSettings(
          title: 'Alarm Notification',
          body: 'Your alarm is at this time'
      ),
    );
    print(alarmDateTime);
    try {
      await Alarm.set(alarmSettings: alarmSettings);
        _loadAlarms();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alarm set for ${selectedTime.format(context)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alarm set error $e'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }


  Future<void> _deleteAlarm(int id) async {
    await Alarm.stop(id);
    _loadAlarms();
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Set Alarm'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Alarm Settings Card
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alarm Time',
                      style: GoogleFontStyles.h4(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Time Display
                    GestureDetector(
                      onTap: _selectTime,
                      child: Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.cyan, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.cyan,
                              size: 32.sp,
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              selectedTime.format(context),
                              style: GoogleFontStyles.h1(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 36.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Alarm Label
                    CustomTextField(
                        controller: alarmTEC,
                      hintText: 'Type alarm title',
                      onChanged: (value) {
                        setState(() {
                          alarmLabel = value;
                        });
                      },
                    ),

                    SizedBox(height: 20.h),

                    // Vibrate Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vibrate',
                          style: GoogleFontStyles.h4(color: Colors.black),
                        ),
                        Switch(
                          value: vibrate,
                          onChanged: (value) {
                            setState(() {
                              vibrate = value;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Colors.cyan,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    // Loop Audio Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Loop Audio',
                          style: GoogleFontStyles.h4(color: Colors.black),
                        ),
                        Switch(
                          value: loopAudio,
                          onChanged: (value) {
                            setState(() {
                              loopAudio = value;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Colors.cyan,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Set Alarm Button
                    CustomButton(
                      text: 'Set Alarm',
                      onTap: _setAlarm,
                    ),
                  ],
                ),
              ),
            ),

            // Active Alarms List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Active Alarms',
                style: GoogleFontStyles.h3(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            alarms.isEmpty
                ? Center(
              child: Text(
                'No alarms set',
                style: GoogleFontStyles.h5(color: Colors.grey[400]),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarms[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.alarm,
                        color: Colors.cyan,
                        size: 32.sp,
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatTime(alarm.dateTime),
                              style: GoogleFontStyles.h3(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              alarm.notificationSettings.title,
                              style: GoogleFontStyles.h6(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 24.sp,
                        ),
                        onPressed: () => _deleteAlarm(alarm.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}