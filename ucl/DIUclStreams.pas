{ ------------------------------------------------------------------------------

  DIUclStreams.pas -- UCL Compression and Decompression Streams

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

  UCL is Copyright (c) 1996-2004 Markus Franz Xaver Johannes Oberhumer
  All Rights Reserved.

  Markus F.X.J. Oberhumer
  <markus@oberhumer.com>
  http://www.oberhumer.com/opensource/ucl/

------------------------------------------------------------------------------ }

unit DIUclStreams;

{$I DI.inc}

interface

uses
  {$IFDEF KOL}
  Windows, KOL
  {$ELSE KOL}
  SysUtils, Classes, DIUclApi
  {$ENDIF KOL} ;

{$IFDEF KOL}
const
  STREAM_ERROR = $FFFFFFFF;

type
  TUclProgressEvent = procedure(const Sender: PObj; const InBytes, OutBytes: Cardinal) of object;

function NewUclCStream(
  const CompressionLevel: Integer;
  const BufferSize: Cardinal;
  const Destination: PStream;
  const OnProgress: TUclProgressEvent = nil): PStream;

function NewUclCCStream(
  out Stream: PStream;
  const CompressionLevel: Integer;
  BufferSize: Cardinal;
  const Destination: PStream;
  OnProgress: TUclProgressEvent = nil): Boolean;

function NewUclDStream(
  const BufferSize: Cardinal;
  const Source: PStream;
  const OnProgress: TUclProgressEvent = nil): PStream;

function NewUclDDStream(
  out Stream: PStream;
  const BufferSize: Cardinal;
  const Source: PStream;
  const OnProgress: TUclProgressEvent = nil): Boolean;

function UclCFlushStream(Strm: PStream): Boolean;

function KOL_Stream_Copy(Dest, Source: PStream; Count: Int64 = 0): Int64;

{$ELSE KOL}

type
  TUclCustomStream = class;

  TUclProgressEvent = procedure(const Sender: TUclCustomStream; const InBytes, OutBytes: Cardinal) of object;

  TUclCustomStream = class(TStream)
  private
    FStream: TStream;
    FBuffer: ^Byte;
    FBufferPos: ^Byte;
    FBufferSize: Cardinal;
    FBufferAlloc: Cardinal;
    FBufferFree: Cardinal;
    FTotalIn: Cardinal;
    FTotalOut: Cardinal;
    FOnProgress: TUclProgressEvent;
    class procedure ErrorCheck(const ErrorCode: Integer);
  protected
    class procedure Error(const ResStringRec: PResStringRec; const Args: array of const);

    procedure DoProgress(const InBytes, OutBytes: Cardinal); dynamic;

    property OnProgress: TUclProgressEvent read FOnProgress write FOnProgress;
  public

    constructor Create(const BufferSize: Cardinal; const Stream: TStream);

    destructor Destroy; override;
  end;

  TUclCompressionStream = class(TUclCustomStream)
  private
    FBufferStart: ^Byte;
    FCallback: ucl_progress_callback_t;
    FCompressionLevel: Integer;
  public

    constructor Create(const CompressionLevel: Integer; const BufferSize: Cardinal; const Dest: TStream);

    destructor Destroy; override;

    procedure Flush;

    function Read(var Buffer; Count: Integer): Integer; override;

    function Write(const Buffer; Count: Integer): Integer; override;

    function Seek(Offset: Integer; Origin: Word): Integer; override;

    property OnProgress;
  end;

  TUclDeCompressionStream = class(TUclCustomStream)
  public

    function Read(var Buffer; Count: Integer): Integer; override;

    function Write(const Buffer; Count: Integer): Integer; override;

    function Seek(Offset: Integer; Origin: Word): Integer; override;

    property OnProgress;
  end;

  EUclError = class(Exception);

resourcestring
  SUclError = 'UCL Error %d';
  SInvalidUclStreamData = 'Invalid UCL stream data';
  SInvalidUclStreamOperation = 'Invalid UCL stream operation';
  {$ENDIF KOL}

type

  TUclProgress = procedure(const InBytes, OutBytes: Cardinal; const User: Pointer);

