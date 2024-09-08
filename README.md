# AtomSys5Keyboard
Use an Acorn Atom as a full functional ASCII keyboard for the System 5
This is a preliminary version of the software.

I want to build an Acorn System 5 compatible rack based computer. Since the keyboards are hard to find I decided to modify an old Atom for this purpose. It can be done without permanent damage to the Atom :-)

The System 5 keyboard is a an ASCII keyboard. It's connected to port A of the System's VIA on the CPU board. Bit 7 indicates wether there's a key pressed or not and the other bits represent the ASCII value of the pressed key. So I connect the Atom's VIA A-port to the keyboard connector with two additional lines for GND and the BREAK key. 
My intention is to remove as much as possible chips from the Atom. I thinks the only IC's needed are the 6502, the 6522, a modified ROM, zero page memory and some decoding logic. The video and cassette circuit can be removed to bring the power consumption as low as possible. The Atom can get its power from the System's keyboard connector in the final version.
By the time I start working seriously on this project (I am waiting for some components and PCB's) I will publish this at the StarDot forum and update this readme for more information.
