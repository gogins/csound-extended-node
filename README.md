# csound.node
![GitHub All Releases (total)](https://img.shields.io/github/downloads/gogins/csound-extended-node/total.svg)<br>

Michael Gogins<br>
https://github.com/gogins<br>
http://michaelgogins.tumblr.com

## License

csound-extended-node is copyright (c) 2021 by Michael Gogins and 
other contributors to the csound-node-extended repository.

csound-extended-node is free software; you can redistribute it
and/or modify them under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

csound-node-extended is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this software; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
02110-1301 USA

## Introduction

[NW.js](http://nwjs.io/), which used to be called Node-Webkit, is a system for building 
applications for personal computers and workstations based on Web browser 
technology. Typically the user interface is defined in HTML and the program 
logic is defined in JavaScript. C++ addons, which expose JavaScript functions 
that call into C++ libraries, also can be used. The application executes in an 
embedded Web browser based on Google Chrome.

csound.node is a C++ addon for NW.js that embeds [Csound](http://csound.github.io/) into the 
JavaScript context of Web pages running in NW.js. Such pages can call core 
methods of the Csound API as member functions of a `csound` object that 
belongs to the window. The csound object also can execute Python, LuaJIT, or 
Embeddable Common Lisp code.

Therefore, NW.js with `csound.node` can be used not only for composing and 
performing Csound pieces, but also for developing standalone applications that 
incorporate Csound. It can be used, for example, to develop sound art 
installations, visual music, or kiosk-type applications.

The `csound_extended-examples/docs/message.html` piece is an example of an HTML file
that embeds not only Csound, but also a Csound orchestra and score. See below 
for how to run such pieces.

The motivation for csound.node should be obvious. It works on all personal 
computer platforms, the build steps are simple, and the end product makes all 
of the myriad capabilities of HTML5 available to Csound pieces, including 
JavaScript, user-defined HTML user interfaces, 3-dimensional animated computer
graphics, and much more. For a full list of capabilities currently implemented 
in HTML5, see [this HTML5 test page](https://html5test.com/).

Please log any bug reports or requests for enhancements at 
https://github.com/gogins/csound-extended-node/issues.

## Usage

From the command line, execute `nw <directory>`, where the directory contains the
JSON-formatted manifest of a NW.js application based on an HTML file that embeds a
Csound piece. See the NW.js documention for more information on the manifest and
packaging NW.js applications. An example manifest (must be named package.json) for
running "Message.html" with nw and csound.node is:

<pre>
{
  "main": "Message.html",
  "name": "Message",
  "description": "Piece for Csound and HTML5",
  "version": "0.1.0",
  "keywords": [ "Csound", "node-webkit" ],
  "nodejs": true,
  "node-remote": "http://<all-urls>/*",
  "window": {
    "title": "Message",
    "icon": "link.png",
    "toolbar": false,
    "frame": false,
    "maximized": true,
    "position": "mouse",
    "fullscreen": true
  },
  "webkit": {
    "plugin": true
  }
}
</pre>

To run your Csound pieces easily in nw, you can use a menu shortcut and script 
in your text editor to automate the construction and deployment of the 
manifest file, or you can use a template package.json and make a copy of your
piece with the name given in the manifest every time you want to run the piece.

The `run_nwjs_application.sh` script can be used in SciTE to automatically run 
the current HTML file in NW.js. See the comments in this script for how to 
configure your editor.

## Installation

Simply make sure that the csound.node shared libary is in a directory included 
in your NODE_PATH environment variable.

## Building

1. Node.js and npm must be installed, not from any Linux 
package repository, but according to the instructions for binary archives at 
https://github.com/nodejs/help/wiki/Installation. When that has been done, 
execute:
```
npm install -g node-gyp 
npm install -g node-addon-api
```

Also, put node-gyp into your executable PATH.

2. Build dependencies must be installed: Csound (on Linux, Csound must be 
   built from sources (https://github.com/csound/csound)) and 
   csound-extended (https://github.com/gogins/csound-extended).

3. The following environment variables MUST be set before building, perhaps in
your .profile script. Obviously, modify the paths as required to suit your
home directory and installation details. These are exported in `build-env.sh` 
which you can source in your .profile script.

```
CSOUND_SRC_ROOT=/home/mkg/csound-extended/dependencies/csound
NODE_PATH=/home/mkg/csound/csound/frontends/nwjs/build/Release
OPCODE6DIR64=/usr/local/lib/csound/plugins64-6.0
RAWWAVE_PATH=/home/mkg/stk/rawwaves
export PATH=/usr/local/lib/node-v12.14.1-linux-x64/bin:${PATH}
unset NODE_ADDON_API_INCLUDE
export NODE_ADDON_API_INCLUDE=/usr/local/lib/node-v12.14.1-linux-x64/lib/node_modules/node-addon-api
```
4. To actually build, execute:
```
node-gyp rebuild
```

If csound.node fails to build: 

1.  You may need to add the NPM bin directory to your PATH variable.
    
2.  You may need to manually configure `csound.node/binding.gyp` to explicly
    include the directory containing `napi.h` more or less as follows:
    ```
    'target_defaults': 
    {
       "cflags!": [ "-fno-exceptions" ],
        "cflags_cc!": [ "-fno-exceptions" ],
        "include_dirs": 
        [
            ## This is theoretically required but causes the build to fail: 
            ## "<!@(node -p \"require('node-addon-api').include\")",
            ## This does work but must be manually configured here:
            "/usr/local/lib/node-v12.14.1-linux-x64/lib/node_modules/node-addon-api",
        ],
    ```

