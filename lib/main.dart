import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucent',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const HomeWidget(),
    );
  }
}

class Device {
  String name;
  final String ipAddress;
  final String macAddress;
  final String type;
  final bool isOnline;
  final bool isBluetoothDevice;
  final bool isNetworkDevice;

  Device({
    required this.name,
    required this.ipAddress,
    required this.macAddress,
    required this.type,
    required this.isOnline,
    this.isBluetoothDevice = false,
    this.isNetworkDevice = true, // Default to true for network devices
  });
}

List<Device> mockDevices = [
  Device(
    name: "Samsung Galaxy S21",
    ipAddress: "192.168.1.2",
    macAddress: "00:14:22:01:23:45",
    type: "Smartphone",
    isOnline: true,
    isBluetoothDevice: true,
    isNetworkDevice: true,
  ),
  Device(
    name: "Dell XPS 13",
    ipAddress: "192.168.1.3",
    macAddress: "00:16:36:12:56:78",
    type: "Laptop",
    isOnline: true,
    isBluetoothDevice: true,
    isNetworkDevice: true,
  ),
  Device(
    name: "Google Nest Hub",
    ipAddress: "192.168.1.4",
    macAddress: "00:1A:11:FA:67:89",
    type: "Smart Display",
    isOnline: false,
    isBluetoothDevice: false,
    isNetworkDevice: true,
  ),
  Device(
    name: "Sony Bravia TV",
    ipAddress: "192.168.1.5",
    macAddress: "00:22:68:AB:CD:EF",
    type: "Smart TV",
    isOnline: true,
    isBluetoothDevice: false,
    isNetworkDevice: true,
  ),
  Device(
    name: "Apple Watch",
    ipAddress: "192.168.1.6",
    macAddress: "00:25:96:89:AB:12",
    type: "Wearable",
    isOnline: false,
    isBluetoothDevice: true,
    isNetworkDevice: false, // Not typically a network device
  ),
  Device(
    name: "Netgear Nighthawk Router",
    ipAddress: "192.168.1.1",
    macAddress: "00:1B:44:11:3A:B7",
    type: "Router",
    isOnline: true,
    isBluetoothDevice: false,
    isNetworkDevice: true,
  ),
  Device(
    name: "iPhone 14 Pro",
    ipAddress: "192.168.1.7",
    macAddress: "00:1E:DC:9A:3B:65",
    type: "Smartphone",
    isOnline: true,
    isBluetoothDevice: true,
    isNetworkDevice: true,
  ),
  Device(
    name: "MacBook Air M2",
    ipAddress: "192.168.1.8",
    macAddress: "00:17:88:6A:4B:33",
    type: "Laptop",
    isOnline: false,
    isBluetoothDevice: true,
    isNetworkDevice: true,
  ),
  Device(
    name: "Unknown Device",
    ipAddress: "192.168.1.9",
    macAddress: "00:99:23:AF:54:78",
    type: "Unrecognized",
    isOnline: true,
    isBluetoothDevice: false,
    isNetworkDevice: true,
  ),
];