function UclCompressStream(
  const AInStream: {$IFDEF KOL}PStream{$ELSE}TStream{$ENDIF};
  const AOutStream: {$IFDEF KOL}PStream{$ELSE}TStream{$ENDIF};
  const ACompressionLevel: Integer = 10;
  const ABufferSize: Cardinal = $1000;
  const AOnProgress: TUclProgress = nil;
  const AUser: Pointer = nil): Boolean;

function UclDeCompressStream(const AInStream, AOutStream: {$IFDEF KOL}PStream{$ELSE}TStream{$ENDIF}; const ABufferSize: Cardinal = $1000; const AOnProgress: TUclProgress = nil; const AUser: Pointer = nil): Boolean;

implementation

{$IFDEF KOL}

uses
  DIUclApi;

{$UNDEF KOL_STREAM_CONST_ARGS}
{$IFNDEF STREAM_COMPAT}
{$DEFINE KOL_STREAM_CONST_ARGS}
{$ENDIF STREAM_COMPAT}

{$ELSE KOL}

uses
  {$IFDEF COMPILER_6_UP}RTLConsts{$ELSE}Consts{$ENDIF};

{$ENDIF KOL}

type
  PUclUser = ^TUclUser;
  TUclUser = record
    InBytes: Cardinal;
    OutBytes: Cardinal;
    OnProgress: TUclProgress;
    User: Pointer;
  end;

procedure UclCompressStreamCallback(ATextSize: Cardinal; ACodeSize: Cardinal; AState: Integer; AUser: Pointer);
begin
  with PUclUser(AUser)^ do
    OnProgress(InBytes + ATextSize, OutBytes + ACodeSize, User);
end;

function UclCompressStream(
  const AInStream, AOutStream: {$IFDEF KOL}PStream{$ELSE}TStream{$ENDIF};
  const ACompressionLevel: Integer = 10;
  const ABufferSize: Cardinal = $1000;
  const AOnProgress: TUclProgress = nil;
  const AUser: Pointer = nil): Boolean;
var
  b, s: ^Byte;
  a, r, f: Cardinal;
  Callback: ucl_progress_callback_t;
  cb: ucl_progress_callback_p;
  User: TUclUser;
begin
  if Assigned(AOnProgress) then
    begin
      User.InBytes := 0;
      User.OutBytes := 0;
      User.OnProgress := AOnProgress;
      User.User := AUser;
      Callback.Callback := UclCompressStreamCallback;
      Callback.User := @User;
      cb := @Callback;
    end
  else
    cb := nil;

  a := ucl_output_block_size(ABufferSize);
  GetMem(b, a);
  try
    s := b;
    Inc(s, a - ABufferSize);
    r := AInStream.Read(s^, ABufferSize);
    if r > 0 then
      repeat
        f := ABufferSize;
        Result := ucl_nrv2e_99_compress(s, r, b, f, cb, ACompressionLevel, nil, nil) = UCL_E_OK;
        if not Result then Break;
        Result := AOutStream.Write(f, SizeOf(f)) = SizeOf(f);
        if not Result then Break;
        Result := Cardinal(AOutStream.Write(b^, f)) = f;
        if not Result then Break;
        if Assigned(cb) then
          begin
            Inc(User.InBytes, r);
            Inc(User.OutBytes, f);
          end;
        r := AInStream.Read(s^, ABufferSize);
      until r = 0
    else
      Result := True;
  finally
    FreeMem(b);
  end;
end;

function UclDeCompressStream(const AInStream, AOutStream: {$IFDEF KOL}PStream{$ELSE}TStream{$ENDIF}; const ABufferSize: Cardinal = $1000; const AOnProgress: TUclProgress = nil; const AUser: Pointer = nil): Boolean;
label
  Fail;
var
  b, s: ^Byte;
  a, f, r, InBytes, OutBytes: Cardinal;
