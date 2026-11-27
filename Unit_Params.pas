unit Unit_Params;
//Параметры все какие есть и будут добавлены в далее
interface
uses KOL;
type
IniBool=record
 Show_QNumber:boolean;
 Record_On:boolean;
 Can_Error_ReTest:boolean;
 GetInfoLastQ:boolean;
 ShowTime:boolean;
 AddCommentOn:boolean;
 FullQuestion:boolean;
 DiagrammOn:boolean;
 ShowWinInfo:boolean;
 ShowWinStat:Boolean
end;
 //Объявим чтобы видеть его из другого модуля
procedure IniParams; //Вызывается в случае если нет файла параметров
procedure Load_Ini; //Метод загрузки параметров из файла "FileParams"
procedure Save_Ini; //Метод сохранения параметров в файл "FileParams"

var
 Record_On: Boolean;  (* Отключение/вкючение статистики запись и сохранение в файл*)
 Can_Error_ReTest: Boolean; (*Отключние/включение возможности прохождения ошибок теста*)
 Show_QNumber: Boolean; (*Отключение/включение отображения номера вопроса
                              в заголовке тестировщика *)
 GetInfoLastQ: Boolean; (* Отключение/вкючение количество осталось вопросов*)
 FullTest: Boolean; (* Флаг о прохождении полного теста нужен для*)
                   (* того чтобы сохранять статистику в случае если
                   тест не был пройден полностью и был завершен
                   событием OnClose*)
 ShowTime: Boolean; (*Флаг Отключение/включение отображение времени теста*)
 AddCommentOn: Boolean; (*Отключение/включение добавления комметария к ответу
                    По умолчанию отключен*)
 FullQuestion: Boolean; (*Отключение/включение выдавать "текст вопроса" в файл статистики
                    По умолчанию выключен*)
 DiagrammOn: Boolean; (*Отключение/включение "Показывать результат диаграмма"
                    По умолчанию отключен*)
 ShowWinInfo: Boolean; (*Отключение/включение "Показывать окно ввода персональных данных"
                    По умолчанию отключен*)
 ShowWinStat:Boolean;  (*Отключение/включение "Показывать окно статистики"
                    По умолчанию отключен*)
implementation
{Метод загрузки параметров из файла "FileParams"}
procedure Load_Ini;
var
file_ini: file of IniBool;
Ini_Obj:IniBool;
//-------------------
begin
//--- Load from file ---
if FileExists('FileParams')
then
 Begin
assign(file_ini,GetStartDir +'FileParams'); // msgok('Есть файл');
  reset(file_ini);//открытие файла для чтения
Read(file_ini,Ini_Obj);
//--- Set params -------
Show_QNumber :=     Ini_Obj.Show_QNumber;
Record_On :=        Ini_Obj.Record_On;
Can_Error_ReTest := Ini_Obj.Can_Error_ReTest;
GetInfoLastQ :=     Ini_Obj.GetInfoLastQ;
ShowTime :=         Ini_Obj.ShowTime;
AddCommentOn :=     Ini_Obj.AddCommentOn;
FullQuestion :=     Ini_Obj.FullQuestion;
DiagrammOn :=       Ini_Obj.DiagrammOn;
ShowWinInfo :=      Ini_Obj.ShowWinInfo;
ShowWinStat :=      Ini_Obj.ShowWinStat;
//---------------------
close(file_ini);
 End
 Else
 Exit
end;

{Метод задания параметров в при отсутствии файла параметров}
procedure IniParams;
begin
//Опции ручное отключение
 //Отключение отображения номера вопроса
//Show_QNumber:= False; //  в заголовке тестировщика
Show_QNumber:=True;
//----------------
//Record_On:= False; //Отключение статистики запись и сохранение в файл
Record_On:= True;
//----------------
//Can_Error_ReTest:= False; //Отключение прохождения ошибок после окончания теста
Can_Error_ReTest:= True;
//----------------
//GetInfoLastQ:= False; //Отключение отображение "Сколько вопросов осталось?"
GetInfoLastQ:= True; //Включает отображение "Сколько вопросов осталось?"
//-----------------------------------------------------------------------
ShowTime:= False; //Включает отображение "Время прохождения теста"
//----------------------
AddCommentOn:= False;//Включает/Отключает добавление комметария к ответу
                  // По умолчанию отключен
//---------------------
FullQuestion := False; //Отключение/включение выдавать "текст вопроса"
                  //в файл статистики -> По умолчанию выключен
//---------------------
DiagrammOn := False; //Отключение/включение "Показывать результат диаграмма"
                    //По умолчанию отключен
//---------------------
ShowWinInfo:= False; //Отключение/включение "Показывать окно ввода персональных данных"
                   // По умолчанию отключен
//---------------------
ShowWinStat:=  False (*Отключение/включение "Показывать окно статистики"
                    По умолчанию отключен*)
end;

{Метод сохранения параметров в файл "FileParams"}
procedure Save_Ini;
var file_ini: file of IniBool;
    Ini_Obj:IniBool;
//-------------------
begin
//----- Read params -----
Ini_Obj.Show_QNumber := Show_QNumber;
Ini_Obj.Record_On := Record_On;
Ini_Obj.Can_Error_ReTest := Can_Error_ReTest;
Ini_Obj.GetInfoLastQ := GetInfoLastQ;
Ini_Obj.ShowTime := ShowTime;
Ini_Obj.AddCommentOn := AddCommentOn;
Ini_Obj.FullQuestion := FullQuestion;
Ini_Obj.DiagrammOn   := DiagrammOn;
Ini_Obj.ShowWinInfo  := ShowWinInfo;
Ini_Obj.ShowWinStat :=   ShowWinStat;
//----- Save to file ----
assign(file_ini,GetStartDir +'FileParams');
  rewrite(file_ini);
Write(file_ini,Ini_Obj);
close(file_ini)
end;
end.
