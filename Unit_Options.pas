unit Unit_Options;
//Задесь форма Опции и его элементы
interface
uses windows,KOL;
 //Объявим чтобы видеть его из другого модуля
procedure WinOptions(Sender: PControl);{Вызов окна Опции}
procedure Options_Close(DummySelf,Sender: PControl;  var Accept: Boolean);
procedure GetOptions; {Метод получения значений опиции}
procedure ChBoxClick(Dummy: Pointer;Sender:pControl);{Собития для ЧекБокс'ов}
var
Options: PControl; //Форма окна опции
GroupBox: PControl;//Бокс для группы контролов
ChBox_Show_QNumber: PControl;// ЧекБокс для показа вопров в заголовке окна тестировщика
ChBox_Record_On: PControl;// ЧекБокс для ведения статистики ответов верно/не верно

GroupBoxStat: PControl;//Бокс для группы статистики

ChBox_Can_Error_ReTest: PControl;// ЧекБокс для прохождение ошибок после окончания теста
ChBox_GetInfoLastQ: PControl;// ЧекБокс для отображение "Сколько вопросов осталось до завершения теста?"
ChBox_ShowTime: PControl;// ЧекБокс для отображение  "Время прохождения теста"
ChBox_AddCommentOn: PControl;// ЧекБокс для добавления комментария к ответу и запись
                             // в файл статистки
ChBox_FullQuestion: PControl;// ЧекБокс для выдавать "текст вопроса" в файл статистики
                              //По умолчанию режим "только номер вопроса"
ChBox_DiagrammOn: PControl; //Отключение/включение "Показывать результат диаграмма"
                    //По умолчанию отключен
ChBox_ShowWinInfo: PControl; //Отключение/включение "Показывать окно ввода персональных данных"
                   // По умолчанию отключен
ChBox_ShowWinStat: PControl;  (*Отключение/включение "Показывать окно статистики"
                    По умолчанию отключен*)
//GroupBoxRecordStat: PControl;  //Бокс для группы -> Запись статистики в файл
implementation
uses
Unit_Act,
Unit_Params,
Unit_PersonInfo;
{Вызов окна Опции}
procedure WinOptions(Sender: PControl);
begin //Msgok('Options')

Options:=NewForm(Form,'Параметры теста').SetClientSize( 596, 335  ).CenterOnParent;

Options.Style := Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);//отключаем кнопку раскрыть и минимизировать
 Options.Font.FontName := 'MS Sans Serif';
 //Options.Font.FontCharset := 0;
GroupBox:= NewGroupBox(Options, ' Регулируемые настройки теста ' ).setalign( caClient );

ChBox_Show_QNumber := NewCheckBox(GroupBox,' Показывать номер вопроса в заголовке  тестировщика.').autosize(true).PlaceUnder;
ChBox_Show_QNumber.Tag:= 1;



GroupBoxStat:= NewGroupBox(GroupBox, '').setclientsize(480,110).PlaceUnder;//autosize(true).PlaceUnder;
GroupBoxStat.Font.Color := TColor(clWindowFrame);
GroupBoxStat.Font.FontHeight := -14;
GroupBoxStat.Font.FontName := 'MS Sans Serif';
GroupBoxStat.Font.FontCharset:= 0;
GroupBoxStat.Caption:=' Группа статистики ';

GroupBoxStat.Color:=  clInactiveBorder ;
ChBox_Record_On := NewCheckBox(GroupBoxStat,' Вести статистику запись и сохранение в файл.').autosize(true).Placedown;
ChBox_Record_On.Tag:= 2;