begin
  a := ucl_output_block_size(ABufferSize);
  InBytes := 0;
  OutBytes := 0;
  GetMem(b, a);
  try
    repeat
      f := AInStream.Read(r, SizeOf(r));
      Result := f = 0;
      if Result then Break;
      Result := f = SizeOf(r);
      if not Result then Break;
      Result := r <= a;
      if not Result then Break;
      s := b;
      Inc(s, a - r);
      Result := Cardinal(AInStream.Read(s^, r)) = r;
      if not Result then Break;
      f := a;
      {$IFDEF KOL}
      Result := ucl_nrv2e_decompress_asm_safe_8(s, r, b, f, nil) = UCL_E_OK;
      {$ELSE}
      Result := ucl_nrv2e_decompress_asm_fast_safe_8(s, r, b, f, nil) = UCL_E_OK;
      {$ENDIF}
      if not Result then Break;
      Result := Cardinal(AOutStream.Write(b^, f)) = f;
      if not Result then Break;
      if Assigned(AOnProgress) then
        begin
          Inc(InBytes, r);
          Inc(OutBytes, f);
          AOnProgress(InBytes, OutBytes, AUser);
        end;
    until False;
  finally
    FreeMem(b);
  end;
end;

{$IFDEF KOL}
type
  TUclCData = record
    FStream: PStream;
    FBuffer: ^Byte;
    FBufferPos: ^Byte;
    FBufferSize: Cardinal;
    FBufferAlloc: Cardinal;
    FBufferFree: Cardinal;
    FTotalIn: Cardinal;
    FTotalOut: Cardinal;
    FOnProgress: TUclProgressEvent;
    FBufferStart: ^Byte;
    FCallback: ucl_progress_callback_t;
    FCompressionLevel: Integer;
  end;
  PUclCData = ^TUclCData;

  TUclDData = record
    FStream: PStream;
    FBuffer: ^Byte;
    FBufferPos: ^Byte;
    FBufferSize: Cardinal;
    FBufferAlloc: Cardinal;
    FBufferFree: Cardinal;
    FTotalIn: Cardinal;
    FTotalOut: Cardinal;
    FOnProgress: TUclProgressEvent;
  end;
  PUclDData = ^TUclDData;
  {$ENDIF KOL}

  {$IFNDEF KOL}
constructor TUclCustomStream.Create(const BufferSize: Cardinal; const Stream: TStream);
begin
  inherited Create;
  ErrorCheck(ucl_init);
  FStream := Stream;
  FBufferSize := BufferSize;
  FBufferAlloc := ucl_output_block_size(BufferSize);
  GetMem(FBuffer, FBufferAlloc);
end;
{$ENDIF KOL}

{$IFNDEF KOL}
destructor TUclCustomStream.Destroy;
begin
  FreeMem(FBuffer);
  inherited Destroy;
end;
{$ENDIF KOL}

{$IFNDEF KOL}
procedure TUclCustomStream.DoProgress(const InBytes, OutBytes: Cardinal);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, InBytes, OutBytes);
end;
{$ENDIF KOL}

{$IFNDEF KOL}
class procedure TUclCustomStream.Error(const ResStringRec: PResStringRec; const Args: array of const);
  function ReturnAddr: Pointer;
  asm
    mov eax, [ebp + 4]
  end;
begin
  raise EUclError.CreateFmt('Class ' + ClassName + ': ' + LoadResString(ResStringRec), Args)At ReturnAddr;
end;
{$ENDIF KOL}

{$IFNDEF KOL}
class procedure TUclCustomStream.ErrorCheck(const ErrorCode: Integer);
begin
  if ErrorCode <> UCL_E_OK then
    Error(PResStringRec(@SUclError), [ErrorCode]);
end;
{$ENDIF KOL}

procedure UclCompressionCallback(TextSize: Cardinal; CodeSize: Cardinal; State: Integer; User: Pointer);
begin
  {$IFDEF KOL}
  with PUclCData(PStream(User).Methods.fCustom)^ do
    if Assigned(FOnProgress) then
      FOnProgress(User, FTotalIn + TextSize, FTotalOut + CodeSize);
  {$ELSE KOL}
  with TUclCompressionStream(User) do
    DoProgress(FTotalIn + TextSize, FTotalOut + CodeSize);
  {$ENDIF KOL}
