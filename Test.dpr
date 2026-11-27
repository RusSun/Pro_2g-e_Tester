program Test;
 //created by Gallamov Ruslan copyright ® 18.01.2020
uses
  {FastMM4,}
  Windows,
  KOL,
  _Hint,//Для всплывающих подсказок
  Unit_Act in 'Unit_Act.pas',
  Unit_Params in 'Unit_Params.pas',
  Unit_PersonInfo in 'Unit_PersonInfo.pas',
  Unit_AnalizePoints in 'Unit_AnalizePoints.pas';

{$R test.res}
{$R StyleXP.RES}
{$R ImageListFour.res}
var  Form1_Main: PForm1;//Главная форма

//{$Include FastMM4Options.inc}
//{$define FullDebugMode}
//{$define LogMemoryLeakDetailToFile}

//===Для подсказок ===
hHint : HWND; // Хэндл для -> //Кнопка для Вызова 'Формы вывод результата теста'
hHint1 : HWND; // Хэндл для -> //Кнопка 'Опции Контролов'
hHint2 : HWND; // Хэндл для -> //Кнопка 'Следующий вопрос'
//====================
{Метод формы изменние размера}
procedure formResize(Sender: PObj);
begin

QuestionCheckList.Height:=form.Height-184;
NextButton.Top := form.ClientHeight - 26;
NextButton.Left :=  form.ClientWidth - 98;

OptBtn.Left:= form.ClientWidth - 32;//OptBtn left 693

end;

{Вызов главной формы}
procedure NewForm1(var Result: PForm1; AParent: PControl);
var
I:integer;  //итератор для цикла размещения цветовой "строки состояния"
P:integer;  //для позиционирования "элементов" цветовой "строки состояния"
begin
 New(Result, Create);
 with Result^ do
 begin
   Form := NewForm(AParent,'Программа тестирования');
   Form.Add2AutoFree(Result);
   Applet := Form;
   Form.SetClientSize( 725,494 ).CenterOnParent;
   //Form.Font.FontName := 'MS Sans Serif';
   //Form.Font.FontCharset := 0;
   form.OnResize:=TonEvent(MakeMethod(nil,@formResize));
   form.OnDestroy:=TOnevent(MakeMethod(nil,@FormDestroy));
   form.OnClose:=TOnEventAccept(MakeMethod(nil,@Form_Close));
   //form.OnShow:=TOnevent(MakeMethod(nil,@FormShow));

   Toolbar1 := NewToolbar( form, caTop, [tboFlat],
    LoadMappedBitmapEx( form, hInstance, 'IMAGELIST4',
     [ clFuchsia, Color2RGB( clBtnFace ) ] ), [ '', '', '', '-', '' ],
      [ 0, 1, 2, -2, 3 ] ).SetAlign ( caTop );
     Toolbar1.SetSize(0,30);
    toolbar1.TBButtonEnabled[1 ]:=false;  //Отключение кнопки Запуска без
                                          //открытия файла теста
    ToolbarSetTooltips( toolbar1,toolbar1.TBIndex2Item( 0 ),
[ 'Открыть тест',
  'Запустить тест',
  'Параметры теста',
  '',
  'Выход'
] );

    LabelTE:= NewLabel( form, '00:00:00' ).autosize(true).SetPosition(120,8); //AutoSize(true).PlaceRight;
    LabelTE.Font.FontHeight:=-21;
    LabelTE.Font.Color:= clgreen;
    LabelTE.BringToFront;
    LabelTE.Visible:=False;
    //Кнопка для Вызова 'Формы вывод результата теста'
   // FormAnalizePointsBtn:=NewButton(Form, 'Форма вывод результата теста' ).PlaceDown.AutoSize(true);
   // FormAnalizePointsBtn.Top:=35;
   // FormAnalizePointsBtn.OnClick:= TonEvent(MakeMethod(nil,@FormAnalizePoints_BtnClick));
   // FormAnalizePointsBtn.visible:= False;
   // hHint  := CreateHint (0, 0, '');
   // Hint(hHint, FormAnalizePointsBtn,'Временная кнопка для вызова Формы'+#13+
    //      ' -> "Вывод результата теста"');


    //form.Caption:= int2str(FormAnalizePointsBtn.Top);
    //FormAnalizePointsBtn.Top:=15;
     {$R Form1_OptBtn.res}
    OptBtn:= NewBitBtn( Toolbar1, '', [ bboNoBorder, bboNoCaption ],
     glyphTop, LoadBmp( hInstance, 'OPTBTN_BITMAP', Result ), 0 ).
    SetAlign ( caRight );//.LikeSpeedButton;
    OptBtn.TextShiftX := 1;
    OptBtn.TextShiftY := 1;
    //toolbar1.Color:=clLime;

    //OptBtn.OnClick := Result.OptBtnClick;
    OptBtn.OnClick:=TonEvent(MakeMethod(nil,@WinOptConrols_BtnClick));

    hHint1  := CreateHint (0, 0, '');
    Hint(hHint, OptBtn,'Кнопка "Опции Контролов"');

    PB:=NewPaintbox(Form).SetClientSize(725,272).SetAlign ( caTop );
    //PB.BoundsRect:=MakeRect(0,10,300,210);
    PB.OnPaint:= TOnPaint( MakeMethod( nil, @Unit_Act.DoPaint));
    PB.Visible:= False;
    CreateForm;
    Paneltop := NewPanel( Form, esNone ).SetAlign ( caTop ).SetSize( 0, 25 );
    p := 0;
    for I := 1 to 20 do begin
        B[I] := NewPanel(Paneltop,esLowered ).SetPosition( p,5 ).SetSize( 15, 15 );
        B[I].Visible := false;
        p := p + 15;
                    end;

    QuestionLabel := NewLabel( Form, '' ).SetPosition( 8, 38 ).SetSize( 505, 63 ).MakeWordWrap;
