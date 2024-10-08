# AtomSys5Keyboard
Use an Acorn Atom as a full functional ASCII keyboard for the System 5
This is a preliminary version of the software.

I want to build an Acorn System 5 compatible rack based computer. Since the keyboards are hard to find I decided to modify an old Atom for this purpose. It can be done without permanent damage to the Atom :-)

The System 5 keyboard is a an ASCII keyboard. It's connected to port A of the System's VIA on the CPU board. Bit 7 indicates wether there's a key pressed or not and the other bits represent the ASCII value of the pressed key. So I connect the Atom's VIA A-port to the keyboard connector with two additional lines for GND and the BREAK key. 
My intention is to remove as much as possible chips from the Atom. I thinks the only IC's needed are the 6502, the 6522, a modified ROM, zero page memory and some decoding logic. The video and cassette circuit can be removed to bring the power consumption as low as possible. The Atom can get its power from the System's keyboard connector in the final version.
By the time I start working seriously on this project (I am waiting for some components and PCB's) I will publish this at the StarDot forum and update this readme for more information.

**This is free software, no warranties. Use it at your own risk!**

The software is written in BeebAsm but it won't be very hard to modify it for another assembler. The build.sh script produces two binary files:
sys5keyb.atm
sys5keyb.bin

The .atm version has a 22 byte header that is used by the AtoMMC software and this header contains the information about the load and execution address of the file. If you want to program the keyboard driver into an EPROM then you want to use the .bin file.

*Hardware modifications*

There are no hardware modifications necessary, other than a 64 way connector to plug into the Atom Expansion connector at the back side. You need a flat cable that connects the D0 ... D6, Strobe and 0V signals to this connector. It connects to the 6522's A port like this:
PA0 (A20) -> D0
PA1 (A19) -> D1
PA2 (A18) -> D2
PA3 (A17) -> D3
PA4 (A16) -> D4
PA5 (A15) -> D5
PA6 (A14) -> D6
PA7 (A13) -> Strobe

And also 0V (A32) goes from the System's keyboard connector to the Atom's 0V. Optionally you can also feed the Atom's reset line (B6) into the System's keyboard connector.

*Autostart*

My intention is to remove as much as IC's from the Atom and only the 6522, 6502, zeropage, ROM and the most necessary decoding logic will remain in the Atom. This keeps the current low so the Atom can get its power from the System 5 keyboard connector. But that requires a new ROM in socket 20. But you can also burn the programme into a 2532 EPROM and install that in socket 24. After each reset you have to LINK #A000 to start the programma. But there's also another trick to make it start automatically: on the expansion connector, put a wire from 0V (B32) to the IRQ pin (A28 or is it B28? I didn't build this yet). After the 6502 has done its reset routine it gets an interrupt and jumps to #A000 where our programme is. After removing the connector from the Atom, it will work normally.

