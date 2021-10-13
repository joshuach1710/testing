import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:testing/Data/event.dart';
import 'package:testing/HomeEventList/eventDetails.dart';
import 'package:testing/Model/event.dart';
import 'package:testing/HomeEventList/newEventForm.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
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
  List<Event> pendingEvents = allEvent;
  List<Event> onGoingEvents = onGoingEvent;
  List<Event> completedEvents = completedEvent;
  List<Event> selectedEvents = allEvent;

  int? sortColumnIndex;
  bool isAscending = false;

  //FUNCTIONS

  //Change Category of Events
  void statusChangedEvent(List<Event> selectedEvent){
    setState(() {
      selectedEvents = selectedEvent;
    });
  }

  void onSelected(List cells, bool? selected, Event event){
    if (selected == true) {
      print('row-selected:' + '$cells' + selected.toString());
      print('Event Name:'+ cells[0]);
      print(event.eventName + ' ' + event.maxSlotAvailability.toString());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetails(eventObj : event),
        ),
      );

    }else if(selected == false){
      print('no row selected');
    }
  }

  void addEvent(){
    print("helloWords");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewEventForm()),
    );

  }

  //BUILD UPDATED CONTENT
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      //body: buildDataTable(),
      body: Column(crossAxisAlignment : CrossAxisAlignment.center, children: [
        Container(margin: EdgeInsets.all(10), child: Text(
          'SOCIAL SERVICE \n WORKSHOP & EVENT',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: (FontWeight.bold)),)),

        Container(margin: EdgeInsets.all(10), child: ButtonBar(
          children: [
            ElevatedButton(
              child: Text("Pending"),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: (){
                statusChangedEvent(allEvent);
              },
            ),
            ElevatedButton(
              child: Text("OnGoing"),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: (){
                statusChangedEvent(onGoingEvent);
              },
            ),
            ElevatedButton(
              child: Text("Completed"),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: (){
                statusChangedEvent(completedEvents);
              },
            ),
          ], alignment: MainAxisAlignment.center,
        ),
        ),

        //Container(child: buildDataTable()), //DATA TABLE
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: buildDataTable(selectedEvents),
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 5, color: Colors.blue)
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(15),
              child: Text('Total :' + selectedEvents.length.toString() + ' Events',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
            ),
          ),
        )
        ],
      ),
    floatingActionButton: FloatingActionButton(
      onPressed: addEvent,
      tooltip: 'Increment',
      child: Icon(Icons.add),
      )
    );
  }

  //DATA TABLE
  Widget buildDataTable(List<Event> events){
    final columns = ['Title', 'Slot', 'MaxSlot','DateTime'];

    return DataTable(
        //decoration: ,
        showBottomBorder: true,
        columnSpacing: 15,
        showCheckboxColumn: false,
        sortColumnIndex: sortColumnIndex,
        sortAscending: isAscending,
        columns: getColumns(columns), rows: getRows(events),);
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
        label: Text(column), onSort: onSort))
      .toList();

  List<DataRow> getRows (List<Event> events) => events
      .map((Event event) {
        final cells = [event.eventName, event.currentSlotAvailability, event.maxSlotAvailability, event.dateTime.toString()];
        return DataRow(cells: getCells(cells),onSelectChanged:(s1){
          //print('hello' + '${cells}' + s1.toString());
          onSelected(cells, s1, event);
        });
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending){
    if(columnIndex==0){
      selectedEvents.sort((event1, event2) =>
        compareString(ascending, event1.eventName, event2.eventName)
      );
    }else if(columnIndex == 1){
      selectedEvents.sort((event1, event2) =>
        compareString(ascending, '${event1.currentSlotAvailability}', '${event2.currentSlotAvailability}')
      );
    }else if(columnIndex == 2){
      selectedEvents.sort((event1, event2) =>
        compareString(ascending, '${event1.maxSlotAvailability}', '${event2.maxSlotAvailability}')
      );
    }else if(columnIndex == 3){
      selectedEvents.sort((event1, event2) =>
        compareString(ascending, event1.dateTime.toString(), event2.dateTime.toString())
      );
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool asceding, String value1, String value2){
    return asceding ? value1.compareTo(value2) : value2.compareTo(value1);
  }

}

/*
* Table(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        border: TableBorder.all(),
        columnWidths: {0: FlexColumnWidth(1.0), 1: FlexColumnWidth(0.25), 2: FlexColumnWidth(0.5)},
        children:[
          TableRow(children: [
            Text('Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            Text('Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
          ]),
          TableRow(children: [
            Text('Title'),
            Text('Slot'),
            Text('Date')
          ])
        ],
      ),
* */