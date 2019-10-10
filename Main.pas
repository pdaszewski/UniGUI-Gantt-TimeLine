unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniPageControl, uniGUIBaseClasses, uniPanel, uniScrollBox, uniLabel,
  uniDateTimePicker, uniStatusBar, uniTimer, Vcl.Imaging.pngimage, uniImage, uniButton;

type
  TMainForm = class(TUniForm)
    pnl_top_bar: TUniPanel;
    PageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    pnl_gantt: TUniPanel;
    pnl_left: TUniPanel;
    pnl_right: TUniPanel;
    pnl_main: TUniPanel;
    box_left: TUniScrollBox;
    box_main: TUniScrollBox;
    display_date: TUniDateTimePicker;
    StatusBar1: TUniStatusBar;
    MouseTimer: TUniTimer;
    pointer_image: TUniImage;
    AutoRun: TUniTimer;
    pnl_trwa_ladowanie: TUniPanel;
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string; Params: TUniStrings);
    procedure UniFormCreate(Sender: TObject);
    procedure MouseTimerTimer(Sender: TObject);
    procedure display_dateChangeValue(Sender: TObject);
    procedure AutoRunTimer(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure def_panelClick(Sender: TObject);
    procedure def_panel_nameClick(Sender: TObject);
  private
   const
    ile_max_rekordow = 100;
   Var
    mousePosition : TPoint;
    pointer_line  : TUniPanel;
    tab_hours     : array[0..23] of TUniPanel;
    tab_minuts    : array[0..23] of TUniPanel;
    tab_rec       : array[1..ile_max_rekordow] of TUniPanel;
    tab_rec_name  : array[1..ile_max_rekordow] of TUniPanel;
    pnl_pointer   : TUniPanel;
    pnl_height    : Integer;
    pnl_width     : Integer;
    pnl_pom       : TUniPanel;
    minute_width  : Integer;
    after_start   : Boolean;

    procedure CreateHourPanels;
    procedure CreateRecords;
    procedure ChangeDate;
    procedure ShowVisilbeRecords;
    procedure ClearAllObjects;
    procedure CreateAllObjectsOnDate;
    procedure InsertObject(record_name, from_time, to_time, memo: string; canvas_color, text_color : TColor);

  public
    { Public declarations }
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

procedure TMainForm.ShowVisilbeRecords;
var
  i: Integer;
  ile: Integer;
  wys: Integer;
Begin
 ile:=0;
 for i := 1 to ile_max_rekordow do
  Begin
   if tab_rec[i].Visible then
    Begin
     tab_rec[i].Top := 3+((ile+1)*(pnl_height*2))-((ile+1)*2);
     tab_rec_name[i].Top := 3+((ile+1)*(pnl_height*2))-((ile+1)*2);
     Inc(ile);
    End;
  End;
 wys := (ile*(pnl_height*2))-(ile*2)+4;
 pointer_line.Height:=wys;
End;

procedure TMainForm.CreateAllObjectsOnDate;
Begin
 InsertObject('Projekt dap.365','01:15','03:25','Faza 1<br>Zarz¹dzanie grupami',clBlue,clWhite);
 InsertObject('Projekt dap.team','03:15','03:35','Analiza<br>Zastosowanie soft robots',clRed,clBlack);
 InsertObject('Projekt new interface','03:40','05:25','Analiza<br>UX i UI',clBlue,clWhite);
 InsertObject('Oczekuj¹ce','02:10','04:45','Analiza dla IA Workers',clBlue,clWhite);
End;

procedure TMainForm.InsertObject(record_name, from_time, to_time, memo: string; canvas_color, text_color : TColor);
Var
  new_object : TUniPanel;
  new_label : TUniLabel;
  i: Integer;
  godzS, minS: string;
  poz: Integer;
  godz, min: Integer;
  left: Integer;
  end_time: Integer;
  width_pos: Integer;
Begin
 new_object := TUniPanel.Create(Self);
 for i := 1 to ile_max_rekordow do
  Begin
   if tab_rec_name[i].Caption = record_name then new_object.Parent:=tab_rec[i];
  End;

 new_object.Top           := 0;
 new_object.Height        := (pnl_height*2)-2;
 new_object.StyleElements := [];
 new_object.ShowHint      := True;
 new_object.Hint          := record_name+#13#13+StringReplace(Memo,'<br>',#13#10,[rfReplaceAll])+#13#13+'Od: '+from_time+#13+'Do: '+to_time;
 new_object.Color         := canvas_color;

 poz  := Pos(':',from_time);
 godzS:= Trim(Copy(from_time,1,poz-1)); Delete(from_time,1,poz);
 minS := Trim(from_time);
 godz := StrToInt(godzS);
 min  := (godz*60)+StrToInt(minS);
 left := min*minute_width;

 poz      := Pos(':',to_time);
 godzS    := Trim(Copy(to_time,1,poz-1)); Delete(to_time,1,poz);
 minS     := Trim(to_time);
 godz     := StrToInt(godzS);
 min      := (godz*60)+StrToInt(minS);
 end_time := min*minute_width;
 width_pos:= end_time-left;

 new_object.Left  := left;
 new_object.Width := width_pos;

 new_label              := TUniLabel.Create(Self);
 new_label.Parent       := new_object;
 new_label.TextConversion:= txtHTML;
 new_label.Top          := 2;
 new_label.Left         := 4;
 new_label.AutoSize     := False;
 new_label.Height       := new_object.Height-4;
 new_label.Width        := new_object.Width-10;
 new_label.Caption      := memo;
 new_label.Font.Color   := text_color;
 new_label.Font.Style   := [fsBold];
 new_label.StyleElements:= [];
 new_label.Transparent  := True;
End;

procedure TMainForm.ClearAllObjects;
var
  i: Integer;
  c: Integer;
Begin
 for i := 1 to ile_max_rekordow do
  Begin
   for c := tab_rec[i].ControlCount - 1 downto 0 do
    begin
     tab_rec[i].Controls[c].Destroy;
    end;
  End;
End;

procedure TMainForm.UniFormAjaxEvent(Sender: TComponent; EventName: string; Params: TUniStrings);
begin
 if EventName='EventMyszki' then
  begin
    mousePosition.X:=StrToInt(Params.Values['X']);
    mousePosition.Y:=StrToInt(Params.Values['Y']);
  end;
end;

procedure TMainForm.CreateHourPanels;
var
  i: Integer;
  hour: string;
  x: Integer;
  w: Integer;
  podzialka: TUniPanel;
  opis: TUniLabel;
  panel_name: TUniPanel;
  panel_pom: TUniPanel;
Begin
 panel_name := TUniPanel.Create(Self);
 panel_name.Parent := box_left;
 panel_name.Height := pnl_height;
 panel_name.Width  := pnl_left.Width;// - 23;
 panel_name.Anchors:= [akLeft,akTop,akRight];
 panel_name.Caption:= 'Nazwa';
 panel_name.Font.Style := [fsBold];

 panel_pom := TUniPanel.Create(Self);
 panel_pom.Parent := box_left;
 panel_pom.Height := pnl_height;
 panel_pom.Width  := pnl_left.Width;// - 23;
 panel_pom.Anchors:= [akLeft,akTop,akRight];
 panel_pom.Top       := panel_name.Top + pnl_height-1;

 for i := 0 to 23 do
  Begin
   tab_hours[i] := TUniPanel.Create(Self);
   tab_hours[i].Parent := box_main;
   tab_hours[i].Height := pnl_height;
   tab_hours[i].Width  := pnl_width;
   tab_hours[i].Left   := i*pnl_width+2;
   tab_hours[i].Top    := 1;
   hour := IntToStr(i); if Length(hour)=1 then hour := '0'+hour;
   tab_hours[i].Caption:= DateToStr(display_date.DateTime)+' '+hour+' : xx';
   tab_hours[i].Font.Style := [fsBold];

   tab_minuts[i] := TUniPanel.Create(Self);
   tab_minuts[i].Parent := box_main;
   tab_minuts[i].Height := pnl_height;
   tab_minuts[i].Width  := pnl_width;
   tab_minuts[i].Left   := i*pnl_width+2;
   tab_minuts[i].Top    := tab_hours[i].Top + pnl_height-1;

   w:=pnl_width div 57;
   minute_width:=w;
   for x := 1 to 60 do
    Begin
     podzialka := TUniPanel.Create(Self);
     podzialka.Parent := tab_minuts[i];
     podzialka.Width  := 1;
     podzialka.Height := pnl_height div 5;
     podzialka.Top    := tab_minuts[i].Height-podzialka.Height-(podzialka.Height div 2);
     podzialka.Left   := (x)*w;
     if (x mod 5) = 0 then
      Begin
       podzialka.Height := podzialka.Height+10;
       podzialka.Top    := podzialka.Top-10;
      End;
     if (x mod 15 = 0) and (x<>60) then
      Begin
       opis := TUniLabel.Create(Self);
       opis.Parent  := tab_minuts[i];
       opis.Caption := IntToStr(x);
       opis.Top     := -2;
       opis.Left    := ((x)*w-2);
      End;
    End;
  End;

 pnl_pointer          := TUniPanel.Create(Self);
 pointer_image.Parent := pnl_pointer;
 pointer_image.Visible:= True;
 pointer_image.Align  := alClient;
 pnl_pointer.Parent   := box_main;
 pnl_pointer.Width    := 20;
 pnl_pointer.Height   := 20;
 pnl_pointer.Top      := pnl_height+pnl_height-pnl_pointer.Height;
End;

procedure TMainForm.CreateRecords;
Var
 i: Integer;
Begin
 for i := 1 to ile_max_rekordow do
  Begin
   tab_rec[i]           := TUniPanel.Create(Self);
   tab_rec[i].Height    := pnl_height*2;
   tab_rec[i].Parent    := box_main;
   tab_rec[i].Anchors   := [akLeft,akTop,akRight];
   tab_rec[i].Top       := 3+(i*(pnl_height*2))-(i*2);
   tab_rec[i].Left      := 2;
   tab_rec[i].Width     := (pnl_width * 24);
   tab_rec[i].SendToBack;
   tab_rec[i].StyleElements := [seFont, seBorder];
   tab_rec[i].Color      := $00F5F5F5;
   tab_rec[i].OnClick    := def_panelClick;

   tab_rec_name[i]            := TUniPanel.Create(Self);
   tab_rec_name[i].Height     := pnl_height*2;
   tab_rec_name[i].Width      := pnl_left.Width;// - 23;
   tab_rec_name[i].Parent     := box_left;
   tab_rec_name[i].Anchors    := [akLeft,akTop,akRight];
   tab_rec_name[i].Top        := 3+(i*(pnl_height*2))-(i*2);
   tab_rec_name[i].Color      := $00F5F5F5;
   tab_rec_name[i].Caption    := 'pnl: '+IntToStr(i);

   //Some example records
   if i=1 then tab_rec_name[i].Caption := 'Oczekuj¹ce';
   if i=2 then tab_rec_name[i].Caption := 'Projekt dap.team';
   if i=3 then tab_rec_name[i].Caption := 'Projekt AI Workers';
   if i=4 then tab_rec_name[i].Caption := 'Projekt dap.365';
   if i=5 then tab_rec_name[i].Caption := 'Projekt new interface';
   if i=6 then tab_rec_name[i].Caption := 'Inne';

   tab_rec_name[i].Font.Style := [fsBold];
   tab_rec_name[i].StyleElements := [seFont, seBorder];
   tab_rec_name[i].OnClick    := def_panel_nameClick;

   tab_rec[i].Visible      := False;
   tab_rec_name[i].Visible := False;

   if i<7 then
    Begin
     tab_rec[i].Visible      := True;
     tab_rec_name[i].Visible := True;
    End;
  End;

 pointer_line        := TUniPanel.Create(Self);
 pointer_line.Color  := clRed;
 pointer_line.Top    := pnl_pointer.Top + pnl_pointer.Height;
 pointer_line.Width  := 3;
 pointer_line.Height := box_main.Height;
 pointer_line.Parent := box_main;
End;

procedure TMainForm.display_dateChangeValue(Sender: TObject);
begin
 if after_start then ChangeDate;
end;

procedure TMainForm.MouseTimerTimer(Sender: TObject);
var
  P: TPoint;
  miejsce: Integer;
  minut_od_poczatku: Integer;
  godzina: Integer;
  godzinaS: string;
  minutS: string;
begin
  GetCursorPos(P);
  P:=mousePosition;
  if (P.X>=(pnl_left.Width + 2 + (pnl_pointer.Width div 2)+5))
  and (P.X<=Screen.Width-30-pnl_right.Width)
  and (P.Y>0) and (P.Y<=Screen.Height-100) then
   Begin
    StatusBar1.Panels[1].Text := IntToStr(P.X)+':'+IntToStr(P.Y);
    pnl_pointer.Left  := P.X - (pnl_left.Width + 2) - (pnl_pointer.Width div 2);
    pointer_line.Left := P.X - (pnl_left.Width + 2) + 3;

    //miejsce := Round(box_main.HorzScrollBar.Position + (P.X - (pnl_left.Width + 2) - (pnl_pointer.Width div 2)));
    miejsce := 15 + (P.X - (pnl_left.Width + 2) - (pnl_pointer.Width div 2));

    minut_od_poczatku := (((miejsce) * 1440) div tab_rec[1].Width);
    godzina := minut_od_poczatku div 60;
    minut_od_poczatku := minut_od_poczatku - (godzina * 60);

    godzinaS := IntToStr(godzina); if Length(godzinaS)=1 then godzinaS:='0'+godzinaS;
    minutS := IntToStr(minut_od_poczatku); if Length(minutS)=1 then minutS:='0'+minutS;

    StatusBar1.Panels[2].Text := DateToStr(display_date.DateTime)+' '+godzinaS+':'+minutS;
   End;
end;

procedure TMainForm.AutoRunTimer(Sender: TObject);
begin
 CreateHourPanels;
 CreateRecords;
 ShowVisilbeRecords;
 CreateAllObjectsOnDate;

 pnl_trwa_ladowanie.Visible := False;
 after_start := True;
 MouseTimer.Enabled := True;
end;

procedure TMainForm.ChangeDate;
var
  i: Integer;
  hour: string;
Begin
 for i := 0 to 23 do
  Begin
   hour := IntToStr(i); if Length(hour)=1 then hour := '0'+hour;
   tab_hours[i].Caption:= DateToStr(display_date.DateTime)+' '+hour+' : xx';
  End;
End;

procedure TMainForm.UniFormCreate(Sender: TObject);
begin
 after_start := False;
 display_date.DateTime := Now;
 pnl_height   := 30;
 pnl_width    := 300;
end;

procedure TMainForm.UniFormShow(Sender: TObject);
begin
 AutoRun.Enabled := True;
end;

procedure TMainForm.def_panelClick(Sender: TObject);
Var
 panel : TUniPanel;
  i: Integer;
  kolor: Integer;
begin
 panel := TUniPanel(Sender);
 for i := 1 to ile_max_rekordow do
  Begin
   if tab_rec[i]=panel then
    Begin
     tab_rec_name[i].Color := $00D5FFFF;
     tab_rec[i].Color      := $00D5FFFF;
    End
   else
    Begin
     tab_rec_name[i].Color := $00F5F5F5;
     tab_rec[i].Color      := $00F5F5F5;
    End;
  End;
end;

procedure TMainForm.def_panel_nameClick(Sender: TObject);
Var
 panel : TUniPanel;
  i: Integer;
  kolor: Integer;
begin
 panel := TUniPanel(Sender);
 for i := 1 to ile_max_rekordow do
  Begin
   if tab_rec_name[i]=panel then
    Begin
     tab_rec_name[i].Color := $00D5FFFF;
     tab_rec[i].Color      := $00D5FFFF;
    End
   else
    Begin
     tab_rec_name[i].Color := $00F5F5F5;
     tab_rec[i].Color      := $00F5F5F5;
    End;
  End;
end;

initialization
  RegisterAppFormClass(TMainForm);

end.
