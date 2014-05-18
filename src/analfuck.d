/+
 + AnalF*ck Programming Language
 +
 + Description: 淫夢厨向けプログラミング言語
 + Version    : 0.0.1
 + Last Update: 2014/05/18
 + Author     : TSUYUSATO Kitsune (Twitter: @make_now_just)
 + License    :
 +   Copyright © 2014 TSUYUSATO Kitsune <make.just.on@gmail.com>
 +   This work is free. You can redistribute it and/or modify it under the
 +   terms of the Do What The Fuck You Want To Public License, Version 2,
 +   as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
 +/

/+
 + Language Specification
 +
 + 1. Overview
 +   AnalF*ck Programming Language is Brainf*ck derivative. So, it is Turing Complete!
 +
 +   AnalF*ck has only a byte buffer 'b' which have 30000 size and index variable 'i'. (It likes 'unsigned char b[30000]; unsigned int i;' as C)
 +   And, Reading source, finding command, operating 'b' and 'i'.
 +   It is all of AnalF*ck.
 +
 + 2. Commands
 +   AnalF*ck supports such commands:
 +
 +   |AnalF*ck command|BrainF*ck command|     As C          |
 +   |----------------|-----------------|-------------------|
 +   |    いいよ！    |       [         | while(b[i]) {     |
 +   |    来いよ！    |       ]         | }                 |
 +   |    アーッ！    |      >>>        | i += 3;           |
 +   |     ｱｰｯ!       |      <<         | i -= 2;           |
 +   |   あのさぁ…   |      +++        | b[i] += 3;        |
 +   |   あくしろよ   |     ++++        | b[i] += 4;        |
 +   |   ファッ！？   |       .         | putchar(b[i]);    |
 +   |    こ↑こ↓    |       ,         | b[i] = getchar(); |
 +/

module analfuck;

import std.algorithm;
import std.array;
import std.stdio;

const BUFFER_SIZE = 30000;

const iiyo    = "いいよ！"w;
const koiyo   = "来いよ！"w;
const ahFull  = "アーッ！"w;
const ahHalf  = "ｱｰｯ!"w;
const anosa   = "あのさぁ…"w;
const akusiro = "あくしろよ"w;
const fa      = "ファッ！"w;
const koko    = "こ↑こ↓"w;

enum Command {
  IIYO,
  KOIYO,
  AH_FULL,
  AH_HALF,
  ANOSA,
  AKUSIRO,
  FA,
  KOKO,
}

void run(wstring src) {
  Command[] cmds;

  // parsing
  for (int i = 0; i < src.length; i++) {
    int restLength = src.length - i;

    if (iiyo.length <= restLength && iiyo == src[i..i+iiyo.length]) {
      cmds ~= Command.IIYO;
      i += iiyo.length - 1;
      continue;
    }
    if (koiyo.length <= restLength && koiyo == src[i..i+koiyo.length]) {
      cmds ~= Command.KOIYO;
      i += koiyo.length - 1;
      continue;
    }
    if (ahFull.length <= restLength && ahFull == src[i..i+ahFull.length]) {
      cmds ~= Command.AH_FULL;
      i += ahFull.length - 1;
      continue;
    }
    if (ahHalf.length <= restLength && ahHalf == src[i..i+ahHalf.length]) {
      cmds ~= Command.AH_HALF;
      i += ahHalf.length - 1;
      continue;
    }
    if (anosa.length <= restLength && anosa == src[i..i+anosa.length]) {
      cmds ~= Command.ANOSA;
      i += anosa.length - 1;
      continue;
    }
    if (akusiro.length <= restLength && akusiro == src[i..i+akusiro.length]) {
      cmds ~= Command.AKUSIRO;
      i += akusiro.length - 1;
      continue;
    }
    if (fa.length <= restLength && fa == src[i..i+fa.length]) {
      cmds ~= Command.FA;
      i += fa.length - 1;
      continue;
    }
    if (koko.length <= restLength && koko == src[i..i+koko.length]) {
      cmds ~= Command.KOKO;
      i += koko.length - 1;
      continue;
    }
  }
  
//  writeln(cmds);

  // executing
  int i = 0;
  char b[BUFFER_SIZE];
  int[] iiyoStack = [];
  for (int j = 0; j < BUFFER_SIZE; j++) b[j] = 0;

  for (int p = 0; p < cmds.length; p++) {
    auto c = cmds[p];
    
//    writeln(c, " ", i, " ", cast(int)b[i]);

    switch (c) {
    case Command.IIYO:
      if (b[i] == 0) {
        int nest = 1;
        auto flag = false;
        do {
          p += 1;
          if (cmds[p] == Command.IIYO)  nest += 1;
          if (cmds[p] == Command.KOIYO) nest -= 1;

          if (nest == 0) {
            flag = true;
            break;
          }
        } while (p < cmds.length);

        assert(flag);
      } else {
        iiyoStack ~= p;
      }
      break;

    case Command.KOIYO:
      assert(iiyoStack.length != 0);

      p = iiyoStack[iiyoStack.length-1] - 1;
      iiyoStack.popBack();
      break;

    case Command.AH_FULL:
      i += 3;
      assert(i < BUFFER_SIZE);
      break;

    case Command.AH_HALF:
      i -= 2;
      assert(i >= 0);
      break;

    case Command.ANOSA:
      b[i] += 3;
      break;

    case Command.AKUSIRO:
      b[i] += 4;
      break;

    case Command.FA:
      writef("%c", b[i]);
      break;

    case Command.KOKO:
      readf("%c", &b[i]);
      break;
    
    default:
      assert(false);
    }
  }
}
