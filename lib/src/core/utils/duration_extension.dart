extension DurationExtension on Duration{

  String minutes(){
    if(inMinutes>60){
      int remainder = inMinutes % 60;
      if(remainder>=10){
        return "$remainder";
      }else{
        return "0$remainder";
      }
    }else{
      if(inMinutes>=10){
        return "$inMinutes";
    }else{
        return "0$inMinutes";
      }
    }
  }
  String seconds(){
    if(inSeconds>60){
      int remainder = inSeconds % 60;
      if(remainder>=10){
        return "$remainder";
      }else{
        return "0$remainder";
      }
    }else{
      if(inSeconds>=10){
        return "$inSeconds";
      }else{
        return "0$inSeconds";
      }
    }
  }
}