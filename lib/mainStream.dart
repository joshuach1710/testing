import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

//import 'package:testing/HomeEventList/newEventFormV2.dart';
import 'package:testing/HomeEventList/eventRegistrationForm.dart';
import 'package:testing/HomeEventList/eventDetailsStream.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //CollectionReference
  CollectionReference events = FirebaseFirestore.instance.collection('event');

  //Variables
  String selectedEventCat = 'pending';

  //Function
  void _getEventCat(String value){
    setState(() {
      selectedEventCat = value;
    });
  }

  String _getEnrollDeadlineDT(Timestamp value){
    DateTime datetimeValue = value.toDate();

    return DateFormat.yMEd().format(datetimeValue);
  }

  String _getDateTime(Timestamp value){
    DateTime datetimeValue = value.toDate();

    return DateFormat.yMd().format(datetimeValue);
  }


  void addEvent(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewEventForm1()),
    );

  }

  void goToEventDetails(DocumentReference reference){

    print(reference.toString());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetails(selEventRef: reference,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment : CrossAxisAlignment.center,
        children: [
          //Title
          Container(margin: EdgeInsets.all(10), child: Text(
            'SOCIAL SERVICE \n WORKSHOP & EVENT',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: (FontWeight.bold)),)
          ),

          //Button Bar Event Category
          Container(margin: EdgeInsets.all(10), child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("Pending"),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: (){
                  _getEventCat('pending');
                },
              ),
              ElevatedButton(
                child: Text("OnGoing"),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: (){
                  _getEventCat('onGoing');
                },
              ),
              ElevatedButton(
                child: Text("Completed"),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: (){
                  _getEventCat('completed');
                },
              ),
            ],
          ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: events.where('eventStatus',isEqualTo: selectedEventCat).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData) return const Text('Loading...');

                return ListView(
                  children: snapshot.data!.docs.map((event){
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(event['eventName']),
                            ),
                            subtitle: Text('Deadline: ' + _getEnrollDeadlineDT(event['enrolledDeadline']) +'\n'+ 'Max Slot: ' + event['maxSlotAvailability'].toString()),
                            leading: CircleAvatar(
                              child: Text(
                                (event['maxSlotAvailability']- event['currentSlotAvailability']).toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            trailing: Text(_getDateTime(event['dateTime'])),
                            onTap: () {
                              //print(event['organiser']);
                              print(event.id);
                              print(event.reference);


                              DocumentReference organiser = event['organiser'];
                              print(organiser.id);

                              CollectionReference organiserRef = FirebaseFirestore.instance.collection('organiser');
                              //organiserRef.doc(organiser.id).get().then((value) => print(value["organisationName"]));

                              var organiserRef2 = FirebaseFirestore.instance.collection('organiser').doc(organiser.id).path;
                              //DocumentReference newOrga = organiserRef.doc('pKzxldlWuJUvKABcMC46');
                              DocumentReference newOrga = organiserRef.doc(organiser.id);

                              print(organiserRef2.toString());
                              print(newOrga.toString());

                              goToEventDetails(event.reference);
                            }
                          ),

                        ],
                      )
                    );
                  }).toList(),
                );
              }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addEvent,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      )
    );
  }

}