{ KOL MCK } // Do not remove this line!

procedure NewFMain( var Result: PFMain; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PFMain.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'KBBI' ).SetPosition( 505, 178 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.SetClientSize( 569, 393 );
    Result.Form.Font.FontHeight := 14;
    Result.Form.Font.FontName := 'Arial';
    Result.Form.Border := 0;
    Result.Form.MinWidth := 580;
    Result.Form.MinHeight := 400;
      Result.Form.OnClose := Result.KOLForm1Close;
      Result.Form.OnResize := Result.KOLForm1Resize;
      Result.Form.OnShow := Result.KOLForm1Show;

    Result.Thread1 := NewThreadAutoFree( nil );
    Result.Thread1.OnExecute := Result.Thread1Execute;
    Result.PanelTop := NewPanel( Result.Form, esNone ).SetAlign ( caTop ).SetSize( 0, 93 ).SetBorder( 0);
    Result.PanelTop.Color := TColor(clBtnFace);
      Result.Label1 := NewLabel( Result.PanelTop, 'Lema' ).SetPosition( 44, 36 ).AutoSize( TRUE ).SetBorder( 2);
      Result.Label2 := NewLabel( Result.PanelTop, 'Arti (Kalimat)' ).SetPosition( 8, 63 ).AutoSize( TRUE ).SetBorder( 2);
      Result.LabelEffect1 := NewLabelEffect( Result.PanelTop, 'Kamus Besar Bahasa Indonesia', 1 ).SetPosition( 8, 8 ).AutoSize( TRUE ).SetBorder( 2);
      Result.LabelEffect1.Ctl3D := False;
      Result.LabelEffect1.HasBorder := FALSE;
    Result.LabelEffect1.Font.Color := TColor(clGray);
    Result.LabelEffect1.Font.FontStyle := [ fsBold ];
    Result.LabelEffect1.Font.FontHeight := 16;
    Result.LabelEffect1.TextAlign := KOL.taLeft;
      Result.LabelEffect1.Transparent := True;
    Result.LabelEffect1.Color := TColor(clBtnFace);
      Result.LabelEffect1.Color2 := TColor(clWhite);
      Result.cbKriteria := NewComboBox( Result.PanelTop, [ coReadOnly, coNoIntegralHeight ] ).SetPosition( 76, 32 ).SetSize( 77, 0 ).SetBorder( 2);
    Result.cbKriteria.Color := TColor(clWindow);
      Result.cbKriteria.Items[ 0 ] := 'Diawali';
      Result.cbKriteria.Items[ 1 ] := 'Diakhiri';
      Result.cbKriteria.Items[ 2 ] := 'Sama';
      Result.cbKriteria.Items[ 3 ] := 'Memuat';
      Result.cbKriteria.CurIndex := 0;
      Result.ebCari := NewEditBox( Result.PanelTop, [  ] ).SetPosition( 160, 32 ).SetSize( 256, 0 ).SetBorder( 2);
    Result.ebCari.Font.FontHeight := 16;
      Result.btnCariKata := NewButton( Result.PanelTop, 'Cari' ).SetPosition( 417, 31 ).SetSize( 53, 0 ).SetBorder( 2);
      Result.chTepatSama := NewCheckBox( Result.PanelTop, 'Huruf sama' ).SetPosition( 76, 60 ).SetBorder( 2);
      Result.ebKalimat := NewEditBox( Result.PanelTop, [  ] ).SetPosition( 160, 59 ).SetSize( 256, 0 ).SetBorder( 2);
    Result.ebKalimat.Font.FontHeight := 16;
      Result.btnCariArti := NewButton( Result.PanelTop, 'Cari' ).SetPosition( 417, 59 ).SetSize( 53, 0 ).SetBorder( 2);
      Result.btnSetting := NewButton( Result.PanelTop, '...' ).SetPosition( 491, 31 ).SetSize( 32, 0 ).SetBorder( 2);
    Result.btnSetting.Font.FontStyle := [ fsBold ];
      Result.btnAbout := NewButton( Result.PanelTop, '!' ).SetPosition( 524, 31 ).SetSize( 32, 0 ).SetBorder( 1);
    Result.btnAbout.Font.FontHeight := 16;
      {$IFDEF USE_MHTOOLTIP}
      Result.btnAbout.Hint.Text := 'Tentang Program';
      {$ENDIF USE_MHTOOLTIP}
      Result.btnHelp := NewButton( Result.PanelTop, '?' ).SetPosition( 524, 55 ).SetSize( 32, 0 ).SetBorder( 1);
    Result.btnHelp.Font.FontHeight := 16;
      {$IFDEF USE_MHTOOLTIP}
      Result.btnHelp.Hint.Text := 'Tentang Program';
      {$ENDIF USE_MHTOOLTIP}
    Result.Panel1 := NewPanel( Result.Form, esNone ).SetAlign ( caBottom ).SetSize( 0, 20 ).SetBorder( 0);
      Result.LblEf1 := NewLabelEffect( Result.Panel1, 'http://ebsoft.web.id', 1 ).SetPosition( 5, 2 ).AutoSize( TRUE ).SetBorder( 2);
      Result.LblEf1.Ctl3D := False;
      Result.LblEf1.HasBorder := FALSE;
    Result.LblEf1.Font.Color := TColor($35271A);
    Result.LblEf1.TextAlign := KOL.taLeft;
      Result.LblEf1.Transparent := True;
    Result.LblEf1.Color := TColor($CEB195);
      Result.LblEf1.Color2 := TColor($E9DCCF);
      Result.LblEf2 := NewLabelEffect( Result.Panel1, 'http://ebsoft.web.id', 1 ).SetPosition( 109, 2 ).AutoSize( TRUE ).SetBorder( 2);
      Result.LblEf2.Ctl3D := False;
      Result.LblEf2.HasBorder := FALSE;
    Result.LblEf2.Font.Color := TColor(clBlue);
    Result.LblEf2.Font.FontStyle := [ fsBold ];
    Result.LblEf2.TextAlign := KOL.taLeft;
      Result.LblEf2.Cursor := LoadCursor( 0, IDC_HAND );
      Result.LblEf2.Transparent := True;
    Result.LblEf2.Color := TColor($CEB195);
      Result.LblEf2.Color2 := TColor(clWhite);
    Result.PanelMain := NewPanel( Result.Form, esNone ).SetAlign ( caClient ).SetBorder( 1);
    Result.PanelMain.Color := TColor($F4EEEA);
      Result.PanelDef := NewPanel( Result.PanelMain, esNone ).SetAlign ( caClient ).SetBorder( 1);
    Result.PanelDef.Color := TColor(clBtnFace);
        Result.REdef := NewRichEdit( Result.PanelDef, [ eoMultiline, eoNoHScroll, eoReadonly ] ).SetAlign ( caClient ).SetBorder( 2);
        Result.REdef.HasBorder := FALSE;
    Result.REdef.RE_CharFmtArea := raAll;
    Result.REdef.RE_Font.FontHeight := 16;
    Result.REdef.RE_CharFmtArea := raSelection;
        Result.REdef.DoubleBuffered := True;
      Result.PanelWord := NewPanel( Result.PanelMain, esNone ).SetAlign ( caLeft ).SetSize( 148, 0 ).SetBorder( 1);
    Result.PanelWord.Color := TColor(clBtnFace);
        Result.PnlTop := NewPanel( Result.PanelWord, esNone ).SetAlign ( caTop ).SetSize( 0, 165 ).SetBorder( 0);
          Result.PnlPageTop := NewPanel( Result.PnlTop, esNone ).SetAlign ( caTop ).SetSize( 0, 20 ).SetBorder( 0);
          Result.PnlPageTop.Visible := False;
    Result.PnlPageTop.Color := TColor(clBtnFace);
            Result.lblMain := NewLabel( Result.PnlPageTop, 'Main word' ).SetAlign ( caClient ).SetBorder( 2);
    Result.lblMain.Font.FontStyle := [ fsItalic ];
    Result.lblMain.VerticalAlign := KOL.vaCenter;
            Result.btnNext1 := NewButton( Result.PnlPageTop, '>' ).SetAlign ( caRight ).AutoSize( TRUE ).SetBorder( 2);
            Result.btnPrev1 := NewButton( Result.PnlPageTop, '<' ).SetAlign ( caRight ).AutoSize( TRUE ).SetBorder( 2);
          Result.lbKata := NewListBox( Result.PnlTop, [ loNoExtendSel, loNoIntegralHeight ] ).SetAlign ( caClient ).SetBorder( 2);
          Result.lbKata.HasBorder := FALSE;
    Result.lbKata.Font.FontHeight := 16;
          Result.lbKata.DoubleBuffered := True;
    Result.lbKata.Color := TColor(clWindow);
        Result.Splitter1 := NewSplitter( Result.PanelWord, 0, 0 ).SetAlign ( caTop ).SetBorder( 2);
        Result.PnlBottom := NewPanel( Result.PanelWord, esNone ).SetAlign ( caClient ).SetBorder( 0);
    Result.PnlBottom.Font.FontHeight := 16;
          Result.PnlPageBottom := NewPanel( Result.PnlBottom, esNone ).SetAlign ( caTop ).SetSize( 0, 20 ).SetBorder( 0);
          Result.PnlPageBottom.Visible := False;
    Result.PnlPageBottom.Color := TColor(clBtnFace);
            Result.lblAdd := NewLabel( Result.PnlPageBottom, 'Memuat' ).SetAlign ( caClient ).SetBorder( 2);
    Result.lblAdd.Font.FontStyle := [ fsItalic ];
    Result.lblAdd.Font.FontHeight := 14;
    Result.lblAdd.VerticalAlign := KOL.vaCenter;
            Result.btnNext2 := NewButton( Result.PnlPageBottom, '>' ).SetAlign ( caRight ).AutoSize( TRUE ).SetBorder( 2);
            Result.btnPrev2 := NewButton( Result.PnlPageBottom, '<' ).SetAlign ( caRight ).AutoSize( TRUE ).SetBorder( 2);
          Result.lbAdd := NewListBox( Result.PnlBottom, [ loNoExtendSel, loNoIntegralHeight ] ).SetAlign ( caClient ).SetBorder( 2);
          Result.lbAdd.HasBorder := FALSE;
          Result.lbAdd.DoubleBuffered := True;
    Result.lbAdd.Color := TColor(clWindow);
      Result.Splitter4 := NewSplitterEx( Result.PanelMain, 0, 0, esNone ).SetAlign ( caLeft ).SetSize( 3, 0 ).SetBorder( 2);
    Result.Splitter4.Color := TColor(clBtnFace);
    Result.ebCari.Color := TColor(clWindow);
      Result.ebCari.OnKeyUp := Result.ebCariKeyUp;
      Result.ebCari.OnChange := Result.ebCariChange;
      Result.btnAbout.OnClick := Result.btnAboutClick;
    Result.btnAbout.Anchor(FALSE, FALSE, TRUE, FALSE);
      Result.cbKriteria.OnKeyDown := Result.cbKriteriaKeyDown;
      Result.cbKriteria.OnChange := Result.cbKriteriaChange;
      Result.btnCariKata.OnClick := Result.btnCariKataClick;
      Result.btnSetting.OnClick := Result.btnSettingClick;
    Result.btnSetting.Anchor(FALSE, FALSE, TRUE, FALSE);
    Result.ebKalimat.Color := TColor(clWindow);
      Result.ebKalimat.OnKeyUp := Result.ebKalimatKeyUp;
      Result.chTepatSama.OnClick := Result.chTepatSamaClick;
      Result.btnCariArti.OnClick := Result.btnCariArtiClick;
      Result.btnHelp.OnClick := Result.btnHelpClick;
    Result.btnHelp.Anchor(FALSE, FALSE, TRUE, FALSE);
    Result.PanelMain.Anchor(TRUE, TRUE, TRUE, TRUE);
    Result.REdef.Color := TColor(clWindow);
      Result.REdef.OnKeyUp := Result.REdefKeyUp;
    {$IFDEF OVERRIDE_SCROLLBARS}
    OverrideScrollbars( Result.REdef);
    {$ENDIF OVERRIDE_SCROLLBARS}
      Result.btnPrev2.OnClick := Result.btnPrev2Click;
      Result.btnNext2.OnClick := Result.btnNext2Click;
      Result.lbKata.OnKeyUp := Result.lbKataKeyUp;
      Result.lbKata.OnSelChange := Result.lbKataSelChange;
    {$IFDEF OVERRIDE_SCROLLBARS}
    OverrideScrollbars( Result.lbKata);
    {$ENDIF OVERRIDE_SCROLLBARS}
      Result.btnPrev1.OnClick := Result.btnPrev1Click;
      Result.btnNext1.OnClick := Result.btnNext1Click;
      Result.LblEf2.OnClick := Result.LblEf2Click;
      Result.LblEf2.OnMouseMove := Result.LblEf2MouseMove;
      Result.LblEf2.OnMouseLeave := Result.LblEf2MouseLeave;
      Result.lbAdd.OnKeyUp := Result.lbAddKeyUp;
      Result.lbAdd.OnSelChange := Result.lbAddSelChange;
    {$IFDEF OVERRIDE_SCROLLBARS}
    OverrideScrollbars( Result.lbAdd);
    {$ENDIF OVERRIDE_SCROLLBARS}
    Result.Form.CenterOnParent;
    Result.KOLForm1FormCreate( Result );

end;

