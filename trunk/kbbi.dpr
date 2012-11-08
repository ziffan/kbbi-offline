{ KOL MCK } // Do not remove this line!
program kbbi;

uses
KOL,
  Unit1 in 'Unit1.pas' {FMain},
  DIUclStreams in 'ucl\DIUclStreams.pas',
  UPosX in 'UPosX.pas',
  USetting in 'USetting.pas' {FSetting},
  UHelp in 'UHelp.pas' {FHelp};

{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IF Defined(KOL_MCK)} {$I kbbi_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;

{$IFEND}

end.