end;

{$IFNDEF KOL}
constructor TUclCompressionStream.Create(const CompressionLevel: Integer; const BufferSize: Cardinal; const Dest: TStream);
begin
  inherited Create(BufferSize, Dest);
  FBufferFree := BufferSize;
  FBufferStart := FBuffer;
  Inc(FBufferStart, FBufferAlloc - BufferSize);
  FBufferPos := FBufferStart;
  FCompressionLevel := CompressionLevel;
  with FCallback do
    begin
      Callback := UclCompressionCallback;
      User := Self;
    end;
end;
{$ENDIF KOL}

{$IFDEF KOL}
function UclCFlushStream(Strm: PStream): Boolean;
{$ELSE KOL}
procedure TUclCompressionStream.Flush;
{$ENDIF KOL}
var
  c, l: Cardinal;
begin
  {$IFDEF KOL}
  with PUclCData(Strm^.Methods^.fCustom)^ do
    begin
      {$ENDIF KOL}
      c := FBufferSize - FBufferFree;
      if c > 0 then
        begin
          Inc(FTotalOut, 4);

          l := FBufferAlloc;
          {$IFDEF KOL}
          Result := ucl_nrv2e_99_compress(FBufferStart, c, FBuffer, l, @FCallback, FCompressionLevel, nil, nil) = UCL_E_OK;
          if not Result then Exit;
          {$ELSE KOL}
          ErrorCheck(ucl_nrv2e_99_compress(FBufferStart, c, FBuffer, l, @FCallback, FCompressionLevel, nil, nil));
          {$ENDIF KOL}
          FStream.Write(l, SizeOf(l));
          FStream.Write(FBuffer^, l);
          Inc(FTotalIn, FBufferSize);
          Inc(FTotalOut, l);
          FBufferFree := FBufferSize;
          FBufferPos := FBufferStart;
        end
          {$IFDEF KOL}
      else
        Result := False;
    end;
  {$ENDIF KOL}
end;

{$IFDEF KOL}
procedure UclCCloseStream(Strm: PStream);
{$ELSE KOL}
destructor TUclCompressionStream.Destroy;
{$ENDIF KOL}
begin
  {$IFDEF KOL}
  UclCFlushStream(Strm);
  FreeMem(PUclCData(Strm^.Methods^.fCustom)^.FBuffer);
  FreeMem(Strm^.Methods^.fCustom);
  {$ELSE KOL}
  Flush;
  inherited Destroy;
  {$ENDIF KOL}
end;

{$IFNDEF KOL}
{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function TUclCompressionStream.Read(var Buffer; Count: Integer): Integer;
begin
  Error(PResStringRec(@SInvalidUclStreamOperation), []);
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}
{$ENDIF KOL}

{$IFDEF KOL}
function UclCWriteStream(Strm: PStream; var Buffer; {$IFNDEF STREAM_COMPAT}const{$ENDIF}Count: TStrmSize): TStrmSize;
{$ELSE KOL}
function TUclCompressionStream.Write(const Buffer; Count: Integer): Integer;
{$ENDIF KOL}
{$IFDEF KOL}
label
  lblError;
  {$ENDIF KOL}
var
  {$IFDEF KOL_STREAM_CONST_ARGS}c: TStrmSize; {$ENDIF}
  PSource: ^Byte;
  l: Cardinal;
begin
  Result := 0;

  {$IFDEF KOL_STREAM_CONST_ARGS}c := Count; {$ENDIF}
  if {$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF} > 0 then
    {$IFDEF KOL}
    with PUclCData(Strm.Methods.fCustom)^ do
      {$ENDIF KOL}
      begin
        PSource := @Buffer;
        repeat
          l := FBufferFree;
          if l > 0 then
            begin

              if Cardinal({$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF}) <= l then
                begin
                  Move(PSource^, FBufferPos^, {$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF});
                  Inc(Result, {$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF});
                  Inc(FBufferPos, {$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF});
                  Dec(FBufferFree, {$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF});
                  Break;
                end;

              Move(PSource^, FBufferPos^, l);
              Inc(Result, l);
              Inc(PSource, l);
              Dec({$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF}, l);
              FBufferFree := 0;
            end;

          {$IFDEF KOL}
          if not UclCFlushStream(Strm) then goto lblError
            {$ELSE KOL}
          Flush;
          {$ENDIF KOL}

        until {$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF} <= 0;
      end;

  {$IFDEF KOL}
  Exit;
  lblError:
  Result := STREAM_ERROR;
  {$ENDIF KOL}
