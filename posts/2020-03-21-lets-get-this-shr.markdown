---
title: "Let's get this SHR: or, how could there possibly be 10 different ways to shift bits in x86 assembler?"
author: 'Robert Stefanic'
---

The x86 instruction set is quite the behemoth. If you're just looking at the base 8086/8088 instruction set, then it doesn't seem so bad. But with each generation of processors that came out after that, more and more instructions were added. Now we have this giagantic instruction set where it's hard to tell the slight naunces between some of these instructions. Just looking at an index of all the x86 instructions is tiring. 

As one can imagine, there are many ways you can shift bits in x86. More precisely, there are 10 different ways to shift bits with x86 

This post also assumes you know what bit shifting is. So it's not going to explain what bit shifting is, but it will detail *how* the shifts in x86 differ. Besides two of the ten shift instructions, these shift instructions all do slightly different things (two of the shifts are isomorphic).

* * *

### The Basics

The shift instructions can be broken up into four main kinds. There are **logical** shifts, **arithmetic** shifts, **rotational** shifts, and **double** shifts. 

* **Logical** shifts are shifts that fill in the new bit positions with 0s. 
* **Arithmetic** shifts are shifts that fill in the new bit positions with a copy of the original number's sign.
* **Rotational** shifts are shifts that rotate the bits in a circular fashion.
* **Double** shifts are shifts fill in the new bit positions at the destination operand with the bits from the source operand.

Every **logical**, **arithmetic**, and **rotational** shift instruction has the same format: the first operand is the *destination* operand, and the second operand is the *amount* of shifts to be performed.

```asm
    ShiftInstruction DESTINATION, AMOUNT
```

We'll work our way through these shifts by their kind.

* * *

### The Logical Shifts

#### SHL (Shift Left)

```SHL``` shifts the bits logically to the left filling in the lowest bits with a zero. The highest bit is then moved into the carry flag, and the bit that was in the carry flag before this operation is discarded.

```asm
    mov al, 07Fh    ; AL = 01111111b, CF = 0
    shl al, 1       ; AL = 11111110b, CF = 0
```

#### SHR (Shift Right)

```SHR``` is the complement to ```SHL```. It shifts the bits logically to the right filling in the highest bits with a zero. The lowest bit is then moved into the carry flag, and the bit that was in the carry flag before this operation is discarded.

```asm
    mov al, 07Fh    ; AL = 01111111b, CF = 0
    shr al, 1       ; AL = 00111111b, CF = 1
```

* * *

### The Arithmetic Shifts

#### SAL (Shift Arithmetic Left)

```SAL``` works exactly the same as the ```SHL``` instruction. So why does it exist? It really only exists because it complements ```SAR```, which *does* do something different from ```SHR```.

#### SHR (Shift Arithmetic Right)

```SAR``` performs a shift on the bits arithmetically to the right, filling in the highest bit with the signed bit of the number instead of always just filling it in with a 0. The lowest bit is still moved into the carry flag, and the bit that was in the carry flag before this operation is discarded.

```asm
    mov al, 0F0h    ; AL = 11110000b
    sar al, 1       ; AL = 11111000b
```

* * *

### The Rotational Shifts

Let's kick it up a notch. What if we need to finagle the bits just a bit more?

#### ROL (Rotate Left)

```ROL``` shifts the bits to the left. But instead of discarding the highest bit, it copies the highest bit into both the carry flag **and** the lowest bit position.

```asm
   mov al, 010000000b
   rol al, 2             ; AL = 000000001b, CF = 1
```

#### ROR (Rotate Right)

```ROR``` is the complement to ```ROL```. ```ROR``` shifts the bits to the right. But instead of discarding the lowest bit, it copies the lowest bit into both the carry flag **and** the highest bit position.

```asm
   mov al, 000000010b
   ror al, 2             ; AL = 10000000b, CF = 1
   ror al, 1             ; AL = 01000000b, CF = 0
```

#### RCL (Rotate Carry Left)

```RCL``` shifts each bit to the left, copies the carry flag into the lowest bit, and copies the highest bit into the carry flag.

You can think of this instruction as adding an additional high bit where the highest bit is now the carry flag. The carry flag is now your most signficiant bit (MSB), and you're now preforming a rotate left shift on this value with the carry flag as your MSB.

```asm
    mov ah, 010000001b ; AH = 010000001b, CF = 0
    stc                ; AH = 010000001b, CF = 1
    rcl ah, 1          ; AH = 000000011b, CF = 1
    rcl ah, 1          ; AH = 000000111b, CF = 0
```

#### RCR (Rotate Carry Right)

```RCR``` is the complment to ```RCL```, but it goes in the opposite direction. It shifts each bit to the right, copies the carry flag into the highest bit, and copies the lowest bit into the carry flag.

Similar to ```RCL```, you can also think this as adding an additional bit to your value where the lowest bit is now the carry flag. The carry flag is now your least significant bit (LSB), and you're now preforming a rotate right shift on this value with the carry flag as the LSB.

```asm
    mov ah, 000000010h    ; AH = 000000010h, CF = 0
    stc                   ; AH = 000000010h, CF = 1
    rcr ah, 2             ; AH = 001000001h, CF = 0
```

* * *

### The Double Shifts

#### SHLD (Shift Left Double)

This instruction takes three operands: the first is the *destination* operand, the second is the *source* operand, the third is the *amount* of shifts.

```SHLD``` shifts the destination operand *n* amount of times to the left (where *n* is the *amount* specified as the third operand). The positions opened up by the bits shifted to the left are then filled in with the highest bits from the source operand.

```asm
    mov ax, 000000001b
    mov bx, 010000000b
    shld ax, bx, 1        ; AX = 000000011, BX = 010000000b
```

It's important to note that with the ```SHLD```  instruction, the *source* operand is not affected.

#### SHRD (Shift Right Double)

```SHRD``` is the complement to ```SHLD```. It does the same thing, but to the right. ```SHRD``` shifts the destination operand *n* amount of times to the right (where *n* is the *amount* specified as the third operand). The positions opened up by the bits shifted to the right are then filled in with the lowest bits from the source operand. Again, the *source* operand is not affected.

```asm
    mov ax, 000000001b
    mov bx, 010000000b
    shrd bx, ax, 1        ; AX = 000000001b, BX = 011000000b
```

* * *

### Summary

That's it. All these shifts do something slightly different, and depending on what you're doing, they may save you a few instructions! Of course this isn't the 60s where writing the tightest assembler code is crucial, but being able to use the right tool for the right task is important. When all you know is ```ROR```, then every ```shl al, 1``` looks like ```ror al, 7```.

<br>

| Instruction | Description |
| ------- | ------- |
| SHL | Shift Left |
| SHR | Shift Right |
| SAL | ~~Shift Left~~ Shift Arithmetic Left |
| SAR | Shift Arithmetic Right |
| ROL | Rotate Left |
| ROR | Rotate Right |
| RCL | Rotate Carry Left |
| RCR | Rotate Carry Right |
| SHLD | Shift Left Double |
| SHRD | Shift Right Double |
