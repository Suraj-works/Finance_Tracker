import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Column(
       children: [
         Card(
           elevation: 0,
           child: Padding(padding: const EdgeInsets.all(10),
           child: Row(
             children: [
               Text("Transactions",style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color:Colors.blue),),
             ],
           ),
           ),
         ),
         Padding(
           padding: const EdgeInsets.all(10.0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text('Date Filter:',style: TextStyle(fontSize: 16),),
               DropdownButton<String>(
                 value: 'This Month',
                 onChanged: (String? newValue){},
                 items: <String>['This Month','Last Month','Custom']
                   .map((String value){
                     return DropdownMenuItem<String>(
                     value: value,
                      child: Text(value),
                     );
               }).toList(),
              ),
             ],
           ),
         ),

         SizedBox(height: 10,),
         Expanded(child: ListView(
           children: [
             TransactionCard(
                 title: 'Groceries',
                 date: 'March 15, 2023',
                 amount: '-150.0',
                 icon: Icons.fastfood,
                 color: Colors.red),
             TransactionCard(
                 title: 'Utilites',
                 date: 'March 18, 2023',
                 amount: '-60.0',
                 icon: Icons.electrical_services,
                 color: Colors.red),
             TransactionCard(
                 title: 'Salary',
                 date: 'March 25, 2023',
                 amount: '+2,500.0',
                 icon: Icons.work,
                 color: Colors.green),
             TransactionCard(
                 title: 'Groceries',
                 date: 'March 15, 2023',
                 amount: '-150.0',
                 icon: Icons.fastfood,
                 color: Colors.red),
             TransactionCard(
                 title: 'Utilites',
                 date: 'March 18, 2023',
                 amount: '-60.0',
                 icon: Icons.electrical_services,
                 color: Colors.red),
             TransactionCard(
                 title: 'Salary',
                 date: 'March 25, 2023',
                 amount: '+2,500.0',
                 icon: Icons.work,
                 color: Colors.green),
             TransactionCard(
                 title: 'Groceries',
                 date: 'March 15, 2023',
                 amount: '-150.0',
                 icon: Icons.fastfood,
                 color: Colors.red),
             TransactionCard(
                 title: 'Utilites',
                 date: 'March 18, 2023',
                 amount: '-60.0',
                 icon: Icons.electrical_services,
                 color: Colors.red),
             TransactionCard(
                 title: 'Salary',
                 date: 'March 25, 2023',
                 amount: '+2,500.0',
                 icon: Icons.work,
                 color: Colors.green),

           ],
         )),
         Center(
           child: Column(
             children: [
               Icon(Icons.account_balance_wallet,size: 80,color: Colors.blue,),
               Text('No transactions yet. Add your first expense or income.',
               style: TextStyle(color: Colors.grey),),
             ],
           ),
         )
       ],
     );
  }

}

class TransactionCard extends StatelessWidget{
  final String title;
  final String date;
  final String amount;
  final IconData icon;
  final Color color;

  TransactionCard({
    required this.title,
    required this.date,
    required this.amount,
    required this.icon,
    required this.color,
});

  Widget build(BuildContext context){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon,color: Colors.blue,),
            SizedBox(width: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
                Text(date, style: TextStyle(color: Colors.grey),),
              ],
            ),
            Spacer(),
            Text(amount,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: color)),
          ],
        ),),
    );
  }


}