end;

{$IFDEF KOL}
function UclCSeekStream(Strm: PStream; {$IFNDEF STREAM_COMPAT}const{$ENDIF}Offset: TStrmMove; Origin: TMoveMethod): TStrmSize;
{$ELSE KOL}
{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function TUclCompressionStream.Seek(Offset: Integer; Origin: Word): Integer;
{$ENDIF KOL}
label
  OperationError, Rewind;
var
  p: Integer;
begin
  {$IFDEF KOL}
  with PUclCData(Strm.Methods.fCustom)^ do
    {$ENDIF KOL}
    case Origin of
      {$IFDEF KOL}spBegin{$ELSE}soFromBeginning{$ENDIF}:
        if Offset = 0 then
          begin
            Rewind:
            Result := 0;
            FStream.Seek(Result, {$IFDEF KOL}spBegin{$ELSE}soFromBeginning{$ENDIF});
            FBufferFree := FBufferSize;
            FBufferPos := FBufferStart;
            FTotalIn := Result;
            FTotalOut := Result;
          end
        else
          if Offset = Integer(FTotalIn + FBufferSize - FBufferFree) then
            Result := Offset
          else
            goto OperationError;

      {$IFDEF KOL}spCurrent{$ELSE}soFromCurrent{$ENDIF},
      {$IFDEF KOL}spEnd{$ELSE}soFromEnd{$ENDIF}:
        begin
          p := FTotalIn + FBufferSize - FBufferFree;
          if Offset = 0 then
            Result := p
          else
            if Offset = -p then
              goto Rewind
            else
              goto OperationError;
        end;

    else
      OperationError:
      {$IFDEF KOL}
      Result := STREAM_ERROR;
      {$ELSE KOL}
      Error(PResStringRec(@SInvalidUclStreamOperation), []);
      {$ENDIF KOL}
    end;
end;
{$IFNDEF KOL}
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}
{$ENDIF KOL}

{$IFDEF KOL}
procedure UclDCloseStream(Strm: PStream);
begin
  FreeMem(PUclCData(Strm^.Methods^.fCustom)^.FBuffer);
  FreeMem(Strm^.Methods^.fCustom);
end;
{$ENDIF KOL}

{$IFDEF KOL}
function UclDReadStream(Strm: PStream; var Buffer; {$IFNDEF STREAM_COMPAT}const{$ENDIF}Count: TStrmSize): TStrmSize;
{$ELSE KOL}
function TUclDeCompressionStream.Read(var Buffer; Count: Integer): Integer;
{$ENDIF KOL}
label
  StreamError;
var
  {$IFDEF KOL_STREAM_CONST_ARGS}c: TStrmSize; {$ENDIF}
  pDest, ReadTarget: ^Byte;
  l: Cardinal;
