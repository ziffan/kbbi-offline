unit UPosX;

interface

uses
  Windows, Messages, KOL;

function PosEx(const SubStr, S: string; Offset: Integer = 1): Integer;
function PosFastcodeRTL(const SubStr : AnsiString; const Str : AnsiString) : Integer;
function Pos2(const SubStr : PAnsiChar; const Str : PAnsiChar) : Integer;



implementation

(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The implementation of function PosEx is subject to the
 * Mozilla Public License Version 1.1 (the "License"); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Fastcode
 *
 * The Initial Developer of the Original Code is Fastcode
 *
 * Portions created by the Initial Developer are Copyright (C) 2002-2004
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s): Aleksandr Sharahov
 *
 * ***** END LICENSE BLOCK ***** *)
function PosEx(const SubStr, S: string; Offset: Integer = 1): Integer;
asm
       test  eax, eax
       jz    @Nil
       test  edx, edx
       jz    @Nil
       dec   ecx
       jl    @Nil

       push  esi
       push  ebx

       mov   esi, [edx-4]  //Length(Str)
       mov   ebx, [eax-4]  //Length(Substr)
       sub   esi, ecx      //effective length of Str
       add   edx, ecx      //addr of the first char at starting position
       cmp   esi, ebx
       jl    @Past         //jump if EffectiveLength(Str)<Length(Substr)
       test  ebx, ebx
       jle   @Past         //jump if Length(Substr)<=0

       add   esp, -12
       add   ebx, -1       //Length(Substr)-1
       add   esi, edx      //addr of the terminator
       add   edx, ebx      //addr of the last char at starting position
       mov   [esp+8], esi  //save addr of the terminator
       add   eax, ebx      //addr of the last char of Substr
       sub   ecx, edx      //-@Str[Length(Substr)]
       neg   ebx           //-(Length(Substr)-1)
       mov   [esp+4], ecx  //save -@Str[Length(Substr)]
       mov   [esp], ebx    //save -(Length(Substr)-1)
       movzx ecx, byte ptr [eax] //the last char of Substr

@Loop:
       cmp   cl, [edx]
       jz    @Test0
@AfterTest0:
       cmp   cl, [edx+1]
       jz    @TestT
@AfterTestT:
       add   edx, 4
       cmp   edx, [esp+8]
       jb   @Continue
@EndLoop:
       add   edx, -2
       cmp   edx, [esp+8]
       jb    @Loop
@Exit:
       add   esp, 12
@Past:
       pop   ebx
       pop   esi
@Nil:
       xor   eax, eax
       ret
@Continue:
       cmp   cl, [edx-2]
       jz    @Test2
       cmp   cl, [edx-1]
       jnz   @Loop
@Test1:
       add   edx,  1
@Test2:
       add   edx, -2
@Test0:
       add   edx, -1
@TestT:
       mov   esi, [esp]
       test  esi, esi
       jz    @Found
@string:
       movzx ebx, word ptr [esi+eax]
       cmp   bx, word ptr [esi+edx+1]
       jnz   @AfterTestT
       cmp   esi, -2
       jge   @Found
       movzx ebx, word ptr [esi+eax+2]
       cmp   bx, word ptr [esi+edx+3]
       jnz   @AfterTestT
       add   esi, 4
       jl    @string
@Found:
       mov   eax, [esp+4]
       add   edx, 2

       cmp   edx, [esp+8]
       ja    @Exit

       add   esp, 12
       add   eax, edx
       pop   ebx
       pop   esi
end;

//Author:            Aleksandr Sharahov
//Date:
//Optimized for:     RTL Replacement
//Instructionset(s): IA32
//Original name:     PosShaAsm5

function PosFastcodeRTL(const SubStr : AnsiString; const Str : AnsiString) : Integer;
asm
       push  ebx
       push  esi
       add   esp, -16
       test  edx, edx
       jz    @NotFound
       test  eax, eax
       jz    @NotFound
       mov   esi, [edx-4] //Length(Str)
       mov   ebx, [eax-4] //Length(Substr)
       cmp   esi, ebx
       jl    @NotFound
       test  ebx, ebx
       jle   @NotFound
       dec   ebx
       add   esi, edx
       add   edx, ebx
       mov   [esp+8], esi
       add   eax, ebx
       mov   [esp+4], edx
       neg   ebx
       movzx ecx, byte ptr [eax]
       mov   [esp], ebx
       jnz   @FindString

       sub   esi, 2
       mov   [esp+12], esi

@FindChar2:
       cmp   cl, [edx]
       jz    @Matched0ch
       cmp   cl, [edx+1]
       jz    @Matched1ch
       add   edx, 2
       cmp   edx, [esp+12]
       jb    @FindChar4
       cmp   edx, [esp+8]
       jb    @FindChar2
@NotFound:
       xor   eax, eax
       jmp   @Exit0ch

