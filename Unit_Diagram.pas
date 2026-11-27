unit Unit_Diagram;

interface
uses windows,KOL,messages;
 //Объявим чтобы видеть его из другого модуля
procedure WinDiagram(DummySelf,Sender: Pobj);{Вызов окна Опции}
//procedure FormDiagram_Close(DummySelf,Sender: PControl;  var Accept: Boolean);
var FormDiagram : PControl; //Форма Диаграмма
implementation
uses Unit_Act;
var
Bm:pBitMap; // Для отображения Диаграммы )
lbl_Errors: PControl; //Надпись -> "Ошибки"
lbl_Allok: PControl; //Надпись -> "Верные ответы"
lbl_Smallok: PControl; //Надпись -> "Неполные ответы"
lbl_Diff: PControl; //Надпись -> "Смешанные ответы"
lbl_None: PControl; //Надпись -> "Пропущенные ответы"

{Метод рисования круговой диаграммы}
procedure Gistogramma;

var a: array[1..5] of integer; //массив значений
    b:array[1..5] of double;  //массив углов в нарастающей
    c:array[1..5] of TColor; //массив цыетов для секторов
    NotNullParam:Integer;//Счетчик не нулевых Параметров
    p:array[1..5] of TPoint; //массив точек
    r,sum,i:integer;//радиус, сумма, счетчик
    x0,y0:integer;//центр диаграммы

begin
//IntNone     //Счётчик "Пропущенные ответы"
//IntAllOk    //Счётчик "Правильных ответов"
//IntSmallOk  //Счётчик "Неполные ответы"
//IntDiff     //Счётчик "Смешанные ответы"
//IntErrors   //Счётчик "Ошибки"
//Блок анализа счётчиков ответов
 NotNullParam := 0;
if IntErrors>0 then
                begin
                inc( NotNullParam);
                c[NotNullParam]:=  clred;

                lbl_Errors.Caption:=lbl_Errors.Caption+Int2Str(IntErrors);
                a[NotNullParam]:=IntErrors // clred;

                end;

if IntAllOk>0 then
                begin
                inc( NotNullParam);
                c[NotNullParam]:=  clgreen;

                lbl_Allok.Caption:=lbl_Allok.Caption+Int2Str(IntAllOk);
                a[NotNullParam]:=IntAllOk //clgreen;

                end;


if IntSmallOk>0 then
                begin
                inc( NotNullParam);
                c[NotNullParam]:=  clyellow;

                lbl_Smallok.Caption:=lbl_Smallok.Caption+Int2Str(IntSmallOk);
                a[NotNullParam]:=IntSmallOk //clyellow;

                end;
if IntDiff>0 then
                begin
                inc( NotNullParam);
                c[NotNullParam]:=  clOrange;

                lbl_Diff.Caption:=lbl_Diff.Caption+Int2Str(IntDiff);
                a[NotNullParam]:=IntDiff //clOrange

                end;
if IntNone>0 then
                begin
                inc( NotNullParam);
                c[NotNullParam]:=  clGray;

                lbl_None.Caption:=lbl_None.Caption+Int2Str(IntNone);
                a[NotNullParam]:=IntNone //clGray;

                end;
sum:=0;
for i:=1 to NotNullParam do sum:=sum+a[i];
FormDiagram.StatusText[0]:= 'Сумма = ' + Int2Str( sum );
FormDiagram.StatusText[1]:= 'Не нулевые '+ Int2Str ( NotNullParam );
//if sum = 0 then exit;
if sum = 0 then begin
with FormDiagram.Canvas^ do
                      begin
        brush.color:=clWhite;
        Pie(111,45,333,267,333,156,333,156);
        //textout(111,45, 'Ноль ответов')
                      end;