begin
  Result := 0;

  {$IFDEF KOL_STREAM_CONST_ARGS}c := Count; {$ENDIF}
  if {$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF} > 0 then
    {$IFDEF KOL}
    with PUclCData(Strm.Methods.fCustom)^ do
      {$ENDIF KOL}
      begin
        pDest := @Buffer;
        repeat
          l := FBufferFree;
          if l > 0 then
            begin

              if Cardinal({$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF}) <= l then
                begin
                  Move(FBufferPos^, pDest^, {$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF});
                  Inc(Result, {$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF});
                  Inc(FBufferPos, {$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF});
                  Dec(FBufferFree, {$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF});
                  Break;
                end;

              Move(FBufferPos^, pDest^, l);
              Inc(pDest, l);
              Inc(Result, l);
              Dec({$IFDEF KOL_STREAM_CONST_ARGS}c{$ELSE}Count{$ENDIF}, l);
              FBufferFree := 0;
            end;

          if FStream.Read(l, SizeOf(l)) <> SizeOf(l) then
            Break;
          if l > FBufferAlloc then
            goto StreamError;
          ReadTarget := FBuffer;
          Inc(ReadTarget, FBufferAlloc - l);
          if FStream.Read(ReadTarget^, l) <> {$IFNDEF KOL}Integer{$ENDIF}(l) then
            goto StreamError;

          FBufferFree := FBufferAlloc;
          {$IFDEF KOL}
          if ucl_nrv2e_decompress_asm_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil) <> UCL_E_OK then
            goto StreamError;
          {$ELSE KOL}
          ErrorCheck(ucl_nrv2e_decompress_asm_fast_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil));
          {$ENDIF KOL}

          Inc(FTotalIn, l + 4);
          Inc(FTotalOut, FBufferFree);

          {$IFDEF KOL}
          if Assigned(FOnProgress) then
            FOnProgress(Strm, FTotalIn, FTotalOut);
          {$ELSE KOL}
          DoProgress(FTotalIn, FTotalOut);
          {$ENDIF KOL}

          FBufferPos := FBuffer;
        until False;

      end;

  Exit;

  StreamError:
  {$IFDEF KOL}
  Result := STREAM_ERROR;
  {$ELSE KOL}
  Error(PResStringRec(@SInvalidUclStreamData), []);
  {$ENDIF KOL}
end;

{$IFNDEF KOL}
{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function TUclDeCompressionStream.Write(const Buffer; Count: Integer): Integer;
begin
  Error(PResStringRec(@SInvalidUclStreamOperation), []);
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}
{$ENDIF KOL}

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
{$IFDEF KOL}
function UclDSeekStream(Strm: PStream; {$IFNDEF STREAM_COMPAT}const{$ENDIF}Offset: TStrmMove; Origin: TMoveMethod): TStrmSize;
{$ELSE KOL}
function TUclDeCompressionStream.Seek(Offset: Integer; Origin: Word): Integer;
{$ENDIF KOL}
label
  OperationError, StreamError, SeekCurrent, SeekAbsolute, SeekForward;
var
  {$IFDEF KOL_STREAM_CONST_ARGS}o: TStrmMove; {$ENDIF}
  ReadTarget: ^Byte;
  l, CurrentPos: Cardinal;
  MinPos: Integer;
