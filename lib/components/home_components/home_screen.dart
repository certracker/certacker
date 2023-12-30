import 'package:certracker/components/home_components/current_screen.dart';
import 'package:certracker/components/home_components/expired_screen.dart';
import 'package:certracker/components/home_components/expiring_soon_screen.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                const Text(
                  "Welcome, Devin!",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        // Add notification icon onPressed action
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        // Add calendar icon onPressed action
                      },
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DashboardBox(color: Colors.green, title: "Current", count: 0),
                DashboardBox(color: Colors.orange, title: "Expiring", count: 0),
                DashboardBox(color: Colors.red, title: "Expired", count: 0),
              ],
            ),
            const SizedBox(height: 50),
            Expanded(
              child: TableCalendar(
                locale: "en_US",
                calendarFormat: CalendarFormat.month,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(color: Colors.white),
                  selectedTextStyle: TextStyle(color: Colors.white),
                ),
                onDaySelected: (selectedDate, focusedDate) {
                  // Handle day selection
                },
                focusedDay: DateTime.now(), // Provide a valid DateTime here
                firstDay:
                    DateTime.utc(2023, 1, 1), // Example: Set to January 1, 2023
                lastDay: DateTime.utc(
                    2023, 12, 31), // Example: Set to December 31, 2023
                // Add more properties and callbacks as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardBox extends StatelessWidget {
  final Color color;
  final String title;
  final int count;

  const DashboardBox({
    Key? key,
    required this.color,
    required this.title,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == "Current") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CurrentPage()),
          );
        } else if (title == "Expiring") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpiringSoonPage()),
          );
        } else if (title == "Expired") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpiredPage()),
          );
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '($count)',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
