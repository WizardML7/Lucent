import 'package:flutter/material.dart';

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
      home: const HomePage(),
    );
  }
}

class Device {
  final String name;
  final String ipAddress;
  final String macAddress;
  final String type; // Example: "Smartphone", "Smart TV", "Laptop"
  final bool isOnline;

  Device({
    required this.name,
    required this.ipAddress,
    required this.macAddress,
    required this.type,
    required this.isOnline,
  });
}

List<Device> mockDevices = [
  Device(
    name: "Samsung Galaxy S21",
    ipAddress: "192.168.1.2",
    macAddress: "00:14:22:01:23:45",
    type: "Smartphone",
    isOnline: true,
  ),
  Device(
    name: "Dell XPS 13",
    ipAddress: "192.168.1.3",
    macAddress: "00:16:36:12:56:78",
    type: "Laptop",
    isOnline: true,
  ),
  Device(
    name: "Google Nest Hub",
    ipAddress: "192.168.1.4",
    macAddress: "00:1A:11:FA:67:89",
    type: "Smart Display",
    isOnline: false,
  ),
  Device(
    name: "Sony Bravia TV",
    ipAddress: "192.168.1.5",
    macAddress: "00:22:68:AB:CD:EF",
    type: "Smart TV",
    isOnline: true,
  ),
  Device(
    name: "Apple Watch",
    ipAddress: "192.168.1.6",
    macAddress: "00:25:96:89:AB:12",
    type: "Wearable",
    isOnline: false,
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lucent Home'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu), // Hamburger menu icon
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open drawer menu
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
              leading: const Icon(Icons.history),
              title: const Text('Scan History'),
              onTap: () {
                // TODO: Navigate to Scan History screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help and Support'),
              onTap: () {
                // TODO: Navigate to Help and Support screen
              },
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           ClipOval(
            child: Image.asset(
              'assets/images/logo.png',
              height: 100,  // Adjust height to your needs
              width: 100,   // Adjust width to your needs
              fit: BoxFit.cover,  // Ensures the image fits the circular frame
            ),
          ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Lucent!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Discover devices in your network.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
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
                  MaterialPageRoute(builder: (context) => const ScanOptionsPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Scan',
              onPressed: () {
                // TODO: Start scanning process
              },
            ),
            IconButton(
              icon: const Icon(Icons.list),
              tooltip: 'Results',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

//Scan options widget
class ScanOptionsPage extends StatefulWidget {
  const ScanOptionsPage({super.key});

  @override
  _ScanOptionsPageState createState() => _ScanOptionsPageState();
}

class _ScanOptionsPageState extends State<ScanOptionsPage> {
  // State variables for the options
  String _scanMode = 'Quick Scan'; // Default scan mode
  double _scanRange = 50.0; // Default scan range (e.g., percentage)
  double _scanDuration = 30.0; // Default scan duration in seconds
  bool _notificationSound = true; // Default notification sound setting

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Scan Mode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _scanMode,
              items: const [
                DropdownMenuItem(value: 'Quick Scan', child: Text('Quick Scan')),
                DropdownMenuItem(value: 'Deep Scan', child: Text('Deep Scan')),
                DropdownMenuItem(value: 'Bluetooth-Only Scan', child: Text('Bluetooth-Only Scan')),
                DropdownMenuItem(value: 'Network-Only Scan', child: Text('Network-Only Scan')),
                DropdownMenuItem(value: 'Hybrid Scan', child: Text('Hybrid Scan')),
              ],
              onChanged: (String? newMode) {
                setState(() {
                  _scanMode = newMode!;
                });
                // Unfocus the dropdown after selection to reset hover/focus state
                FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Scan Range',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _scanRange,
              min: 0,
              max: 100,
              divisions: 5,
              label: _scanRange.round().toString(),
              onChanged: (double newRange) {
                setState(() {
                  _scanRange = newRange;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Scan Duration (seconds)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _scanDuration,
              min: 10,
              max: 300,
              divisions: 29,
              label: _scanDuration.round().toString(),
              onChanged: (double newDuration) {
                setState(() {
                  _scanDuration = newDuration;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Notification Sound',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Enable Sound Alerts'),
              value: _notificationSound,
              onChanged: (bool newValue) {
                setState(() {
                  _notificationSound = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}


//Settings widget
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;  // Notification toggle state
  bool _locationAccess = false;       // Location toggle state (Privacy)
  bool _bluetoothAccess = true;       // Bluetooth toggle state (Privacy)
  bool _darkMode = false;             // Theme toggle state
  String _selectedLanguage = 'English';  // Language preference state

  // List of supported languages
  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];

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

            // Language Preferences
            const Text('Language Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              title: const Text('Select Language'),
              subtitle: Text(_selectedLanguage),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                _showLanguageDialog();
              },
            ),
            const Divider(),

            // Other Settings Example (e.g., clear history)
            ListTile(
              title: const Text('Clear Scan History'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                // TODO: Implement Clear Scan History functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the language selection dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.of(context).pop(); // Close the dialog after selection
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Results'),
      ),
      body: ListView.builder(
        itemCount: mockDevices.length,
        itemBuilder: (context, index) {
          final Device device = mockDevices[index];
          return Card(
            child: ListTile(
              leading: Icon(
                device.isOnline ? Icons.wifi : Icons.wifi_off,
                color: device.isOnline ? Colors.green : Colors.red,
              ),
              title: Text(device.name),
              subtitle: Text('${device.type}\nIP: ${device.ipAddress}\nMAC: ${device.macAddress}'),
              isThreeLine: true,
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          );
        },
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
              'Domenic Lo Iacono and Kyri Christensen',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
