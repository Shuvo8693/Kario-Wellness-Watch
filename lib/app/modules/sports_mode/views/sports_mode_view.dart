
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/sports_mode/widgets/sport_mode_item.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class SportsModeView extends StatefulWidget {
  const SportsModeView({super.key});

  @override
  State<SportsModeView> createState() => _SportsModeViewState();
}

class _SportsModeViewState extends State<SportsModeView> {
  // Track selected sports
  final Set<String> _selectedSports = {
    'Jump rope',
    'Football',
    'Badminton',
    'Basketball',
    'Hiking',
    'Yoga',
    'Strength training',
  };

  final List<SportMode> _sportModes = [
    SportMode(icon: Icons.directions_run, name: 'Outdoor Run'),
    SportMode(icon: Icons.directions_walk, name: 'Outdoor walk'),
    SportMode(icon: Icons.directions_bike, name: 'Outdoor cycling'),
    SportMode(icon: Icons.skip_next, name: 'Jump rope'),
    SportMode(icon: Icons.sports_soccer, name: 'Football'),
    SportMode(icon: Icons.sports_tennis, name: 'Badminton'),
    SportMode(icon: Icons.sports_basketball, name: 'Basketball'),
    SportMode(icon: Icons.hiking, name: 'Hiking'),
    SportMode(icon: Icons.self_improvement, name: 'Yoga'),
    SportMode(icon: Icons.fitness_center, name: 'Strength training'),
  ];

  void _toggleSport(String sportName) {
    setState(() {
      if (_selectedSports.contains(sportName)) {
        _selectedSports.remove(sportName);
      } else {
        _selectedSports.add(sportName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sports modes',
          style: GoogleFontStyles.h3(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Handle save action
                  Navigator.pop(context, _selectedSports);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFontStyles.h5(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: _sportModes.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final sport = _sportModes[index];
          final isSelected = _selectedSports.contains(sport.name);

          return SportModeItem(
            sport: sport,
            isSelected: isSelected,
            onTap: () => _toggleSport(sport.name),
          );
        },
      ),
    );
  }
}

