import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:testing/Model/event.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget{

  const EventDetails({Key? key, required this.eventObj}) : super(key: key);

  final Event eventObj;

  @override
  EventDetailsState createState() => EventDetailsState(eventObj: this.eventObj);

}

class EventDetailsState extends State<EventDetails> {

  //final Event eventObj = new Event(eventName: 'joshua',description: 'yes', dateTime: DateTime.now(), address: 'ABC Hehehe', maxSlotAvailability: 30, currentSlotAvailability: 14);
  final Event eventObj;

  EventDetailsState({required this.eventObj});

  //Functions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventObj.eventName),
      ),
      body: Column(
        children: [

          //Map
          Container(
            child: Text(eventObj.address),
          ),

          Expanded(child:
            Container(
                child: eventDetails()
            ),
          ),
          Container(
            color: Colors.blue,
            child: bottomPanel()
          )

        ],
      ),
    );
  }

  //Display Event Details such as address, datetime, location, and description
  Widget eventDetails(){
    return SizedBox(
      child: Card(
        child: Column(
          children: [
            eventTile(DateFormat.yMd().add_jm().format(eventObj.dateTime), Icons.date_range_rounded),
            eventTile(eventObj.address, Icons.location_on),
            eventTile(eventObj.description, Icons.info_rounded),
          ],
        ),
      ),
    );

  }

  ListTile eventTile(String titleStr, IconData icon){
    return ListTile(
      title: Text(titleStr),
      leading: Icon(
        icon,
        color: Colors.blue,
      ),
    );
  }

  //Display Registration Deadline, Slot Availability, Edit and Remove Button
  Widget bottomPanel(){

    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Registration Deadline
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Text(
                      'Sign-up Dealine :' ,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  Container(
                    child: Text(
                      DateFormat.yMEd().format(eventObj.enrollDeadline),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              //Slot Availability
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Text(
                    'Current Slot :' ,
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                Container(
                  child: Container(
                    child: Text(
                      eventObj.currentSlotAvailability.toString() + '/' + eventObj.maxSlotAvailability.toString(),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              ],
            ),
            ],
          ),
          ),

          ButtonBar(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber
                ),
                child: Icon(Icons.edit),
                onPressed: (){
                  print('pressed');
                }
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red
                ),
                child: Icon(
                  Icons.delete_forever,
                ),
                onPressed: (){
                  print('pressed');
                }
              )
            ],
          )
        ],
      )
    );
  }


}