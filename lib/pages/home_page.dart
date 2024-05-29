import 'package:flutter/material.dart';
import 'models/swapping_record.dart';
import 'swapping_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SwappingRecord> _swappingRecords = [];

  void _addSwappingRecord(SwappingRecord record) {
    setState(() {
      _swappingRecords.add(record);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swaps Application'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('John Doe'),
              accountEmail: Text('johndoe@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'JD',
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Stock'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/stock');
              },
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text('Expenses'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/expenses');
              },
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('Note'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/note');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Perform logout actions
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _swappingRecords.length,
        itemBuilder: (context, index) {
          final record = _swappingRecords[index];
          return ListTile(
            title: Text('Record ID: ${record.id}'),
            subtitle: Text('Date: ${record.date.toLocal()}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Swapping Details'),
                  content: Text(
                    'Rider ID: ${record.riderId}\n'
                    'Bike ID: ${record.bikeId}\n'
                    'Mileage: ${record.mileage}\n'
                    'Gauge In: ${record.gaugeIn}\n'
                    'Battery In: ${record.batteryIn}\n'
                    'Gauge Out: ${record.gaugeOut}\n'
                    'Battery Out: ${record.batteryOut}\n'
                    'Charger: ${record.charger}\n'
                    'Comment: ${record.comment}\n'
                    'Price: UGX ${record.price}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SwappingPage(),
            ),
          );

          if (result != null && result is SwappingRecord) {
            _addSwappingRecord(result);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
