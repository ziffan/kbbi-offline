{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit USetting;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, KOL {$IF Defined(KOL_MCK)}{$ELSE}, mirror, Classes, Controls, mckCtrls, mckObjs, Graphics {$IFEND (place your units here->)};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
{$ENDIF}

type
  {$IF Defined(KOL_MCK)}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} {$I TFSettingclass.inc} {$ELSE OBJECTS} PFSetting = ^TFSetting; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TFSetting.inc}{$ELSE} TFSetting = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TFSetting = class(TForm)
  {$IFEND KOL_MCK}
    KOLForm1: TKOLForm;
    chAuto: TKOLCheckBox;
    Label1: TKOLLabel;
    btnSimpan: TKOLButton;
    edMaxPage: TKOLEditBox;
    btnBatal: TKOLButton;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure btnSimpanClick(Sender: PObj);
    procedure btnBatalClick(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSetting {$IFDEF KOL_MCK} : PFSetting {$ELSE} : TFSetting {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewFSetting( var Result: PFSetting; AParent: PControl );
{$ENDIF}

implementation

uses
  Unit1;

{$IF Defined(KOL_MCK)}{$ELSE}{$R *.DFM}{$IFEND}

{$IFDEF KOL_MCK}
{$I USetting_1.inc}
{$ENDIF}

procedure TFSetting.KOLForm1FormCreate(Sender: PObj);
begin
   Form.Caption := 'Pengaturan KBBI';
   setting.Mode := ifmRead;
   chAuto.Checked := setting.ValueBoolean('Auto Search',False);
   edMaxPage.Text := Int2Str(setting.ValueInteger('MaxPage', 300 ));
end;

procedure TFSetting.btnSimpanClick(Sender: PObj);
begin
  setting.Mode := ifmWrite;
  setting.ValueBoolean('Auto Search',chAuto.Checked);
  setting.ValueInteger('MaxPage', Str2Int(edMaxPage.Text));
  AutoSearch := chAuto.Checked;
  MsgOK('OK, setting telah disimpan');
end;

procedure TFSetting.btnBatalClick(Sender: PObj);
begin
  form.Close;
end;

end.



