import 'dart:ui';
import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedStartDate = DateTime(2022, 10, 24);
  DateTime _selectedEndDate = DateTime(2022, 10, 26);
  DateTime _currentMonth = DateTime(2022, 10, 1);

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isDateInRange(DateTime date) {
    return date.isAfter(_selectedStartDate.subtract(const Duration(days: 1))) &&
        date.isBefore(_selectedEndDate.add(const Duration(days: 1))) ||
        date.isAtSameMomentAs(_selectedStartDate) ||
        date.isAtSameMomentAs(_selectedEndDate);
  }

  bool _isSelectedDate(DateTime date) {
    return date.isAtSameMomentAs(_selectedStartDate) ||
        date.isAtSameMomentAs(_selectedEndDate);
  }

  List<Widget> _buildCalendarDays(double cellSize) {
    List<Widget> days = [];
    
    // Get first day of month and what day of week it falls on
    DateTime firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    // DateTime.weekday: 1=Monday, 7=Sunday, convert to 0=Sunday, 6=Saturday
    int firstDayWeekday = firstDay.weekday == 7 ? 0 : firstDay.weekday; // 0 = Sunday, 6 = Saturday
    
    // Get number of days in month
    int daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    
    // Calculate actual cell size (accounting for spacing)
    double actualCellSize = cellSize - 4; // Subtract margin
    
    // Add empty cells for days before first day of month
    for (int i = 0; i < firstDayWeekday; i++) {
      days.add(SizedBox(width: actualCellSize, height: actualCellSize));
    }
    
    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime currentDate = DateTime(_currentMonth.year, _currentMonth.month, day);
      bool isInRange = _isDateInRange(currentDate);
      bool isSelected = _isSelectedDate(currentDate);
      
      days.add(
        Container(
          width: actualCellSize,
          height: actualCellSize,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1C8EF9)
                : isInRange
                    ? const Color(0xFF1C8EF9).withOpacity(0.4)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                color: day == 1 && !isSelected && !isInRange
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }
    
    return days;
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    // DateTime.weekday: 1=Monday, 7=Sunday, so we need to adjust
    int weekdayIndex = (date.weekday - 1) % 7; // 0=Monday, 6=Sunday
    return '${weekdays[weekdayIndex]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatMonthYear(DateTime date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 
                    'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    String startDateStr = _formatDate(_selectedStartDate);
    String endDateStr = _formatDate(_selectedEndDate);
    String monthYear = _formatMonthYear(_currentMonth);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Top section with stay info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2-night stay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$startDateStr - $endDateStr',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Calendar section with glassmorphism
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E2031).withOpacity(0.6),
                  const Color(0xFF0D0E1A).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1E2031).withOpacity(0.4),
                        const Color(0xFF0D0E1A).withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFF1C8EF9).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Month header with navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            monthYear,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E2031),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                                  onPressed: _previousMonth,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                                  onPressed: _nextMonth,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Days of week header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _DayLabel(text: 'SUN'),
                          _DayLabel(text: 'MON'),
                          _DayLabel(text: 'TUE'),
                          _DayLabel(text: 'WED'),
                          _DayLabel(text: 'THU'),
                          _DayLabel(text: 'FRI'),
                          _DayLabel(text: 'SAT'),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Calendar grid - using GridView for proper layout
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double cellSize = (constraints.maxWidth - 12) / 7; // 7 columns, account for margins
                          return Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 0,
                            runSpacing: 4,
                            children: _buildCalendarDays(cellSize),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Bottom section with price and book button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0E1A),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                // Left section - Price (dark background)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$200 CAD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(
                                'night',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white.withOpacity(0.7),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Oct 24 - 26',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Right section - Book Now button (lighter dark blue background)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2031),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2A3AFF), Color(0xFF00E5FF)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00E5FF).withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class _DayLabel extends StatelessWidget {
  final String text;
  
  const _DayLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

