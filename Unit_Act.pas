unit Unit_Act;
 //Все действия и другие важные переменные и контролы здесь
interface
uses Windows,KOL,JpegObj;
type
 PForm1 = ^TForm1;
 TForm1 = object(TObj)
 public
 end;
 type
  PQuestion=^TQuestion;
  TQuestion=record
   Name: String[255];
   ResultCount:Integer;
   ResiltText: array[0..10] of String[255];
   ResiltValue: array[0..10] of boolean
  end;

 //Объявим чтобы видеть его из другого модуля
//procedure Colored_Controls; {Раскраска контролов для определения видимых размеров}
 procedure DoPaint(Dummy: Pointer;Sender: PControl; DC: HDC );{метод отрисовки картинки}
 procedure CreateForm;{ Инициализация переменных }
 procedure Form_Close(DummySelf,Sender: PControl;  var Accept: Boolean);{Вызов событий на закрытие формы}
 procedure FormDestroy(DummySelf,Sender: PControl); {Освобождение объектов}
 procedure QuestionCheckList_MouseDown(Dummy:Pointer; Sender: PControl; var Mouse: TMouseEventData);
 procedure NextButtonClick(Sender: PControl);
 function GetText(S1:String):String;
 function GetNewPicPuth(S:String):String;
 procedure DoWorkToolBar(Sender: PControl); {Метод для работы ToolBara}
 procedure Toolbar1MouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
 procedure SaveFileErrorTest(Sender: PControl);  {Метод сохранения теста ошибок}
 {Событие при нажатии на кнопку ErrorsButton}
 procedure ErrorsButton_MouseDown(Dummy:Pointer; Sender: PControl; var Mouse: TMouseEventData);
 {Метод инициализации параметров для модуля Диаграмма}
  procedure InitParamsForUnit_Diagram;
{Две процедуры Комфорт для записи коментария}
  {Метод Click Clear}
procedure MouseDownClearText(dummy:pointer;Sender:PControl; var mouse:TMouseEventData);
{Метод если мы ничего не записали и уходим из контрола}
procedure EditBoxLeave(Dummy:pointer;Sender:PControl; var mouse:TMouseEventData);
 {Метод вызова окна "Оции контролов"}
procedure WinOptConrols_BtnClick(Sender: PControl);
 {Метод вызова окна "Формa вывод результата теста"}
procedure FormAnalizePoints_BtnClick(Sender: PControl);
 var
 Jpg: pJpeg;//Объект картинки загружается в формате JPG
 PicNamePuth:String;// Путь к картинке храниться в билете

 Form: PControl;//Главная Форма теста
 Toolbar1: PControl;// Панель кнопок
 Splitter: PControl;//Разделитель м/у QuestionLabel и QuestionCheckList
 LabelTE: Pcontrol;//Метка отображающая "сколько времени прошло"
 OptBtn: Pcontrol;//BitBtn Кнопка для вызова окна "Оции контролов"
 Dialog:pOpenSaveDialog;//Диалог для открытия файлов тестов
 QuestionLabel: Pcontrol;//Метка для отбражения текущего вопроса
 PB: Pcontrol;//Пайт бокс в нём отрисовывается картинка теста
 Paneltop: Pcontrol;//Панель содержит элементы "строки" "состояния прохождения теста"
 B:array[1..20] of PControl; //для отображения ответов верно/неверно
                            //"элементов" цветовой "строки состояния"
 NextButton: PControl;// Кнопка далее
 ErrorsButton:PControl; //Кнопка для Прохождения теста ошибок/
                        //Второе назначение прав кнопка сохранение ошибок
                        //в отдельный тест
 AddCommEditBox:PControl;//Поле для ввода комметария пользователя
 //Преременные формы
 IntColor:integer;   //для определения номера вопроса цвевой строки состояния
 Question:Integer; //Номер вопроса
 QuestionCheckList: Pcontrol;//Визуальный Список ответов
 LVItemCurrent:Integer; //Определения текущего ответа
 FalseNumber: Integer; //Количество не правльных ответов

 QNumber:String; //реальный номер вопроса
 StatisticNameFile:String; //Имя файла статистики
 QuestionNumber: Integer;// Номер ответа в формате инт
 Count:Integer;//количество загруженных вопросов
 BiletName:String;//Имя билета для сохранения в файл статистики
 NumofAllTrueAnsers: Integer;//Количество всех правильных ответов в вопросе
 //---Контейнеры-------
 QuestionList:pList;//Список в котором хранятся вопросы и ответы
 ErrorsList:pList;// Список ошибок допущенных в тесте
 //---Переменные для модуля Диаграмма--
