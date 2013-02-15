{ KOL MCK } // Do not remove this line!

procedure ReadSetting;
begin
  setting.Mode := ifmRead;
//  setting.Section := 'KBBI '+ VERSI;
  FHelp.Form.Width := setting.ValueInteger('fhelp-width',380);
  FHelp.Form.Height :=  setting.ValueInteger('fhelp-height',400);
  FHelp.Form.Top :=  setting.ValueInteger('fhelp-top',(ScreenHeight-FHelp.form.Height) div 2);
  FHelp.Form.Left :=  setting.ValueInteger('fhelp-left',(ScreenWidth-FHelp.form.Width) div 2);
end;


procedure NewFHelp( var Result: PFHelp; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PFHelp.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'FHelp' ); //.SetPosition( 516, 192 );
  Result.Form.Add2AutoFree( Result );
    //Result.Form.SetClientSize( 360, 358 );
    ReadSetting;
    Result.Form.OnResize := Result.KOLForm1Resize;
    Result.REHelp := NewRichEdit( Result.Form, [ eoMultiline, eoNoHScroll, eoReadonly ] ).SetAlign ( caClient );
    Result.REHelp.HasBorder := FALSE;
    Result.REHelp.Text := 'RichEdit1'+#13+#10;
    Result.REHelp.Color := TColor($C5FBFC);
    Result.Form.CenterOnParent;
    Result.KOLForm1FormCreate( Result );

end;

