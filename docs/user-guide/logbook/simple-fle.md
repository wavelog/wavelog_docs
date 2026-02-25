# SimpleFLE

SimpleFLE ("Simple Fast Log Entry") is a syntax-based way to log multiple QSOs with a minimum of text and effort. Originally designed by [DF3CB](https://df3cb.com/fle/), it is a great way to log QSOs you've already made. SimpleFLE is not meant to be a "live" logging feature, but if you were outside in nature and wrote down your QSOs on a sheet of paper, it is much faster to use SimpleFLE to log these QSOs in Wavelog.

- [QSO Table](#the-qso-table)  
- [Basic Configuration](#basic-configuration)  
- [Textarea and Syntax](#textarea-and-syntax)
   - [Change band and/or mode](#change-band-andor-mode)
   - [Change date](#change-date)
   - [Add a QSO](#add-a-qso)
      - [Time](#time)
      - [Callsign](#callsign)
      - [RST](#rst)
      - [Reference (SOTA, POTA, IOTA, WWFF)](#reference)
      - [Gridsquare](#gridsquare)
      - [Operator name](#operator-name) (since v2.0)
      - [Contest exchange](#contest-exchange) (since v2.0)
      - [Comments and QSL-message](#comments-and-qsl-message) (since v2.0)
      - [Additional fields](#additional-fields) (since v2.0)

Due to the fact that the syntax of SimpleFLE is slightly different from the original FLE, we created this Wiki to give a detailed explanation of how things work here.

## The QSO Table
<img width="800" alt="QSO Table" src="https://github.com/wavelog/wavelog/assets/80885850/9a6349b2-2401-4d66-8f47-7396126449dc">

Entered QSOs will be shown here. Double-check all callsigns and other data before saving it to Wavelog!

***

## Basic Configuration

<img width="650" alt="Basic SimpleFLE Configuration" src="https://github.com/wavelog/wavelog/assets/80885850/28dfe168-1f12-461c-94ca-ee4b084c4bd5">

In the upper left area, you define some basic information for the following QSOs.

- QSO date  
  You can define a QSO date here if you didn't make the QSOs today. If no date is set, SFLE will use today's date.  

- Station Call/Location  
  Define a station location for the QSOs you've made.  

- Operator  
  Usually, the Operator Callsign is the callsign of the logged-in user. Remember that the operator is just the basic call without any pre- or suffixes. It just describes "who" did the QSOs. The used callsign during the QSO is defined in the station location (with pre-/suffixes).

***

## Textarea and Syntax

<img width="650" alt="Simple FLE Text Area" src="https://github.com/wavelog/wavelog/assets/80885850/7d8ff258-820d-466c-84b4-d43f16400f90">

This is the place where you enter your QSOs. The syntax is based on lines and 'segments'. Some segments are required, while others are optional. The order of the segments does matter, so make sure you enter the data in the correct sequence.

### Line Operator

_Line Operators_ are used to change the band, mode, or date. All following QSOs will have these values.

#### Change band and/or mode
All modes which are implemented in your Wavelog Instance are supported.  
**SEGMENTS:** `BAND/FREQ  |  MODE`

```
20m ssb
17m
70cm fm
am
```

To change the frequency, use MHz and a dot as the decimal sign.
```
10.112 cw
7.145
```

#### Change date

Add a day to the last date that was set. One day for each `+` sign.
```
day +
day ++
... 
```

Another way to change the date is by typing it directly in the format YYYY-MM-DD
```
date 2024-05-21
```

### Add a QSO
Adding QSOs is quite simple. Just type at least the required segments and add information accordingly.  
  
**REQUIRED SEGMENTS:** `TIME  |  CALLSIGN   ...`  
**OPTIONAL SEGMENTS:** `...   |  RST(s) |  RST(r) | GRIDSQUARE |  REFERENCE`

#### Time
In the first line, you need to start with a full time `HHMM`, written without `:` (UTC).

```
1734 4W7EST
```

In all following lines, you just need to type in the change value.

```
1734 4W7EST
5 HB9HIL         -> QSO was at 17:35 UTC
1800 DJ7NT       -> QSO was at 18:00 UTC
13 DF2ET         -> QSO was at 18:13 UTC
```

#### Callsign
The callsign always needs to be the second segment after the QSO time. It can be with or without pre- and/or suffixes. The callsign can be upper or lower case. 

```
1703 LA8AJA/P
8 hb0/f4ans
23 dl/4w7est/m
```

#### RST

The signal report is divided into two segments: `RST(s)` and `RST(r)` (in this order). Both are optional! 

```
40m lsb
1337 DJ7NT        -> No RST. SFLE will use default RST for the used mode. E.g. 59 for SSB, 599 for CW and 0db for FT8

ft8
42 DF2ET -4 -12   -> Because we defined the mode as FT8, the reports are -4dB (sent) and -12dB (rcvd)

20 usb
1423 LA8AJA 43    -> If only one RST is given, this will be used as the sent RST. In this case: RST(s) 43, RST(r) 59
1554 HB9HJQ 7 3   -> You gave both RST but each just one digit. This will be used as Signal of the RST. Here: RST(s) 57, RST(r) 53
```

#### Reference
The reference for SOTA, IOTA, POTA, and WWFF is recognized by SimpleFLE fully automatically.

```
10m cw
0732 hb9/la8aja hbff-0499     ->  07:32 UTC - LA8AJA - RST defaults - WWFF Ref: HBFF-0499
3 dj7nt de-0034               ->  07:33 UTC - DJ7NT - RST defaults - POTA Ref: DE-0034
```
The reference type is indicated in the QSO table by the first letter of the reference type.  
<img width="135" alt="image" src="https://github.com/wavelog/wavelog/assets/80885850/02a689e6-e574-4e15-9a36-83036316d330">  
<img width="406" alt="image" src="https://github.com/wavelog/wavelog/assets/80885850/486111d3-c487-4994-b0fe-8d393d2390ed">

##### Special: "POTA 2fer" - Multiple Parks in POTA
POTA activators can have multiple references. From Wavelog Version 1.9.0 SimpleFLE supports multiple POTA references divided by commas `,`. Make sure there is **no space** after the comma!

```
3 HB9HGG ch-0067,ch-0068
```

#### Gridsquare
To set the gridsquare of your QSO partner just type the grid after the callsign or RST (but before reference). You may prefix the gridsquare with a hash `#`. Supported are 4-10 digit locators (JN47, JO31DH56, JD46SH ...).

```
1245 la8aja jo61dh
1246 la8aja #jo61dh
```

#### Operator name

As in the FLE specification, the operator name may be set by prefixing it with the at-symbol `@`:

```
1234 dn5ce @Anne
```

#### Contest exchange

The contest exchange parsing differs from the original FLE specification, as it also includes non-serial / non-numeric contest-exchanges. The sent information persists between QSOs, if there is a received contest-exchange detected.

Use a prefix comma (`,`) to denote sent exchange and a period (`.`) for received exchange. Both, comma and period may appear multiple times and do not need to be separated by spaces. Purely numeric characters will set the serial (technically: `srx` and `stx` ADIF-fields), whereas everything else (alphanumeric and slash) will set the exchange string (technically: `srx_string` and `stx_string` ADIF-fields).

```
2112 dn5ce ,1.12         <-- Sent 1, received 12
2114 dn5ce ,2,EU.NM      <-- Sent 2 and EU, received NM
2116 dn5ce ,3.123.AS     <-- Sent 3 and EU (persisted!), received 123 and AS
```
To clear the sent exchange use `,-`. To enable incrementing the sent serial automatically, use `,++` and disable it with `,+0`:

```
80m ,++                  <-- Set autoincrement
2110 dn5ce .73 ,1,EU     <-- Sent 1 and EU, received 73
2112 dn5ce .72           <-- Sent 2 and EU, received 72
2116 dn5ce ,             <-- Sent 3 and EU, no received exchange
2117 dn5ce ,-,8          <-- Sent 8 and no string - first all sent exchange is cleared, then the serial is set
```

#### Comments and QSL-Message

To include a QSL-message put it in square brackets, surround comments by angle brackets:

```
2359 dn5ce @Anne [Tnx fer fb qrq qso!] <QSO at 35wpm, fun time!> 
```

#### Additional fields

Using the comment-syntax, all implemented ADIF-fields may be set by naming the field, followed by a colon in the comment:

```
2312 dn5ce <tx_pwr:50> <rx_pwr:750> <darc_dok:F39> <sfi:210> <rig:QRPlabs QCX> <notes: …enter the notes-field>
```

The field `tx_pwr` and fields starting with `my_` are retained and *not reset* between QSOs - setting an empty value resets the field. Some `my_`-fields **will be overwritten** by station-location details.


ADIF-exports may include fields not visible in Wavelog, like `sfi` or `rx_pwr` from the example.

## Development Progress

Currently in work is a "Callbook Lookup" feature to lookup callsigns automatically [from the set callbook](https://github.com/wavelog/Wavelog/wiki/Callsign-Lookup).


*** 

Links:
- Original Project by DF3CB: [https://df3cb.com/fle/](https://df3cb.com/fle/)
- SimpleFLE written by OK2CQR: [https://github.com/ok2cqr/sfle](https://github.com/ok2cqr/sfle)