@FindChar4:
       cmp   cl, [edx]
       jz    @Matched0ch
       cmp   cl, [edx+1]
       jz    @Matched1ch
       cmp   cl, [edx+2]
       jz    @Matched2ch
       cmp   cl, [edx+3]
       jz    @Matched3ch
       add   edx, 4
       cmp   edx, [esp+12]
       jb    @FindChar4
       cmp   edx, [esp+8]
       jb    @FindChar2
       xor   eax, eax
       jmp   @Exit0ch

@Matched2ch:
       add   edx, 2
@Matched0ch:
       inc   edx
       mov   eax, edx
       sub   eax, [esp+4]
@Exit0ch:
       add   esp, 16
       pop   esi
       pop   ebx
       ret

@Matched3ch:
       add   edx, 2
@Matched1ch:
       add   edx, 2
       xor   eax, eax
       cmp   edx, [esp+8]
       ja    @Exit1ch
       mov   eax, edx
       sub   eax, [esp+4]
@Exit1ch:
       add   esp, 16
       pop   esi
       pop   ebx
       ret

@FindString4:
       cmp   cl, [edx]
       jz    @Test0
       cmp   cl, [edx+1]
       jz    @Test1
       cmp   cl, [edx+2]
       jz    @Test2
       cmp   cl, [edx+3]
       jz    @Test3
       add   edx, 4
       cmp   edx, [esp+12]
       jb    @FindString4
       cmp   edx, [esp+8]
       jb    @FindString2
       xor   eax, eax
       jmp   @Exit1

@FindString:
       sub   esi, 2
       mov   [esp+12], esi
@FindString2:
       cmp   cl, [edx]
       jz    @Test0
@AfterTest0:
       cmp   cl, [edx+1]
       jz    @Test1
@AfterTest1:
       add   edx, 2
       cmp   edx, [esp+12]
       jb    @FindString4
       cmp   edx, [esp+8]
       jb    @FindString2
       xor   eax, eax
       jmp   @Exit1

@Test3:
       add   edx, 2
@Test1:
       mov   esi, [esp]
@Loop1:
       movzx ebx, word ptr [esi+eax]
       cmp   bx, word ptr [esi+edx+1]
       jnz   @AfterTest1
       add   esi, 2
       jl    @Loop1
       add   edx, 2
       xor   eax, eax
       cmp   edx, [esp+8]
       ja    @Exit1
@RetCode1:
       mov   eax, edx
       sub   eax, [esp+4]
@Exit1:
       add   esp, 16
       pop   esi
       pop   ebx
       ret

@Test2:
       add   edx,2
@Test0:
       mov   esi, [esp]
@Loop0:
       movzx ebx, word ptr [esi+eax]
       cmp   bx, word ptr [esi+edx]
       jnz   @AfterTest0
       add   esi, 2
       jl    @Loop0
       inc   edx
@RetCode0:
       mov   eax, edx
       sub   eax, [esp+4]
       add   esp, 16
       pop   esi
       pop   ebx
end;

// Org Author:        Aleksandr Sharahov
// Modified PAnsiChar Ebta Setiawan
// Date:
// Optimized for:     Blended / Pascal
// Instructionset(s): IA32
// Original name:     PosShaPas3

function Pos2(const SubStr : PAnsiChar; const Str : PAnsiChar) : Integer;
var
  len, lenSub: integer;
  ch: char;
  p, pSub, pStart, pStop: PAnsiChar;
label
  Ret, Ret0, Ret1, Next0, Next1;
begin;
  p:=Str;
  pSub:=SubStr;

  if (p=nil) or (pSub=nil) then begin;
    Result:=0;
    exit;
    end;

  len:= StrLen(p);
  lenSub:=StrLen(pSub);
  if (len<lenSub) or (lenSub<=0) then begin;
    Result:=0;
    exit;
    end;

  lenSub:=lenSub-1;
  pStop:=p+len;
  p:=p+lenSub;
  pSub:=pSub+lenSub;
  pStart:=p;

  ch:=pSub[0];

  if lenSub=0 then begin;
    repeat;
      if ch=p[0] then goto Ret0;
      if ch=p[1] then goto Ret1;
      p:=p+2;
      until p>=pStop;
    Result:=0;
    exit;
    end;

  lenSub:=-lenSub;
  repeat;
    if ch=p[0] then begin;
      len:=lenSub;
      repeat;
        if pword(psub+len)^<>pword(p+len)^ then goto Next0;
        len:=len+2;
        until len>=0;
      goto Ret0;
  Next0:end;

      if ch=p[1] then begin;
        len:=lenSub;
        repeat;
          if pword(@psub[len])^<>pword(@p[len+1])^ then goto Next1;
          len:=len+2;
          until len>=0;
        goto Ret1;
  Next1:end;

      p:=p+2;
      until p>=pStop;
    Result:=0;
    exit;

  Ret1:
    p:=p+2;
    if p<=pStop then goto Ret;
    Result:=0;
    exit;
  Ret0:
    inc(p);
  Ret:
    Result:=p-pStart;
end;

end.