IntNone   : Integer; //Счётчик "Пропущенные ответы"
IntAllOk  : Integer; //Счётчик "Правильных ответов"
IntSmallOk: Integer; //Счётчик "Неполные ответы"
IntDiff   : Integer; //Счётчик "Смешанные ответы"
IntErrors : Integer; //Счётчик "Ошибки"
 //------------------------------------
 //Информация о тестируемом
 StrInfo:String;
 //-----------------------------------
 //Временная кнопка для вызова Формы резуотат теста
 FormAnalizePointsBtn:PControl; //Кнопка для Вызова 'Формы вывод результата теста'
implementation
uses
Unit_Params,
Unit_Records,
Unit_Timer,
Unit_Options,
Unit_Diagram,
Unit_Stat,//Показыват окно статистики
Conrtol_Options, //Опции управления внешний вид надписей и так далее
Unit_AnalizePoints; //Окно 'вывод результата теста'
//Сюда складываем реализацию процедур
{Раскраска контролов для определения видимых размеров}
procedure Colored_Controls;
begin
Paneltop.Color := clGreen;
QuestionCheckList.LVTextColor := clFuchsia;
QuestionCheckList.LVBkColor := ColorsMix( clLime, clSilver );
QuestionCheckList.LVTextBkColor := ColorsMix( clAqua, clSilver );
end;

{Инициализация переменных формы}
Procedure CreateForm;
begin
QuestionList:= NewList;
 //NumberQList:= NewStrList; if Can_Error_ReTest then
  ErrorsList:= NewList; //For errors
JPG := NewJpeg;
JPG.Bitmap := NewBitmap(1, 1);
IntColor:=0;
Timer := NewTimer( 1000 );
Timer.OnTimer :=TonEvent(MakeMethod(nil,@Timer1));
//========================================
if FileExists('FileParams') then Load_Ini else IniParams;

FullTest:=False;//Флаг о прохождении полного теста
//Colored_Controls; //for test's
//OutputDebugString('step 1 passed');
if GetInfoLastQ then form.StatusText[0]:=pchar('');
if ShowTime then LabelTE.visible:=true;
//FullQuestion:= True //Опция выдавать "текст вопроса"  в статистику
end;

{Метод инициализации параметров для модуля Диаграмма}
procedure InitParamsForUnit_Diagram;
begin
// Case All null
IntNone   := 0; //Счётчик "Пропущенные ответы"
IntAllOk  := 0; //Счётчик "Правильных ответов"
IntSmallOk:= 0; //Счётчик "Неполные ответы"
IntDiff   := 0; //Счётчик "Смешанные ответы"
IntErrors := 0; //Счётчик "Ошибки"
end;

{Метод отрисовки картинки}
procedure DoPaint(Dummy: Pointer;Sender: PControl; DC: HDC );
begin
jpg.LoadFromFile(PicNamePuth);
SetStretchBltMode(PB.Canvas.Handle,MAXSTRETCHBLTMODE);
Jpg.StretchDraw(Sender.Canvas.Handle, Sender.ClientRect);
end;

{Метод сброса цветовой строки состояния}
procedure MakeAgainQ;
var I:integer;
begin
  for I := 1 to 20 do begin
  B[I].Color:=clBtnFace;
  B[I].Visible:= False;
                      end;
