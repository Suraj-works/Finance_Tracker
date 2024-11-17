import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_fund/database_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() {
    return _DashboardScreenState();
  }

}

class _DashboardScreenState extends State<DashboardScreen>{
  num total_income = 0.0;

  void initState(){
    super.initState();
    someFunction();
  }

  void someFunction() async{
    total_income = await DatabaseHelper().getTotalIncomeForCurrentMonth() as double;
    print('total_income $total_income');
    List<Map<String, dynamic>> transactions = await DatabaseHelper().getTransaction();
    for (var transaction in transactions) {
      print(transaction);  // This will print each transaction map
    }

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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOverviewCard('Total Income', '$total_income', Icons.monetization_on, Colors.blue),
              _buildOverviewCard('Total Expenses', '3200', Icons.shopping_cart, Colors.red),
              _buildOverviewCard('Net Saving', '1800', Icons.savings, Colors.green),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                width: 200,
                child: PieChart(
                    PieChartData(
                      sections: getSections(),
                      centerSpaceRadius: 50,
                      sectionsSpace: 3,
                    )
                ),
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
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                buildTransactionTile("Grocery Shopping", 'Food', 'Oct 24, 2023', '-150', Colors.red),
                buildTransactionTile("Electricity Bill", 'Bills', 'Oct 25, 2023', '-70', Colors.red),
                buildTransactionTile("Grocery Shopping", 'Food', 'Oct 24, 2023', '-150', Colors.red),

              ],
            ),
          )
        ],
      );
  }

}

Widget _piechart(List <_ChartData> data, TooltipBehavior _tooltip){
  return SfCircularChart(
      tooltipBehavior: _tooltip,
      series: <CircularSeries<_ChartData, String>>[
        DoughnutSeries<_ChartData, String>(
          dataSource: data,
          xValueMapper: (_ChartData data, _)=> data.x,
          yValueMapper: (_ChartData data, _)=> data.y,
          name: 'Gold',
        )
      ]
  );
}

class _ChartData {
  _ChartData(this.x,this.y);
  final String x;
  final double y;
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
  final formatter = NumberFormat('#,###.##');
  return formatter.format(num);
}

List<PieChartSectionData> getSections(){
  var totalSalary =5000.0;
  var totalExpenses = 3200.0;
  var netSavings = 1800.0;
  return[
    // Section for Expenses
    PieChartSectionData(
      color: Colors.red,
      value: totalExpenses,
      title: '${((totalExpenses / totalSalary) * 100).toStringAsFixed(1)}%',
      radius: 50,
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:Colors.white),
    ),
    // Section for Savings
    PieChartSectionData(
      color: Colors.green,
      value: netSavings,
      title: '${((netSavings / totalSalary) * 100).toStringAsFixed(1)}%',
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

Widget buildTransactionTile(String title, String category, String date, String amount, Color color){
  return Padding(padding: EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 4,),
            Text(category,style: TextStyle(fontSize: 14,color: Colors.grey),),
            Text(date,style: TextStyle(fontSize: 14,color: Colors.grey),),
          ],
        ),
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