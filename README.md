# csound.node
![GitHub All Releases (total)](https://img.shields.io/github/downloads/gogins/csound-extended-node/total.svg)<br>

Michael Gogins<br>
https://github.com/gogins<br>
http://michaelgogins.tumblr.com

## Deprecation Notice

Currently, I am not maintaining this repository. In general, my priority is 
composing music, not programming. However, I create open-source GitHub 
repositories in order to share tools that I create for composing. As my 
working methods change, so do the tools I create. 

I now use [csound-webserver-opcodes](https://github.com/gogins/csound-webserver-opcodes), 
which run as plugin opcodes inside Csound, instead of csound-node to support 
the use of HTML and JavaScript in Csound pieces.

However, this repository will remain available.

## License

csound-extended-node is copyright (c) 2021 by Michael Gogins and 
other contributors to the csound-node-extended repository.

csound-extended-node is free software; you can redistribute it
and/or modify them under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

csound-extended-node is distributed in the hope that it will be useful,
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
belongs to the window.

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

Simply make sure that the `csound.node` shared libary is in a directory included 
in your `NODE_PATH` environment variable.

## Building

csound-extended-node is built in the "npm way" but uses cmake.js rather than 
node-gyp to compile the addon.

1. Make a local clone of this repository.

2. Install Csound from `https://csound.com/download.html`. On Linux, it is 
   easy to build Csound from source code.

3. Install npm.

4. Install node-addon-api: `npm install -g node-addon-api`.

5. Install cmake-js: `npm install -g cmake-js`.

6. The following environment variable MUST be set before using, perhaps in
your .profile script. `NODE_PATH` must be the pathname to the directory 
where csound.node has been built. The example is for macOS, so you must 
change this to suit your environment.

```
NODE_PATH=/Users/michaelgogins/csound-extended-node/build/release
```

7. CMakeLists.txt is configured for building on macOS. You will need to 
   change the library and include directories configuration to suit your 
   own environment. To actually build execute:
```
cmake.js rebuild
```

