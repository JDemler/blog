---
title: Types, Structs, and Unions
layout: post
---

I'm going to explain some things about C and computers in general in simplified
terms, ignoring a lot of implementation details.

When a C program starts, it has access to a big chunk of memory. This memory is
basically just a really long series of bits that can only either be 1 or 0.
Everything in computing is either a 1 or a 0, and that's it!  I've always loved
that.

Here are a bunch of bits:

```
0110100001100101011011000110110001101111001000000111011101101111011100100110110001100100
```

Here, here are some more bits:

```
0100110001101111011011110110101100100000011000010111010000100000011110010110111101110101001000010010000001011001011011110111010100100111011100100110010100100000011101100110010101110010011110010010000001100011011011000110010101110110011001010111001000101100001000000110110101100001011110010110001001100101001000000111100101101111011101010010000001110011011010000110111101110101011011000110010000100000011100110110101101101001011100000010000001110100011010000110100101110011001000000111001101100101011000110111010001101001011011110110111000101110
```

You get the idea. You can think of this collection of bits as one long
continuous block. It isn't _really_ that, necessarily, but you can think of it
that way.

The C program can only "see" a small portion of the
memory that is available to the whole computer, but from the program's
perspective, this memory is it's entire universe.

There isn't much you can represent with binary atomic values like 1 and 0. In
fact, you can only represent like, max 2 things. Hamburgers (1) and hotdogs (0)
maybe, or donuts (0) and jetskis (1), or, idk, true (1) and false (0). Whatever. We need to be able to represent
_way_ more than two things.

if we group bits together and look at them as little contiguous units, we can
do that. If we always read them two at a time, suddenly we can represent 4
things:

```
00 Hamburgers
01 Hotdogs
10 Bacon Sandwiches
11 Ice Cream
```

This could be arbitrary, as above, or it could make more sense, like this, now
with groups of 3 bits:

```
000 Zero
001 One
010 Two
011 Three
100 Four
101 Five
110 Six
111 Seven
```

In that case, a set of bits like `011001` would map to `3` for the first three bits
and `1` for the second three bits.

This is just counting up in binary numbers, in fact, and binary is just another
way of saying "base 2."

Decimal numbers, the numbers we are used to using almost all the time in
regular life, have a base of 10 (`Dec-` for 10, like in
`decade` or `decathalon`). Counting up like this, try it on your hands:

```
 0  1  2  3  4  5  6  7  8  9 10
10 11 12 13 14 15 16 17 18 19 20
etc...
```

Notice that the "full" set of fingers (10!) is the same thing as the "empty"
set of fingers for the next round up.

When you get to 9 (the tenth number, including 0!) you increment the tens place
and start over at zero. The fact that we do this is pretty arbitrary, really,
and probably came from having ten fingers. What if we had 4 fingers on each
hand, for a total of 8 fingers?

```
 0  1  2  3  4  5  6  7 10
10 11 12 13 14 15 16 17 20
```

That would be a base of 8. Or how about 2 fingers on one hand and 1 on the other?

```
 0  1  2 10
10 11 12 20
```

That would be base 3. How about just two lonely fingers on one lonely hand?

```
  0   1  10
 10  11 100
100 101 111
```

Aha, base 2! Remember, the "full" count of all the fingers is equivalent to
the empty count on the next set up, like when you get to the 10s and 20s and
30s and onwards and upwards!

> It's important to pause here to point out again that what a collection of
bits represents really is arbitrary, we can map it to anything we want, as long
as we all agree on that mapping. MAYBE LINK TO ASCII SOMETHING Just keep this
in mind when we talk about types.

You might notice that which each added bit, we double the amount of things we could
represent.

```
1 = 2^1 = 2 things
2 = 2^2 = 4 things
3 = 2^3 = 8 things
.
8 = 2^8 = 256 things!
.
32 = 2^32 = 4294967296 things!!!
.
64 = 2^64 = 18446744073709551616 things!!!!!! ZOMG  . * ･ ｡ﾟ☆━੧༼ •́ヮ•̀ ༽୨
```

Remember, these are _bits_. A bit is one tiny piece of information: 1 or 0. A lot
of times we will also talk about _bytes_, which are chunks of 8 bits. 2 bytes are 16
bits, 8 bytes are 64 bits, etc. _One_ byte is 8 bits, which can represent 256
things (`2^8`). If that rings a bell, maybe you've worked with digital imagry,
where often the most saturated value in an RGB channel is represented as `255`
(the `256th` value is `0`!)

Let's look at a little C program.

```c
#include <stdio.h>

int main() {
    int x;
    printf("%lu", sizeof x);
    return 0;
}
```

Notice the variable declaration `int x;`. This program sets aside some space in the memory for `x`, which we are telling
the program is an `int`. That's what declaring a variable does; whether or not
you assign it any value (this program does not do that, `x` has not been
initialized to any value, and so is _uninitialized_), it sets aside that space.

In C, the typing of a variable determines an appropriate amount of memory to
use for that variable's value. In the above example, the `sizeof` operator
looks at x, discovers that it is an int, and prints out the number of _bytes_
that an int uses, which in this case is:

```
4
```

4 bytes is 32 bits, so an `int` on my machine (this can vary by machine!) takes
up 32 bits. looking at the table above, 32 bits (4 bytes) can represent a
maximum of `4294967296` things.

><h4>Signed vs Unsigned Integers</h4>
> Though 32 bits can represent `4294967296` things, it doesn't necessarily
> represent a number that large. We also need a way to represent negative
> numbers. A _signed_ integer (which is the default) uses the _most significant
> bit_ as a flag to mark a number as negative (1) or positive (0). In our above
> example, as a signed int, x can be initialized to a value between -2147483648
> and 2147483647 (they are one off of each other to account for 0), which is
> 1/2 of 4294967296 and also is equal to 2^31 (because that one bit is used as
> the sign: 32 - 1 = 31).

`int`s, on my machine, are 4 bytes long.

Remember- `x` here is still _uninitialized_ If you try to actually _use_ an
uninitialized variable, you'll get a warning, something like this:

```
filename.c:6:19: warning: variable 'x' is uninitialized when used here
    printf("%i", x);
```

Though you haven't assigned `x` to anything, that line _will_ print out a
value. That value is junk data; it's whatever happened to be in the slot that
was set aside for x, but since x was not initialized, that slot had residual,
junk data inside of it. It will also be different each time you run the
program, since memory allocation occurs at runtime.

Knowing that an int is 32 bits long is valuable information. Remember before,
when we looked at our 3 bit possibilities? Well, that actually would look more
like this, with a bunch of leading zeroes:

```
00000000000000000000000000000000 Zero
00000000000000000000000000000001 One
00000000000000000000000000000010 Two
00000000000000000000000000000011 Three
00000000000000000000000000000100 Four
00000000000000000000000000000101 Five
00000000000000000000000000000110 Six
00000000000000000000000000000111 Seven
```

We never write it down that way.