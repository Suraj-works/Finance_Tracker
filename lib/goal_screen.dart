import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class GoalScreen extends StatefulWidget {

  @override
  State<GoalScreen> createState() {
    return _GoalScreenState();
  }

}

class _GoalScreenState extends State<GoalScreen>{
  int _selectedIndex = 0; // variable to keep track of selected chip
  late Future<List<Map<String,dynamic>>> goalsData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGoals();
  }
  
  void fetchGoals(){
    switch(_selectedIndex){
      case 0 : 
        goalsData = DatabaseHelper().getActiveGoals();
        break;
      case 1 : 
        goalsData = DatabaseHelper().getCompletedGoals();
        break;
      case 2 : 
        goalsData = DatabaseHelper().getAllGoals();
        break;
    }
    setState(() {
    }); // refresh the UI
  }




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
                    selected: _selectedIndex == 0, // check if this chip is selected
                    onSelected: (value){
                     setState(() {
                       _selectedIndex = 0; // update selected index
                       fetchGoals();
                     });
                    },
                    selectedColor: Colors.blueAccent,
                ),
                SizedBox(width: 10,),
                ChoiceChip(
                    label: Text("Completed Goals"),
                    selected: _selectedIndex == 1, // check if this chip is selected
                    onSelected: (value){
                      setState(() {
                        _selectedIndex = 1; // update selected index
                        fetchGoals();
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    ),
                SizedBox(width: 10,),
                ChoiceChip(
                    label: Text("All Goals"),
                    selected: _selectedIndex == 2, // check if this chip is selected
                    onSelected: (value){
                      setState(() {
                        _selectedIndex = 2; // update selected index
                        fetchGoals();
                      });
                    },
                    selectedColor: Colors.blueAccent,
                ),
              ],
            ),
            SizedBox(height: 20,),

            // List of Goals (Example with goals)
            Expanded(
              child: FutureBuilder(
                  future: goalsData, 
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }else if(snapshot.hasError){
                      return Center(child: Text('Error : ${snapshot.error}'),);
                    } else if(snapshot.hasData){
                      List<Map<String,dynamic>> data = snapshot.data!;
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context,index){
                            String title = data[index]['title'];
                            String targetAmount = data[index]['target_amount'].toString();
                            String savings = data[index]['current_savings'].toString();
                            String startDate = data[index]['start_date'];
                            String endDate = data[index]['end_date'];
                            double progress = data[index]['progress'];
                            String status = data[index]['status'];
                            List<String> time = getRemainingTime(endDate);
                            String timeLabel = time[0];
                            String remainingTime = time[1];

                            Color progressColor;
                            if(progress<0.33){
                              progressColor = Colors.red;
                            }else if(progress<0.66){
                              progressColor = Colors.orangeAccent;
                            }else if(progress<0.99){
                              progressColor = Colors.blueAccent;
                            }else{
                              progressColor = Colors.green;
                            }

                            return _buildGoalCard(title, targetAmount, savings, startDate, endDate, timeLabel, remainingTime, progress, progressColor, status);


                          });
                    }else{
                      return Center(child: Text("No Data Available"),);
                    }
                  }),
            ),
          ],
        ),
      );
  }
}

// Goals Cards
Widget _buildGoalCard(String title,String targetAmount,String currentSavings, String startDate, String endDate,
    String timeLabel, String remainingTime, double progress, Color progressColor, String status){
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.3),blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            SizedBox(height: 8,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Target ₹$targetAmount'),
                    Text('Savings ₹$currentSavings'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start Date'),
                    Text('End Date'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(startDate),
                    Text(endDate),
                  ],
                )
              ],
            ),
            
            SizedBox(height: 5,),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: progressColor,
              minHeight: 8,
            ),
            SizedBox(height: 5,),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(progress * 100).toStringAsFixed(1)}% Completed',
                  style: TextStyle(color: progressColor),),
                if(status == 'In Progress')...[
                Column(
                  children: [
                    Text(timeLabel, style: TextStyle(
                      color: timeLabel == 'Time Overdue'? Colors.orangeAccent : null,),),
                  ],
                ),
                Column(
                  children: [
                    Text(remainingTime, style: TextStyle(
                        color: timeLabel == 'Time Overdue'? Colors.red : null,),),
                  ],
                ),]
              ],
            )
          ],
        ),
      ),
  );
}

List<String> getRemainingTime(String endDate){
  String timelabel = 'Time Remaining';
    // Parse the dates into DateTime objects
  DateTime endDateTime = DateTime.parse('${endDate.substring(6, 10)}-${endDate.substring(3, 5)}-${endDate.substring(0, 2)}',);
  // Get the current date
  DateTime currentDate = DateTime.now();

  // Calculate remaining Time
  Duration remainingDuration = endDateTime.difference(currentDate);
  int remainingDays = remainingDuration.inDays;
  // check if the goal is still in progress

  if(currentDate.isAfter(endDateTime)){
    // The goal deadline has already passed
    timelabel = 'Time Overdue';
    remainingDays *= -1;
  }


  int years = (remainingDays / 365).floor();
  int months = ((remainingDays % 365) / 30).floor();
  int days = ((remainingDays % 365) % 30).floor();
  String remainingTime;
  if( years > 0){
    remainingTime = '$years yrs $months months $days days';
  }else if( months > 0){
    remainingTime = '$months months $days days';
  }else{
    remainingTime = '$days days';
  }
  return [timelabel,remainingTime];

}


