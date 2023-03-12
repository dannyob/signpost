# Signpost

Hello, frens:

On the wall of my home, I have two NeoPixel 32x8 matrices lashed together, and
wired up to a microcontroller. Originally this was set up so that I could flash
a "ON AIR" sign automatically when I was on a video call as a warning that to
local friends and family that I was in full performative mode and also they
should wear clothes when walking behind me.

As these things go, the Signpost design has now spiralled outwards into being a
full ulisp-driven graphics system. 

Its "design" is mostly just me clumsily lashing together the considered and
tidier work of hackers like:

- David Johnson-Davies and frens' [ulisp](http://www.ulisp.com/) lisp for microcontrollers.
- Lady Ada and frens' [Adafruit GFX](https://github.com/adafruit/Adafruit-GFX-Library) library.
- Michael Miller and frens' [NeoPixelBus](https://github.com/Makuna/NeoPixelBus) library.
- Me-no-dev and frens' [ESPAsyncWebServer](https://github.com/me-no-dev/ESPAsyncWebServer).
- Ayush Sharma and frens' [AsyncElegantOTA](https://github.com/ayushsharma82/AsyncElegantOTA).

Signpost by default drives two 32x8 NeoPixel displays, one piled on top of the
other to make a 32x16 matrix. The lower display is turned upside-down -- the
connecting wires were too short otherwise. The mapping for all this is handled
by the NeoPixelBus library, amazingly. It is connected to a Lilygogo (TTGogo)
T-Display ESP32 board on pin 17.

## LED signs over the web

The easiest way to drive the display is to visit
`http://signpost.local/screen/?text=YOUR+MESSAGE`. You could also use `curl -d
text="YOUR MESSAGE" 'http://signpost.local/screen/'`, or manually visit
[http://signpost.local/](http://signpost.local) in your browser. 

That will display the message in red on the NeoPixel. The font is a basic 3x5
character set: just uppercase, lowercase, numbers, "!" and ".". The text does
wrap, but not very prettily.

As an example of signpost's use, [onair](./bin/onair) is a shell script for a
Linux PC that will constantly check if a local program, such as Zoom or a web
browser, is accessing any attached cameras, and if so, will tell a signpost on
the local network to remotely display "ON AIR" in cheery LED letters.

## Lisp repl over serial or telnet

The ESP32 can also be controlled from the serial port, or by telnetting into port
1958. You'll get a ulisp repl. 

There are currently two additions to the standard ulisp library:

- (led-text string)
    Output a string in cylon red, to the Neopixel display.

- (led-getpixel x y)
    Return RGB565 integer value of Neopixel at (x,y).

- (with-led () body)
    By default, ulisps' graphic extensions are output on the T-Display's
    built-in TFT screen. Within the with-led special form, ulisp GFX extensions
    instead write to the Neopixel display.

## More power than you can safely use

WARNING: If you're like me, you'll only realise after building your 32x16
signpost, that you have invested in a total of 512 neopixels, each one using a
possible maximum of 60ma. That's an insane amount of ampage. Even if you found
a power supply that could provide the 30 amps for the full output, the wiring
of the matrices would probably melt.

Future versions of Signpost will hopefully include a LED brightness quota to
ensure you can't go overboard on power consumption. In the meantime, the
`led-text` function's soothing cylon red and skinny 3x5 font is low in power
needs. Just be careful with the graphics extensions -- too much power draw will
cause things to halt, if not always catch fire.




