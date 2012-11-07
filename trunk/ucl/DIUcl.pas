{ ------------------------------------------------------------------------------

  DIUcl.pas -- UCL Compression Library for Borland Delphi

  This file is part of the DIUcl package.

  Copyright (c) 2003-2010 Ralf Junker - The Delphi Inspiration
  All Rights Reserved.

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

  Ralf Junker - The Delphi Inspiration
  <delphi@yunqa.de>
  http://www.yunqa.de/delphi/

  UCL is Copyright (c) 1996-2002 Markus Franz Xaver Johannes Oberhumer
  All Rights Reserved.

  Markus F.X.J. Oberhumer
  <markus@oberhumer.com>
  http://www.oberhumer.com/opensource/ucl/

------------------------------------------------------------------------------ }

unit DIUcl;

{$I DI.inc}

interface

uses
  DISystemCompat;

function UclCompressStrA(
  const s: AnsiString;
  const CompressionLevel: Integer = 10): AnsiString;

function UclDecompressStrA(
  const s: AnsiString): AnsiString;

function UclCompressStrW(
  const s: UnicodeString;
  const CompressionLevel: Integer = 10): UnicodeString;

function UclDecompressStrW(
  const s: UnicodeString): UnicodeString;

implementation

uses
  DIUclApi;

function UclCompressStrA(const s: AnsiString; const CompressionLevel: Integer = 10): AnsiString;
label
  Fail;
var
  l, u: Cardinal;
begin
  l := Length(s);
  if l = 0 then goto Fail;
  u := ucl_output_block_size(l);
  SetString(Result, nil, u + 4);
  if ucl_nrv2e_99_compress(Pointer(s), l, Pointer(Cardinal(Result) + 4), u, nil, CompressionLevel, nil, nil) <> UCL_E_OK then
    goto Fail;

  if u < l then
    begin
      PCardinal(Result)^ := l;
      SetLength(Result, u + 4);
    end
  else
    begin
      PCardinal(Result)^ := 0;
      Move(Pointer(s)^, Pointer(Cardinal(Result) + 4)^, l);
      SetLength(Result, l + 4);
    end;

  Exit;

  Fail:
  Result := '';
end;

function UclDecompressStrA(const s: AnsiString): AnsiString;
label
  Fail;
var
  l, u: Cardinal;
begin
  l := Length(s);
  if l < 4 then goto Fail;
  u := PCardinal(s)^;

  if u <> 0 then
    begin
      SetString(Result, nil, u);
      if ucl_nrv2e_decompress_asm_safe_8(Pointer(Cardinal(s) + 4), l - 4, Pointer(Result), u, nil) <> UCL_E_OK then
        goto Fail;
    end
  else
    begin
      Dec(l, 4);
      SetString(Result, nil, l);
      Move(Pointer(Cardinal(s) + 4)^, Pointer(Result)^, l);
    end;

  Exit;

  Fail:
  Result := '';
end;

function UclCompressStrW(const s: UnicodeString; const CompressionLevel: Integer = 10): UnicodeString;
label
  Fail;
var
  l, u: Cardinal;
begin
  l := Length(s);
  if l = 0 then goto Fail;

  l := l * SizeOf(s[1]);

  u := (ucl_output_block_size(l) + 1) and not 1;
  SetString(Result, nil, u div SizeOf(Result[1]) + 2);
  if ucl_nrv2e_99_compress(Pointer(s), l, Pointer(Cardinal(Result) + 4), u, nil, CompressionLevel, nil, nil) <> UCL_E_OK then
    goto Fail;

  if u < l then
    begin

      PCardinal(Result)^ := l or (u and 1);
      SetLength(Result, (u + 1) shr 1 + 2);
    end
  else
    begin
      PCardinal(Result)^ := 0;
      Move(Pointer(s)^, Pointer(Cardinal(Result) + 4)^, l);
      SetLength(Result, l shr 1 + 2);
    end;

  Exit;

  Fail:
  Result := '';
end;

function UclDecompressStrW(const s: UnicodeString): UnicodeString;
label
  Fail;
var
  l, u: Cardinal;
  r: Integer;
begin
  l := Length(s) * SizeOf(s[1]);
  if l < 4 then goto Fail;
  u := PCardinal(s)^;

  if u <> 0 then
    begin

      if u and 1 <> 0 then
        Dec(l);
      SetString(Result, nil, u shr 1);
      r := ucl_nrv2e_decompress_asm_safe_8(Pointer(Cardinal(s) + 4), l - 4, Pointer(Result), u, nil);
      if r <> UCL_E_OK then
        goto Fail;
    end
  else
    begin
      Dec(l, 4);
      SetString(Result, nil, l shr 1);
      Move(Pointer(Cardinal(s) + 4)^, Pointer(Result)^, l);
    end;

  Exit;

  Fail:
  Result := '';
end;

end.

