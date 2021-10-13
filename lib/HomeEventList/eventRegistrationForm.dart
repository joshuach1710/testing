import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing/Backup/newEventForm.dart';
import 'package:testing/HomeEventList/eventValidations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewEventForm1 extends StatelessWidget {

  //const NewEventForm1({Key? key}) : super(key: key);

  final appTitle = 'New Event Form';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: NewEventForm(key: UniqueKey()),
      ),
    );
  }
}

class NewEventForm extends StatefulWidget{

  const NewEventForm({
    Key? key,
  }) : super(key: key);

  @override
  NewEventFormState createState() => NewEventFormState();
}

class NewEventFormState extends State<NewEventForm>{

  //CollectionReference
  CollectionReference events = FirebaseFirestore.instance.collection('event');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Controllers that store string values
  var eventNameValue = TextEditingController();
  var eventDescriptionValue = TextEditingController();
  var eventAddress = TextEditingController();
  var maxSlotAvailabilityValue = TextEditingController();

  //Controllers Used to display date and time
  var eventDateValue = TextEditingController();
  var eventTimeValue = TextEditingController();
  var eventExpiredDateValue = TextEditingController();

  late DateTime eventDate;
  late TimeOfDay eventTime;
  late DateTime eventFinalDateTime;

  late DateTime eventExpiredDate;

  void validation(){
    final isValid = _formKey.currentState?.validate();

    if(isValid == false){
      print('Please Retry!');
    }else {
      print('Success!');
      print(eventNameValue.text.toString());
      print(eventNameValue.value.text);
      print(eventDescriptionValue.text.toString());
      print(eventAddress.text.toString());
      print(maxSlotAvailabilityValue.text.toString());

      eventFinalDateTime = new DateTime(eventDate.year, eventDate.month, eventDate.day, eventTime.hour, eventTime.minute);
      Timestamp eventTimeStamp = Timestamp.fromDate(eventFinalDateTime);
      Timestamp eventEnrollDeadlineTS = Timestamp.fromDate(eventExpiredDate);

      var organiserID = 'pKzxldlWuJUvKABcMC46';
      CollectionReference organiserRef = FirebaseFirestore.instance.collection('organiser');
      DocumentReference organiserRefDoc = organiserRef.doc(organiserID);

      events.add({
        'eventName': eventNameValue.text.toString(),
        'eventDescription': eventDescriptionValue.text.toString(),
        'address': eventAddress.text.toString(),
        'currentSlotAvailability': 0,
        'maxSlotAvailability': int.tryParse(
            maxSlotAvailabilityValue.text.toString()),
        'eventStatus': 'pending',
        'dateTime': eventTimeStamp,
        'enrolledDeadline': eventEnrollDeadlineTS,
        'organiser': organiserRefDoc
      });

    }

  }

  @override
  Widget build(BuildContext context){

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(20.0),
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(


                        decoration: InputDecoration(
                          labelText: 'Event Name',
                          prefixIcon: Icon(Icons.event),
                          hintText: "Healthcare Charity",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        maxLength: 30,
                        controller: eventNameValue,
                        validator: (value){
                          if(value?.isEmpty == true && eventNameValue.text.isEmpty){
                            return '* Required';
                          }else if(eventNameValue.text.isEmpty){
                            return '* Required';
                          }else{
                            return null;
                          }
                        },

                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: eventDescriptionValue,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.info),
                          hintText: "",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        maxLines: 8,
                        maxLength: 200,
                        validator: (value){
                          if(value?.isEmpty == true){
                            return '* Required';
                          }else{
                            return null;
                          }
                        },
                      ),
                    ),

                    //Address
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: eventAddress,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.info),
                          hintText: "",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        maxLines: 5,
                        maxLength: 150,
                        validator: (value){
                          if(value?.isEmpty == true){
                            return '* Required';
                          }else{
                            return null;
                          }
                        },
                      ),
                    ),

                    //Max Slot
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: maxSlotAvailabilityValue,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Max Slot',
                          prefixIcon: Icon(Icons.info),
                          hintText: "30",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        maxLength: 3,
                        validator: (value){
                          return eventMaxSlot(value);
                        },
                      ),
                    ),

                    //Event Date Picker
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        readOnly: true,
                        //keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Event Date',
                          prefixIcon: IconButton(
                              onPressed: (){
                                pickEventDate(context);
                              },
                              icon: Icon(Icons.calendar_today)
                          ),
                          hintText: 'Select Event Date',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        controller: eventDateValue,
                        validator: (value){
                          if(value?.isEmpty == true){
                            return '* Required';
                          }else{
                            if(eventExpiredDateValue.text.isEmpty){
                              return null;
                            }else{
                              return eventDateValidatorNew(eventDate, eventExpiredDate);
                            }
                            //return null;
                          }
                        },
                      ),
                    ),

                    //Event Time Picker
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        readOnly: true,
                        //keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Event Time',
                          prefixIcon: IconButton(
                              onPressed: (){
                                pickEventTime(context);
                              },
                              icon: Icon(Icons.timelapse)
                          ),
                          hintText: 'Select Event Time',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        controller: eventTimeValue,
                        validator: (value){
                          return eventTimeValidator(value);

                        },
                      ),
                    ),

                    //Registration Expired Date Picker
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        readOnly: true,
                        //keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Event Registration Deadline',
                          prefixIcon: IconButton(
                              onPressed: (){
                                pickExpiredDate(context);
                              },
                              icon: Icon(Icons.calendar_today)
                          ),
                          hintText: 'Select Event Registration Deadline',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        controller: eventExpiredDateValue,
                        validator: (value){
                          if(value?.isEmpty == true){
                            return '* Required';
                          }else{
                            if(eventDateValue.text.isEmpty){
                              return null;
                            }else{
                              return eventDateValidatorNew(eventDate, eventExpiredDate);
                            }
                            //return null;
                          }

                        },
                      ),
                    ),

                  ],
                ),
              ),
          ),


          //Next Button
          Container(
            color: Colors.blue,
            child:
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white
                    ),
                    onPressed: (){
                      validation();
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.blue ,fontWeight:(FontWeight.bold))
                    ),
                  ),
                )
              ),
            )
          )
        ],
      );

  }

  //Date and Time Picker Widget
  Future pickEventDate(BuildContext context) async{
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year+5)
    );

    if (newDate == null) return;

    setState((){
      eventDate = newDate;
      eventDateValue.text = '${eventDate.day}/${eventDate.month}/${eventDate.year}';
    });
  }

  Future pickEventTime(BuildContext context) async{
    final initialTime = TimeOfDay(hour: 8, minute: 0);
    final newTime = await showTimePicker(
        context: context,
        initialTime: initialTime);

    if(newTime == null) return;

    setState(() {
      eventTime = newTime;
      eventTimeValue.text = eventTime.hour.toString() + ' : '+ eventTime.minute.toString();
    });
  }

  Future pickExpiredDate(BuildContext context) async{
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year+5)
    );

    if (newDate == null) return;

    setState(() {
      eventExpiredDate = newDate;
      eventExpiredDateValue.text = '${eventExpiredDate.day}/${eventExpiredDate.month}/${eventExpiredDate.year}';
    });

  }

}