begin
  {$IFDEF KOL_STREAM_CONST_ARGS}o := Offset; {$ENDIF}
  {$IFDEF KOL}
  with PUclCData(Strm.Methods.fCustom)^ do
    {$ENDIF}
    case Origin of
      {$IFDEF KOL}spBegin{$ELSE}soFromBeginning{$ENDIF}:
        begin
          CurrentPos := FTotalOut - FBufferFree;
          goto SeekAbsolute;
        end;

      {$IFDEF KOL}spCurrent{$ELSE}soFromCurrent{$ENDIF}:
        begin
          goto SeekCurrent;
        end;

      {$IFDEF KOL}spEnd{$ELSE}soFromEnd{$ENDIF}:
        begin

          repeat
            Inc(FBufferPos, FBufferFree);
            FBufferFree := 0;

            if FStream.Read(l, SizeOf(l)) <> SizeOf(l) then
              Break;
            if l > FBufferAlloc then
              goto StreamError;
            ReadTarget := FBuffer;
            Inc(ReadTarget, FBufferAlloc - l);
            if FStream.Read(ReadTarget^, l) <> {$IFNDEF KOL}Integer{$ENDIF}(l) then
              goto StreamError;

            FBufferFree := FBufferAlloc;
            {$IFDEF KOL}
            if ucl_nrv2e_decompress_asm_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil) <> UCL_E_OK then
              goto StreamError;
            {$ELSE KOL}
            ErrorCheck(ucl_nrv2e_decompress_asm_fast_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil));
            {$ENDIF KOL}

            Inc(FTotalIn, l + 4);
            Inc(FTotalOut, FBufferFree);

            FBufferPos := FBuffer;
          until False;

          SeekCurrent:

          CurrentPos := FTotalOut - FBufferFree;
          Inc({$IFDEF KOL_STREAM_CONST_ARGS}o{$ELSE}Offset{$ENDIF}, CurrentPos);

          SeekAbsolute:

          if {$IFDEF KOL_STREAM_CONST_ARGS}o{$ELSE}Offset{$ENDIF} > Integer(FTotalOut) then
            begin
              goto SeekForward;
            end
          else
            begin
              MinPos := CurrentPos - (Cardinal(FBufferPos) - Cardinal(FBuffer));
              if {$IFDEF KOL_STREAM_CONST_ARGS}o{$ELSE}Offset{$ENDIF} < MinPos then
                begin
                  if {$IFDEF KOL_STREAM_CONST_ARGS}o{$ELSE}Offset{$ENDIF} < 0 then
                    {$IFDEF KOL_STREAM_CONST_ARGS}o{$ELSE}Offset{$ENDIF} := 0;

                  FTotalIn := 0;
                  FTotalOut := 0;
                  FStream.Seek(0, {$IFDEF KOL}spBegin{$ELSE}soFromBeginning{$ENDIF});

                  SeekForward:

                  repeat
                    FBufferFree := 0;

                    if FStream.Read(l, SizeOf(l)) <> SizeOf(l) then
                      goto OperationError;
                    if l > FBufferAlloc then
                      goto StreamError;
                    ReadTarget := FBuffer;
                    Inc(ReadTarget, FBufferAlloc - l);
                    if FStream.Read(ReadTarget^, l) <> {$IFNDEF KOL}Integer{$ENDIF}(l) then
                      goto StreamError;

                    FBufferFree := FBufferAlloc;
                    {$IFDEF KOL}
                    if ucl_nrv2e_decompress_asm_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil) <> UCL_E_OK then
                      goto StreamError;
                    {$ELSE}
                    ErrorCheck(ucl_nrv2e_decompress_asm_fast_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil));
                    {$ENDIF}

                    Inc(FTotalIn, l + 4);
                    Inc(FTotalOut, FBufferFree);

                    FBufferPos := FBuffer;

                    if Cardinal({$IFDEF KOL_STREAM_CONST_ARGS}o{$ELSE}Offset{$ENDIF}) <= FTotalOut then
                      begin
                        Inc(FBufferPos, FBufferFree - (FTotalOut - Cardinal({$IFDEF KOL_STREAM_CONST_ARGS}o{$ELSE}Offset{$ENDIF})));
                        FBufferFree := FTotalOut - Cardinal({$IFDEF KOL_STREAM_CONST_ARGS}o{$ELSE}Offset{$ENDIF});
                        Break;
                      end;

                  until False;
                end
              else
                begin
                  FBufferPos := FBuffer;
                  Inc(FBufferPos, {$IFDEF KOL_STREAM_CONST_ARGS}o{$ELSE}Offset{$ENDIF} - MinPos);
                  Inc(FBufferFree, CurrentPos - Cardinal({$IFDEF KOL_STREAM_CONST_ARGS}o{$ELSE}Offset{$ENDIF}));
                end;
            end;

          Result := {$IFDEF KOL_STREAM_CONST_ARGS}o{$ELSE}Offset{$ENDIF};
        end;
    else
      OperationError:
      {$IFDEF KOL}
      StreamError:
      Result := STREAM_ERROR;
      {$ELSE KOL}
      Error(PResStringRec(@SInvalidUclStreamOperation), []);
      {$ENDIF KOL}
    end;

  {$IFDEF KOL}
  {$ELSE KOL}
  Exit;
  StreamError:
  Error(PResStringRec(@SInvalidUclStreamData), []);
  {$ENDIF KOL}
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{$IFDEF KOL}

function DummyGetSize(Strm: PStream): TStrmSize;
begin
  Result := 0;
end;

function SeekGetSize(Strm: PStream): TStrmSize;
var
  Pos: TStrmSize;
begin
  Pos := Strm^.Seek(0, spCurrent);
  Result := Strm^.Seek(0, spEnd);
  Strm^.Seek(Pos, spBegin);