//     Msgok(
//     QuestionLabel.Font.FontName+#10#13+
//     'QuestionLabel.Font.FontWidth '+int2str(QuestionLabel.Font.FontHeight)
//     );
    //QuestionLabel.Color := clGray;
    QuestionLabel.SetAlign ( caTop ); //lvsDetailNoHeader
    Splitter:= NewSplitter( Form, 10,10 );
    Splitter.Color:=clBtnFace;
    
    QuestionCheckList:=newlistview(Form,lvsList,[lvoNoScroll,lvoMultiselect,lvoCheckBoxes],nil,nil,nil).PlaceUnder.SetAlign ( caTop );//SetSize(505,137);//SetPosition(8,112)
    //QuestionCheckList.WordWrap:=true;
    //QuestionCheckList.RightClick:=true;
    //QuestionCheckList.OnClick:=TonEvent(MakeMethod(nil,@QuestionCheckListClick));
    QuestionCheckList.OnMouseDown := TOnMouse(MakeMethod(nil, @QuestionCheckList_MouseDown));

    NextButton := NewButton(Form, ' Дальше >>' ).SetPosition(424, 264 ).SetSize(86,25);//PlaceUnder
    NextButton.Enabled:=false;
    NextButton.BringToFront;
    NextButton.OnClick:=TonEvent(MakeMethod(nil,@NextButtonClick));

    hHint2  := CreateHint (0, 0, '');
    Hint(hHint2, NextButton,'Кнопка "Следующий вопрос"');


    ErrorsButton := NewButton(Form, 'Пройти ошибки теста').SetSize(166,25).SetPosition(354, 324 );//.PlaceDown;//.PlaceUnder;
    ErrorsButton.BringToFront; //.centeronparent;
    ErrorsButton.Visible:= False;
    ErrorsButton.OnMouseDown := TOnMouse(MakeMethod(nil,@ErrorsButton_MouseDown));

    AddCommEditBox:= NewEditBox( form, [eomultiline,eoWantReturn,eoNoHScroll, eoNoVScroll] ).SetAlign(caBottom);//SetPosition( 68, 18).SetSize( 282,40);
    AddCommEditBox.SetClientSize(0,20);
    AddCommEditBox.Text:= 'Мой комментарий к вопросу.';
    AddCommEditBox.Font.Color:=clGray;
    AddCommEditBox.Color := clWindow;
    AddCommEditBox.Visible:= False;
    
    AddCommEditBox.OnMouseDown:= TOnMouse(MakeMethod(nil, @MouseDownClearText));
    AddCommEditBox.OnMouseLeave:=TonEvent(MakeMethod(nil,@EditBoxLeave));
    if AddCommentOn then AddCommEditBox.visible:=true; //Если включен режим добавления комментария
    if ShowWinInfo then WinInfoForm(nil,form);
    //FormUserInfo.Show;

    //Colored_Controls;  //"тест размерности"
    //область для работы
    Toolbar1.OnTBClick:=TonEvent(MakeMethod(nil,@DoWorkToolBar));
  //  Toolbar1.OnMouseDblClk:= TOnMouse(MakeMethod(nil,@Toolbar1MouseDblClk));
  //  toolbar1.TBButtonVisible[2]:=False;
 end;
end;
begin
Applet:=NewForm(Applet,'');
NewForm1(Form1_Main, nil);
Run(Applet);
 // Run(Form1.Form);
end.