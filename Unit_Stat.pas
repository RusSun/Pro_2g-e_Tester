unit Unit_Stat;

interface
uses windows,KOL;
 //Объявим чтобы видеть его из другого модуля
procedure WinFormStat(DummySelf,Sender: PControl);{Вызов окна статистики}
var FormStat : PControl; //Форма Просмотра статистики

implementation
uses Unit_Act;
//Для функции
function file2str(filename:string):string;
var f2: textfile;
    s2:string;
begin
   result := '';
   if fileexists(filename) then
   begin
       S2:='';
       assignfile(f2,filename);
       reset(f2);
       while not eof(f2) do
       begin
          readln(f2,s2);
          result := result + s2+#13#10;//с переходом на другую строку
       end;
       closefile(f2);
     end;
End;

 procedure WinFormStat(DummySelf,Sender: PControl);
 var Memo : PControl; //Область для текста
// var f:textfile;
 begin // StatisticNameFile
   FormStat:= NewForm(Form,'');
//   SetClientSize(GetSystemMetrics(SM_CXSCREEN),
//   GetSystemMetrics(SM_CXSCREEN));
   FormStat.Font.FontName:='Times New Roman';
   FormStat.Font.FontHeight:=-16;
   FormStat.Margin:=0;
   FormStat.CenterOnParent;
   // FormStat.Color:=$0000FF;      // Задаем цвет окна (в данном случае Красный)
   // FormStat.HasCaption := False; // Скрываем заголовок окна
   // FormStat.HasBorder := False;  // Скрываем бордюр

  // ShowWindow(FormStat.Handle,SW_SHOWMAXIMIZED ); //SW_MAXIMIZE

   Memo := NewEditBox( FormStat, [ eoMultiline,eoNoHScroll,eoReadonly ] ).SetAlign ( caClient );
   Memo.WordWrap:=True;
   if FileExists(StatisticNameFile) then
   begin
   Memo.Text:=file2str(StatisticNameFile);
   //FormStat.Caption:= FileShortPath(StatisticNameFile);
   end;
 end; //eoNoHScroll
end.