// List<Device> _filterDevicesByScanMode(String scanMode, List<Device> devices) {
//   switch (scanMode) {
//     case 'Bluetooth-Only Scan':
//       return devices.where((device) => device.isBluetoothDevice).toList();
//     case 'Network-Only Scan':
//       return devices.where((device) => device.isNetworkDevice).toList();
//     case 'Hybrid Scan':
//       return devices
//           .where((device) => device.isBluetoothDevice || device.isNetworkDevice)
//           .toList();
//     case 'Quick Scan':
//     case 'Deep Scan':
//     default:
//       return devices; // Show all devices
//   }
// }

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
  bool _isGraphView = false;
  bool isScanning = false;
  bool scanComplete = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadViewPreference();

    // Initialize AnimationController
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Define Scale Animation using Tween
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse(); // Return to original size
      }
    });
  }

  void _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGraphView = prefs.getBool('isGraphView') ?? false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startMockScan() async {
    setState(() {
      isScanning = true;
      scanComplete = false;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isScanning = false;
      scanComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lucent Home'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help and Support'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About the App'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTapDown: (_) {
                if (!isScanning) _animationController.forward();
              },
              onTapUp: (_) {
                if (!isScanning) {
                  _animationController.reverse();
                  startMockScan();
                }
              },
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return InkWell(
                    splashColor: Colors.blue.withOpacity(0.4), // Ripple color
                    highlightColor: Colors.transparent, // No highlight
                    onTap: () {}, // Empty onTap to prevent accidental actions
                    child: ClipOval(
                      child: Container(
                        height: 250 * _scaleAnimation.value, // Animate the logo size
                        width: 250 * _scaleAnimation.value,
                        color: Colors.transparent, // No color, just to size the container
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: InkWell(
              onTap: () {
                if (!isScanning) {
                  _animationController.forward();
                  startMockScan();
                }
              },
              child: Container(
                color: Colors.transparent, // Full screen tapable area
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Options',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScanOptionsPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.list),
              tooltip: 'Results',
              onPressed: () async {
                _loadViewPreference();
                if (scanComplete) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          _isGraphView ? ResultsGraphPage() : ResultsPage(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}




// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

class ScanOptionsPage extends StatefulWidget {
  const ScanOptionsPage({super.key});

  @override
  _ScanOptionsPageState createState() => _ScanOptionsPageState();
}

class _ScanOptionsPageState extends State<ScanOptionsPage> {
  String _scanMode = 'Quick Scan';
  late Future<void> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _loadingFuture = _loadScanMode();
  }

  Future<void> _loadScanMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString('scanMode');
      setState(() {
        _scanMode = savedMode ?? 'Quick Scan';
      });
    } catch (e) {
      print('Error loading scan mode: $e');
    }
  }

  Future<void> _saveScanMode(String mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('scanMode', mode);
    } catch (e) {
      print('Error saving scan mode: $e');
    }
  }

  void _startScan() {
    Navigator.pop(context); // Close the ScanOptionsPage and return to the previous page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting $_scanMode...'),
        duration: const Duration(seconds: 2),
      ),
    );
    // Here you can trigger the scan logic based on the selected scan mode
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Scan Mode'),
      ),
      body: FutureBuilder<void>(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load scan options'));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select Scan Type',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 129, 71, 104),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _scanMode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    style: const TextStyle(fontSize: 18,
                    color: Color.fromARGB(255, 129, 71, 104)),
                    items: const [
                      DropdownMenuItem(value: 'Quick Scan', child: Text('Quick Scan')),
                      DropdownMenuItem(value: 'Deep Scan', child: Text('Deep Scan')),
                      DropdownMenuItem(value: 'Bluetooth-Only Scan', child: Text('Bluetooth-Only Scan')),
                      DropdownMenuItem(value: 'Network-Only Scan', child: Text('Network-Only Scan')),
                      DropdownMenuItem(value: 'Hybrid Scan', child: Text('Hybrid Scan')),
                    ],
                    onChanged: (String? newMode) {
                      if (newMode != null) {
                        setState(() {
                          _scanMode = newMode;
                          _saveScanMode(newMode);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _startScan,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Start Scan'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}




//Settings widget
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;  // Notification toggle state
  bool _locationAccess = false;       // Location toggle state (Privacy)
  bool _bluetoothAccess = true;       // Bluetooth toggle state (Privacy)
  bool _darkMode = false;             // Theme toggle state
  //String _selectedLanguage = 'English';  // Language preference state
  bool _isGraphView = false;         // Persistent state for results view

  // final List<String> _languages = ['English', 'Spanish', 'French', 'German'];

  @override
  void initState() {
    super.initState();
    _loadViewPreference();
  }

  // Load view preference from shared preferences
  void _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGraphView = prefs.getBool('isGraphView') ?? false;
    });
  }

  // Toggle view preference and save it
  void _toggleViewPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGraphView = value;
    });
    await prefs.setBool('isGraphView', _isGraphView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Notification Settings
            const Text('Notification Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            const Divider(),

            // Privacy Settings
            const Text('Privacy Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Allow Location Access'),
              value: _locationAccess,
              onChanged: (bool value) {
                setState(() {
                  _locationAccess = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Allow Bluetooth Access'),
              value: _bluetoothAccess,
              onChanged: (bool value) {
                setState(() {
                  _bluetoothAccess = value;
                });
              },
            ),
            const Divider(),

            // Theme Settings
            const Text('Theme Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _darkMode,
              onChanged: (bool value) {
                setState(() {
                  _darkMode = value;
                });
              },
            ),
            const Divider(),

            // View Preference
            const Text('Choose Results View:', style: TextStyle(fontSize: 18)),
            SwitchListTile(
              title: const Text('Graph View'),
              value: _isGraphView,
              onChanged: (value) {
                _toggleViewPreference(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}


class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  //##
  String _scanMode = 'Quick Scan';

  @override
  void initState() {
    super.initState();
    _loadScanMode();
  }

  Future<void> _loadScanMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _scanMode = prefs.getString('scanMode') ?? 'Quick Scan';
    });
  }

  List<Device> _filterDevicesByScanMode(List<Device> devices) {
    switch (_scanMode) {
      case 'Bluetooth-Only Scan':
        return devices.where((device) => device.isBluetoothDevice).toList();
      case 'Network-Only Scan':
        return devices.where((device) => device.isNetworkDevice).toList();
      case 'Hybrid Scan':
        // Filter for devices that are either Bluetooth or Network
        return devices
            .where((device) => device.isBluetoothDevice || device.isNetworkDevice)
            .toList();
      case 'Quick Scan':
      case 'Deep Scan':
      default:
        // Show all devices for Quick and Deep Scan
        return devices;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter devices based on the selected scan mode
    List<Device> filteredDevices = _filterDevicesByScanMode(mockDevices);

    // Separating devices into online and offline lists
    List<Device> onlineDevices =
        filteredDevices.where((device) => device.isOnline).toList();
    List<Device> offlineDevices =
        filteredDevices.where((device) => !device.isOnline).toList();

    //##
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Results'),
      ),
      body: ListView(
        children: [
          // Online Devices Section
          if (onlineDevices.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Online Devices',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          // List of Online Devices
          ...onlineDevices.map((device) {
            Icon deviceIcon = _getDeviceIcon(device.type, isOnline: true);
            return _buildDeviceTile(context, device, deviceIcon);
          }).toList(),

          const Divider(),

          // Offline Devices Section
          if (offlineDevices.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Offline Devices',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          // List of Offline Devices
          ...offlineDevices.map((device) {
            Icon deviceIcon = _getDeviceIcon(device.type, isOnline: false);
            return _buildDeviceTile(context, device, deviceIcon);
          }).toList(),
        ],
      ),
    );
  }

  // Helper method to build a ListTile for a device
  ListTile _buildDeviceTile(BuildContext context, Device device, Icon deviceIcon) {
    return ListTile(
      leading: deviceIcon,
      title: Text(device.name),
      subtitle: Text(
        '${device.type}\nIP: ${device.ipAddress}\nMAC: ${device.macAddress}',
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceDetailPage(device: device),
          ),
        );
      },
    );
  }

  // Helper method to determine the device icon based on type and status
  Icon _getDeviceIcon(String deviceType, {required bool isOnline}) {
    Color iconColor = isOnline ? Colors.green : Colors.red;

    switch (deviceType) {
      case "Smartphone":
        return Icon(Icons.smartphone, color: iconColor);
      case "Laptop":
        return Icon(Icons.laptop, color: iconColor);
      case "Smart Display":
        return Icon(Icons.smart_toy, color: iconColor);
      case "Smart TV":
        return Icon(Icons.tv, color: iconColor);
      case "Wearable":
        return Icon(Icons.watch, color: iconColor);
      case "Router":
        return Icon(Icons.router, color: iconColor);
      default:
        return Icon(Icons.help, color: iconColor);
    }
  }
}


// #################################################


class ResultsGraphPage extends StatefulWidget {
  const ResultsGraphPage({super.key});

  @override
  _ResultsGraphPageState createState() => _ResultsGraphPageState();
}

class _ResultsGraphPageState extends State<ResultsGraphPage> {
  //##
  final Random random = Random();
  Map<String, Offset> devicePositions = {};
  Map<String, Offset> initialPositions = {}; // Store initial positions for dragging
  String? selectedDevice; // Track currently selected device (for tapping)
  Offset? dragStartPosition; // Store the starting position for drag
  String _scanMode = 'Quick Scan'; // Default scan mode
  //##
  
  @override
  void initState() {
    super.initState();
    _loadScanMode();
  }

  Future<void> _loadScanMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _scanMode = prefs.getString('scanMode') ?? 'Quick Scan';
    });
  }

  List<Device> _filterDevicesByScanMode(List<Device> devices) {
    switch (_scanMode) {
      case 'Bluetooth-Only Scan':
        return devices.where((device) => device.isBluetoothDevice).toList();
      case 'Network-Only Scan':
        return devices.where((device) => device.isNetworkDevice).toList();
      case 'Hybrid Scan':
        // Filter for devices that are either Bluetooth or Network
        return devices
            .where((device) => device.isBluetoothDevice || device.isNetworkDevice)
            .toList();
      case 'Quick Scan':
      case 'Deep Scan':
      default:
        // Show all devices for Quick and Deep Scan
        return devices;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter devices based on the selected scan mode
    List<Device> filteredDevices = _filterDevicesByScanMode(mockDevices);

    // Separating devices into online and offline lists
    List<Device> onlineDevices =
        filteredDevices.where((device) => device.isOnline).toList();
    List<Device> offlineDevices =
        filteredDevices.where((device) => !device.isOnline).toList();

    //##
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph View of Devices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomPaint(
          painter: GraphGridPainter(
            gridColor: Colors.blueGrey,
            gridSpacing: 30.0,
          ),
          child: Center(
            child: Flow(
              delegate: DeviceFlowDelegate(devicePositions: devicePositions),
              children: filteredDevices.map((device) {
                // Set initial position if not yet set
                if (!devicePositions.containsKey(device.name)) {
                  devicePositions[device.name] = Offset(
                    random.nextDouble() * 300, // Random initial x position
                    random.nextDouble() * 300, // Random initial y position
                  );
                  initialPositions[device.name] = devicePositions[device.name]!;
                }

                // Determine the icon based on the device type
                Icon deviceIcon = _getDeviceIcon(device.type, isOnline: device.isOnline);

                return GestureDetector(
                  onTap: () {
                    if (selectedDevice != device.name) {
                      setState(() {
                        selectedDevice = device.name;
                      });
                      // Navigate to device details page when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeviceDetailPage(device: device),
                        ),
                      );
                    }
                  },
                  onPanStart: (details) {
                    // Store initial position when the drag starts
                    dragStartPosition = details.localPosition;
                  },
                  onPanUpdate: (details) {
                    // Update the position based on the drag movement
                    setState(() {
                      if (dragStartPosition != null) {
                        devicePositions[device.name] = initialPositions[device.name]! +
                            (details.localPosition - dragStartPosition!);
                      }
                    });
                  },
                  onPanEnd: (details) {
                    // Store the new position after the drag ends
                    setState(() {
                      initialPositions[device.name] = devicePositions[device.name]!;
                      dragStartPosition = null;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      deviceIcon,
                      const SizedBox(height: 5),
                      Text(
                        device.name,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to determine the device icon based on type and status
  Icon _getDeviceIcon(String deviceType, {required bool isOnline}) {
    Color iconColor = isOnline ? Colors.green : Colors.red;

    switch (deviceType) {
      case "Smartphone":
        return Icon(Icons.smartphone, size: 40, color: iconColor);
      case "Laptop":
        return Icon(Icons.laptop, size: 40, color: iconColor);
      case "Smart Display":
        return Icon(Icons.smart_toy, size: 40, color: iconColor);
      case "Smart TV":
        return Icon(Icons.tv, size: 40, color: iconColor);
      case "Wearable":
        return Icon(Icons.watch, size: 40, color: iconColor);
      case "Router":
        return Icon(Icons.router, size: 40, color: iconColor);
      default:
        return Icon(Icons.help, size: 40, color: iconColor);
    }
  }
}


// Custom FlowDelegate to position device icons
class DeviceFlowDelegate extends FlowDelegate {
  final Map<String, Offset> devicePositions;
  DeviceFlowDelegate({required this.devicePositions});

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++) {
      final device = mockDevices[i];
      final position = devicePositions[device.name]!;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(position.dx, position.dy, 0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => true;
}

//########

class GraphGridPainter extends CustomPainter {
  final Color gridColor;
  final double gridSpacing;

  GraphGridPainter({this.gridColor = Colors.grey, this.gridSpacing = 20.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor.withOpacity(0.2)
      ..strokeWidth = 1.0;

    // Draw horizontal grid lines
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical grid lines
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ###################################

class DeviceDetailPage extends StatefulWidget {
  final Device device;

  const DeviceDetailPage({super.key, required this.device});

  @override
  _DeviceDetailPageState createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    // Initialize the text controller with the current device name
    _nameController = TextEditingController(text: widget.device.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveDeviceName() {
    setState(() {
      widget.device.name = _nameController.text;
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Device name updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.device.type,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            const Text(
              'Change Device Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Text field to edit the device name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Device Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Save button to update the name
            ElevatedButton(
              onPressed: _saveDeviceName,
              child: const Text('Save'),
            ),
            const Divider(height: 32),

            Text(
              'IP Address: ${widget.device.ipAddress}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'MAC Address: ${widget.device.macAddress}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${widget.device.isOnline ? "Online" : "Offline"}',
              style: TextStyle(
                fontSize: 16,
                color: widget.device.isOnline ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// New AboutPage widget
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Lucent'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              'Lucent App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Lucent helps you discover and manage devices in your network, '
              'with a focus on ease of use for both technical and non-technical users. '
              'This app provides features like device scanning, results overview, '
              'and more to enhance your awareness of the devices connected to your network.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Developed by:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Domenic Lo Iacono and Kyri Lea',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
