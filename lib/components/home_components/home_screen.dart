import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  void selectItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4, // Adjust the elevation as needed
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 4, // Adjust the elevation as needed
            child: Container(
              color: const Color(0XFF591A8F),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  const Text(
                    "Welcome, Devin!",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          // Add notification icon onPressed action
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {
                          // Add calendar icon onPressed action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterItem(
                  text: 'All',
                  isSelected: selectedIndex == 0,
                  onTap: () => selectItem(0),
                ),
                FilterItem(
                  imagePath: "assets/images/icons/1.png",
                  isSelected: selectedIndex == 1,
                  onTap: () => selectItem(1),
                ),
                FilterItem(
                  imagePath: "assets/images/icons/2.png",
                  isSelected: selectedIndex == 2,
                  onTap: () => selectItem(2),
                ),
                FilterItem(
                  imagePath: "assets/images/icons/3.png",
                  isSelected: selectedIndex == 3,
                  onTap: () => selectItem(3),
                ),
                FilterItem(
                  imagePath: "assets/images/icons/4.png",
                  isSelected: selectedIndex == 4,
                  onTap: () => selectItem(4),
                ),
                FilterItem(
                  imagePath: "assets/images/icons/5.png",
                  isSelected: selectedIndex == 5,
                  onTap: () => selectItem(5),
                ),
                FilterItem(
                  imagePath: "assets/images/icons/6.png",
                  isSelected: selectedIndex == 6,
                  onTap: () => selectItem(6),
                ),
                FilterItem(
                  imagePath: "assets/images/icons/7.png",
                  isSelected: selectedIndex == 7,
                  onTap: () => selectItem(7),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: const [
                PageOne(),
                PageTwo(),
                PageThree(),
                PageFour(),
                PageFive(),
                PageSix(),
                PageSeven(),
                PageEight(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterItem extends StatelessWidget {
  final String? imagePath;
  final String? text;
  final bool isSelected;
  final VoidCallback? onTap;

  const FilterItem({
    Key? key,
    this.imagePath,
    this.text,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
              ),
            if (text != null)
              Text(
                text!,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            if (isSelected)
              Container(
                height: 2,
                width: 20,
                color: Colors.blue,
                margin: const EdgeInsets.only(top: 4),
              ),
          ],
        ),
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('This is Page 1'),
    );
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('This is Page 2'),
    );
  }
}

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('This is Page 3'),
    );
  }
}

class PageFour extends StatelessWidget {
  const PageFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('This is Page 4'),
    );
  }
}

class PageFive extends StatelessWidget {
  const PageFive({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('This is Page 5'),
    );
  }
}

class PageSix extends StatelessWidget {
  const PageSix({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('This is Page 6'),
    );
  }
}

class PageSeven extends StatelessWidget {
  const PageSeven({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('This is Page 7'),
    );
  }
}

class PageEight extends StatelessWidget {
  const PageEight({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('This is Page 8'),
    );
  }
}