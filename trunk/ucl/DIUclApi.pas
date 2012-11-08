{ ------------------------------------------------------------------------------

  DIUclApi.pas -- UCL Compression Library API for Borland Delphi

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

  UCL is Copyright (c) 1996-2003 Markus Franz Xaver Johannes Oberhumer
  All Rights Reserved.

  Markus F.X.J. Oberhumer
  <markus@oberhumer.com>
  http://www.oberhumer.com/opensource/ucl/

------------------------------------------------------------------------------ }

unit DIUclApi;

{$I DI.inc}

interface

const
  UCL_VERSION_CONST = $010200;

  UCL_E_OK = 0;
  UCL_E_ERROR = -1;
  UCL_E_INVALID_ARGUMENT = -2;
  UCL_E_OUT_OF_MEMORY = -3;

  UCL_E_NOT_COMPRESSIBLE = -101;

  UCL_E_INPUT_OVERRUN = -201;
  UCL_E_OUTPUT_OVERRUN = -202;
  UCL_E_LOOKBEHIND_OVERRUN = -203;
  UCL_E_EOF_NOT_FOUND = -204;
  UCL_E_INPUT_NOT_CONSUMED = -205;
  UCL_E_OVERLAP_OVERRUN = -206;

type
  PCardinal = ^Cardinal;

  ucl_progress_callback_p = ^ucl_progress_callback_t;
  ucl_progress_callback_t = record
    Callback: procedure(TextSize: Cardinal; CodeSize: Cardinal; State: Integer; User: Pointer);
    User: Pointer;
  end;

  ucl_compress_config_p = ^ucl_compress_config_t;

  ucl_compress_config_t = record
    bb_endian: Integer;
    bb_size: Integer;
    max_offset: Cardinal;
    max_match: Cardinal;
    s_level: Integer;
    h_level: Integer;
    p_level: Integer;
    c_flags: Integer;
    m_size: Cardinal;
  end;

function ucl_init: Integer;

function __ucl_init2(v: Cardinal; s1, s2, s3, s4, s5, s6, s7, s8, s9: Integer): Integer;

function ucl_version: Cardinal;

function ucl_version_string: PAnsiChar;

function ucl_version_date: PAnsiChar;

function ucl_output_block_size(const input_block_size: Cardinal): Cardinal;

function ucl_nrv2b_99_compress(
  const In_: Pointer;
  in_len: Cardinal;
  Out_: Pointer;
  var out_len: Cardinal;
  cb: ucl_progress_callback_p;
  Level: Integer;
  const conf: ucl_compress_config_p;
  Result: PCardinal): Integer;

