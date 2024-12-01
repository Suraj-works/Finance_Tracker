import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_fund/dashboard_screen.dart';
import 'package:my_fund/database_helper.dart';

class TransactionScreen extends StatefulWidget {

  @override
  State<TransactionScreen> createState() {
    return _TransactionScreenState();
  }

}

  class _TransactionScreenState extends State<TransactionScreen>{
  String selectedFilter = 'This Month'; // Default selected value
  late Future<List<Map<String,dynamic>>> transactionData;
  void initState(){
    super.initState();
    fetchTransactions(); // Load Data initially
  }

  void fetchTransactions(){
    switch(selectedFilter){
      case 'This Month' :
        transactionData = DatabaseHelper().getThisMonthTransactions();
        break;
      case 'Last Month' :
        transactionData = DatabaseHelper().getLastMonthTransactions();
        break;
      case 'Last 6 Months':
        transactionData = DatabaseHelper().getLastSixMonthTransactions();
        break;
    }
    setState(() {
    }); // Refresh the UI
  }


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
                 value: selectedFilter,
                 onChanged: (String? newValue){
                   setState((){
                     selectedFilter = newValue!;
                     fetchTransactions(); // update the transaction
                   });
                 },
                 items: <String>['This Month','Last Month','Last 6 Months']
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
         Expanded(child: FutureBuilder(
             future: transactionData,
             builder: (context,snapshot){
               if(snapshot.connectionState == ConnectionState.waiting){
                 return Center(child: CircularProgressIndicator(),);
               }else if(snapshot.hasError){
                 return Center(child: Text('Error : ${snapshot.error}'),);
               }else if(snapshot.hasData){
                 // Extract data from the snapshot
                 List<Map<String, dynamic>> data = snapshot.data!;

                 if(selectedFilter == 'This Month' && data.isEmpty)
                   return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.account_balance_wallet,size: 80,color: Colors.blue,),
                         Text('No transactions yet. Add your first expense or income.',
                           style: TextStyle(color: Colors.grey),),
                       ],
                     );

                 return ListView.builder(
                     itemCount: data.length,
                     itemBuilder: (context,index){
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

                     });
               } else {
                 return Center(
                   child: Text('No Data Availabel'),
                 );
               }
             }) ,
         ),
       ],
     );
  }



}




  IconData getIcon(String categoryName) {
    switch (categoryName) {
      case 'Business Income':
        return Icons.attach_money;
      case 'Charitable Giving':
        return Icons.volunteer_activism;
      case 'Debt Payments':
        return Icons.payment;
      case 'Education & Personal Development':
        return Icons.school;
      case 'Entertainment & Recreation':
        return Icons.movie;
      case 'Family & Childcare':
        return Icons.family_restroom;
      case 'Food & Groceries':
        return Icons.restaurant;
      case 'Gifts & Donations':
        return Icons.card_giftcard;
      case 'Government Benefits':
        return Icons.flag;
      case 'Health & Wellness':
        return Icons.health_and_safety;
      case 'Housing / Utilities':
        return Icons.home;
      case 'Insurance':
        return Icons.shield;
      case 'Investments':
        return Icons.money;
      case 'Miscellaneous':
        return Icons.more_horiz;
      case 'Miscellaneous Income':
        return Icons.attach_money;
      case 'Pensions & Retirement Funds':
        return Icons.account_balance;
      case 'Personal Care':
        return Icons.person;
      case 'Refunds / Reimbursements':
        return Icons.money_off;
      case 'Rental Income':
        return Icons.home;
      case 'Royalties':
        return Icons.copyright;
      case 'Salary / Wages':
        return Icons.work;
      case 'Savings & Investments':
        return Icons.savings;
      case 'Transportation':
        return Icons.directions_car;
      default:
        return Icons.question_mark;
    }
  }
