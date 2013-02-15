{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit UHelp;

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
  {$IFDEF KOLCLASSES} {$I TFHelpclass.inc} {$ELSE OBJECTS} PFHelp = ^TFHelp; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TFHelp.inc}{$ELSE} TFHelp = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TFHelp = class(TForm)
  {$IFEND KOL_MCK}
    KOLForm1: TKOLForm;
    REHelp: TKOLRichEdit;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLForm1Resize(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FHelp {$IFDEF KOL_MCK} : PFHelp {$ELSE} : TFHelp {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewFHelp( var Result: PFHelp; AParent: PControl );
{$ENDIF}

implementation

uses
  Unit1;

{$IF Defined(KOL_MCK)}{$ELSE}{$R *.DFM}{$IFEND}

{$IFDEF KOL_MCK}
{$I UHelp_1.inc}
{$ENDIF}

procedure TFHelp.KOLForm1FormCreate(Sender: PObj);
var
  P : PStream;
  r : TRect;
begin
  form.Caption := 'Informasi Singkatan';

  REHelp.perform( EM_GETRECT, 0, lparam(@r));
  Inflaterect( r, - 10, - 10 );
  REHelp.perform( EM_SETRECT, 0, lparam(@r));

  P := NewMemoryStream;
  Resource2Stream(P,HInstance,'kbbiacronim',RT_RCDATA);
  P.position :=0;
  REHelp.RE_LoadFromStream(P,P.Size,reRTF,false);
  P.free;
end;

procedure TFHelp.KOLForm1Resize(Sender: PObj);
var
  xy : TPoint;
begin                                                                                
  setting.Mode := ifmWrite;
  setting.ValueInteger('fhelp-width',form.Width);
  setting.ValueInteger('fhelp-height',form.Height);
  xy.X := form.Top;
  xy.Y := form.Left;
  //ScreenToClient(applet.Handle,xy);
  setting.ValueInteger('fhelp-top',xy.X);
  setting.ValueInteger('fhelp-left',xy.Y);
end;

end.



