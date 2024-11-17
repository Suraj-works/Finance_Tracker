import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_fund/dashboard_screen.dart';
import 'package:my_fund/database_helper.dart';
import 'package:my_fund/goal_screen.dart';
import 'package:my_fund/report_screen.dart';
import 'package:my_fund/transaction_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Fund',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen()
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
  return _HomeScreenState();
  }

}

class _HomeScreenState extends State<HomeScreen>{
  int _currentNaviIndex = 0; // to keep track of the selected tab

  final List<Widget> _screens = [
    DashboardScreen(),
    TransactionScreen(),
    ReportScreen(),
    GoalScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentNaviIndex = index; // to update the current index when an item is tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Funds",
        style: TextStyle(fontWeight: FontWeight.w600),),
        backgroundColor: Colors.teal,
      ),
      body: _screens[_currentNaviIndex], // display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNaviIndex, // set the currently selected index
        onTap: _onTabTapped, // handle the taps
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize),
              label: 'Dashboard',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Transactions',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Reports',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.flag),
              label: 'Goals',
          ),
        ],
        selectedItemColor: Colors.blue, // selected tab color
        unselectedItemColor: Colors.grey, // unselected tab color
      ),
      floatingActionButton: _shouldShowFloatingButton(),
    );
  }

  // Logic for the FloatingActionButton
  Widget? _shouldShowFloatingButton(){
    if(_currentNaviIndex == 1){
      return FloatingActionButton(
          onPressed: (){
            showAddTransactionDialog(context);
          },
          child: Icon(Icons.add),
          tooltip: 'Add Transaction',
          backgroundColor: Colors.blueAccent,
      );
    }
    if(_currentNaviIndex == 3){
      return FloatingActionButton(
          onPressed: (){},
          child: Icon(Icons.add),
          tooltip: 'Add Goal',
          backgroundColor: Colors.blueAccent,
      );
    }
    return null; // to hide the FAB
  }


  void showAddTransactionDialog(BuildContext context){
    final _formKey = GlobalKey<FormState>();
    TextEditingController amountController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Transaction'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Amount'),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: dateController,
                    readOnly: true, // So user can't type in the date feild
                    decoration: InputDecoration(labelText: 'Date'),
                    onTap: () async{
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if(pickedDate != null){
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        dateController.text = formattedDate; // set Date in the textfield
                      }
                    },
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please pick a date';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Please enter a category";
                      }
                    },
                  ),
                  TextFormField(
                    controller: typeController,
                    decoration: InputDecoration(labelText:'Type'),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter the type of transaction';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: notesController,
                    decoration: InputDecoration(labelText: "Notes"),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter notes';
                      }
                      return null;
                    },
                  ),

                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                }, child: Text("Cancel"),
            ),
            ElevatedButton(
                onPressed:(){
                  if(_formKey.currentState!.validate()){
                    // _addTransactionToDatabase(
                    //   amountController.text,
                    //   dateController.text,
                    //   categoryController.text,
                    //   typeController.text,
                    //   notesController.text,
                    // );
                    Navigator.of(context).pop(); // close the dialog
                  }
                },
                child: Text("Add Transaction")
            ),
          ],
        );
      }
    );

  }

// Method to insert data into the database
_addTransactionToDatabase(
    String amount,
    String date,
    String categoryId,
    String type,
    String notes
    ) async{
    DatabaseHelper.instance.insertTransaction({

    });
}

}

