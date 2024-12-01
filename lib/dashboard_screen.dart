import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_fund/database_helper.dart';
import 'package:my_fund/transaction_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() {
    return _DashboardScreenState();
  }

}

class _DashboardScreenState extends State<DashboardScreen>{
  late Future<double> total_income;
  late Future<double> total_expenses;


  void initState(){
    super.initState();
    total_income = DatabaseHelper().getTotalIncomeForCurrentMonth();
    total_expenses = DatabaseHelper().getTotalExpensesForCurrentMonth();

  }


  TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Dashboard",style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text(
                      DateFormat('dd MMMM, yyyy').format(DateTime.now()),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder(
                            future: total_income,
                            builder: (context, incomeSanpshot){
                              if(incomeSanpshot.connectionState == ConnectionState.waiting){
                                return Center(child: CircularProgressIndicator());
                              }else if(incomeSanpshot.hasError){
                                return Text("Error : ${incomeSanpshot.error}");
                              }else if(incomeSanpshot.hasData) {
                                double totalIncome = incomeSanpshot.data ?? 0.0;
                                return _buildOverviewCard('Total Income', totalIncome.toStringAsFixed(2), Icons.monetization_on,Colors.blue);
                              }else {
                                return Text("No Data Available");
                              }
                            }),

                        FutureBuilder(
                            future: total_expenses,
                            builder: (context,expensesSnapshot){
                              if(expensesSnapshot.connectionState == ConnectionState.waiting){
                                return Center(child: CircularProgressIndicator(),);
                              }else if(expensesSnapshot.hasError){
                                return Text("Error: ${expensesSnapshot.error}");
                              }else if(expensesSnapshot.hasData){
                                double totalExpenses = expensesSnapshot.data ?? 0.0;
                                return _buildOverviewCard('Total Expenses', totalExpenses.toStringAsFixed(2), Icons.shopping_cart, Colors.red);
                              }else{
                                return Text("No Data Available");
                              }
                            }),
                        FutureBuilder(
                            future: Future.wait([total_income,total_expenses]),
                            builder: (context,snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return Center(child: CircularProgressIndicator(),);
                              }else if(snapshot.hasError){
                                return Text('Error : ${snapshot.error}');
                              }else if(snapshot.hasData) {
                                double totalIncome = snapshot.data![0];
                                double totalExpenses = snapshot.data![1];
                                double totalSaving = totalIncome - totalExpenses;
                                return _buildOverviewCard('Net Saving', totalSaving.toStringAsFixed(2), Icons.savings, Colors.green);
                              }else {
                                return Text('No data Available');
                              }
                            }),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 250,
                          width: 200,
                          child: FutureBuilder(
                              future: Future.wait([total_income,total_expenses]),
                              builder: (context,snapshot){
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return Center(child: CircularProgressIndicator(),);
                                }else if(snapshot.hasError){
                                  return Text('Error : ${snapshot.error}');
                                }else if(snapshot.hasData){
                                  double totalIncome = snapshot.data![0];
                                  double totalExpenses = snapshot.data![1];
                                  double totalSaving = totalIncome - totalExpenses;
                                  return PieChart(
                                      PieChartData(
                                        sections: getSections(totalIncome,totalExpenses,totalSaving),
                                        centerSpaceRadius: 50,
                                        sectionsSpace: 3,
                                      )
                                  );
                                }else {
                                  return Text('No Data Available');
                                }
                              }),

                        ),
                        SizedBox(width: 10,),
                        Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PieLegends('Net Savings', Colors.green),
                            SizedBox(height: 5,),
                            PieLegends('Total Expenses', Colors.red),

                          ],
                        )
                      ],
                    ),

                    SizedBox(height: 5,),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 8.0,right: 8.0),
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text('Recent Transactions',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    ),

                    FutureBuilder(
                        future: DatabaseHelper().getLastFiveTransactions(),
                        builder: (context,snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator(),);
                          }
                          else if( snapshot.hasError){
                            return Center(child: Text("error: ${snapshot.error}"),);
                          } else if(snapshot.hasData){
                            // Extract data from the snapshot
                            List<Map<String, dynamic>> data = snapshot.data!;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index){
                                String categoryName = data[index]['category_name'];
                                String subcategoryName = data[index]['subcategory_name'];
                                String note = data[index]['notes'];
                                String date = data[index]['date'];
                                date = formatDate(date);
                                String amount = data[index]['amount'].toString();
                                String type = data[index]['type'];
                                Color color = type == 'Income' ? Colors.green : Colors.red;
                                amount = type == 'Income' ? '+$amount' : '-$amount';

                                return buildTransactionTile(categoryName,subcategoryName, date, amount, note, color);

                              },
                            );

                          }else{
                            return (Center(child: Text("No Data Available"),));
                          }
                        }),

                  ],
                ),
              ),),


        ],
      );
  }

}


Widget _buildOverviewCard(String title, String amount, IconData icon, Color color){
  List<String> strings = title.split(" ");
  String formatedAmount = formatNumber(amount);
  return  SizedBox(
    width: 120.0,
    child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(icon,size: 30, color: color,),
              SizedBox(height: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strings[0],style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  Text(strings[1],style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  SizedBox(height: 4,),
                  Text("₹"+formatedAmount,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: color),)
                ],
              ),

            ],
          ),
        )
    ),
  );
}

String formatNumber(String number){
  double num = double.parse(number);
  final formatter = NumberFormat('#,###');
  print('format : ${formatter.format(num)}');
  return formatter.format(num);
}

List<PieChartSectionData> getSections(double totalIncome, double totalExpenses,double netSavings){

  return[
    // Section for Expenses
    PieChartSectionData(
      color: Colors.red,
      value: totalExpenses,
      title: '${((totalExpenses / totalIncome) * 100).toStringAsFixed(1)}%',
      radius: 50,
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:Colors.white),
    ),
    // Section for Savings
    PieChartSectionData(
      color: Colors.green,
      value: netSavings,
      title: '${((netSavings / totalIncome) * 100).toStringAsFixed(1)}%',
      radius: 50,
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),

    )
  ];
}

Widget PieLegends(String title, Color color){
  return Row(
    children: [
      Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: color,
        ),
      ),
      SizedBox(width: 5,),
      Text(title,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
    ],
  );
}

Widget buildTransactionTile(String category, String subcategory, String date, String amount, String note, Color color){
  IconData icon = getIcon(category);
  return Padding(padding: EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon,color: Colors.blue,),
        SizedBox(width: 16,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 4,),
            Text(subcategory,style: TextStyle(fontSize: 14,color: Colors.grey),),
            Text(date,style: TextStyle(fontSize: 14,color: Colors.grey),),
            Text(note,style: TextStyle(fontSize:12,color: Colors.grey),),
          ],
        ),
        Spacer(),
        Text(amount,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: color),),
      ],
    ),
  );
}

editSalaryPanelDialog(BuildContext context){
  AlertDialog salaryDialog = AlertDialog(
    title: Text("Salary"),
    content: Form(child: Column(

      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Enter Salary',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value){
            if(value == null || value.isEmpty){
              return 'Please enter a number';
            }
            return null;
          },
        ),
      ],
    )),
    actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop();
      }, child: Text("Save"))
    ],
  );

  showDialog(context: context, builder: (BuildContext context){
    return salaryDialog;
  });
}

String formatDate(String date){
  // Parse the date string
  DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
  // Format the parsed date into "dd MMMM, yyyy"
  String formattedDate = DateFormat("dd MMMM, yyyy").format(parsedDate);
  return formattedDate;
}