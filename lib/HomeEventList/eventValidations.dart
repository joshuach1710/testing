//Event Validations

String? eventNameValidator(String? value){

  if(value?.isEmpty == true){
    return '* Required';
  }

  return null;
}

String? eventDescriptionValidator(String? value){

  if(value?.isEmpty == true){
    return '* Required';
  }

  return null;
}

String? eventAddressValidator(String? value){

  if(value?.isEmpty == true){
    return '* Required';
  }

  return null;
}

String? eventMaxSlot(String? value){
  if(value?.isEmpty == true){
    return '* Required';
  }

  bool isDigit = true;
  //[1-9]|[1-9][0-9]|100
  if(value?.contains(new RegExp(r'^[0-9]+$')) == false){
    isDigit = false;

    if(isDigit == false){
      return '* Digit Only';
    }
  }

  bool isWithinMax = true;
  if(value?.contains(new RegExp(r'^[1-9]$|^[1-9][0-9]$|^100$')) == false){
    isWithinMax = false;

    if(isWithinMax == false){
      return '* Invalid Value (MAX: 100)';
    }
  }

  return null;
}

String? eventDateValidator(String? value, DateTime? eventDate, DateTime eventDateSet,
    DateTime? eventExpiredDate, DateTime eventExpiredDateSet){

  if(value?.isEmpty == true){
    return '* Required';
  }

  if(eventDate == null ){
    return null;
  }

  if(eventExpiredDate == null){
    return null;
  }

  if(eventDateSet.isAfter(eventExpiredDateSet) == false){
    return 'Event Date must be initialised before Registration Deadline';
  }
  return null;

}

String? eventDateValidatorNew(DateTime eventDate, DateTime eventExpiredDate){

  if(eventDate.isAfter(eventExpiredDate) == false){
    return 'Event Date must be initialised before Registration Deadline';
  }

  return null;
}

String? eventTimeValidator(String? value){
  if(value?.isEmpty == true){
    return '* Required';
  }

  return null;
}