ChBox_AddCommentOn:= NewCheckBox(GroupBoxStat,' Добавление '+#34+'Комментария к ответу и запись в статистику'+#34).autosize(true).Placedown;
ChBox_AddCommentOn.Tag:= 6;

    ChBox_AddCommentOn.Left:= 15;

ChBox_FullQuestion:=  NewCheckBox(GroupBoxStat,' Добавление '+#34+'Выдавать "текст вопроса" в файл статистики'+#34).autosize(true).Placedown;
ChBox_FullQuestion.Tag:= 7;

    ChBox_FullQuestion.Left:= 15;

ChBox_ShowWinInfo := NewCheckBox(GroupBoxStat,' Показывать '+#34+'Показывать окно ввода персональных данных'+#34).autosize(true).Placedown;
ChBox_ShowWinInfo.Tag:=9;

    ChBox_ShowWinInfo.Left:= 15;

ChBox_Can_Error_ReTest:= NewCheckBox(GroupBox,' Прохождение ошибок, после окончания теста.').autosize(true).Placedown;
ChBox_Can_Error_ReTest.Tag:= 3;
ChBox_GetInfoLastQ:= NewCheckBox(GroupBox,' Отображение '+#34+'Сколько вопросов осталось'+#34+' до завершения теста?').autosize(true).Placedown;
ChBox_GetInfoLastQ.Tag:= 4;
ChBox_ShowTime:= NewCheckBox(GroupBox,' Отображение '+#34+'Время прохождения теста'+#34).autosize(true).Placedown;
ChBox_ShowTime.Tag:= 5;


ChBox_DiagrammOn:=  NewCheckBox(GroupBox,' Добавление '+#34+'Показывать результат диаграмма'+#34).autosize(true).Placedown;
ChBox_DiagrammOn.Tag:= 8;

ChBox_ShowWinStat := NewCheckBox(GroupBox,' Показывать '+#34+'Показывать окно статистики, после окончания теста'+#34).autosize(true).Placedown;
ChBox_ShowWinStat.Tag:=0;

ChBox_Show_QNumber.OnClick := TOnEvent(MakeMethod(nil, @ChBoxClick));
ChBox_Record_On.OnClick := TOnEvent(MakeMethod(nil, @ChBoxClick));
ChBox_Can_Error_ReTest.OnClick := TOnEvent(MakeMethod(nil, @ChBoxClick));
ChBox_GetInfoLastQ.OnClick := TOnEvent(MakeMethod(nil, @ChBoxClick));
ChBox_ShowTime.OnClick := TOnEvent(MakeMethod(nil, @ChBoxClick));
ChBox_AddCommentOn.OnClick := TOnEvent(MakeMethod(nil, @ChBoxClick));
ChBox_FullQuestion.OnClick := TOnEvent(MakeMethod(nil, @ChBoxClick));
ChBox_DiagrammOn.OnClick := TOnEvent(MakeMethod(nil, @ChBoxClick));
ChBox_ShowWinInfo.OnClick := TOnEvent(MakeMethod(nil, @ChBoxClick));
ChBox_ShowWinStat.OnClick := TOnEvent(MakeMethod(nil, @ChBoxClick));

GetOptions;

Options.OnClose:=TOnEventAccept(MakeMethod(nil,@Options_Close));
end;

 {Метод получения значений опиции}
procedure GetOptions;
begin
if Show_QNumber then ChBox_Show_QNumber.Checked:= True;
if Record_On then ChBox_Record_On.Checked:= True;
if Can_Error_ReTest then ChBox_Can_Error_ReTest.Checked:= True;
if GetInfoLastQ then ChBox_GetInfoLastQ.Checked:= True;
if ShowTime then ChBox_ShowTime.Checked:=True;
if AddCommentOn then ChBox_AddCommentOn.Checked:=True;
if FullQuestion then ChBox_FullQuestion.Checked:=True;
if DiagrammOn then ChBox_DiagrammOn.Checked:=True;
if ShowWinInfo then ChBox_ShowWinInfo.Checked:=True;
if ShowWinStat then ChBox_ShowWinStat.Checked:=True

end;

{События для ЧекБокс'ов}
procedure ChBoxClick(Dummy: Pointer;Sender:pControl);
begin
 case sender.Tag of //Выбор одного из
   1: Show_QNumber := not Show_QNumber;
   2: begin  //Запись статистики в файл
   Record_On := not Record_On;
   if ChBox_Record_On.Checked = false then
                                           begin
       //Если запись в файл статистики отключена ->
       //то отключаем связанные действия
       // 1  Откл -> Добавление Комментария к ответу и запись в статистику
           AddCommentOn:= False;
           ChBox_AddCommentOn.Checked:= False; //снятие галочки!

       // 2  Откл -> Добавление Выдавать "текст вопроса" в файл статистики
           FullQuestion:= False;
           ChBox_FullQuestion.Checked:= False; //снятие галочки!
       // 3  Откл -> Показывать окно ввода персональных данных -> Запись в файл статистики
           ShowWinInfo:= False;
           ChBox_ShowWinInfo.Checked:= False; //снятие галочки!
       // Причина :  Иначе ошибка записи в файл статистики!
                                            end;

      end;
   3: Can_Error_ReTest := not Can_Error_ReTest;
   4: GetInfoLastQ := not GetInfoLastQ;
   5: begin
   ShowTime := not ShowTime;
   LabelTE.Visible:= not LabelTE.Visible;
      end;
   6: begin  //-> Добавление Комментария к ответу и запись в статистику
     AddCommentOn := not AddCommentOn;
     AddCommEditBox.Visible := not AddCommEditBox.Visible;
     if ChBox_Record_On.Checked = false then  begin  // Если запись статистики откл -> включаем её!
                                             Record_On:= True;
                                             ChBox_Record_On.Checked:= True;
                                                end;
      end;
   7: begin  //-> Добавление Выдавать "текст вопроса" в файл статистики
   FullQuestion := not FullQuestion;
        if ChBox_Record_On.Checked = false then  begin  // Если запись статистики откл -> включаем её!
                                             Record_On:= True;
                                             ChBox_Record_On.Checked:= True;
                                                end;
      end;
   8: DiagrammOn := not DiagrammOn;
   9: begin //-> Показывать окно ввода персональных данных -> Запись в файл статистики
   ShowWinInfo := not ShowWinInfo;
        if ChBox_Record_On.Checked = false then  begin  // Если запись статистики откл -> включаем её!
                                             Record_On:= True;
                                             ChBox_Record_On.Checked:= True;
                                                end;
      end;
   0: ShowWinStat := not ShowWinStat;
 end;{End of case}
end;
{Вызов события Close }
procedure Options_Close(DummySelf,Sender: PControl;  var Accept: Boolean);
begin
 if ShowWinInfo then
      begin
   WinInfoForm(nil,form);
   FormUserInfo.Show;
      end;
end;
end.
