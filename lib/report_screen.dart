import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatelessWidget{
  List<_ChartData> data = [
    _ChartData('CHN', 12),
    _ChartData('GER', 15),
    _ChartData('RUS', 30),
    _ChartData('BRZ', 6.4),
    _ChartData('IND', 14)
  
  ];
  TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  Widget build(BuildContext context){
    return Column(
        children: [
          Card(
            elevation: 0,
            child: Padding(padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text("Financial Report",style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color:Colors.blue),),
                ],
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: Text("This Month"),
                        selected: true,
                        onSelected: (value){},
                        selectedColor: Colors.blueAccent,
                      ),
                      SizedBox(width: 5,),
                      ChoiceChip(
                        label: Text("Last Month"),
                        selected: false,
                        onSelected: (value){},
                        selectedColor: Colors.blueAccent,
                      ),
                      SizedBox(width: 5,),
                      ChoiceChip(
                        label: Text("Custom"),
                        selected: false,
                        onSelected: (value){},
                        selectedColor: Colors.blueAccent,
                      ),
                  
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildOverviewCard('Total Income', '5000', Icons.monetization_on, Colors.blue),
                      _buildOverviewCard('Total Expenses', '3200', Icons.shopping_cart, Colors.red),
                      _buildOverviewCard('Net Saving', '1800', Icons.savings, Colors.green),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Pie Chart for Expenses Distribution
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 200,
                        child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 50,
                              sectionsSpace: 3,
                              sections: [
                                PieChartSectionData(color: Colors.red,value: 40,title: '40%'),
                                PieChartSectionData(color: Colors.blue,value: 30,title: '30%'),
                                PieChartSectionData(color: Colors.yellow,value: 20, title: '20%'),
                                PieChartSectionData(color: Colors.purple,value: 10,title: '10%'),
                              ],
                            )
                        ),
                      ),
                      Column(
                        children: [
                          PieLegends('title1', Colors.red),
                          SizedBox(height: 5,),
                          PieLegends('title2', Colors.blue),
                          SizedBox(height: 5,),
                          PieLegends('title3', Colors.yellow),
                          SizedBox(height: 5,),
                          PieLegends('title4', Colors.purple),
                          SizedBox(height: 5,),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  // Bar Chart for Expenses Categories
                  SizedBox(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(minimum: 0,maximum: 100,interval: 10,),
                        tooltipBehavior: _tooltip,
                        series: <CartesianSeries<_ChartData,String>>[
                          BarSeries<_ChartData, String>(
                            dataSource: data,
                            xValueMapper: (_ChartData data, _)=> data.x,
                            yValueMapper: (_ChartData data, _)=> data.y,
                            name: 'Gold',
                            color: Color.fromRGBO(8, 142, 255, 1),
                          )
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20,),
                  // Export Button
                  Center(
                    child: ElevatedButton(
                      onPressed: (){},
                      child: Text('Export Report'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                      ),),
                  ),

                  Column(

                    children: [
                      SizedBox(height: 20,),
                      // Expenses Categories
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.3),blurRadius: 5, spreadRadius: 2),
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Expense Categories', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 8,),
                                Text('Groceries : 40 %\n Rent: 30%\n Entertainment: 20%\n Others: 10%'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),

                      // Savings Trends
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.3),blurRadius: 5, spreadRadius: 2),
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Savings Trends', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 8,),
                                Text('This Month vs Last Month: +10%'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),

                ],
              ),
            ),
          )
        ],
      );

  }
}

Widget _buildOverviewCard(String title, String amount, IconData icon, Color color){
  List<String> strings = title.split(" ");
  String formatedAmount = formatNumber(amount);
  return  SizedBox(
    width: 120.0,
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
    ),
  );
}

String formatNumber(String number){
  int num = int.parse(number);
  final formatter = NumberFormat('#,###');
  return formatter.format(num);
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

class _ChartData {
 
  final String x;
  final double y;
  _ChartData(this.x, this.y);
}

