unit Unit_PersonInfo;

interface
uses windows,messages,KOL;
 //Объявим чтобы видеть его из другого модуля
procedure WinInfoForm(DummySelf,Sender: PControl);{Вызов окна Опции}
//procedure WinInfo_Close(DummySelf,Sender: PControl;  var Accept: Boolean);
var FormUserInfo : PControl; //Форма Диаграмма
{События для КоммЭдитБокс'ов}
{Метод Click Clear}
procedure AllMouseDownClearText(dummy:pointer;Sender:PControl; var mouse:TMouseEventData);
{Метод если мы ничего не записали и уходим из контрола}
procedure AllEditBoxLeave(Dummy: Pointer;Sender:pControl);
{Вызов события по нажатию кноки Готово}
procedure Btn_OK_User_Info_click(dummy:pointer;Sender:PControl; var mouse:TMouseEventData);
 {Метод введен текст}
Procedure EditHasNewText(DummySelf,Sender: PObj; Key: Longint; Shift: DWORD );
 {Метод Key Clear}
Procedure EditOnKeyDown(DummySelf,Sender: PObj; Key: Longint; Shift: DWORD );
{Метод Press Enter}
procedure Btn_OK_User_Info_Entr(DummySelf, Sender: PControl; var Key: Char;Shift: DWORD);
{Метод AddCommEditBoxGo}  //Перемещаемся кнопкой Enter
procedure AddCommEditBox1Go(DummySelf, Sender: PControl ; var Key: Char;  Shift: DWORD);
{Функция для AddCommEditBox}
function EditMessage(Sender: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
implementation

uses Unit_Act,
Unit_Records;
var AddCommEditBox:PControl; //Первое поле для записи
    AddCommEditBox2:PControl; //Второе поле для записи
    AddCommEditBox3:PControl; //Третье поле для записи
    AddCommEditBox4:PControl; //Поле комментария

Btn_OK_User_Info :Pcontrol; //Кнопка Ок завершает сбор информации и
//Вызывает метод передачи и записи данных

{Вызов окна Формы Информация}
procedure WinInfoForm(DummySelf,Sender: PControl);
var
Top_pnl: PControl; //Панель отступ от верхнего края
//lbl_greeting: PControl; //Надпись Добро пожаловать
Second_pnl: PControl; //Вторая панель разделитель
Third_pnl: PControl; // Третья панель разделитель
Fourth_pnl: PControl; //Четвертая панель разделитель
Bottom_pnl: PControl; //Панель отсуп от нижнего края

begin //Msgok('Options')
FormUserInfo:= NewForm(Form,'  Добро пожаловать, в Тестировщик :) ').
SetClientSize( 480,220  ).CenterOnParent.Tabulate;//setposition(100,100)
   FormUserInfo.Font.FontName := 'MS Sans Serif';
   FormUserInfo.Font.FontCharset := 0;

 //  lbl_greeting:= NewLabel( FormUserInfo ,' Добро пожаловать, в Тестировщик :) ' ).AutoSize(True).PlaceRight;
Top_pnl:= NewPanel( FormUserInfo, esNone ).SetClientSize(0,20).SetAlign(caTop);
Top_pnl.Caption:='';
    AddCommEditBox:= NewEditBox( FormUserInfo, [eomultiline,eoWantReturn,eoNoHScroll, eoNoVScroll] ).
    SetAlign(caTop);//SetPosition( 68, 18).SetSize( 282,40);
    AddCommEditBox.SetClientSize(0,20);
    AddCommEditBox.Text:= ' (Ник) Имя, Фамилия, Отчество, Возраст, Пол ';
    AddCommEditBox.Font.Color:=clGray;
    AddCommEditBox.Color := clWindow;
    AddCommEditBox.Tag:= 1;

//*********************************EV
AddCommEditBox.OnMouseDown:= TOnMouse(MakeMethod(nil, @AllMouseDownClearText));
AddCommEditBox.OnMouseLeave:=TonEvent(MakeMethod(nil,@AllEditBoxLeave));
AddCommEditBox.OnKeyUp:= TOnkey(MakeMethod(nil,@EditHasNewText));
AddCommEditBox.OnKeyDown:= TOnkey(MakeMethod(nil,@EditOnKeyDown));
AddCommEditBox.OnChar:=TOnChar(MakeMethod(nil,@AddCommEditBox1Go));
AddCommEditBox.OnMessage := TOnMessage(MakeMethod(AddCommEditBox, @EditMessage));

Second_pnl:= NewPanel( FormUserInfo, esNone ).SetClientSize(0,20).SetAlign(caTop);
Second_pnl.Caption:='';

AddCommEditBox2:= NewEditBox( FormUserInfo, [eomultiline,eoWantReturn,eoNoHScroll, eoNoVScroll] ).
    SetAlign(caTop);
    AddCommEditBox2.SetClientSize(0,20);
    AddCommEditBox2.Text:= ' Учащийся, Студент, Специалист, Ваш вариант ';
    AddCommEditBox2.Font.Color:=clGray;
    AddCommEditBox2.Color := clWindow;
    AddCommEditBox2.Tag:= 2;

//*********************************EV
AddCommEditBox2.OnMouseDown:= TOnMouse(MakeMethod(nil, @AllMouseDownClearText));
AddCommEditBox2.OnMouseLeave:=TonEvent(MakeMethod(nil,@AllEditBoxLeave));
AddCommEditBox2.OnKeyUp:= TOnkey(MakeMethod(nil,@EditHasNewText));
AddCommEditBox2.OnKeyDown:= TOnkey(MakeMethod(nil,@EditOnKeyDown));
AddCommEditBox2.OnChar:=TOnChar(MakeMethod(nil,@AddCommEditBox1Go));
AddCommEditBox2.OnMessage := TOnMessage(MakeMethod(AddCommEditBox2, @EditMessage));

Third_pnl:= NewPanel( FormUserInfo, esNone ).SetClientSize(0,20).SetAlign(caTop);
Third_pnl.Caption:='';

AddCommEditBox3:= NewEditBox( FormUserInfo, [eomultiline,eoWantReturn,eoNoHScroll, eoNoVScroll] ).
    SetAlign(caTop);
    AddCommEditBox3.SetClientSize(0,20);
    AddCommEditBox3.Text:= ' Преподаватель: Имя, Фамилия, Отчество ';
    AddCommEditBox3.Font.Color:=clGray;
    AddCommEditBox3.Color := clWindow;
    AddCommEditBox3.Tag := 3;

//*********************************EV
AddCommEditBox3.OnMouseDown:= TOnMouse(MakeMethod(nil, @AllMouseDownClearText));
AddCommEditBox3.OnMouseLeave:=TonEvent(MakeMethod(nil,@AllEditBoxLeave));
AddCommEditBox3.OnKeyUp:= TOnkey(MakeMethod(nil,@EditHasNewText));
AddCommEditBox3.OnKeyDown:= TOnkey(MakeMethod(nil,@EditOnKeyDown));
AddCommEditBox3.OnChar:=TOnChar(MakeMethod(nil,@AddCommEditBox1Go));
AddCommEditBox3.OnMessage := TOnMessage(MakeMethod(AddCommEditBox3, @EditMessage));

Fourth_pnl:= NewPanel( FormUserInfo, esNone ).SetClientSize(0,20).SetAlign(caTop);
Fourth_pnl.Caption:='';

AddCommEditBox4:= NewEditBox( FormUserInfo, [eomultiline,eoWantReturn,eoNoHScroll, eoNoVScroll] ).
    SetAlign(caTop);
    AddCommEditBox4.SetClientSize(0,20);
    AddCommEditBox4.Text:= 'Мой комментарий.';
    AddCommEditBox4.Font.Color:=clGray;
    AddCommEditBox4.Color := clWindow;
    AddCommEditBox4.Tag := 4;

//*********************************EV
AddCommEditBox4.OnMouseDown:= TOnMouse(MakeMethod(nil, @AllMouseDownClearText));
AddCommEditBox4.OnMouseLeave:=TonEvent(MakeMethod(nil,@AllEditBoxLeave));
AddCommEditBox4.OnKeyUp:= TOnkey(MakeMethod(nil,@EditHasNewText));
AddCommEditBox4.OnKeyDown:= TOnkey(MakeMethod(nil,@EditOnKeyDown));
AddCommEditBox4.OnChar:=TOnChar(MakeMethod(nil,@AddCommEditBox1Go));
AddCommEditBox4.OnMessage := TOnMessage(MakeMethod(AddCommEditBox4, @EditMessage));

Bottom_pnl:= NewPanel( FormUserInfo, esNone ).SetClientSize(0,24).SetAlign(caTop);
Bottom_pnl.Caption:='';

{$R Form1_Bt_Q_Ready.res}
Btn_OK_User_Info:= NewBitBtn( Bottom_pnl, 'Готово' , [  ],
 glyphLeft, LoadBmp( hInstance, 'BT_READY_BITMAP', Bottom_pnl), 1 ).SetSize( 80,22 ).CenterOnParent;

Btn_OK_User_Info.TextShiftX := 1;
Btn_OK_User_Info.TextShiftY := 1;
//*********************************EV
Btn_OK_User_Info.OnClick:=TonEvent(MakeMethod(nil,@Btn_OK_User_Info_click));
Btn_OK_User_Info.OnKeyDown:=Tonkey(MakeMethod(nil,@Btn_OK_User_Info_Entr));

//FormUserInfo.OnClose:=TOnEventAccept(MakeMethod(nil,@WinInfo_Close));

//GroupBox:= NewGroupBox(FormUserInfo, ' Добро пожаловать, в Тестировщик :) ' ).setalign( caBottom ).PlaceUnder;
//:= NewLabel( GroupBox ,'' ).AutoSize(True).PlaceRight;
//lbl_Errors.Caption:= '-> Ошибки ';
//pnl_Errors := NewPanel( GroupBox, esNone ).SetSize(60, 25 ).PlaceRight;

end;

{Метод AddCommEditBoxGo} //Перемещаемся кнопкой Enter
procedure AddCommEditBox1Go(DummySelf, Sender: PControl ; var Key: Char;  Shift: DWORD);
begin
//if key=#44 then key:=#46;//если , то .
if key=#13 then begin
 keybd_event(9,0,0,0);
keybd_event(9,0,KEYEVENTF_KEYUP,0);
                end;
end;

{Функция для AddCommEditBox}
function EditMessage(Sender: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
begin
 Result := False;
 if Msg.message = WM_SETFOCUS then
                        begin
   Sender.SelStart := 0;
   Sender.SelLength := -1;
                        end;
end;

{События для КоммЭдитБокс'ов}
{Метод если мы ничего не записали и уходим из контрола}
procedure AllEditBoxLeave(Dummy: Pointer;Sender:pControl);
begin
 case sender.Tag of //Выбор одного из
   1: if AddCommEditBox.Text = ''
                              then
                              begin
AddCommEditBox.Text:= ' (Ник) Имя, Фамилия, Отчество, Возраст, Пол ';
AddCommEditBox.Font.Color:=clGray;
//AddCommEditBox.Font.FontStyle:=[]
                              end;

   2: if AddCommEditBox2.Text = ''
                              then
                              begin
AddCommEditBox2.Text:= ' Учащийся, Студент, Специалист, Ваш вариант ';
AddCommEditBox2.Font.Color:=clGray;
                              end;
   3: if AddCommEditBox3.Text = ''
                              then
                              begin
AddCommEditBox3.Text:= ' Преподаватель: Имя, Фамилия, Отчество ';
AddCommEditBox3.Font.Color:=clGray;
                              end;

   4: if AddCommEditBox4.Text = ''
                              then
                              begin
AddCommEditBox4.Text:= 'Мой комментарий.';
AddCommEditBox4.Font.Color:=clGray
                              end;

 end;{End of case}
end;

 {Метод введен текст}
Procedure EditHasNewText(DummySelf,Sender: PObj; Key: Longint; Shift: DWORD );
begin
 pcontrol(sender).Font.Color:=clblack;
 pcontrol(sender).Font.FontStyle:=[fsbold];
end;

 {Метод Key Clear}  {Метод если не кликать мышью}
Procedure EditOnKeyDown(DummySelf,Sender: PObj; Key: Longint; Shift: DWORD );
begin
Case sender.Tag of //Выбор одного из
  1:if AddCommEditBox.Text = ' (Ник) Имя, Фамилия, Отчество, Возраст, Пол '
                            then
                AddCommEditBox.Clear;

  2:if AddCommEditBox2.Text = ' Учащийся, Студент, Специалист, Ваш вариант '
                             then
                AddCommEditBox2.Clear;

  3:if AddCommEditBox3.Text = ' Преподаватель: Имя, Фамилия, Отчество '
                             then
                AddCommEditBox3.Clear;

  4:if AddCommEditBox4.Text = 'Мой комментарий.'
                             then
                AddCommEditBox4.Clear

 end;//End of Case
end;

{Метод Click Clear}
procedure AllMouseDownClearText(dummy:pointer;Sender:PControl; var mouse:TMouseEventData);
begin
case sender.Tag of //Выбор одного из
  1:if AddCommEditBox.Text = ' (Ник) Имя, Фамилия, Отчество, Возраст, Пол '
                            then
                AddCommEditBox.Clear;

  2:if AddCommEditBox2.Text = ' Учащийся, Студент, Специалист, Ваш вариант '
                             then
                AddCommEditBox2.Clear;

  3:if AddCommEditBox3.Text = ' Преподаватель: Имя, Фамилия, Отчество '
                             then
                AddCommEditBox3.Clear;

  4:if AddCommEditBox4.Text = 'Мой комментарий.'
                             then
                AddCommEditBox4.Clear

end;{End of case}

end;

{Вызов события по нажатию кноки Готово}
procedure Btn_OK_User_Info_click(dummy:pointer;Sender:PControl; var mouse:TMouseEventData);

begin
StrInfo:=''; //Сброс перед использованем
//check AddCommEditBox.text -> Первое поле для записи

if AddCommEditBox.Text <> ' (Ник) Имя, Фамилия, Отчество, Возраст, Пол '
                      then
 StrInfo:=  StrInfo + AddCommEditBox.Text+#13#10;

//check AddCommEditBox2.text -> Второе поле для записи

if AddCommEditBox2.Text <> ' Учащийся, Студент, Специалист, Ваш вариант '
                      then
 StrInfo:=  StrInfo + AddCommEditBox2.Text+#13#10;

//check AddCommEditBox3.text -> Третье поле для записи

if AddCommEditBox3.Text <> ' Преподаватель: Имя, Фамилия, Отчество '
                      then
 StrInfo:=  StrInfo + AddCommEditBox3.Text+#13#10;

 //check My Comment = ) text -> Поле комментария

if AddCommEditBox4.Text <> 'Мой комментарий.'
                      then
 StrInfo:=  StrInfo + AddCommEditBox4.Text+#13#10;

FormUserInfo.Close;
Applet.Show;
end;

{Метод Press Enter}
procedure Btn_OK_User_Info_Entr(DummySelf, Sender: PControl; var Key: Char;Shift: DWORD);

begin
if key=#13 then begin
Btn_OK_User_Info.Perform(WM_LBUTTONDOWN,0,0);
Btn_OK_User_Info.Perform(WM_LBUTTONUP,0,0)
end;
end;

//{Вызов события Close }
//procedure WinInfo_Close(DummySelf,Sender: PControl;  var Accept: Boolean);
//begin
// Form.Close
//end;

end.