lbl_Errors.Caption:=lbl_Errors.Caption+Int2Str(IntErrors);
lbl_Allok.Caption:=lbl_Allok.Caption+Int2Str(IntAllOk);
lbl_Smallok.Caption:=lbl_Smallok.Caption+Int2Str(IntSmallOk);
lbl_Diff.Caption:=lbl_Diff.Caption+Int2Str(IntDiff);
lbl_None.Caption:=lbl_None.Caption+Int2Str(IntNone);
 exit;
                end;
x0:=FormDiagram.Width div 4 ; //-FormDiagram.Width div 20
y0:=FormDiagram.Height div 4; //центр
r:=FormDiagram.Width div 4;

b[1]:=0;
p[1].X:=x0+r;
p[1].Y:=y0;

for i:=2 to NotNullParam do
b[i]:=b[i-1]+2*pi*a[i-1]/sum;

for i:=2 to NotNullParam do
 begin
  p[i].X:=round(x0+(r+10)*cos(b[i]));
  p[i].Y:=round(y0-(r+10)*sin(b[i]));
 end;
//диаграмма
with BM.Canvas^ do
  begin
    //brush.Color:=clWhite;
    //FillRect(ClipRect);
    case NotNullParam of
     1:Begin
        brush.color:=c[1];
        Pie(x0-r,y0-r,x0+r,y0+r,p[1].X,p[1].Y,p[1].x,p[1].y);
        end;
     2:Begin
        brush.color:=c[1];
        Pie(x0-r,y0-r,x0+r,y0+r,p[1].X,p[1].Y,p[2].x,p[2].y);
        brush.color:=c[2];
        Pie(x0-r,y0-r,x0+r,y0+r,p[2].x,p[2].y,p[1].x,p[1].y);
        end;
     3:Begin
        brush.color:=c[1];
        Pie(x0-r,y0-r,x0+r,y0+r,p[1].X,p[1].Y,p[2].x,p[2].y);
        brush.color:=c[2];
        Pie(x0-r,y0-r,x0+r,y0+r,p[2].x,p[2].y,p[3].x,p[3].y);
        brush.color:=c[3];
        Pie(x0-r,y0-r,x0+r,y0+r,p[3].x,p[3].y,p[1].x,p[1].y);
        end;
     4:Begin
        brush.color:=c[1];
        Pie(x0-r,y0-r,x0+r,y0+r,p[1].X,p[1].Y,p[2].x,p[2].y);
        brush.color:=c[2];
        Pie(x0-r,y0-r,x0+r,y0+r,p[2].x,p[2].y,p[3].x,p[3].y);
        brush.color:=c[3];
        Pie(x0-r,y0-r,x0+r,y0+r,p[3].x,p[3].y,p[4].x,p[4].y);
        brush.color:=c[4];
        Pie(x0-r,y0-r,x0+r,y0+r,p[4].x,p[4].y,p[1].x,p[1].y);
       end;
     5:Begin
        brush.color:=c[1];
        Pie(x0-r,y0-r,x0+r,y0+r,p[1].X,p[1].Y,p[2].x,p[2].y);
        brush.color:=c[2];
        Pie(x0-r,y0-r,x0+r,y0+r,p[2].x,p[2].y,p[3].x,p[3].y);
        brush.color:=c[3];
        Pie(x0-r,y0-r,x0+r,y0+r,p[3].x,p[3].y,p[4].x,p[4].y);
        brush.color:=c[4];
        Pie(x0-r,y0-r,x0+r,y0+r,p[4].x,p[4].y,p[5].x,p[5].y);
        brush.color:=c[5];
        Pie(x0-r,y0-r,x0+r,y0+r,p[5].x,p[5].y,p[1].X,p[1].Y);

       end;
    end;//End of Case   
  end;

end;
procedure DrawPaint( Dummy: Pointer; Sender: PControl; DC: HDC );
begin
bm.Draw(FormDiagram.Canvas.Handle,
110 , //влево
44); //сверху
end;
{Вызов окна Диаграмма}
procedure WinDiagram(DummySelf,Sender: Pobj);
var //
GroupBox:PControl;

