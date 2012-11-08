{ KOL MCK } // Do not remove this line!

procedure NewFHelp( var Result: PFHelp; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PFHelp.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'FHelp' ).SetPosition( 516, 192 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.SetClientSize( 360, 358 );
    Result.REHelp := NewRichEdit( Result.Form, [ eoMultiline, eoNoHScroll, eoReadonly ] ).SetAlign ( caClient );
    Result.REHelp.HasBorder := FALSE;
    Result.REHelp.Text := 'RichEdit1'+#13+#10;
    Result.REHelp.Color := TColor($C5FBFC);
    Result.Form.CenterOnParent;
    Result.KOLForm1FormCreate( Result );

end;

