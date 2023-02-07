unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, EditBtn, StdCtrls;

type
  TShareModes = (
              smShareCompat,
              smShareExclusive,
              smShareDenyWrite,
              smShareDenyRead,
              smShareDenyNone);
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    FileNameEdit1: TFileNameEdit;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

uses LazUTF8, LazFileUtils;

const
  CaptLock = 'Lock file';
  CaptUnlock = 'Unlock file';

  ShareModesStringArr: array[TShareModes] of String =
                                       ('fmShareCompat',
                                        'fmShareExclusive',
                                        'fmShareDenyWrite',
                                        'fmShareDenyRead',
                                        'fmShareDenyNone'
                                       );
  ShareModesIntArr: array[TShareModes] of Integer =
                                       ($0000,
                                        $0010,
                                        $0020,
                                        $0030,
                                        $0040
                                       );
var
  h: THandle = 0;
  ShareModeValue: PtrInt = $0000;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (h = 0)
  then
    begin
      if FileExistsUTF8(FileNameEdit1.FileName) then
      begin
        h:= FileOpenUTF8(FileNameEdit1.FileName,ShareModeValue);
        Button1.Caption:= CaptUnlock;
        FileNameEdit1.Enabled:= False;
        ComboBox1.Enabled:= False;
      end;
    end
  else
    begin
      FileClose(h);
      h:= 0;
      Button1.Caption:= Captlock;
      FileNameEdit1.Enabled:= True;
      ComboBox1.Enabled:= True;
    end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
    0: ShareModeValue:= fmShareCompat;
    1: ShareModeValue:= fmShareExclusive;
    2: ShareModeValue:= fmShareDenyWrite;
    3: ShareModeValue:= fmShareDenyRead;
    4: ShareModeValue:= fmShareDenyNone;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: TShareModes;
begin
  Button1.Caption:= Captlock;

  with ComboBox1 do
  begin
    Style:= csDropDownList;
    Clear;
    for i:= Low(ShareModesStringArr) to High(ShareModesStringArr) do
    Items.Add(ShareModesStringArr[i]);
    ItemIndex:= 0;
  end;

  ComboBox1Change(Sender);
end;

end.