pnl_Errors: PControl; //Цветовое поле -> "Ошибки"

pnl_Allok: PControl; //Цветовое поле -> "Верные ответы"

pnl_Smallok: PControl; //Цветовое поле -> "Неполные ответы"

pnl_Diff: PControl; //Цветовое поле -> "Смешанные ответы"

pnl_None: PControl; //Цветовое поле -> "Пропущенные ответы"

begin //Msgok('Options')
FormDiagram:= NewForm(Form,'Результаты в виде круговой диаграммы').
SetClientSize( 428,400  ).CenterOnParent;//setposition(100,100)
   FormDiagram.Font.FontName := 'MS Sans Serif';
   FormDiagram.Font.FontCharset := 0;
FormDiagram.Style := FormDiagram.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);//отключаем кнопку раскрыть и минимизировать
//FormDiagram.OnClose:=TOnEventAccept(MakeMethod(nil,@FormDiagram_Close));

GroupBox:= NewGroupBox(FormDiagram, ' Ответы ' ).SetClientSize( 328,100  ).
setalign( caBottom ).PlaceUnder;

pnl_Errors := NewPanel( GroupBox, esNone ).SetSize(60, 25 ).PlaceRight;
pnl_Errors.Color:=clred;
pnl_Errors.SetPosition(20,28);

lbl_Errors := NewLabel( GroupBox ,'' ).AutoSize(True).PlaceRight;
lbl_Errors.Caption:= '-> Ошибки ';

pnl_Allok := NewPanel( GroupBox, esNone ).SetSize(60, 25 );
pnl_Allok.SetPosition(215,28);
pnl_Allok.Color:=clgreen;

lbl_Allok := NewLabel( GroupBox ,'' ).AutoSize(True).PlaceRight;
lbl_Allok.Caption:='-> Верные ';

pnl_Smallok := NewPanel( GroupBox, esNone ).SetSize(60, 25 ).PlaceDown;
pnl_Smallok.Color:=clyellow;
pnl_Smallok.SetPosition(20,58);


lbl_Smallok := NewLabel( GroupBox ,'' ).AutoSize(True).PlaceRight;
lbl_Smallok.Caption:='-> Неполные ';
lbl_Smallok.Top:=lbl_Smallok.Top+5;

pnl_Diff := NewPanel( GroupBox, esNone ).SetSize(60, 25 ).PlaceRight;
pnl_Diff.Color:=clOrange;
pnl_Diff.SetPosition(215,58);

lbl_Diff := NewLabel( GroupBox ,'' ).AutoSize(True).PlaceRight;
lbl_Diff.Caption:='-> Смешанные ';
lbl_Diff.Top:=lbl_Diff.Top+5;

pnl_None := NewPanel( GroupBox, esNone ).SetSize(60, 25 ).PlaceDown;
pnl_None.Color:=clGray;
pnl_None.SetPosition(20,88);


lbl_None := NewLabel( GroupBox ,'' ).AutoSize(True).PlaceRight;
lbl_None.Caption:='-> Пропущенные ';
lbl_None.Top:=lbl_None.Top+5;

 bm :=  NewBitmap( 0, 0 );
 BM.Height:=228;
 BM.Width:=224;

 BM.Canvas.Brush.BrushStyle:=bsSolid;
 //BM.Canvas.Brush.Color:=clLime;
 BM.Canvas.FloodFill(0,0,clBtnFace,fsBorder);
 FormDiagram.Add2AutoFree(BM);
 FormDiagram.OnPaint := TOnPaint( MakeMethod( nil, @DrawPaint ) );
 FormDiagram.CanResize:=False;
 FormDiagram.StayOnTop:= True;
Gistogramma;
end;


//{Вызов события Close }
//procedure FormDiagram_Close(DummySelf,Sender: PControl;  var Accept: Boolean);
//begin
// Form.Close
//end;
end.
