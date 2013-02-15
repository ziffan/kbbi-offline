{*******************************************************}
{                                                       }
{       KBBI Offline                                    }
{                                                       }
{       Copyright (C) 2013 ebsoft.web.id                }
{                                                       }
{*******************************************************}

{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}

unit Unit1;


interface

{$IFDEF KOL_MCK}
uses Windows, Messages, KOL {$IF Defined(KOL_MCK)}{$ELSE}, mirror, Classes,
 Controls, mckCtrls, mckObjs, Graphics {$IFEND (place your units here->)}
 ,ShellAPI,DIUclStreams,UPosX, SHFolder, err, RegExpr;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;
{$ENDIF}

type
  TKriteriaCari = (kcMemuat,kcSama,kcDiakhiri,kcDiawali,kcRegex);
  TListWord = packed record
    x : Integer;
    kata : string;
  end;

  TListWords = array of TListWord;
  TListWordType = (wtBold,wtItalic);
  TREView = (vNormal,vIndent);

  {$IF Defined(KOL_MCK)}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} {$I TFMainclass.inc} {$ELSE OBJECTS} PFMain = ^TFMain; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TFMain.inc}{$ELSE} TFMain = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TFMain = class(TForm)
  {$IFEND KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    PanelDef: TKOLPanel;
    lbKata: TKOLListBox;
    REdef: TKOLRichEdit;
    PanelTop: TKOLPanel;
    ebCari: TKOLEditBox;
    PanelWord: TKOLPanel;
    lbAdd: TKOLListBox;
    PanelMain: TKOLPanel;
    Splitter4: TKOLSplitter;
    Panel1: TKOLPanel;
    LblEf1: TKOLLabelEffect;
    LblEf2: TKOLLabelEffect;
    Thread1: TKOLThread;
    LabelEffect1: TKOLLabelEffect;
    btnAbout: TKOLButton;
    cbKriteria: TKOLComboBox;
    PnlBottom: TKOLPanel;
    PnlPageBottom: TKOLPanel;
    btnPrev2: TKOLButton;
    btnNext2: TKOLButton;
    PnlTop: TKOLPanel;
    PnlPageTop: TKOLPanel;
    btnPrev1: TKOLButton;
    btnNext1: TKOLButton;
    lblMain: TKOLLabel;
    lblAdd: TKOLLabel;
    Splitter1: TKOLSplitter;
    btnCariKata: TKOLButton;
    btnSetting: TKOLButton;
    ebKalimat: TKOLEditBox;
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    chTepatSama: TKOLCheckBox;
    btnCariArti: TKOLButton;
    btnHelp: TKOLButton;
    btnRandom: TKOLButton;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure ebCariKeyUp(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure lbKataSelChange(Sender: PObj);
    procedure KOLForm1Close(Sender: PObj; var Accept: Boolean);
    procedure lbAddSelChange(Sender: PObj);
    procedure LblEf2Click(Sender: PObj);
    procedure LblEf2MouseMove(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure LblEf2MouseLeave(Sender: PObj);
    function Thread1Execute(Sender: PThread): Integer;
    procedure btnAboutClick(Sender: PObj);
    procedure KOLForm1Resize(Sender: PObj);
    procedure ebCariChange(Sender: PObj);
    procedure cbKriteriaKeyDown(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure lbKataKeyUp(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure lbAddKeyUp(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure REdefKeyUp(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure btnNext1Click(Sender: PObj);
    procedure btnPrev1Click(Sender: PObj);
    procedure btnNext2Click(Sender: PObj);
    procedure btnPrev2Click(Sender: PObj);
    procedure btnCariKataClick(Sender: PObj);
    procedure btnSettingClick(Sender: PObj);
    procedure KOLForm1Show(Sender: PObj);
    procedure ebKalimatKeyUp(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure chTepatSamaClick(Sender: PObj);
    procedure btnCariArtiClick(Sender: PObj);
    procedure btnHelpClick(Sender: PObj);
    procedure cbKriteriaChange(Sender: PObj);
    procedure btnRandomClick(Sender: PObj);
    procedure KOLForm1KeyUp(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
  private
    { Private declarations }
    //REtmp : TKOLRichEdit;
    isSearchArti : Boolean;
    curWord,curSearchArti : string;
    OldHeight : Integer;
    KriteriaCari : TKriteriaCari;
    function GetListBold(src : String) : String;
    
    function GetListItalic(src : string) : string;
    //function CariKata(const kata : string) : Boolean;
    procedure CariKata(const kata : string);
    procedure CariArti(const arti : string);

    function CariDgRegex(kata: string; const regex : TRegExpr; out lema: String) : Integer;
    // Mencari kata dengan regular expresion
    // kata akan diubah ke StringList dan diparsing mulai idx=0
    // hasil adalah index di kata ke berapa ditemukan mulai dari 1
    // jika tidak ditemukan, return value = -1

    procedure TampilkanDef(kata :string);
    procedure ReadSettings;
    procedure SaveFormPosition;
    procedure DisplayResult;
    procedure DisplayResultMain(page : Integer);
    procedure DisplayResultAdd(page : Integer);
    // mendapatkan folder khusus, diperlukan sejak adanya UAC
    function GetSpecialFolderPath(folder : integer) : string;
  public
    { Public declarations }
    AppDataDir : string;
  end;

var
  FMain {$IFDEF KOL_MCK} : PFMain {$ELSE} : TFMain {$ENDIF} ;
  word_list,word_def,hasil_all,hasil_main,hasil_add : PStrList;
  aListBold,aListItalic : TlistWords;
  Tampilan : TREView;
  cari : string;
  FCurrPageMain,FCurrPageAdd,FJmlPageMain,FJmlPageAdd,FMaxPage : Integer;
  AutoSearch : Boolean;
  setting : PIniFile;

const JenisKata : array[1..49] of string =
  ( 'a','a,','n','n,','v','v,','ki','olr','mk v','dik','jk n',
    'ar n','ark n','adv','kim','jw a','n dok','v kas','a kim','n kim','n cak',
    'jw n','mk a','mk n','cak','s sas','kl n','jp n','met','n geo','ark v',
    'min','n min','jw n','n sas','hid','a ki','far','ark kl','tan','lay',
    'geo','isl','kris','tern','jw','antr','ek','kl');

VERSI = '1.5';
SZ_WORD = 344889; // 1.3 = 345215; // 1.2: 345290; // v1.1 : 318201;
SZ_DEF = 3065456; // 1.3 = 3060838; // 1.2: 3060990; // 2996209;

{
  HISTORY
  1.3 + Auto search
      + Pencarian berdasar kriteria : sama, diawali, diakhiri, memuat
      + informasi jumlah hasil pencarian + waktu
      * Perbaikan beberapa kata dasar dan definisi yang ada tambahan angka
      * Fix multi select daftar kata ( set loNoExtendSel = true )
      * Perbaikan beberapa kesalahan pewarnaan definisi

  1.4
      + Pencarian kata/kalimat dari arti/definisi
      + Opsi pengaturan penggunaan auto search (bawaan tidak aktif)
      + Penjelasan tentang arti singkatan (jenis kata, istilah dll)
      + Icon baru
      * Lisensi menjadi Freeware & Open Source
      * Perbaikan pencarian kata yg ada tanda - didepannya
      * Perbaikan penebalan nomor/urutan arti kata
      * Perbaikan beberapa kata yang belum masuk (bising, durian, uang, sarasehan dan romantisisme)
      * Perbaikan hasil pencarian lainnya
      * Fitur pencarian otomatis tidak aktif secara bawaan (penambahan tombol cari)
      * Perbaikan tampilan font yang mengecil di Windows 8



  1.5  2013-02-15
      * Perbaikan error ketika klik bagian kosong kata utama/tambahan
      * Perbaikan setting 'Tepat sama' di pencarian arti
      * Perbaikan hasil pencarian arti yang sebelumnya huruf kecil semua
      + Penambahan informasi tooltip menu/button
      + Menu informasi singkatan yg lebih informatif
      + Regular Expression searching
      + Menampilkan kata acak (button 'Rnd' atau Ctrl+R)

  1.6 TO DO
      * ?=Hasil didaftar yg kurang akurat, misal Pecundang -> Cundang [1]
      * Penambahan jenis-kata dari panduan singkatan
      + Penambahan (database) kata oleh pengguna
}

{$IFDEF KOL_MCK}
procedure NewFMain( var Result: PFMain; AParent: PControl );
{$ENDIF}

implementation

uses
  USetting, UHelp;

{$IF Defined(KOL_MCK)}{$ELSE}{$R *.DFM}{$IFEND}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

{$R WinXP2.RES}
{ $R kbbi.res}
{$R kbbi_acro.RES}

function MyStrReplace(src,sfrom,sto:string): string;
var
  i,l,x :  Integer;
  s : string;
begin
  i := PosEx(sfrom,src);
  if i = 0 then
  begin
    Result := src;
    Exit;
  end;            
  s :='';
  l := Length(sfrom);
  x := 1 ;
  while i > 0 do
  begin
    s := s + Copy(src,x,i-x)+sto;
    x := i + l;
    i := PosEx(sfrom,src,x);
  end;
  
  s := s + Copy(src,x,MaxInt);
  Result :=s;
end;

{ Mencari daftar kata yang akan di format Bold di RichEdit
  Hasilnya adalah string 'src' yang sudah dihilangkan @ dan # }

function TFMain.GetListBold(src : string) : string;
  function getTotal: Integer;
  var
    i1,j1,n1 : Integer;
  begin
    { Cari banyaknya @ }

    i1 := PosEx('@',src,1);
    n1 := 0;
    while i1 > 0 do
    begin
      j1 := PosEx('�',src,i1);
      Inc(n1);
      i1:= PosEx('@',src,j1);
    end;
    Result := n1;
  end;
var
  n,i,j,k  : Integer;
  sx,sw,nl,stmp,stmp_b : string;
begin
  Result := src;
  n := getTotal;
  if n = 0 then Exit;
  aListBold := nil;
  SetLength(aListBold,n);

  { Ingat, semua list_word harus ada penanda awal dan akhir @� }
  i := PosEx('@',src,1);
  n := 0;

  { sx = result  }
  sx := '';
  while i > 0 do
  begin
    j := PosEx('�',src,i);
    k := j-i-1;

    { sw = string diantara sep[1] dan sep[2] }
    sw := Copy(src,i+1,k);
    aListBold[n].kata := sw;
    { x=1 untuk kata dasar }
    if i = 1 then
      aListBold[n].x := 1;


    { tambahkan newline untuk pembatas tipe wtBold }
    nl := '';
    if i > 3 then
    begin

      stmp_b := Copy(src,i,4);
      { stmp = string sebelum pembatas awal }
      stmp := Copy(src,i-3,4);
      { bukan angka }
      if Str2Int(sw) = 0 then
      begin
        { newline -> ~; , ;
          no newline -> ;--  , ;~  }
        if PosFastcodeRTL('@--',stmp_b) > 0 then
        begin
          case Tampilan of
            vNormal : nl :='';
            vIndent : begin
                        nl := #13#10;
                        { x=9 untuk indent }
                        aListBold[n].x :=9;
                      end;
          end;
        end
        else
        if PosFastcodeRTL('~',stmp_b) > 0 then
          nl := ''
        else
        if (PosFastcodeRTL('--',stmp) = 0) and (PosFastcodeRTL(';',stmp) > PosFastcodeRTL('~',stmp)) then
          nl := #13#10#13#10
        else
          nl := '';
      end;
    end;
    { -- end wtBold -- }
    sx := sx + nl + sw ;

    i := PosEx('@',src,j);
    if i = 0 then
      k := Length(src)
    else
      k := i-j-1;

    { copy string di luar @ dan � }
    sx := sx + Copy(src,j+1,k);
    Inc(n);
  end;

  Result := sx;
end;

{ Mencari daftar kata yang akan di format Italic di RichEdit
  Hasilnya adalah string 'src' yang sudah dihilangkan # dan � }
function TFMain.GetListItalic(src : string) : string;
  function getTotal: Integer;
  var
    i1,j1,n1 : Integer;
  begin
    { Cari banyaknya # }

    i1 := PosEx('#',src,1);
    n1 := 0;
    while i1 > 0 do
    begin
      j1 := PosEx('�',src,i1);
      Inc(n1);
      i1:= PosEx('#',src,j1);
    end;
    Result := n1;
  end;

  function TotalNewLine( s2 : string) : Integer;
  var
    i2,n2 : Integer;
  begin
    //i2 := PosEx(#13#10#13#10,s2);
    i2 := PosEx(#13#10,s2);
    n2 := 0;
    while i2 > 0 do
    begin
      i2 := PosEx(#13#10,s2,i2+1);
      inc(n2);
    end;
    Result :=n2;
  end;  
var
  n,i,j,k,l,m  : Integer;
  sx,sw : string;
begin
  Result := src;
  n := getTotal;
  aListItalic := nil;
  if n = 0 then Exit;
  SetLength(aListItalic,n);

  { Tidak semua list_italic ada penanda akhir-nya }
  i := PosEx('#',src,1);
  n := 0;

  { sx = result  }
  sx := Copy(src,0,i-1);
  while i > 0 do
  begin
    j := PosEx('�',src,i);
    l := j-i-1;

    { sw = string diantara # dan � }
    sw := Copy(src,i+1,l);
    aListItalic[n].kata := sw;
    m := i - (2*n) - 1;
    //m := m - TotalNewLine(sx)*2;
    m := m - TotalNewLine(sx);
    aListItalic[n].x := m;

    if j = 0 then { Tidak ditemukan batas akhir }
    begin
      sx := sx + Copy(src,i+1,MAXWORD);
      Break;
    end
    else
      sx := sx + sw ;

    i := PosEx('#',src,j);
    if i = 0 then
      k := MAXWORD
    else
      k := i-j-1;

    { copy string di luar # dan � }
    sx := sx + Copy(src,j+1,k);
    Inc(n);
  end;

  Result := sx;
end;

procedure TFMain.KOLForm1FormCreate(Sender: PObj);
var
  r : TREct;
begin
  //Disable system beep
  SystemParametersInfo(SPI_SETBEEP, 0, nil, SPIF_SENDWININICHANGE);
  //Enable system beep
  //SystemParametersInfo(SPI_SETBEEP, 1, nil, SPIF_SENDWININICHANGE);
  Form.KeyPreview := True;
  
  FMain.Form.Caption := 'KBBI Offline '+VERSI;
  LblEf1.Caption := 'Download, update dan informasi terbaru, kunjungi';
  LblEf2.Caption := 'http://ebsoft.web.id';
  LabelEffect1.Caption := 'Kamus Besar Bahasa Indonesia Luar Jaringan (Luring)';
  cbKriteria.Clear;
  cbKriteria.Add('Diawali');
  cbKriteria.Add('Diakhiri');
  cbKriteria.Add('Sama');
  cbKriteria.Add('Memuat');
  cbKriteria.Add('RegEx');

  { Application Hint }
  btnSetting.Hint.Text := 'Buka menu Pengaturan';
  btnHelp.Hint.Text := 'Panduan singkat istilah di KBBI Offline';
  btnAbout.Hint.Text := 'Tentang Program ini';
  btnCariKata.Hint.Text := 'Mencari kata';
  btnCariArti.Hint.Text := 'Mencari dari arti kata';
  chTepatSama.Hint.Text := 'Pencarian tepat sama huruf kecil dan besar';
  btnRandom.Hint.Text := 'Tampilkan kata acak dari KBBI (Ctrl+R)';

  LblEf1.Left := (form.Width - ( lblef1.Width + lblef2.Width )) div 2;
  LblEf2.Left := LblEf1.Left + LblEf1.Width + 3;
      
  ebCari.DoSetFocus;
  word_list  := NewStrList;
  word_def := NewStrList;

  hasil_all := NewStrList;
  hasil_main := NewStrList;
  hasil_add := NewStrList;

  Thread1.Resume;
  REdef.perform(EM_GETRECT, 0, lparam(@r));
  Inflaterect( r, - 5, - 5 );
  REdef.perform(EM_SETRECT, 0, lparam(@r));

  Tampilan := vIndent;
  OldHeight := Form.Height;
  REdef.Font.FontHeight := Round (12 * GetDeviceCaps (REdef.canvas.Handle, LogPixelsY) / 72);

  if FileExists(GetStartDir + 'kbbi_config.ini') then
  begin
    setting := OpenIniFile( GetStartDir + 'kbbi_config.ini');
    ReadSettings;
  end
  else
  begin
    AppDataDir := GetSpecialFolderPath($001C);
    if DirectoryExists(AppDataDir) then
    begin
      if not DirectoryExists(AppDataDir+'\ebsoft') then
        CreateDir(AppDataDir+'\ebsoft');

      if not DirectoryExists(AppDataDir+'\ebsoft\kbbi offline') then
        CreateDir(AppDataDir+'\ebsoft\kbbi offline');

        if DirectoryExists(AppDataDir+'\ebsoft\kbbi offline') then
        begin
          setting := OpenIniFile( AppDataDir+'\ebsoft\kbbi offline\kbbi_config.ini');
          ReadSettings;
        end;
    end;
  end; 
end;

{-------------------------------------------------------------------------------
  Procedure:   TFMain.TampilkanDef
  Author:      Ebta Setiawan
  Arguments:   kata :string
  Description
    - Menampilkan arti dari parameter kata (kata yang dipilih baik main/add)
    - Mengatur format font (bold,italic,warna,bck) berbagai kata
-------------------------------------------------------------------------------}
procedure TFMain.TampilkanDef(kata :string);
var
  i,j,k,l,sz : Integer;
  def,sw,stmp,sl,kd : string;
  sublemaMatch : Boolean;
  //start : DWORD;
begin
  if kata = curWord then Exit;
  //REdef.Clear;
  REdef.Text := '';
  stmp := word_def.Items[str2int(hasil_all.Values[kata])];
  stmp := GetListBold(stmp);
  def  := GetListItalic(stmp);
  REdef.Add(def);
  //REdef.Font.FontHeight := 16;

  REdef.BeginUpdate;
  //start := GetTickCount;

  k:=0;
  for i:= 0 to High(aListBold) do
  begin
    sw := aListBold[i].kata;
    // ambil kata dasarnya
    if i = 0 then kd := sw;
    l := Length(sw);
    if Str2Int(sw) = 0 then
      j := REdef.RE_WSearchText(sw,False,False,True,k,-1)
    else
      j := REdef.RE_WSearchText(sw,False,True,True,k,-1);

    if j > -1 then
    begin
      REdef.SelStart := j ;
      REdef.SelLength := l ;
      REdef.RE_FmtFontColor := clRed;

      sz := REDEf.RE_Font.FontHeight;
      if aListBold[i].x = 1 then
      begin
        { kata dasar }
        REdef.RE_FmtFontSize  := Round(sz*1.2);
        REdef.RE_FmtBackColor := clYellow;
      end
      else
      begin
        REdef.RE_FmtFontSize := Round(sz*1.1);

        { sub lema yang di hilangkan karakter pemisah B7 = #183 }
        sl := MyStrReplace(sw,#183,'');

        { kata yg di cari di sub-lema }
        l := PosFastcodeRTL('--',sl);
        if l = 0 then
        begin
          l := PosFastcodeRTL('~', sl);
        end;  


        { Test apakah Cari ada di sub-lema }
        if KriteriaCari = kcRegex then
        begin
          sl := kd + sl;
          sl := MyStrReplace(sl,'--','');
          sl := MyStrReplace(sl,'~','');
          sublemaMatch := PosFastcodeRTL(kata,sl) > 0;
        end
        else
        begin
          sublemaMatch := (sl = cari) or ((l>0) and (Pos(cari,sl)>0) );
        end;

        if sublemaMatch  then
          begin
            REdef.RE_FmtBackColor := clLime;
            REdef.RE_FmtFontColor := clBlack;
          end;
      end;

      { Indent x =9 }
      if aListBold[i].x = 9 then
      begin
        REdef.RE_StartIndent := 200;
        REdef.RE_Indent := 240;
      end;

      REdef.RE_FmtBold := True;

      { Atur Subscript}
      l := Length(sw);

      { huruf terakhir-1 adalah integer }
      if Str2Int(sw) = 0 then
        if Str2Int(sw[l-1])> 0 then
        begin
          REdef.SelStart := j + Length(sw) - 3;
          REdef.SelLength := 3;
          REdef.RE_FmtBold := false;
          REdef.RE_FmtFontColor := clBlack;
          REdef.RE_FmtFontSize := Round(sz*0.8);
          REdef.RE_FmtFontOffset := 100;
          REdef.RE_FmtBackColor := clWhite;
        end;   
    end;
    k := j + Length(sw);
  end;

  for i:= 0 to High(aListItalic) do
  begin
    sw := aListItalic[i].kata;
    k := aListItalic[i].x;
    l := Length(sw);
    j := REdef.RE_WSearchText(sw,False,False,True,k,-1);
    if j > -1 then
    begin
      REdef.SelStart := j ;
      REdef.SelLength := l ;

      if StrIn(LowerCase(Trim(sw)),JenisKata) then
        REdef.RE_FmtFontColor := clBlue
      else if PosFastcodeRTL('pb',sw) > 0 then
        REdef.RE_FmtFontColor := clPurple
      else
        REdef.RE_FmtFontColor := clGreen;

      REdef.RE_FmtItalic := True;
      REdef.RE_FmtBold := False;
      REdef.RE_FmtBackColor := clWhite;
    end;
  end;

  if isSearchArti then
  begin
    l := Length(curSearchArti);
    j := REdef.RE_WSearchText(curSearchArti,False,False,True,0,-1);
    while j > -1 do
    begin
      REdef.SelStart := j;
      REdef.SelLength := l;
      REdef.RE_FmtBackColor := clLime;
      REdef.RE_FmtFontColor := clBlack;
      j := REdef.RE_WSearchText(curSearchArti,False,False,True,j+l,-1);
    end;
  end;  

  REdef.EndUpdate;
  curWord := kata;
  //MsgOK(Int2Ths(GetTickCount-start));

  // diulang lagi fungsi pengecekan ini
  if not PnlBottom.Visible then
    PnlTop.Height := PanelWord.Height
  else
    PnlTop.Height := (PanelWord.Height - 43) div 2;
end;  

procedure TFMain.ebCariKeyUp(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if Key = 13 then
    CariKata(ebcari.Text)
end;

procedure TFMain.lbKataSelChange(Sender: PObj);
begin
  if lbKata.CurIndex = -1 then Exit;    
  TampilkanDef(lbKata.Items[lbKata.CurIndex]);

  if PnlBottom.Visible and (lbAdd.Count > 0)  then
    lbAdd.CurIndex := -1;
end;

procedure TFMain.lbAddSelChange(Sender: PObj);
begin
  if lbAdd.CurIndex = -1 then Exit;
  TampilkanDef(lbAdd.Items[lbAdd.CurIndex]);
  lbKata.CurIndex := -1;
end;


procedure TFMain.KOLForm1Close(Sender: PObj; var Accept: Boolean);
begin
  SaveFormPosition;
//  Free_And_Nil(word_list);
//  Free_And_Nil(hasil_main);
//  Free_And_Nil(hasil_all);
//  Free_And_Nil(word_def);
//  Free_And_Nil(hasil_add);
  word_list.Free;
  word_def.Free;
  hasil_all.Free;
  hasil_main.Free;
  hasil_add.Free;

  setting.Free;
end;

procedure TFMain.LblEf2Click(Sender: PObj);
begin
  ShellExecute(0, 'open', PChar(LblEf2.Caption), '', '', SW_SHOWNORMAL);
end;

procedure TFMain.LblEf2MouseMove(Sender: PControl;
  var Mouse: TMouseEventData);
begin
  LblEf2.Font.FontStyle := [fsUnderline,fsBold];
  LblEf2.Font.Color := clRed;
end;

procedure TFMain.LblEf2MouseLeave(Sender: PObj);
begin
  LblEf2.Font.FontStyle := [fsBold];
  LblEf2.Font.Color := clBlue;
end;

function TFMain.Thread1Execute(Sender: PThread): Integer;
var
  src,dst,rslt : PStream;
begin
  Result :=1;
  if not FileExists(GetStartDir+'data.dat') then
  begin
    MsgOK('File database kbbi "data.dat" tidak ditemukan');
    Exit;
  end;
  src := NewReadFileStream(GetStartDir+'data.dat');
  dst := NewMemoryStream;
  rslt := NewMemoryStream;
  Stream2Stream(dst,src,SZ_WORD);

  { Decompress Database }
  if NewUclDDStream(rslt,$7D000,dst,nil) then
    word_list.LoadFromStream(rslt,False);

  dst.Position := 0;
  src.Position := SZ_WORD;
  Stream2Stream(dst,src,SZ_DEF);


  rslt.Position :=0;
  if NewUclDDStream(rslt,$7D000,dst,nil) then
    word_def.LoadFromStream(rslt,False);
  
  dst.Free;
  src.Free;
  rslt.Free;
end;

procedure TFMain.btnAboutClick(Sender: PObj);
begin
  MsgOK('KBBI Offline Versi '+VERSI+#13#10+
    'Freeware �2010-2013 by Ebta Setiawan'+#13#10#13#10+

    'KBBI (Kamus Besar Bahasa Indonesia) Luar Jaringan (offline) dengan mengacu pada data'+#13#10+
    'dari KBBI Daring ( edisi III) diambil dari http://pusatbahasa.diknas.go.id/kbbi/'+#13#10+
    'Sekarang berganti di http://pusatbahasa.kemdiknas.go.id/kbbi/'+#13#10+
    'Database data merupakan hak cipta PusatBahasa'+#13#10+
    'Software ini gratis dan bebas disebarluaskan'+#13#10#13#10+

    'Download, Informasi, update, dukungan, masukan dan saran melalui:'+#13#10+
    'Website: http://ebsoft.web.id'+#13#10+
    'Email: ebta.setiawan@gmail.com'

  );
end;

procedure TFMain.KOLForm1Resize(Sender: PObj);
begin
  LblEf1.Left := ((form.Width - ( lblef1.Width + lblef2.Width )) div 2) - 3;
  LblEf2.Left := LblEf1.Left + LblEf1.Width + 3;
end;

procedure TFMain.ebCariChange(Sender: PObj);
begin
  if AutoSearch then
  begin
    if Trim(ebcari.Text) <> '' then
    begin
      CariKata(ebcari.Text);
    end;

    ebCari.DoSetFocus;
  end; 
end;

procedure TFMain.cbKriteriaKeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if Key = VK_TAB then
    ebCari.DoSetFocus;
end;

procedure TFMain.lbKataKeyUp(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if Key = VK_TAB then
    if lbAdd.Count > 0 then
      lbAdd.DoSetFocus
    else
  cbKriteria.DoSetFocus;
end;

procedure TFMain.lbAddKeyUp(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if Key = VK_TAB then
    cbKriteria.DoSetFocus;
end;

procedure TFMain.REdefKeyUp(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if Key = VK_TAB then
    cbKriteria.DoSetFocus;
end;

procedure TFMain.SaveFormPosition;
begin
  setting.Mode := ifmWrite;
  setting.ValueInteger('width',form.Width);
  setting.ValueInteger('height',form.Height);
  setting.ValueInteger('top',form.Top);
  setting.ValueInteger('left',form.Left);
end;

{-------------------------------------------------------------------------------
  Procedure:   TFMain.CariKata
  Author:      Ebta Setiawan
  Arguments:   const kata: string
  Description
    - Pencarian utama dari kata yang dimasukkan user
    - Hasil yang ditemukan dimasukkan dalam list main, add & all (main+add)
-------------------------------------------------------------------------------}
procedure TFMain.CariKata(const kata: string);
var
  i,k,m,n : Integer;
  start :DWORD;
  s,sk,sd : KOLstring;
  pCari : PAnsiChar;
  re : TRegExpr;
  reHasil : string;
begin
  hasil_main.Clear;
  hasil_add.Clear;
  hasil_all.Clear;
  start := GetTickCount;
  //j:=0; {Jumlah hasil_main ditemukan}
  //t:=0; {Jumlah hasil yang PosFastcodeRTL() = 1}

  cari := LowerCase(trim(kata));
  if trim(cari) = '' then Exit;
  { Kriteria Pencarian }
  if cbKriteria.Text = 'Diawali' then KriteriaCari := kcDiawali else
  if cbKriteria.Text = 'Diakhiri' then KriteriaCari := kcDiakhiri else
  if cbKriteria.Text = 'Sama' then KriteriaCari := kcSama else
  if cbKriteria.Text = 'Memuat' then KriteriaCari := kcMemuat else
  if cbKriteria.Text = 'RegEx' then
  begin
    KriteriaCari := kcRegex;
    re := TRegExpr.Create;
    re.Expression := kata;
  end;  
  
  { Yang dicari 1 huruf saja }
  if Length(cari) = 1 then
  begin
    if Str2Int(cari) = 0 then
      if cari[1] in ['a' .. 'z'] then
        cari := UpperCase(cari)+', '+cari;
  end;  

  isSearchArti := False;
  pCari := Pointer(cari);

  { Mulai Pencarian word_list }
  for i:=0 to word_list.Count-1 do
  begin
    s := word_list.ItemPtrs[i];
    if KriteriaCari = kcRegex then
      m := CariDgRegex(s,re,reHasil)
    else
      m := Pos2(pCari,word_list.ItemPtrs[i]);
      
    if m > 0 then
    begin
      { cari batas terakhir word_list pertama }
      k := PosFastcodeRTL('|',s);
      { !!PENTING... semua string harus ada pembatas akhir "|" }
      { Ambil word_list pertama }
      if k > 0 then
        sk := Copy(s,1,k-1);

      sd := sk;

      n := PosFastcodeRTL('^',sk);
      { ubah tanda ^N jika ada }
      if n > 0 then
      begin
        { sd : string kata dasar }
        sd := Copy(sd,1,n-1);
        StrReplace(sk,'^',' [');
        sk := sk+']';

        if k > 0 then k := k+2;
      end;

      { tambahkan index word_def, khusus regex,
        tambahkan hasil lema yang ditemukan, bukan kata dasarnya }
      if KriteriaCari = kcRegex then
        sk := reHasil + '=' + Int2Str(i)
      else
        sk := sk + '=' + Int2Str(i);

      { Semua hasil yg ditemukan, kelompokkan berdasar kriteria }
      case KriteriaCari of
        kcDiawali : if m = 1 then hasil_all.Add(sk);
        kcDiakhiri : if k = (m + Length(cari)) then hasil_all.Add(sk);
        kcSama : if sd = cari then hasil_all.Add(sk);
        kcMemuat,kcRegex : hasil_all.Add(sk);
      end;

      { Tambahkan index pos dengan 2 digit, untuk sorting
        fix in 1.3 : cari:abu -> kok abu-abu yg pertama..}
      if m = 1 then
      begin
        //Inc(t);
        if (length(sd) > Length(cari)) then
          sk := '02' + sk
        else
          sk := '01' + sk
      end
      else
        sk := '07' + sk;

      { Pisah jika yg dicari di word_list pertama }
      case KriteriaCari of
        kcDiawali : if m = 1 then hasil_main.Add(sk);
        kcDiakhiri : if k = (m + Length(cari)) then
          if m < k then hasil_main.Add(sk)
          else hasil_add.Add(sk);
        kcSama : if sd = cari then hasil_main.Add(sk);
        kcMemuat,kcRegex : if m < k then hasil_main.Add(sk)
          else hasil_add.Add(sk);
      end;

      //Inc(j);
      //if t = MaxList then Break;
    end;
  end;
  DisplayResult;

  Form.StatusText[0] := PChar(' Ditemukan '+ Int2Ths(hasil_all.Count)+ ' kata (' +
    Int2Ths(GetTickCount-start) + 'ms)');
end;

{-------------------------------------------------------------------------------
  Procedure:   TFMain.DisplayResult
  Author:      Ebta Setiawan
  Arguments:   None
  Description
    - Menampilkan daftar kata utama dan tambahan setelah pencarian
    - Menampilkan paging pertama main & add
    - Memilih/select hasil kata pertama (index=0) main/add jika ada
    - menampilkan informasi jika pencarian tidak menemukan data
-------------------------------------------------------------------------------}
procedure TFMain.DisplayResult;
var
  i,j,k,jml : Integer;
  s : string;
  //start : DWORD;
begin
  //start := GetTickCount;
  { Sort }
  hasil_main.Sort(False);

  lbKata.Clear;
  j := 0;

  // Paging
  jml := hasil_main.Count;
  PnlPageTop.Visible := jml > FMaxPage;
  btnPrev1.Enabled := false;
  btnNext1.Enabled := True;
  FCurrPageMain := 1;
  FJmlPageMain := (jml div FMaxPage)+1;
  lblMain.Caption := ' ada '+Int2Ths(FJmlPageMain) + ' hlm';

  LockWindowUpdate(lbKata.Handle);
  //for i:=hasil_main.Count-1 downto 0 do
  for i:=0 to jml-1 do
  begin
    s := hasil_main.Items[i];
    { Hilangkan lagi tambahan 2 digit }
    k := PosFastcodeRTL('=',s);
    {Ambil setelah karakter ke-2 }
    lbKata.Add( copy(s,3,k-3));
    Inc(j);
    if j = FMaxPage then Break;
  end;
  LockWindowUpdate(0);

  { Sort }
  hasil_add.Sort(False);

  if (hasil_add.Count = 0) and (jml > 5 ) then
  begin
    PnlTop.Height := PanelWord.Height;
    PnlBottom.Visible := False;
  end
  else
  begin
    PnlTop.Height := (PanelWord.Height - 43) div 2;
    PnlBottom.Visible := True;

    // Paging
    PnlPageBottom.Visible := hasil_add.Count > FMaxPage;
    btnPrev2.Enabled := false;
    btnNext2.Enabled := True;
    FCurrPageAdd := 1;
    FJmlPageAdd := (hasil_add.Count div FMaxPage) + 1;
    lblAdd.Caption := ' ada '+Int2Ths(FJmlPageAdd) + ' hlm';


    lbAdd.Clear;
    j := 0;
    LockWindowUpdate(lbAdd.Handle);
    //for i:=hasil_add.Count-1 downto 0 do
    for i:=0 to hasil_add.Count-1 do
    begin
      s := hasil_add.Items[i];
      { Hilangkan lagi tambahan 2 digit }
      k := PosFastcodeRTL('=',s);
      {Ambil setelah karakter ke-2 }
      lbAdd.Add(copy(s,3,k-3));
      Inc(j);
      if j = FMaxPage then Break;
    end;
    LockWindowUpdate(0);
  end;
     
  Form.StatusText[0] := PChar(' Ditemukan '+ Int2Ths(hasil_all.Count)+ ' kata');
  // ('+ Int2Ths(GetTickCount-start) + 'ms)');

  if hasil_all.Count = 0 then
  begin
    REDEf.Clear;
    REdef.Add('Tidak ditemukan pencarian kata "'+cari+'"');
    curWord := '';
    Exit;
  end;
//  else
//    ShowMessage('Ditemukan:'+ Int2Str(hasil_all.Count));

  { Tampilkan definisi kata pertama }
  if lbKata.Count > 0 then
  begin
    lbKata.CurIndex :=0;
    lbKataSelChange(nil);
  end
  else if lbAdd.Count > 0 then
  begin
    lbAdd.CurIndex :=0;
    lbAddSelChange(nil);
  end
end;

{-------------------------------------------------------------------------------
  Procedure:   TFMain.DisplayResultMain
  Author:      Ebta Setiawan
  Arguments:   page: Integer
  Description
    - Mengatur Paging List Main word 
-------------------------------------------------------------------------------}
procedure TFMain.DisplayResultMain(page: Integer);
var
  i,k,awal,akhir : Integer;
begin
//  akhir := (hasil_main.Count -1) - (FMaxPage * (page-1));
//  awal := hasil_main.Count - ( FMaxPage * page);
  awal  := FMaxPage * (page-1);
  akhir := (FMaxPage * page)-1;
  
  if akhir > (hasil_main.Count-1) then
    akhir := hasil_main.Count -1;
  if awal < 0 then awal :=0;

  lbKata.Clear;
  LockWindowUpdate(lbKata.Handle);
  //for i:= akhir downto awal do
  for i:= awal to akhir do
  begin
    { Hilangkan lagi tambahan 2 digit }
    k := PosFastcodeRTL('=',hasil_main.Items[i]);
    {Ambil setelah karakter ke-2 }
    lbKata.Add( copy(hasil_main.Items[i],3,k-3));
  end;
  LockWindowUpdate(0);
end;

{-------------------------------------------------------------------------------
  Procedure:   TFMain.DisplayResultAdd
  Author:      Ebta Setiawan
  Arguments:   page: Integer
  Description
    - Mengatur paging list add word
-------------------------------------------------------------------------------}
procedure TFMain.DisplayResultAdd(page: Integer);
var
  i,k,awal,akhir : Integer;
begin
//  akhir := (hasil_add.Count -1) - (FMaxPage * (page-1));
//  awal := hasil_add.Count - ( FMaxPage * page);

  awal  := FMaxPage * (page-1);
  akhir := (FMaxPage * page)-1;


  if akhir > (hasil_add.Count-1) then
    akhir := hasil_add.Count -1;
  if awal < 0 then awal :=0;

  lbAdd.Clear;
  LockWindowUpdate(lbAdd.Handle);
  //for i:= akhir downto awal do
  for i:= awal to akhir do
  begin
    { Hilangkan lagi tambahan 2 digit }
    k := PosFastcodeRTL('=',hasil_add.Items[i]);
    {Ambil setelah karakter ke-2 }
    lbAdd.Add( copy(hasil_add.Items[i],3,k-3));
  end;
  LockWindowUpdate(0);
end;

procedure TFMain.btnNext1Click(Sender: PObj);
begin
  if FCurrPageMain < FJmlPageMain then
  begin
    Inc(FCurrPageMain);
    DisplayResultMain(FCurrPageMain);
    lblMain.Caption := ' hlm ' + Int2Ths(FCurrPageMain) + ' dari ' +
      Int2Ths(FJmlPageMain);
  end;

  if  FCurrPageMain >= FJmlPageMain then
    btnNext1.Enabled := False;
  btnPrev1.Enabled := True;
end;

procedure TFMain.btnPrev1Click(Sender: PObj);
begin
  if FCurrPageMain > 1 then
  begin
    Dec(FCurrPageMain);
    DisplayResultMain(FCurrPageMain);
    lblMain.Caption := ' hlm ' + Int2Ths(FCurrPageMain) + ' dari ' +
      Int2Ths(FJmlPageMain);
  end;

  if FCurrPageMain <= 1 then
    btnPrev1.Enabled := False;

  btnNext1.Enabled := True;
end;



procedure TFMain.btnNext2Click(Sender: PObj);
begin
  if FCurrPageAdd < FJmlPageAdd then
  begin
    Inc(FCurrPageAdd);
    DisplayResultAdd(FCurrPageAdd);
    lblAdd.Caption := ' hlm ' + Int2Ths(FCurrPageAdd) + ' dari ' +
      Int2Ths(FJmlPageAdd);
  end;

  if  FCurrPageAdd >= FJmlPageAdd then
    btnNext2.Enabled := False;
  btnPrev2.Enabled := True;
end;

procedure TFMain.btnPrev2Click(Sender: PObj);
begin
  if FCurrPageAdd > 1 then
  begin
    Dec(FCurrPageAdd);
    DisplayResultAdd(FCurrPageAdd);
    lblAdd.Caption := ' hlm ' + Int2Ths(FCurrPageAdd) + ' dari ' +
      Int2Ths(FJmlPageAdd);
  end;

  if FCurrPageAdd <= 1 then
    btnPrev2.Enabled := False;

  btnNext2.Enabled := True;
end;

(*
CSIDL_DESKTOP                       = $0000; { <desktop> }
  CSIDL_INTERNET                      = $0001; { Internet Explorer (icon on desktop) }
  CSIDL_PROGRAMS                      = $0002; { Start Menu\Programs }
  CSIDL_CONTROLS                      = $0003; { My Computer\Control Panel }
  CSIDL_PRINTERS                      = $0004; { My Computer\Printers }
  CSIDL_PERSONAL                      = $0005; { My Documents.  This is equivalent to CSIDL_MYDOCUMENTS in XP and above }
  CSIDL_FAVORITES                     = $0006; { <user name>\Favorites }
  CSIDL_STARTUP                       = $0007; { Start Menu\Programs\Startup }
  CSIDL_RECENT                        = $0008; { <user name>\Recent }
  CSIDL_SENDTO                        = $0009; { <user name>\SendTo }
  CSIDL_BITBUCKET                     = $000a; { <desktop>\Recycle Bin }
  CSIDL_STARTMENU                     = $000b; { <user name>\Start Menu }
  CSIDL_MYDOCUMENTS                   = $000c; { logical "My Documents" desktop icon }
  CSIDL_MYMUSIC                       = $000d; { "My Music" folder }
  CSIDL_MYVIDEO                       = $000e; { "My Video" folder }
  CSIDL_DESKTOPDIRECTORY              = $0010; { <user name>\Desktop }
  CSIDL_DRIVES                        = $0011; { My Computer }
  CSIDL_NETWORK                       = $0012; { Network Neighborhood (My Network Places) }
  CSIDL_NETHOOD                       = $0013; { <user name>\nethood }
  CSIDL_FONTS                         = $0014; { windows\fonts }
  CSIDL_TEMPLATES                     = $0015;
  CSIDL_COMMON_STARTMENU              = $0016; { All Users\Start Menu }
  CSIDL_COMMON_PROGRAMS               = $0017; { All Users\Start Menu\Programs }
  CSIDL_COMMON_STARTUP                = $0018; { All Users\Startup }
  CSIDL_COMMON_DESKTOPDIRECTORY       = $0019; { All Users\Desktop }
  CSIDL_APPDATA                       = $001a; { <user name>\Application Data }
  CSIDL_PRINTHOOD                     = $001b; { <user name>\PrintHood }
  CSIDL_LOCAL_APPDATA                 = $001c; { <user name>\Local Settings\Application Data (non roaming) }
  CSIDL_ALTSTARTUP                    = $001d; { non localized startup }
  CSIDL_COMMON_ALTSTARTUP             = $001e; { non localized common startup }
  CSIDL_COMMON_FAVORITES              = $001f;
  CSIDL_INTERNET_CACHE                = $0020;
  CSIDL_COOKIES                       = $0021;
  CSIDL_HISTORY                       = $0022;
  CSIDL_COMMON_APPDATA                = $0023; { All Users\Application Data }
  CSIDL_WINDOWS                       = $0024; { GetWindowsDirectory() }
  CSIDL_SYSTEM                        = $0025; { GetSystemDirectory() }
  CSIDL_PROGRAM_FILES                 = $0026; { C:\Program Files }
  CSIDL_MYPICTURES                    = $0027; { C:\Program Files\My Pictures }
  CSIDL_PROFILE                       = $0028; { USERPROFILE }
  CSIDL_SYSTEMX86                     = $0029; { x86 system directory on RISC }
  CSIDL_PROGRAM_FILESX86              = $002a; { x86 C:\Program Files on RISC }
  CSIDL_PROGRAM_FILES_COMMON          = $002b; { C:\Program Files\Common }
  CSIDL_PROGRAM_FILES_COMMONX86       = $002c; { x86 C:\Program Files\Common on RISC }
  CSIDL_COMMON_TEMPLATES              = $002d; { All Users\Templates }
  CSIDL_COMMON_DOCUMENTS              = $002e; { All Users\Documents }
  CSIDL_COMMON_ADMINTOOLS             = $002f; { All Users\Start Menu\Programs\Administrative Tools }
  CSIDL_ADMINTOOLS                    = $0030; { <user name>\Start Menu\Programs\Administrative Tools }
  CSIDL_CONNECTIONS                   = $0031; { Network and Dial-up Connections }
  CSIDL_COMMON_MUSIC                  = $0035; { All Users\My Music }
  CSIDL_COMMON_PICTURES               = $0036; { All Users\My Pictures }
  CSIDL_COMMON_VIDEO                  = $0037; { All Users\My Video }
  CSIDL_RESOURCES                     = $0038; { Resource Directory }
  CSIDL_RESOURCES_LOCALIZED           = $0039; { Localized Resource Directory }
  CSIDL_COMMON_OEM_LINKS              = $003a; { Links to All Users OEM specific apps }
  CSIDL_CDBURN_AREA                   = $003b; { USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning }
  CSIDL_COMPUTERSNEARME               = $003d; { Computers Near Me (computered from Workgroup membership) }
  CSIDL_PROFILES                      = $003e;
*)


function TFMain.GetSpecialFolderPath(folder : integer) : string;
 const
   SHGFP_TYPE_CURRENT = 0;
 var
   path: array [0..MAX_PATH] of char;
 begin
   if SUCCEEDED(SHGetFolderPath(0,folder,0,SHGFP_TYPE_CURRENT,@path[0])) then
     Result := path
   else
     Result := '';
 end;

procedure TFMain.btnCariKataClick(Sender: PObj);
begin
  CariKata(ebcari.Text);
end;

procedure TFMain.btnSettingClick(Sender: PObj);
begin
  NewFSetting(FSetting,FMain.Form);
  FSetting.Form.ShowModal;
  FSetting.form.Free;
end;

procedure TFMain.KOLForm1Show(Sender: PObj);
begin
  ebCari.DoSetFocus;
end;

procedure TFMain.ebKalimatKeyUp(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if Key = 13 then
    CariArti(ebKalimat.Text);
end;

procedure TFMain.CariArti(const arti: string);
var
  i,k,m,n : Integer;
  start :DWORD;
  s,sk,sd : KOLstring;
  pCari : PAnsiChar;
begin
  hasil_main.Clear;
  hasil_add.Clear;
  hasil_all.Clear;
  start := GetTickCount;
  //j:=0; {Jumlah hasil_main ditemukan}
  //t:=0; {Jumlah hasil yang PosFastcodeRTL() = 1}

  cari := LowerCase(trim(arti));
  if trim(cari) ='' then Exit;
  
  { Yang dicari 1 huruf saja }
  if Length(cari) < 3 then
  begin
    MsgOK('Pencarian minimal 3 huruf');
    Exit;
  end;  

  isSearchArti := True;
  curSearchArti := cari;
  pCari := Pointer(cari);

  if chTepatSama.Checked then
    pCari := Pointer(arti);

  { Mulai Pencarian word_list }
  for i:=0 to word_list.Count-1 do
  begin
    //s := word_list.Items[i];
    if chTepatSama.Checked then
      m := Pos2(pCari, word_def.ItemPtrs[i])
    else
      m := PosFastcodeRTL(pCari, LowerCase(word_def.Items[i]) );
      
    if m > 0 then
    begin
      s := word_list.ItemPtrs[i];
      { cari batas terakhir word_list pertama }
      k := PosFastcodeRTL('|',s);
      { !!PENTING... semua string harus ada pembatas akhir "|" }
      { Ambil word_list pertama }
      if k > 0 then
        sk := Copy(s,1,k-1);

      { sd : string kata dasar }
      sd := sk;
      n := PosFastcodeRTL('^',sk);
      { ubah tanda ^N jika ada }
      if n > 0 then
      begin
        sd := Copy(sd,1,n-1);
        StrReplace(sk,'^',' [');
        sk := sk+']';
      end;

      { tambahkan index word_def }
      sk := sk + '=' + Int2Str(i);
      hasil_all.Add(sk);

      { Tambahkan index pos dengan 2 digit, untuk sorting
        fix in 1.3 : cari:abu -> kok abu-abu yg pertama..}
      if m = 1 then
      begin
        //Inc(t);
        if (length(sd) > Length(cari)) then
          sk := '02' + sk
        else
          sk := '01' + sk
      end
      else
        sk := '07' + sk;

      hasil_main.Add(sk);
      
      //Inc(j);
      //if t = MaxList then Break;
    end;
  end;
  //ShowMessage('hasil_all:' + Int2Str(hasil_all.Count) + ' hasil_main:'+ Int2Str(hasil_main.Count));
  DisplayResult;

  Form.StatusText[0] := PChar(' Ditemukan '+ Int2Ths(hasil_all.Count)+ ' kata (' +
    Int2Ths(GetTickCount-start) + 'ms)');

end;

procedure TFMain.chTepatSamaClick(Sender: PObj);
begin
  curSearchArti := '';
  setting.Mode := ifmWrite;
  setting.ValueBoolean('Huruf Sama',chTepatSama.Checked);
end;

procedure TFMain.btnCariArtiClick(Sender: PObj);
begin
  CariArti(ebKalimat.Text);
end;

procedure TFMain.btnHelpClick(Sender: PObj);
begin
  NewFHelp(FHelp,FMain.Form);
  FHelp.Form.ShowModal;
  FHelp.form.Free;
end;

procedure TFMain.cbKriteriaChange(Sender: PObj);
begin
  ebCariChange(Sender);
  setting.Mode := ifmWrite;
  setting.ValueInteger('Kriteria',cbKriteria.CurIndex)
end;

procedure TFMain.ReadSettings;
var
  x : Integer;
begin
  setting.Mode := ifmRead;
  setting.Section := 'KBBI '+ VERSI;
  Form.Width := setting.ValueInteger('width',600);
  Form.Height :=  setting.ValueInteger('height',480);
  Form.Top :=  setting.ValueInteger('top',(ScreenHeight-form.Height) div 2);
  Form.Left :=  setting.ValueInteger('left',(ScreenWidth-form.Width) div 2);
  FMaxPage  := setting.ValueInteger('MaxPage',300);
  AutoSearch := setting.ValueBoolean('Auto Search',false);

  x := setting.ValueInteger('Kriteria',0);
  if (x < 0) or (x>4) then
    x := 0;
  cbKriteria.CurIndex := x;
end;

function TFMain.CariDgRegex(kata: string; const regex : TRegExpr; out lema: string) : Integer;
var
  n,i,j : Integer;
  subWord : string;
begin
  Result := -1;
  i  := PosFastcodeRTL('|',kata);
  if i < 1 then Exit;

  n := 1;
  while i > 0 do
  begin
    subWord := Copy(kata,n,i-n);

    j := PosFastcodeRTL('^',subWord);
    if j > 0 then
    begin
      subWord := Copy(subWord,1,j-1);
    end;  

    if regex.Exec(subWord) then
    begin
      Result := n+1;
      lema := subWord;
      Break;
    end;
    n := i+1;
    i := PosEx('|',kata,n);
  end;
end;

procedure TFMain.btnRandomClick(Sender: PObj);
var
  i,max,n,k : Integer;
  word,sk :  string;
begin
  Randomize;
  setting.Mode := ifmRead;
  max := setting.ValueInteger('RandomCount',20);

  hasil_main.Clear;
  hasil_add.Clear;
  hasil_all.Clear;
  for i:=0 to max-1 do
  begin
    n := Random(word_list.Count);
    word := word_list.Items[n];

    { cari batas terakhir word_list pertama }
    k := PosFastcodeRTL('|',word);
    { !!PENTING... semua string harus ada pembatas akhir "|" }
    { Ambil word_list pertama }
    if k > 0 then
      sk := Copy(word,1,k-1);

    k := PosFastcodeRTL('^',sk);
    { ubah tanda ^N jika ada }
    if k > 0 then
    begin
      StrReplace(sk,'^',' [');
      sk := sk+']';
    end;

    { tambahkan index word_def, khusus regex,
      tambahkan hasil lema yang ditemukan, bukan kata dasarnya }
    sk := sk + '=' + Int2Str(n);
    hasil_all.Add(sk);
    hasil_main.Add('01'+sk);
  end;
  DisplayResult;
end;

procedure TFMain.KOLForm1KeyUp(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if (Shift=8) and (Key = Ord('R')) then
    btnRandom.Click;
end;

end.



