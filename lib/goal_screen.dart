import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoalScreen extends StatelessWidget{
  Widget build(BuildContext context){
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              elevation: 0,
              child: Padding(padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text("Financial Goals",style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color:Colors.blue),),
                  ],
                ),
              ),
            ),
            // Filter Button(Active , Completed , All)

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                    label: Text('Active Goals'),
                    selected: true,
                    onSelected: (value){},
                    selectedColor: Colors.blueAccent,
                ),
                SizedBox(width: 10,),
                ChoiceChip(
                    label: Text("Completed Goals"),
                    selected: false,
                    onSelected: (value){},
                    ),
                SizedBox(width: 10,),
                ChoiceChip(
                    label: Text("All Goals"),
                    selected: false,
                    onSelected: (value){},
                ),
              ],
            ),
            SizedBox(height: 20,),

            // List of Goals (Example with goals)
            Expanded(
              child: ListView(
                children: [
                  _buildGoalCard('Buy a Car', 5000, 3500, Colors.green),
                  _buildGoalCard("Emergency Fund", 10000, 5000, Colors.orange),
                  _buildGoalCard('Vacation', 2000, 1200, Colors.blue),
                ],
              ),
            ),
          ],
        ),
      );
  }
}

// Goals Cards
Widget _buildGoalCard(String title,double targetAmount,double currentSavings, Color progressColor){
  double progress = currentSavings / targetAmount;
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.3),blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            SizedBox(height: 10,),
            Text('Target: \$${targetAmount.toStringAsFixed(0)}'),
            Text('Current Savings: \$${currentSavings.toStringAsFixed(0)}'),
            SizedBox(height: 10,),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: progressColor,
              minHeight: 10,
            ),
            SizedBox(height: 10,),
            Text('${(progress * 100).toStringAsFixed(1)} % Completed',
            style: TextStyle(color: progressColor),),

          ],
        ),
      ),
  );
}