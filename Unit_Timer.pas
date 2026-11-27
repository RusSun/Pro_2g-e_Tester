unit Unit_Timer;
 //Здесь все что относится к измерению времени
 // также сюда перейдут и другие элты измерения из галвного модуля
interface
uses windows,KOL;

//Объявим чтобы видеть его из другого модуля
procedure Timer1(Sender:PControl);
procedure ReTime;
var TimeLoadQuestion:Cardinal;//Для получения времени прохождения теста
     TimeElapsedStr: String; (* Строка длительности прохождения теста *)
     Timer :pTimer; (*Сам таймер *)
     Time: DWORD; (*Для таймера*)
implementation
uses
Unit_Act,
Unit_Params;

procedure Timer1(Sender:PControl);
var
    NewTime: Dword; //from TimerTimer
    STemp: String;
    SResult: String;
   // test:string;
begin
    //if ProcessThread <> nil then begin
         NewTime := GetTickCount - Time;
        Str(((NewTime div 3600000) mod 24):2, STemp);
        if STemp[1]=' ' then
            STemp[1]:='0';
        SResult := STemp + ':';
        Str(((NewTime div 60000) mod 60):2, STemp);
        if STemp[1]=' ' then
            STemp[1]:='0';
        SResult := SResult + STemp + ':';
        Str(((NewTime div 1000) mod 60):2, STemp);
        if STemp[1]=' ' then
            STemp[1]:='0';
        //Label7.Caption := SResult + STemp;
        TimeElapsedStr:=SResult+ STemp;//form.Caption
        //form.Caption:=SResult+ STemp;
       if ShowTime then LabelTE.Caption:=TimeElapsedStr;
end;
{Метод сборса времени таймера}
procedure ReTime;
begin
if Timer <> nil then
  begin
Timer.Enabled:=false;
Timer.Free;

Time:= GetTickCount;
TimeElapsedStr:='00:00:00';

Timer := NewTimer( 1000 );
Timer.OnTimer :=TonEvent(MakeMethod(nil,@Timer1));
Timer.Enabled:=true;
  end;
end;

end.
