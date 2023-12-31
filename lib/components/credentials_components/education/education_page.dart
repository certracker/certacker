import 'package:certracker/components/credentials_components/education/page/education_detail.dart';
import 'package:flutter/material.dart';

class CerEducationPage extends StatefulWidget {
  const CerEducationPage({Key? key}) : super(key: key);

  @override
  State<CerEducationPage> createState() => _CerEducationPageState();
}

class _CerEducationPageState extends State<CerEducationPage> {
 bool _isSelectMode = false;
  late List<bool> _isSelected;
  late List<Map<String, String>> _certificationCards = [];
  bool _isSearchVisible = true;

  @override
  void initState() {
    super.initState();
    _certificationCards = [];
    _isSelected = [];
    _initializeEducationCards();
  }

  void _initializeEducationCards() async {
    // Simulate fetching certification data
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _certificationCards = _getEducationCards().toList();
      _isSelected = List.filled(_certificationCards.length, false);
    });
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
             ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text("Select Multiple"),
                onTap: () {
                  setState(() {
                    _isSelectMode = true;
                    _isSearchVisible = false;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Recycle bin"),
                onTap: () {
                  // Handle your action here
                  Navigator.pop(context);
                },
              ),
              // Add more list items as needed
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBarOrActions(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _certificationCards.length,
                itemBuilder: (context, index) {
                  return _buildEducationCard(
                    _certificationCards[index]['title']!,
                    _certificationCards[index]['expiration']!,
                    index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBarOrActions() {
    if (_isSelectMode) {
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isSelectMode = false;
                _isSearchVisible = true;
              });
            },
            child: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  _deleteSelectedItems();
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  _shareSelectedItems();
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ],
          ),
        ],
      );
    } else {
      return GestureDetector(
        onLongPress: () {
          setState(() {
            _isSelectMode = true;
            _isSearchVisible = false;
          });
        },
        child: SizedBox(
          height: 50,
          child: _isSearchVisible
              ? Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _openBottomSheet(context);
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                )
              : null,
        ),
      );
    }
  }

  List<Map<String, String>> _getEducationCards() {
    // Replace this with your certification data list
    return [
      {
        'title': 'Education Name 1',
        'expiration': 'Expiring 15 July 2025',
      },
      {
        'title': 'Education Name 2',
        'expiration': 'Expiring 15 July 2025',
      },
      {
        'title': 'Education Name 3',
        'expiration': 'Expiring 15 July 2025',
      },
      {
        'title': 'Education Name 4',
        'expiration': 'Expiring 15 July 2025',
      },
      {
        'title': 'Education Name 5',
        'expiration': 'Expiring 15 July 2025',
      },
      {
        'title': 'Education Name 6',
        'expiration': 'Expiring 15 July 2025',
      },
      // Add more certification cards as needed
    ];
  }

  Widget _buildEducationCard(
  String title,
  String expiration,
  int index,
) {
  return GestureDetector(
    onTap: () {
      if (_isSelectMode) {
        setState(() {
          // Toggle the selection
          _isSelected[index] = !_isSelected[index];
        });
      } else {
        // Navigate to a new page when a card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EducationDetailPage(
              title: title,
              expiration: expiration,
            ),
          ),
        );
      }
    },
    onLongPress: () {
      setState(() {
        _isSelectMode = true;
        _isSearchVisible = false;
        // Toggle the selection on long press
        _isSelected[index] = !_isSelected[index];
      });
    },
    child: Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (_isSelectMode)
              Checkbox(
                value: _isSelected[index],
                onChanged: (value) {
                  setState(() {
                    _isSelected[index] = value!;
                  });
                },
              ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          expiration,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  void _deleteSelectedItems() {
    setState(() {
      for (var i = _isSelected.length - 1; i >= 0; i--) {
        if (_isSelected[i]) {
          _certificationCards.removeAt(i);
          _isSelected.removeAt(i);
        }
      }
      _isSelectMode = false;
      _isSearchVisible = true;
    });
  }

  void _shareSelectedItems() {
    // Implement share functionality here
  }
}