end;

{Получение текста оибочного ответа}
function GetErrorAnserText(S1:String):String;
begin
Result:=copy(s1,1,36);;
end;

{Для получения текста}
function GetText(S1:String):String;
var r,r1 :integer;
begin
r1:=length(s1);
r:=pos(' ',s1);
Result:=copy(s1,r,r1);;
end;

{Метод получения Вопроса без номера}
function GetQuestion(S:String):String;
var Pos : Integer;
begin
Pos:= IndexOfCharsMin( S,#59 );
Result:=Copy( S, 0 , Pos-1 );
//Delete( S, Pos,Length(S) );
end;

{Метод получения пути к картинке}
function GetNewPicPuth(S:String):String;
var Pos : Integer;
begin
Pos:= IndexOfCharsMin( S,#59 );
Result:=Copy( S, Pos+1, Length( S ) );
end;

{Метод переход к следующему вопросу}
procedure NextQuestion(Sender: PControl);
var
 i:Integer;
 
begin
TimeLoadQuestion:= Gettickcount;
 Randomize;
 Question:=Random(QuestionList.Count-1);
 //form.Caption:=form.Caption+int2str(Question);

 QNumber:=PQuestion(QuestionList.Items[Question]).Name;

 if (GetText(GetQuestion(QNumber)) = '') then  //если тест без картинки
 QuestionLabel.Caption:=GetText(QNumber)
  else
 QuestionLabel.Caption:=GetText(GetQuestion(QNumber)); //Для теста с картинкой

  PicNamePuth:= GetStartDir+GetNewPicPuth(QNumber);
 QNumber:= Parse(QNumber,#32);
 if Show_QNumber then
 Form.Caption:= BiletName+' '+QNumber;
 QuestionCheckList.Clear;
  QuestionCheckList.LVColAdd('colum1',taleft,(QuestionCheckList.Width+150));
for i:=0 to PQuestion(QuestionList.Items[ Question])^.ResultCount-1 do
  QuestionCheckList.LVItemAdd(PQuestion(QuestionList.Items[Question])^.ResiltText[i]);

 Inc(QuestionNumber);

if GetInfoLastQ then begin
  form.StatusText[0]:=pchar('Осталось вопросов : '+int2str(QuestionList.Count));
  if QuestionList.Count=0 then form.StatusText[0]:='';
                      end;
//form.Caption:= 'Осталось '+int2str(QuestionList.Count-1);
form.StatusText[1]:=pchar(' Время загрузки вопроса: '+int2str(Gettickcount-TimeLoadQuestion)+' ms');
end;

{Метод определения множественности ответов}
(*А также косвенно будем узнавать количество верных ответов*)
function IsMnTRueAnsers:Boolean;
var i:Integer;
begin
result:=False;
 NumofAllTrueAnsers :=0; //Количество правильных вопросов всегда по началу NULL

  for i:=0 to PQuestion(QuestionList.Items[Question]).ResultCount-1 do //идем по списку вопросов
 {Если встречаем ответ => Верен, то увеличиваем счетчик всех правильных вопросов}

  if PQuestion(QuestionList.Items[Question]).ResiltValue[i] = true then
                        inc(NumofAllTrueAnsers);

 if NumofAllTrueAnsers>1 then result:=True;
 //Переменная NumofAllTrueAnsers глобальная чтобы видеть ее зачение в
 //следующей процедуре NextButtonClick(Sender)
end;
{Метод получает текст ответ 100 символов}
function GetTextQPart(S1:String):String;
begin
Result:=copy(s1,1,100)
end;
{Метод следующий вопрос}
procedure NextButtonClick(Sender: PControl);

type StateQ = (None,AllOk,SmallOk,Diff,Errors);

var
 OK:Boolean;//,bo
 i:Integer;// Итератор цикла номер вопроса
 QuestionState:StateQ;//Текущее состояние ответа
 //---------------Строки для статистики---)
 NoAnserStr,        //Овет пропущен
 GoodStr,           //ответ верен
 SmallGoodStr,      //Верен (не полный ответ)
 DiffStr,           //Не верен (Смешанный есть оба типа)
 ErrorStr: String;  //Не Верный (только не правильные)
 //=======================================
 FinAnserStr:String;//Результирующая строка
 //=======================================
 //======================================
 (*две локальные переменные*)
 NumIntRightAnser : Integer; //Количество Правильных ответов дал(а) Тестируемый(я)
 NumIntErrorAnser : Integer; //Количество Не правильных ответов дал(а) Тестируемый(я)
 IsAnser          : Integer; //Ответ дан "Флаг-Integer"
 //======================================
  GoodAnserText   : String;  //Строка для сбора правильных ответов
  ErrorAnserText  : String;  //Строка для сбора не правильных ответов
 //======================================
begin
//======================
 NoAnserStr   := ' Овет пропущен';
 GoodStr      := ' ответ верен';
 SmallGoodStr := ' Верен (не полный ответ)';
 DiffStr      := ' Не верен (Смешанный)';
 ErrorStr     := '   НЕ ВЕРНЫЙ';
 //=====================
// Блок инициализации двух переменных
OK            := True;
QuestionState := None;
 //=====================
  (*Конечный ответ сбрасываем перед началом*)
 FinAnserStr := '';
 //===================Begin
NumIntRightAnser:= 0;//Выставляем количество правильных ответов в Ноль
NumIntErrorAnser:= 0;//Выставляем количество неправильных ответов в Ноль
IsAnser:=0; //Выставляем количество данных ответов в Ноль начальные условия
//===================Сброс для множественных ответов
GoodAnserText   := '';// Все правильные ответы    -> Текст
ErrorAnserText  := '';// Все НЕ правильные ответы -> Текст

Case IsMnTRueAnsers of  //Опеделяем множественность ответов
True: //Правильных ответов несколько
  begin
  //Получение информации об ответах !->>
 for i:=0 to PQuestion(QuestionList.Items[Question]).ResultCount-1 do //Идем по списку ответов
      Begin
      //Если ответ -> верен
      if (QuestionCheckList.LVItemStateImgIdx[i] = 2) and //Если галочка отмечена
     (PQuestion(QuestionList.Items[Question]).ResiltValue[i] = true) //И это правльный ответ, то
      then //Верен
                                                              begin
      //Собираем только правильные ответы
      GoodAnserText:=GoodAnserText+'|'+PQuestion(QuestionList.Items[Question]).ResiltText[i];
      inc(NumIntRightAnser);//Считаем правильные ответы !
      inc(IsAnser) // Ответ дан
                                                              end;
      //Если ответ -> ошибочен
     if (QuestionCheckList.LVItemStateImgIdx[i] = 2) and //Если галочка отмечена
     (PQuestion(QuestionList.Items[Question]).ResiltValue[i] = false)//И это НЕ правльный ответ, то
      then //Ошибочен
                                                              begin
      //Собираем только НЕ правильные ответы
      ErrorAnserText:=ErrorAnserText+'|'+PQuestion(QuestionList.Items[Question]).ResiltText[i];
      inc(NumIntErrorAnser);//Считаем Не правильные ответы !
      inc(IsAnser); // Ответ дан
                                                              end;

      End;


     //Обрабатываем полученную информацию!
     // Если Нет ни одного ответа -> Пропуск вопроса
       if IsAnser = 0 then

       QuestionState := None;//"состояние ответа" -> "Пропуск вопроса"


     // Если все правильные ответы есть и количество не правильных НОЛЬ, то
       if (NumIntRightAnser = NumofAllTrueAnsers) and (NumIntErrorAnser = 0)  then
       
       QuestionState := AllOk;//"состояние ответа"  -> "Все ответы верны"

     //Если есть правильные ответы, но их количество не полное, то
       if (NumIntRightAnser <> NumofAllTrueAnsers) and (NumIntErrorAnser = 0) and (IsAnser>0) then
                            begin
       QuestionState := SmallOk;//"состояние ответа" -> "Не полный ответ"
       inc(IntSmallOk);// Считаем количество Неполных ответов
       dec(IntAllOk); // Сделал чтобы не путаться =)
      //===========
                            end;
     //Если есть Правильные ответы и НЕ правильные, то ответ смешанный
       if (NumIntRightAnser>0) and (NumIntErrorAnser>0) then
                            begin
       QuestionState := Diff; //"состояние ответа" -> "Cмешанные ответы"
       inc(IntDiff);// Считаем количество Смешанных ответов
       dec(IntErrors);// Сделал чтобы не путаться =)
      //===========
                            end;
     //Если есть только НЕ правильные и количество "Правильных" НОЛЬ, то
       if (NumIntErrorAnser>0) and (NumIntRightAnser=0) then
       QuestionState := Errors;//"состояние ответа" -> "Ошибки"


  Case QuestionState of //"Получаем и анализируем состояние ответа"
      None:(*'Тип "None" ответы не отмечены*)
  begin
      OK := false;//Он пропущен, но это всё равно не правильный ответ
      FinAnserStr:=  NoAnserStr
  end;

    AllOk: (*Тип "Allok" все ответы верны*)
  begin
      OK:=true;//Отмечаем его как верный
      FinAnserStr:= GoodStr+' '+GoodAnserText
  end;

    SmallOk: (*Тип "SmallOk" ответ не полный*)
  begin
      OK:=true;//Отмечаем его как верный
      // OK := false;//Отмечаем как не правильный 
      FinAnserStr:= SmallGoodStr+' '+GoodAnserText
  end;
    Diff: (*Тип "Diff" смешанные ответы*)
  begin
      OK := false;//Отмечаем как не правильный есть оба типа ответов
      FinAnserStr:= DiffStr+' Good -> '+GoodAnserText+' Errs -> '+ErrorAnserText;
  end;
    Errors: (*Тип "Errors" все ответы Не верны*)
  begin
      OK := false;//Отмечаем как не правильный "только ошибки"
      FinAnserStr:= ErrorStr+' '+ErrorAnserText
  end;

 end; //End of Case
 
  end; //True
False: //Правильный Ответ только 1
  begin
 for i:=0 to PQuestion(QuestionList.Items[Question]).ResultCount-1 do //Идем по списку ответов
      Begin

     //Если ответ -> верен
     if (QuestionCheckList.LVItemStateImgIdx[i] = 2) and //Если галочка отмечена
     (PQuestion(QuestionList.Items[Question]).ResiltValue[i] = true) //И это правльный ответ, то
      then //Верен
                                                              begin
       OK:=true;//Отмечаем его как верный
      FinAnserStr:=GoodStr+' '+PQuestion(QuestionList.Items[Question]).ResiltText[i];
      inc(IsAnser) // Ответ дан
                                                              end;

     //Если ответ -> ошибочен
     if (QuestionCheckList.LVItemStateImgIdx[i] = 2) and //Если галочка отмечена
     (PQuestion(QuestionList.Items[Question]).ResiltValue[i] = false)//И это НЕ правльный ответ, то
      then //Ошибочен
                                                              begin
      OK := false;//Отмечаем его как не правильный
      FinAnserStr:=ErrorStr+' '+PQuestion(QuestionList.Items[Question]).ResiltText[i];
      inc(IsAnser) // Ответ дан
                                                              end;

      // Если ни одного ответа нет вовсе
      if IsAnser = 0
       then  // Нет ни одного ответа -> Пропуск вопроса
                                                              Begin
      OK := false;//Он пропущен, но это всё равно не правильный ответ
      FinAnserStr:=  NoAnserStr;
                                                              end;
      
      End; //False
  end;//case IsMnTRueAnsers

end;//End of Case
//===================My Maginc===== End;
 if IsAnser = 0 then    inc(IntNone);// Считаем количество пропущенных ответов
      //===========
 if OK = false then
  Inc(FalseNumber);

 Inc(IntColor);//для позиционирования

 if IntColor = 21 then begin IntColor:= 1;MakeAgainQ;end;
 if FullQuestion then AddRecord('Q '+QNumber+GetTextQPart(QuestionLabel.Caption),'');
 if OK then
  begin
  inc(IntAllOk);// Считаем количество верных ответов
  //===========
    B[IntColor].Color := clgreen;//$7F299
    if Record_On then if not FullQuestion then AddRecord(QNumber, FinAnserStr+#13#10) else AddRecord('', FinAnserStr+#13#10)
  end
 else
  begin
  if (IsAnser <> 0) then inc(IntErrors);// Считаем количество Ошибочных ответов
      //===========
    B[IntColor].Color := clred;
    if Record_On then if not FullQuestion then AddRecord(QNumber, FinAnserStr+#13#10) else AddRecord('', FinAnserStr+#13#10);
    if Can_Error_ReTest then ErrorsList.Add( PQuestion(QuestionList.Items[Question]));
  end;
  B[IntColor].Visible := true;
 QuestionList.Delete(Question);

 if QuestionNumber< Count then
  NextQuestion(sender)// Преход на следующий вопрос -> Метод

 else
  begin
  FullTest:=True;
  //MessageBoxA(0,pchar('Вы закончили тест с количеством ошибок = '+Int2Str(FalseNumber)),'Внимание!!!',MB_ok);
   //msgbox(pchar('Вы закончили тест с количеством ошибок = '+Int2Str(FalseNumber)),+MB_ok);
  QuestionCheckList.Clear;
  //FalseNumber:=100; //Для тестирования "длины вывода ошибок" если >100,
  // то третий символ не был виден
  QuestionLabel.Text:= Form.Caption+#32+#13#10+
  'Вы закончили тест с количеством ошибок = '+Int2Str(FalseNumber);
  //FormAnalizePointsBtn.visible:= true;
  ShowTime:=False;
  form.StatusText[0]:=pchar('');

   if Record_On then FinRecord;//Конечная запись
   NextButton.Enabled:=false;
   toolbar1.TBButtonEnabled[0]:=true;
   if (FalseNumber>0) and Can_Error_ReTest then ErrorsButton.Visible:= True;
  if DiagrammOn then
                    begin
   //Вызываем отрисовку результата прохождения теста =)
  WinDiagram(nil,Sender);
  FormDiagram.Show;
                    end;
  if ShowWinStat then
                     begin
  //Вызов окна статистики
  WinFormStat(nil,form);
  FormStat.Show;
                     end;
  end;
  //if QuestionList.Count-1=0 then form.StatusText[0]:='';
  PB.Invalidate;

end;

{Метод выбора ответа}
procedure QuestionCheckList_MouseDown(Dummy:Pointer; Sender: PControl; var Mouse: TMouseEventData);
 var Item: Integer;
 Where: TWherePosLVItem;
begin
// msgok(' MouseDown ');
 if (Mouse.Button = mbRight) then
 Begin
 if not NextButton.Enabled then exit;
 NextButtonClick(Sender);// Левая клавиша мыши  - Перемещаем окно
 End
 Else
 Begin
  Item := Sender.LVItemAtPosEx(Mouse.X, Mouse.Y, Where);
  LVItemCurrent:=Item;//Запоминаем текуший ответ
 if (Item >= 0) and (Where <> lvwpOnStateIcon) then
   Sender.LVItemStateImgIdx[Item] := Sender.LVItemStateImgIdx[Item] xor 3;
 end;
end;

{Метод загрузки из файла теста}
procedure LoadFile(Sender: PControl);
var
 fs:PStream;
 i:Integer;
 Str:String[5];
 ProjectName:String[255];
 NewQuest:PQuestion;
begin
 QuestionList.Clear;
 //Открыть файл для чтения
 fs:=NewReadFileStream( Dialog.Filename );

 //Перейти в начало файла и прочитать заголовок
 fs.Seek( 0, spBegin );
 fs.read(Str, SizeOf(Str));

 //Если заголовок равен тексу "Тест", значит это "вопрос-
 //варианты ответов".
 if Str='Тест' then
  begin
   //Прочитать имя проекта
   fs.Read(ProjectName, sizeof(ProjectName));
   form.Caption:=ProjectName;
   BiletName:=ProjectName;
   try
    //Прочитать количество вопросов
    fs.Read(Count, sizeof(Count));

    //Запустить цикл чтения вопросов
    for i:=0 to Count-1 do
     begin
      //Создаю новую структуру в памяти для вопроса
      NewQuest:=New(PQuestion);
      //Читаю структуру
      fs.Read(NewQuest^, sizeof(TQuestion));
       // msgok('s2 '+s2);
      //Добавляю структуру в контейнер
      QuestionList.Add(NewQuest);
     end;
   finally
    //Закрываю файл
    fs.Free;
   end;
  end;
end;

{Метод для работы ToolBara}
procedure DoWorkToolBar(Sender: PControl);
var f:file;
 begin
    case toolbar1.CurIndex of
     0:begin {Open}   //Показать окно открытия файла
     if ErrorsButton.Visible then ErrorsButton.Visible:= False;

     if B[1].Visible then MakeAgainQ;
        Dialog:=NewOpenSaveDialog('','',[]) ;
        Dialog.Filter := 'Файлы теста|*.tst';
        Dialog.title := 'Открыть';
        Dialog.OpenDialog := true;
          if Dialog.Execute then begin
          assign(f,Dialog.Filename);
       toolbar1.TBButtonEnabled[1 ]:=true;
             // closefile(f);
             QuestionLabel.Text :='Для запуска теста, пожалуйста, нажмите вторую кнопку с желтыми кубиками )';
                                 end else exit;
      end;
     1:begin {Run}
     if Dialog.Filename ='' then Exit;

     if ErrorsButton.Visible then ErrorsButton.Visible:= False;
     if B[1].Visible then MakeAgainQ;
     LoadFile(Sender);
     IntColor:=0;//сброс позиции
     QuestionNumber:=0;
     FalseNumber:=0;
      NextButton.Enabled:=true;
      NextQuestion(Sender);
      if Record_On then NewRecord;
      PB.Visible:= True;
      PB.Invalidate;

      if Timer.Enabled = False then begin
      Time:= GetTickCount;
      TimeElapsedStr:='00:00:00';
      Timer.Enabled:=true
      end
      else
      Unit_timer.ReTime;
      toolbar1.TBButtonEnabled[ 0 ]:= False;
      InitParamsForUnit_Diagram;
      //Msgok(StrInfo);
      Unit_Records.AddRecordInfo(StrInfo);
      end;
     2:WinOptions(Sender);
     4:Applet.Close;{Exit}
 end;{case}
end;

{Метод Toolbar1MouseDblClk}
procedure Toolbar1MouseDblClk(Sender: PControl;var Mouse: TMouseEventData);
begin
//Msgok('DblClick')
toolbar1.TBButtonVisible[2]:= not toolbar1.TBButtonVisible[2];
end;
{Метод Форм Дестрой}
procedure FormDestroy(DummySelf,Sender: PControl);
begin
  QuestionList.Free;
  ErrorsList.Free;
end;
{Вызов событий на закрытие формы}
procedure Form_Close(DummySelf,Sender: PControl;  var Accept: Boolean);
begin
//msgok('Закрытие формы')
if Record_On then
if not FullTest then NotFinRecord; //Если тест не закончен, то запись
// о времени и длительности все же будет сделана!
 Save_Ini
end;

{Событие при нажатии на кнопку ErrorsButton}
procedure ErrorsButton_MouseDown(Dummy:Pointer; Sender: PControl; var Mouse: TMouseEventData);
var I:Integer;
begin
 // Msgok('It work'+#39+'s')
 if Can_Error_ReTest then
 Begin
//Record_On:= False;
if (Mouse.Button = mbLeft) then
 Begin

ErrorsButton.Visible:= False;
QuestionList.Clear;
//QuestionList:= ErrorsList; //Error 204
for I := 0 to ErrorsList.Count-1 do QuestionList.Add(ErrorsList.Items[I]);
 Count:=QuestionList.Count; //Обновляем количество вопросов
 if B[1].Visible then MakeAgainQ;
     //LoadFile(Sender);
     IntColor:=0;//сброс позиции
     QuestionNumber:=0;
     FalseNumber:=0;
      NextButton.Enabled:=true;
      NextQuestion(Sender);
      if Record_On then NewRecord;
      PB.Visible:= True;
      PB.Invalidate;
      toolbar1.TBButtonEnabled[ 0 ]:= False;
      ErrorsList.Clear;
      InitParamsForUnit_Diagram;
      ReTime
 end
 Else //mbRight
  begin
  QuestionList.Clear;
//QuestionList:= ErrorsList; //Error 204
for I := 0 to ErrorsList.Count-1 do QuestionList.Add(ErrorsList.Items[I]);
 Count:=QuestionList.Count; //Обновляем количество вопросов
  SaveFileErrorTest(Sender); {Метод сохранения теста ошибок}
  form.StatusText[0]:=' файл тест ошибок сохранен ';
  QuestionList.Clear;
  end;// End of mbRight
 End
 Else
 Exit;
end;

{Метод сохранения теста ошибок}
procedure SaveFileErrorTest(Sender: PControl);
var
 f:file;
 FileName:String;
 fs:PStream;
 i,Count:Integer;
 Str:String[5];
 ProjectName:String[255];
begin
//showmessage('save something')
//Создаю новый файл. Если он уже существовал, то его
 //содержимое будет уничтожено
 FileName:= GetUniqueFilename(GetStartDir +BiletName+'Er.tst');
  assign(f,FileName);
 fs:=NewWriteFileStream(FileName);
 //Сохраняю в начале файла текст "Тест", чтобы по нему потом
 //определить к чему относиться данный файл.
 Str:='Тест';
 fs.write(Str, SizeOf(Str));
   //Записать имя проекта
   ProjectName:=BiletName;
   fs.write(ProjectName, sizeof(ProjectName));
   try
   Count:=QuestionList.Count;
    //Записать количество вопросов
    fs.write(Count, sizeof( Count));
  // for i:=0 to Count-1 do showmessage(string(QuestionList.Items[i]));
  //Запускаю цикл, в котором сохраняються все вопросы.
  for i:=0 to Count-1 do
   fs.Write(QuestionList.Items[i]^, sizeof(TQuestion));
   finally
    //Закрываю файл
    fs.Free;
   end;//finally end
end;

{Две процедуры Комфорт для записи коментария}
{Метод если мы ничего не записали и уходим из контрола}
procedure EditBoxLeave(Dummy:pointer;Sender:PControl; var mouse:TMouseEventData);
begin
if AddCommEditBox.Text = '' then
AddCommEditBox.Text:= 'Мой комментарий к вопросу.'
end;
{Метод Click Clear}
procedure MouseDownClearText(dummy:pointer;Sender:PControl; var mouse:TMouseEventData);
begin
if AddCommEditBox.Text = 'Мой комментарий к вопросу.'
then
AddCommEditBox.Clear;
end;
 {Метод вызова окна "Оции контролов"}
procedure WinOptConrols_BtnClick(Sender: PControl);
begin  // Msgok('Я красавица )')
  WinCntlOptions(Sender);
  Win_Options.Show
end;
 {Метод вызова окна "Формa вывод результата теста"}
procedure FormAnalizePoints_BtnClick(Sender: PControl);
begin
  WinAnalizePointsForm(nil,form);
end;
end.
