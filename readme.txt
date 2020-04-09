SUPERFIX.PRG
Copyright (c) 2020 Christian Zietz <czietz@gmx.net>


== Usage ==

SUPERFIX.PRG fixes random crashes that happen when using the USB keyboard
or mouse drivers for TOS/EmuTOS together with ExtenDOS. It needs to be run
(preferably immediately) after EXTENDOS.PRG. It's not required under
FreeMiNT.


== Technical explanation ==

SUPERFIX.PRG works around a GEMDOS reentrancy issue: Under TOS, the USB
keyboard and mouse drivers are invoked by the timer interrupt, which can
occur in the middle of a GEMDOS call. GEMDOS is not designed to be
reentrant. In particular, this also applies to the parts that ExtenDOS adds
to GEMDOS. Unfortunately, the USB drivers have to call the GEMDOS function
Super(1) to detect whether they are being executed in supervisor mode. If
this happens while ExtenDOS is already handling a GEMDOS call, the current
program crashes.
SUPERFIX.PRG handles Super(1) calls in a reentrant way so that they are not
passed to GEMDOS/ExtenDOS.


== License ==

SUPERFIX.PRG is free software under the MIT License. The full license is as
follows:

Copyright (c) 2020 Christian Zietz <czietz@gmx.net>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.