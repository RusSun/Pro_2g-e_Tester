unit Unit_AnalizePoints;

interface
uses windows,KOL;

 //Объявим чтобы видеть его из другого модуля
{Вызов окна результаты теста}
procedure WinAnalizePointsForm(DummySelf,Sender: PControl);
//событие для кнопки 'Сохранение в тхт'
procedure BtnSavetoTXTfile_Click(Sender: PObj);
 {Событие закрытие формы}
procedure BtnCloseClick(Sender: PObj);

var FormAnalizePoints : PControl; //Форма результаты теста
    Memo1:Pcontrol; //Поле вывода 'Описание: результата теста'
                  //Только для чтения
    Button1:Pcontrol; //Кнопка -> 'Сохранить в файле тхт'
    Button2:Pcontrol; //Кнопка -> 'Закрыть'

implementation
uses Unit_Act;
 

{Вызов окна вывод результата теста}
procedure WinAnalizePointsForm(DummySelf,Sender: PControl);
var
  Panel1: PControl; //Панель размечение Надписи 'Результаты теста'
  Label1: PControl; //Надпись 'Результаты теста'

  Panel2: PControl; //Панель размещение Кнопки 'Сохранить' и 'Закрыть'

  Panel3:Pcontrol;//Панель размещение Надписи 'Сумма баллов ='
  Label2: PControl; //Надпись 'Сумма баллов ='

begin // Msgok('Bright Idea =)')
FormAnalizePoints := NewForm( Form, '' ).
SetClientSize( 687, 532 ).CenterOnParent.Tabulate;

   // Applet :=  Form;
  //Form.Add2AutoFree( form );

  FormAnalizePoints.Font.FontHeight := -16;
  FormAnalizePoints.Font.FontName := 'TimesNewRoman';
  FormAnalizePoints.SimpleStatusText := ' ';
  
  Panel1 := NewPanel( FormAnalizePoints, esRaised ).SetAlign ( caTop ).SetSize( 0, 80 );

  Label1 := NewLabel( Panel1, 'Результаты теста' ).SetPosition( 85, 21 ).AutoSize( TRUE );
  Label1.Font.Color := TColor(clBlue);
  Label1.Font.FontHeight := -32;

  Panel2 := NewPanel( FormAnalizePoints, esRaised ).SetAlign ( caBottom ).SetSize( 0, 60 );

  Button1 := NewButton( Panel2, 'Сохранить в файле тхт' ).SetPosition( 142, 12 ).SetSize( 185, 30 );
  Button2 := NewButton( Panel2, 'Закрыть' ).SetPosition( 357, 12 ).SetSize( 105, 30 );

  Panel3 := NewPanel( FormAnalizePoints, esRaised ).SetAlign ( caBottom ).SetSize( 0, 80 );

  Label2 := NewLabel( Panel3, 'Сумма баллов =' ).SetPosition( 85, 13 ).AutoSize( TRUE );
  Label2.Font.Color := TColor(clBlue);
  Label2.Font.FontHeight := -32;

  Memo1 := NewEditBox( FormAnalizePoints, [ eoMultiline, eoNoHScroll, eoReadonly ] ).SetAlign ( caClient );
  Memo1.Text := 'Описание :'+#13+#10;
  Memo1.Color := TColor(clWindow);

//Привязка события 'Сохранение в тхт' к кнопке 'Сохранение в тхт'
Button1.OnClick:= TonEvent(MakeMethod(nil,@BtnSavetoTXTfile_Click));
//Привязка события  'Закрытие формы резутаты теста' к кнопке Закрыть
Button2.OnClick := TonEvent(MakeMethod(nil,@BtnCloseClick));
end;

{Вызов события -> 'Сохранение в тхт'}
procedure BtnSavetoTXTfile_Click(Sender: PObj);
var
SL: PStrList;//Для сохранения текста
OpenSaveDialog1:pOpenSaveDialog;//Диалог сохранения в тхт файл
begin
SL := NewStrList;

OpenSaveDialog1:=NewOpenSaveDialog('',GetStartDir,[]) ;
 OpenSaveDialog1.title := 'Сохранить в формате txt';
 OpenSaveDialog1.Filter := '*.txt|*.txt|все|*.*';
 //OpenSaveDialog1.filename := 'Файл';
 OpenSaveDialog1.OpenDialog := false;

  if OpenSaveDialog1.Execute then
                                    begin
 SL.Text := Memo1.Text;

 SL.SaveToFile( OpenSaveDialog1.filename );

 FormAnalizePoints.StatusText[0]:= OpenSaveDialog1.filename;

                                    end;
 SL.Free;
end;
 {Событие закрытие формы}
procedure BtnCloseClick(Sender: PObj);
begin
FormAnalizePoints.Close
end;
end.