function ucl_nrv2b_decompress_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_decompress_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_decompress_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_decompress_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_decompress_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_decompress_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_decompress_asm_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_fast_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_fast_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_fast_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_fast_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_fast_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_fast_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_small_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_small_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_small_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_test_overlap_8(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_test_overlap_le16(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_test_overlap_le32(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_99_compress(
  const In_: Pointer;
  in_len: Cardinal;
  Out_: Pointer;
  var out_len: Cardinal;
  cb: ucl_progress_callback_p;
  Level: Integer;
  const conf: ucl_compress_config_p;
  Result: PCardinal): Integer;

function ucl_nrv2d_decompress_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_decompress_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_decompress_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_decompress_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_decompress_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_decompress_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_decompress_asm_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_fast_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_fast_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_fast_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_fast_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_fast_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_fast_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_small_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_small_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_small_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_test_overlap_8(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_test_overlap_le16(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_test_overlap_le32(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_99_compress(
  const In_: Pointer;
  in_len: Cardinal;
  Out_: Pointer;
  var out_len: Cardinal;
  cb: ucl_progress_callback_p;
  Level: Integer;
  const conf: ucl_compress_config_p;
  Result: PCardinal): Integer;

function ucl_nrv2e_decompress_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_decompress_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_decompress_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_decompress_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_decompress_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_decompress_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_decompress_asm_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_fast_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_fast_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_fast_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_fast_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_fast_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_fast_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_small_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_small_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_small_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_test_overlap_8(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_test_overlap_le16(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_test_overlap_le32(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

implementation

function malloc(const Size: Cardinal): Pointer; cdecl;
begin
  GetMem(Result, Size);
end;

procedure Free(const p: Pointer); cdecl;
begin
  FreeMem(p);
end;

function memcpy(Dest: Pointer; const Src: Pointer; n: Cardinal): Pointer; cdecl;
begin
  Result := Dest;
  Move(Src^, Result^, n);
end;

function memset(const Source: Pointer; const Value: Integer; const Count: Cardinal): Pointer; cdecl;
begin
  Result := Source;
  FillChar(Result^, Count, Value);
end;

function ucl_init: Integer;
begin
  Result := __ucl_init2(
    UCL_VERSION_CONST,
    SizeOf(SmallInt),
    SizeOf(Integer),
    SizeOf(Integer),
    SizeOf(Cardinal),
    SizeOf(Cardinal),
    -1,
    SizeOf(PAnsiChar),
    SizeOf(Pointer),
    4);
end;

function ucl_output_block_size(const input_block_size: Cardinal): Cardinal;
begin
  Result := input_block_size + input_block_size div 8 + 256;
end;

{$L ucl_obj\UCL_init}
{$L ucl_obj\UCL_ptr}
{$L ucl_obj\UCL_util}

{$L ucl_obj\n2b_99}
{$L ucl_obj\n2b_d}
{$L ucl_obj\n2b_ds}
{$L ucl_obj\n2b_to}

{$L ucl_obj\n2b_d_f1}
{$L ucl_obj\n2b_d_f2}
{$L ucl_obj\n2b_d_f3}
{$L ucl_obj\n2b_d_f4}
{$L ucl_obj\n2b_d_f5}
{$L ucl_obj\n2b_d_f6}

{$L ucl_obj\n2b_d_n1}
{$L ucl_obj\n2b_d_n2}
{$L ucl_obj\n2b_d_n3}
{$L ucl_obj\n2b_d_n4}
{$L ucl_obj\n2b_d_n5}
{$L ucl_obj\n2b_d_n6}

{$L ucl_obj\n2b_d_s1}
{$L ucl_obj\n2b_d_s2}
{$L ucl_obj\n2b_d_s3}
{$L ucl_obj\n2b_d_s4}
{$L ucl_obj\n2b_d_s5}
{$L ucl_obj\n2b_d_s6}

{$L ucl_obj\n2d_99}
{$L ucl_obj\n2d_d}
{$L ucl_obj\n2d_ds}
{$L ucl_obj\n2d_to}

{$L ucl_obj\n2d_d_f1}
{$L ucl_obj\n2d_d_f2}
{$L ucl_obj\n2d_d_f3}
{$L ucl_obj\n2d_d_f4}
{$L ucl_obj\n2d_d_f5}
{$L ucl_obj\n2d_d_f6}

{$L ucl_obj\n2d_d_n1}
{$L ucl_obj\n2d_d_n2}
{$L ucl_obj\n2d_d_n3}
{$L ucl_obj\n2d_d_n4}
{$L ucl_obj\n2d_d_n5}
{$L ucl_obj\n2d_d_n6}

{$L ucl_obj\n2d_d_s1}
{$L ucl_obj\n2d_d_s2}
{$L ucl_obj\n2d_d_s3}
{$L ucl_obj\n2d_d_s4}
{$L ucl_obj\n2d_d_s5}
{$L ucl_obj\n2d_d_s6}

{$L ucl_obj\n2e_99}
{$L ucl_obj\n2e_d}
{$L ucl_obj\n2e_ds}
{$L ucl_obj\n2e_to}

{$L ucl_obj\n2e_d_f1}
{$L ucl_obj\n2e_d_f2}
{$L ucl_obj\n2e_d_f3}
{$L ucl_obj\n2e_d_f4}
{$L ucl_obj\n2e_d_f5}
{$L ucl_obj\n2e_d_f6}

{$L ucl_obj\n2e_d_n1}
{$L ucl_obj\n2e_d_n2}
{$L ucl_obj\n2e_d_n3}
{$L ucl_obj\n2e_d_n4}
{$L ucl_obj\n2e_d_n5}
{$L ucl_obj\n2e_d_n6}

{$L ucl_obj\n2e_d_s1}
{$L ucl_obj\n2e_d_s2}
{$L ucl_obj\n2e_d_s3}
{$L ucl_obj\n2e_d_s4}
{$L ucl_obj\n2e_d_s5}
{$L ucl_obj\n2e_d_s6}

{$L ucl_obj\alloc.obj}

function __ucl_init2; external;

function ucl_version; external;
function ucl_version_string; external;
function ucl_version_date; external;

function ucl_nrv2b_99_compress; external;

function ucl_nrv2b_decompress_8; external;
function ucl_nrv2b_decompress_le16; external;
function ucl_nrv2b_decompress_le32; external;

function ucl_nrv2b_decompress_safe_8; external;
function ucl_nrv2b_decompress_safe_le16; external;
function ucl_nrv2b_decompress_safe_le32; external;

function ucl_nrv2b_decompress_asm_8; external;
function ucl_nrv2b_decompress_asm_le16; external;
function ucl_nrv2b_decompress_asm_le32; external;

function ucl_nrv2b_decompress_asm_fast_8; external;
function ucl_nrv2b_decompress_asm_fast_le16; external;
function ucl_nrv2b_decompress_asm_fast_le32; external;

function ucl_nrv2b_decompress_asm_fast_safe_8; external;
function ucl_nrv2b_decompress_asm_fast_safe_le16; external;
function ucl_nrv2b_decompress_asm_fast_safe_le32; external;

function ucl_nrv2b_decompress_asm_safe_8; external;
function ucl_nrv2b_decompress_asm_safe_le16; external;
function ucl_nrv2b_decompress_asm_safe_le32; external;

function ucl_nrv2b_decompress_asm_small_8; external;
function ucl_nrv2b_decompress_asm_small_le16; external;
function ucl_nrv2b_decompress_asm_small_le32; external;

function ucl_nrv2b_test_overlap_8; external;
function ucl_nrv2b_test_overlap_le16; external;
function ucl_nrv2b_test_overlap_le32; external;

function ucl_nrv2d_99_compress; external;

function ucl_nrv2d_decompress_8; external;
function ucl_nrv2d_decompress_le16; external;
function ucl_nrv2d_decompress_le32; external;

function ucl_nrv2d_decompress_safe_8; external;
function ucl_nrv2d_decompress_safe_le16; external;
function ucl_nrv2d_decompress_safe_le32; external;

function ucl_nrv2d_decompress_asm_8; external;
function ucl_nrv2d_decompress_asm_le16; external;
function ucl_nrv2d_decompress_asm_le32; external;

function ucl_nrv2d_decompress_asm_fast_8; external;
function ucl_nrv2d_decompress_asm_fast_le16; external;
function ucl_nrv2d_decompress_asm_fast_le32; external;

function ucl_nrv2d_decompress_asm_fast_safe_8; external;
function ucl_nrv2d_decompress_asm_fast_safe_le16; external;
function ucl_nrv2d_decompress_asm_fast_safe_le32; external;

function ucl_nrv2d_decompress_asm_safe_8; external;
function ucl_nrv2d_decompress_asm_safe_le16; external;
function ucl_nrv2d_decompress_asm_safe_le32; external;

function ucl_nrv2d_decompress_asm_small_8; external;
function ucl_nrv2d_decompress_asm_small_le16; external;
function ucl_nrv2d_decompress_asm_small_le32; external;

function ucl_nrv2d_test_overlap_8; external;
function ucl_nrv2d_test_overlap_le16; external;
function ucl_nrv2d_test_overlap_le32; external;

function ucl_nrv2e_99_compress; external;

function ucl_nrv2e_decompress_8; external;
function ucl_nrv2e_decompress_le16; external;
function ucl_nrv2e_decompress_le32; external;

function ucl_nrv2e_decompress_safe_8; external;
function ucl_nrv2e_decompress_safe_le16; external;
function ucl_nrv2e_decompress_safe_le32; external;

function ucl_nrv2e_decompress_asm_8; external;
function ucl_nrv2e_decompress_asm_le16; external;
function ucl_nrv2e_decompress_asm_le32; external;

function ucl_nrv2e_decompress_asm_fast_8; external;
function ucl_nrv2e_decompress_asm_fast_le16; external;
function ucl_nrv2e_decompress_asm_fast_le32; external;

function ucl_nrv2e_decompress_asm_fast_safe_8; external;
function ucl_nrv2e_decompress_asm_fast_safe_le16; external;
function ucl_nrv2e_decompress_asm_fast_safe_le32; external;

function ucl_nrv2e_decompress_asm_safe_8; external;
function ucl_nrv2e_decompress_asm_safe_le16; external;
function ucl_nrv2e_decompress_asm_safe_le32; external;

function ucl_nrv2e_decompress_asm_small_8; external;
function ucl_nrv2e_decompress_asm_small_le16; external;
function ucl_nrv2e_decompress_asm_small_le32; external;

function ucl_nrv2e_test_overlap_8; external;
function ucl_nrv2e_test_overlap_le16; external;
function ucl_nrv2e_test_overlap_le32; external;

end.

