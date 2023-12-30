import 'package:flutter/material.dart';

class CerCertificationPage extends StatefulWidget {
  const CerCertificationPage({Key? key}) : super(key: key);

  @override
  State<CerCertificationPage> createState() => _CerCertificationPageState();
}

class _CerCertificationPageState extends State<CerCertificationPage> {
  bool _isSelectMode = false;
  late List<bool> _isSelected;
  late List<Map<String, String>> _certificationCards =
      []; // Initialize with an empty list

 @override
  void initState() {
    super.initState();
    _certificationCards = [];
    _isSelected = [];
    _initializeCertificationCards();
  }


Future<void> _initializeCertificationCards() async {
    // Simulate fetching certification data
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _certificationCards = _getCertificationCards().toList();
      _isSelected = List.filled(_certificationCards.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          if (_isSelectMode)
            Row(
              children: [
                _actionButton(
                  Icons.delete,
                  'Delete',
                  Colors.red,
                  onPressed: () {
                    _deleteSelectedItems();
                  },
                ),
                _actionButton(
                  Icons.share,
                  'Share',
                  Colors.green,
                  onPressed: () {
                    _shareSelectedItems();
                  },
                ),
              ],
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _certificationCards.length,
                itemBuilder: (context, index) {
                  return _buildCertificationCard(
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

  List<Map<String, String>> _getCertificationCards() {
    // Replace this with your certification data list
    return [
      {
        'title': 'Certification Name 1',
        'expiration': 'Expiring 15 July 2025',
      },
      {
        'title': 'Certification Name 2',
        'expiration': 'Expiring 15 July 2025',
      },

       {
        'title': 'Certification Name 3',
        'expiration': 'Expiring 15 July 2025',
      },
       {
        'title': 'Certification Name 4',
        'expiration': 'Expiring 15 July 2025',
      },
       {
        'title': 'Certification Name 5',
        'expiration': 'Expiring 15 July 2025',
      },
       {
        'title': 'Certification Name 6',
        'expiration': 'Expiring 15 July 2025',
      },
      // Add more certification cards as needed
    ];
  }

  Widget _actionButton(
    IconData icon,
    String text,
    Color color, {
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }

  Widget _buildCertificationCard(
    String title,
    String expiration,
    int index,
  ) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isSelectMode = !_isSelectMode;
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
                    if (!_isSelectMode)
                      const Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 10),
                          Icon(Icons.share, color: Colors.green),
                        ],
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
    });
  }

  void _shareSelectedItems() {
    }
}
