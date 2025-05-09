import 'package:flutter/material.dart';

class HomeDemo extends StatefulWidget {
  const HomeDemo({super.key});

  @override
  State<HomeDemo> createState() => _HomeDemoState();
}

class _HomeDemoState extends State<HomeDemo> {
  List<String> services = ['home', 'service', 'about', 'contact'];
  List<String> servicesData = [
    'Home section content. ' * 50,
    'Service section content is longer. ' * 50,
    'About section has detailed info. ' * 45,
    'Contact section with address and forms. ' * 35,
  ];

  int selectedIndex = 0;

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = [];
  final List<double> _sectionHeights = [];

  @override
  void initState() {
    super.initState();
    _sectionKeys.addAll(List.generate(services.length, (_) => GlobalKey()));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 100));
      _calculateHeights();
    });
    _scrollController.addListener(_onScroll);
  }

  void _calculateHeights() {
    _sectionHeights.clear();
    for (var key in _sectionKeys) {
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        _sectionHeights.add(box.size.height);
      }
    }
  }

  void _onScroll() {
    double offset = _scrollController.offset;
    double currentOffset = 0;

    for (int i = 0; i < _sectionHeights.length; i++) {
      double sectionHeight = _sectionHeights[i];
      if (offset >= currentOffset && offset < currentOffset + sectionHeight) {
        if (selectedIndex != i) {
          setState(() {
            selectedIndex = i;
          });
        }
        break;
      }
      currentOffset += sectionHeight;
    }
  }

  void scrollToIndex(int index) {
    double targetOffset = 0;
    for (int i = 0; i < index; i++) {
      if (i < _sectionHeights.length) {
        targetOffset += _sectionHeights[i];
      }
    }

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TOP NAV BAR
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: services.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  bool isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () => scrollToIndex(index),
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black,
                        fontSize: 16,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                        child: Text(services[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),

            // MAIN SCROLLING CONTENT
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: servicesData.length,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemBuilder: (context, index) {
                  return Container(
                    key: _sectionKeys[index],
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      servicesData[index],
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
