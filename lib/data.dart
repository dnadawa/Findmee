class Data{


  final List categories = [
    {'category': 'Anlæg' , 'selected': false},
    {'category': 'Nedriver' , 'selected': false},
    {'category': 'Pakke/plukke' , 'selected': false},
    {'category': 'Truckkørsel' , 'selected': false},
    {'category': 'Maskinoperatør' , 'selected': false},
    {'category': 'Montage' , 'selected': false},
    {'category': 'Oprydning' , 'selected': false},
    {'category': 'Rengøring' , 'selected': false},
    {'category': 'Vinduespudsning' , 'selected': false},
    {'category': 'Atuomekaniker' , 'selected': false},
    {'category': 'Brolægning' , 'selected': false},
    {'category': 'Atu. Kloakarbejde' , 'selected': false},
    {'category': 'Elektriker' , 'selected': false},
    {'category': 'Tømrer' , 'selected': false},
    {'category': 'Arbejdsmand' , 'selected': false},
    {'category': 'Maler' , 'selected': false},
  ];


  final List cities = [
    {'city': 'København' , 'selected': false},
    {'city': 'Sjælland' , 'selected': false},
    {'city': 'Aarhus' , 'selected': false},
    {'city': 'Odense' , 'selected': false},
    {'city': 'Fyn' , 'selected': false},
    {'city': 'Bornholm' , 'selected': false},
    {'city': 'Aalborg' , 'selected': false},
    {'city': 'Esbjerg' , 'selected': false},
    {'city': 'Randers' , 'selected': false},
    {'city': 'Kolding' , 'selected': false},
    {'city': 'Horsens' , 'selected': false},
  ];

  String getDay(String weekday){
    switch(weekday){
      case '1': {
        return 'Monday';
      }
      break;

      case '2': {
        return 'Tuesday';
      }
      break;

      case '3': {
        return 'Wednesday';
      }
      break;

      case '4': {
        return 'Thursday';
      }
      break;

      case '5': {
        return 'Friday';
      }
      break;

      case '6': {
        return 'Saturday';
      }
      break;

      case '7': {
        return 'Sunday';
      }
      break;

      default : {
        return 'N/A';
      }
      break;
    }
  }

}