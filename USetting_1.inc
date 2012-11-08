{ KOL MCK } // Do not remove this line!

procedure NewFSetting( var Result: PFSetting; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PFSetting.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'FSetting' ).SetPosition( 548, 310 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.ExStyle := Result.Form.ExStyle or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
    Result.Form.SetClientSize( 273, 116 );
    Result.Form.Font.FontHeight := 16;
    Result.Form.Font.FontName := 'Arial';
    Result.Label1 := NewLabel( Result.Form, 'Maksimal kata perhalaman' ).SetPosition( 12, 16 ).AutoSize( TRUE );
    Result.chAuto := NewCheckBox( Result.Form, 'Aktifkan fitur pencarian otomatis (lema)' ).SetPosition( 12, 40 ).AutoSize( TRUE );
    Result.btnBatal := NewButton( Result.Form, 'Batal' ).SetPosition( 139, 76 ).SetSize( 0, 25 );
    Result.btnSimpan := NewButton( Result.Form, 'Simpan' ).SetPosition( 71, 76 ).SetSize( 0, 25 );
    Result.edMaxPage := NewEditBox( Result.Form, [ eoNumber ] ).SetPosition( 180, 13 ).SetSize( 73, 0 );
    Result.edMaxPage.TextAlign := KOL.taRight;
    Result.edMaxPage.Text := '300';
      Result.btnSimpan.OnClick := Result.btnSimpanClick;
      Result.btnBatal.OnClick := Result.btnBatalClick;
    Result.edMaxPage.Color := TColor(clWindow);
    Result.Form.CenterOnParent.CanResize := False;
    Result.Form.Perform( WM_INITMENU, 0, 0 );
    Result.KOLForm1FormCreate( Result );
    Result.Form.Icon := THandle(-1);

end;

