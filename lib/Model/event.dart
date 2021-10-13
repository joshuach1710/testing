class Event{

  final String eventName;
  final String description;
  final DateTime dateTime;
  final String address;
  final int maxSlotAvailability;
  final int currentSlotAvailability;
  final DateTime enrollDeadline;

  const Event({
    required this.eventName,
    required this.description,
    required this.dateTime,
    required this.address,
    required this.maxSlotAvailability,
    required this.currentSlotAvailability,
    required this.enrollDeadline,

  });

  String getEventName(){
    return this.eventName;
  }
}