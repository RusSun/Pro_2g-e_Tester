unit Unit_Records;
//Методы записи в файл статистики
interface
uses KOL;
 //Объявим чтобы видеть его из другого модуля
procedure NewRecord;{Метод добавления Первичная запись}
procedure AddRecord(Question,Ok: string );{Метод добавления вопроса + комментария }
procedure FinRecord; {Метод конечная запись}
procedure NotFinRecord;{Не закончен, но завершен}
procedure AddRecordInfo(InfoStr: string ); {Метод Инфо}

implementation
uses Unit_Act,
Unit_Params,
Unit_Timer;
{Метод добавления Первичной записи в файл статистики}
procedure NewRecord;
var
My_Record : PStrList;
strBiletName: String;
begin
My_Record:= NewStrList;
My_Record.Add(form.Caption+PChar(' дата '+Date2StrFmt('dd.MM.yyyy',Date)+' время '+Time2StrFmt('HH:mm:ss', Now) ) );
//+BiletName
strBiletName:= BiletName;
StatisticNameFile:=GetStartDir+Parse(strBiletName,#32)+' Statis'+Date2StrFmt('dd.MM.yyyy',Date)+Time2StrFmt('_HH_mm', Now)+'.txt';

My_Record.SaveToFile(StatisticNameFile);
My_Record.Free
end;

{Метод добавления Инфо}
procedure AddRecordInfo(InfoStr: string );
var f:textfile;
begin
if InfoStr = '' then Exit; //Нет строки и нечего записывать =)

if FileExists(StatisticNameFile)
 then
 Begin
    assign(f,StatisticNameFile);
   append(f);
   Writeln(f,InfoStr);
  close(f)
 end
 else msgok('Опс нет файла')
end;

{Метод добавления вопроса + комментария }
procedure AddRecord(Question,Ok: string );
var f:textfile;
StrofAddComm:String;
begin
StrofAddComm:='Мой комментарий к вопросу.';
 //StrFilePuth:=PChar(GetStartDir+'Statis'+Date2StrFmt('dd.MM.yyyy',Date)+'.txt');
 if FileExists(StatisticNameFile)
 then
 Begin
    assign(f,StatisticNameFile);
   append(f);
   Writeln(f,Question+' '+Ok);
     if AddCommentOn then //Если включен режим добавления комментария
                         Begin
                         //Если есть комментарий добавим его
                       //  AddCommentRecord(Comment: string );
                         if trim(AddCommEditBox.Text) <> StrofAddComm then
                         Writeln(f,' " '+AddCommEditBox.Text+' " <-  Comm');
                         AddCommEditBox.Text:=StrofAddComm; //Сброс комментария для следующего вопроса
                         End;
   close(f)
 end
 else msgok('Опс нет файла')
end;

{Метод конечной записи в файл статистики}
procedure FinRecord;
var f:textfile;
begin
 //StrFilePuth:=PChar(GetStartDir+'Statis'+Date2StrFmt('dd.MM.yyyy',Date)+'.txt');
 if FileExists(StatisticNameFile)
 then
 Begin
    assign(f,StatisticNameFile);
   append(f);
   Writeln(f,'');
   Writeln(f,'Тест закончен в '+PChar(' время '+Time2StrFmt('HH:mm:ss', Now)+
   ' ( '+TimeElapsedStr+' ) '+' кол-во ошибок = '+Int2Str(FalseNumber) ));
   close(f)
 end
 else msgok('Опс нет файла')
end;

{Метод вызывается в случае когда тест не закончен, но завершен}
procedure NotFinRecord;
var f:textfile;
begin
 //StrFilePuth:=PChar(GetStartDir+'Statis'+Date2StrFmt('dd.MM.yyyy',Date)+'.txt');
 if FileExists(StatisticNameFile)
 then
 Begin
    assign(f,StatisticNameFile);
   append(f);
   Writeln(f,'');
   Writeln(f,'Тест завершен в '+PChar(' время '+Time2StrFmt('HH:mm:ss', Now)+
   ' ( '+TimeElapsedStr+' ) '+
   ' кол-во ошибок = '+Int2Str(FalseNumber) ));
   close(f)
 end
 else  exit
 //msgok('Опс нет файла')
end;

{Метод записи вопроса и его состояния "верно/не верно"}
(*procedure AddRecord(Question,Ok: string );
var f:textfile;
begin
 //StrFilePuth:=PChar(GetStartDir+'Statis'+Date2StrFmt('dd.MM.yyyy',Date)+'.txt');
 if FileExists(StatisticNameFile)
 then
 Begin
    assign(f,StatisticNameFile);
   append(f);
   Writeln(f,Question+' '+Ok);
   close(f)
 end
 else msgok('Опс нет файла')
end;*)
end.
