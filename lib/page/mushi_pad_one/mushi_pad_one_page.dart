import 'package:flutter/material.dart';
import 'change_doctor_page.dart';
import 'change_hosts_page.dart';

class MuShiPadOnePage extends StatefulWidget {
  const MuShiPadOnePage({Key? key}) : super(key: key);

  @override
  State<MuShiPadOnePage> createState() => _MuShiPadOnePageState();
}

class _MuShiPadOnePageState extends State<MuShiPadOnePage> {
  int _selectedIndex = 0;
  final Map<int, Widget> _pages = {
    0: const ChangeHostsPage(),
    1: const ChangeDoctorPage(),
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = _pages[_selectedIndex]!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              child: const Text('修改Hosts'),
            ),
            const SizedBox(width: 30),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: const Text('替换Doctor'),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
