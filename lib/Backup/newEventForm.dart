import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:testing/HomeEventList/eventValidations.dart';

class NewEventForm extends StatefulWidget {

  const NewEventForm({Key? key}) : super(key: key);

  @override
  NewEventFormState createState() => NewEventFormState();

}

class NewEventFormState extends State<NewEventForm>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Date Picker Variables
  DateTime? eventDate;
  DateTime eventDateSet = new DateTime(2021,2,4);

  TimeOfDay? eventTime;
  TimeOfDay eventTimeSet = new TimeOfDay(hour: 8, minute: 00);

  DateTime? eventExpiredDate;
  DateTime eventExpiredDateSet = new DateTime(2021,2,4);

  DateTime eventFinalDateTime = new DateTime(2021,2,4);

  //Controllers
  var eventDateValue = TextEditingController();
  var eventTimeValue = TextEditingController();
  var eventExpiredDateValue = TextEditingController();

  //Date Time Functions
  String getEventDateText(){
    if(eventDate == null){
      eventDateValue.text = '';
      return 'Select Event Date';
    }else{
      String displayDateTime = '${eventDate?.day}/${eventDate?.month}/${eventDate?.year}';
      eventDateValue.text = ''+ displayDateTime;
      return '' + displayDateTime;
    }
  }

  String getEventTime(){
    if(eventTime == null){
      return 'Select Event Time';
    }else{
      String displayTime = '${eventTime?.hour}:${eventTime?.minute}';
      eventTimeValue.text = ''+ displayTime;
      return displayTime;
    }
  }

  String getExpiredDateText(){
    if(eventExpiredDate == null){
      return 'Select Registration Deadline(Date)';
    }else{
      //String formattedDate = DateFormat('yyyy-MM-dd').format(eventExpiredDate);
      String displayDateTime = '${eventExpiredDate?.day}/${eventExpiredDate?.month}/${eventExpiredDate?.year}';
      eventExpiredDateValue.text = ''+ displayDateTime;
      return displayDateTime  ;
    }
  }

  //Validations
  void validation(){
    final isValid = _formKey.currentState?.validate();

    if(isValid == false){
      print('Please Retry!');
    }else{
      print('Success!');
      //snackbar flutter
    }

    if(eventDate != null && eventTime != null)
    {
      eventFinalDateTime = new DateTime(eventDateSet.year, eventDateSet.month, eventDateSet.day, eventTimeSet.hour, eventTimeSet.minute);
      print(eventFinalDateTime.toUtc());
      print(eventExpiredDateSet.toUtc());
    }else{
      print('Please fill in Date and Time');
    }

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Event Registration Form"),
      ),
      body: Column(
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
                        validator: (value){
                          return eventNameValidator(value);
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
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
                          if (value?.isEmpty == true) {
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
                          hintText: getEventDateText(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        controller: eventDateValue,
                        validator: (value){
                          return eventDateValidator(value, eventDate, eventDateSet, eventExpiredDate, eventExpiredDateSet);
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
                          hintText: getEventTime(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        controller: eventTimeValue,
                        validator: (value){
                          if (value?.isEmpty == true) {
                            return '* Required';
                          }else{
                            return null;
                          }
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
                          hintText: getExpiredDateText(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        controller: eventExpiredDateValue,
                        validator: (value){
                          return eventDateValidator(value, eventDate, eventDateSet, eventExpiredDate, eventExpiredDateSet);
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
      )
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

    setState(() => eventDate = eventDateSet = newDate);
  }

  Future pickEventTime(BuildContext context) async{
    final initialTime = TimeOfDay(hour: 8, minute: 0);
    final newTime = await showTimePicker(
        context: context,
        initialTime: eventTime ?? initialTime);

    if(newTime == null) return;

    setState(() => eventTime = eventTimeSet = newTime);
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

    setState(() => eventExpiredDate = eventExpiredDateSet = newDate);

  }

}