end;

const
  BaseUclCMethods: TStreamMethods = (
    fSeek: UclCSeekStream;
    fGetSiz: DummyGetSize;
    fSetSiz: DummySetSize;
    fRead: DummyReadWrite;
    fWrite: UclCWriteStream;
    FClose: UclCCloseStream; );

  BaseUclDMethods: TStreamMethods = (
    fSeek: UclDSeekStream;
    fGetSiz: SeekGetSize;
    fSetSiz: DummySetSize;
    fRead: UclDReadStream;
    fWrite: DummyReadWrite;
    FClose: UclDCloseStream;
    );

function NewUclCStream(const CompressionLevel: Integer; const BufferSize: Cardinal; const Destination: PStream; const OnProgress: TUclProgressEvent): PStream;
var
  UclData: PUclCData;
begin
  if ucl_init = UCL_E_OK then
    begin
      UclData := AllocMem(SizeOf(UclData^));
      with UclData^ do
        begin
          FStream := Destination;
          FBufferSize := BufferSize;
          FBufferAlloc := ucl_output_block_size(BufferSize);
          GetMem(FBuffer, FBufferAlloc);

          FBufferFree := BufferSize;
          FBufferStart := FBuffer;
          Inc(FBufferStart, FBufferAlloc - BufferSize);
          FBufferPos := FBufferStart;
          FCompressionLevel := CompressionLevel;
          FOnProgress := OnProgress;

          Result := _NewStream(BaseUclCMethods);

          with FCallback do
            begin
              Callback := UclCompressionCallback;
              User := Result;
            end;
        end;

      Result.Methods.fCustom := UclData;
    end
  else
    Result := nil;
end;

function NewUclDStream(const BufferSize: Cardinal; const Source: PStream; const OnProgress: TUclProgressEvent): PStream;
var
  UclData: PUclDData;
begin
  if ucl_init = UCL_E_OK then
    begin
      UclData := AllocMem(SizeOf(UclData^));
      with UclData^ do
        begin
          FStream := Source;
          FBufferSize := BufferSize;
          FBufferAlloc := ucl_output_block_size(BufferSize);
          GetMem(FBuffer, FBufferAlloc);
          FOnProgress := OnProgress;
        end;
      Result := _NewStream(BaseUclDMethods);
      Result^.Methods^.fCustom := UclData;
    end
  else
    Result := nil;
end;

function NewUclCCStream(out Stream: PStream; const CompressionLevel: Integer; BufferSize: Cardinal; const Destination: PStream; OnProgress: TUclProgressEvent): Boolean;
begin
  Stream := NewUclCStream(CompressionLevel, BufferSize, Destination, OnProgress);
  Result := Stream <> nil;
end;

function NewUclDDStream(out Stream: PStream; const BufferSize: Cardinal; const Source: PStream; const OnProgress: TUclProgressEvent): Boolean;
begin
  Stream := NewUclDStream(BufferSize, Source, OnProgress);
  Result := Stream <> nil;
end;

function KOL_Stream_Copy(Dest, Source: PStream; Count: Int64): Int64;
const
  MaxBufSize = $80000;
var
  BufSize: Cardinal;
  Readed: Cardinal;
  Buffer: Pointer;
  Need: Cardinal;
begin
  if Count = 0 then
    begin
      Source.Seek(0, spBegin);
      Count := Source.Size;
    end;
  Result := 0;
  if Count > MaxBufSize then BufSize := MaxBufSize else BufSize := Count;
  GetMem(Buffer, BufSize);
  try
    repeat
      if Count > BufSize then Need := BufSize else Need := Count;
      Readed := Source.Read(Buffer^, Need);
      if Readed = STREAM_ERROR then Exit;
      if Dest.Write(Buffer^, Readed) = STREAM_ERROR then Exit;
      Dec(Count, Readed);
      Inc(Result, Readed);
    until (Count = 0) or (Readed = 0);
  finally

    FreeMem(Buffer, BufSize);
  end;
end;

{$ENDIF KOL}

end.

