# csound.node

Michael Gogins<br>
https://github.com/gogins<br>
http://michaelgogins.tumblr.com

## Introduction

[NW.js][nwjs], which used to be called Node-Webkit, is a system for building applications
for personal computers and workstations based on Web browser technology. Typically
the user interface is defined in HTML and the program logic is defined in JavaScript.
C++ addons, which expose JavaScript functions that call into C++ libraries, also can
be used. The application executes in an embedded Web browser based on Google Chrome.

`csound.node` is a C++ addon for NW.js that embeds [Csound][csound] into the JavaScript context
of Web pages running in NW.js. Such pages can call core methods of the Csound API
as member functions of a `csound` object that belongs to the window. The
`csound/examples/html` directory contains a number of examples that run in NW.js with
`csound.node` (the CSD examples will also run on Csound for Android or in CsoundQt).

Therefore, NW.js with `csound.node` can be used not only for composing and performing
Csound pieces, but also for developing standalone applications that incorporate Csound.
It can be used, for example, to develop sound art installations, visual music, or kiosk-type
applications.

The `NW_Csound_Demo.html` piece is an example of
an HTML file that embeds not only Csound, but also a Csound orchestra and score. The
`GameOfLife3D.csd` piece is an example of a CSD file that embeds a Web page in the
`<html>` element of the CSD file. See below for how to run these.

The motivation for `csound.node` should be obvious. It works on all personal computer
platforms, the build steps are simple, and the
end product makes all of the myriad capabilities of HTML5 available to Csound pieces,
including JavaScript, user-defined HTML user interfaces, 3-dimensional animated computer
graphics, and much more. For a full list of capabilities currently implemented in HTML5, see
[this HTML5 test page][html5test].

Please log any bug reports or requests for enhancements at https://github.com/gogins/csound-extended/issues.

## Usage

From the command line, execute `nw <directory>`, where the directory contains the
JSON-formatted manifest of a NW.js application based on an HTML file that embeds a
Csound piece. See the NW.js documention for more information on the manifest and
packaging NW.js applications. An example manifest (must be named package.json) for
running "Scrims_node.html" with nw and csound.node is:

<pre>
{
  "main": "Scrims_node.html",
  "name": "Scrims_node",
  "description": "Visual music for Csound and HTML5",
  "version": "0.1.0",
  "keywords": [ "Csound", "node-webkit" ],
  "nodejs": true,
  "node-remote": "http://<all-urls>/*",
  "window": {
    "title": "Scrims_node",
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

To run your Csound pieces easily in nw, you can use a menu shortcut and script in
your text editor to automate the construction and deployment
of the manifest file, or you can use a template package.json and make a copy of your
piece with the name given in the manifest every time you want to run the piece.

# Installation

See the installation instructions in the csound-extended main README.md.

You may need to ensure that the csound.node shared libary is in a directory included 
in the NODE_PATH environment variable.

## Building

Currently, there is an issue with a nw-gyp error in recent versions of NW.js. See https://github.com/nwjs/nw.js/issues/5960 for how to fix this by patching the nw-gyp configuration.

### Windows

Currently, on Windows, there is no need to build `csound.node`, it is distributed in the
Windows installer for Csound along with NW.js.

If you do want to build `csound.node` on Windows, then you need to install [Microsoft Visual Studio][msvs]
and [Python 2.7][python].

Install [NW.js](nwjs). On Windows, make sure you get the version built for the CPU architecture of the
version of Csound that you need to use. The default should now be x64.

Install [Node.js](https://nodejs.org/en/). On Windows, make sure you get the version built for the CPU architecture of the
version of Csound that you need to use. The default should now be x64.

From the Node.js command prompt, execute `npm install nw-gyp` to install the build tool
for NW.js addons. See [nw-gyp](http://docs.nwjs.io/en/v0.13.0-rc2/For%20Users/Advanced/Use%20Native%20Node%20Modules/) for more information.

Set an environment variable named `CSOUND_HOME` that points to the root directory of
your Csound tree. Or, it may be necessary to modify binding.gyp to reflect the
installed locations of the Csound header files and shared libraries on your system.

In the `csound/frontends/nwjs` directory, execute `nw-gyp rebuild --target=0.12.3 --arch=x64` (or, --arch=x86, or whatever version of NW you have) to build `csound.node`. If the build messages end with `ok`, then the build succeeded.

### Linux

Building on Linux is the same as building on Windows, except that one installs build-essentials, nodejs and npm using apt-get. Then, one installs nw-gyp using npm.

## Installing

### Windows

Currently, getting csound.node to run in a development environment is tricky. The easiest way is to run the csound/mingw64/find_csound_dependencies.py script,
which copies all Csound targets and dependencies into the NW.js directory. Then set both OPCODE6DIR64 and NODE_PATH also to point to the NW.js directory.

Test your installation by running the NW.js program, `nw`. Drag the `NW_Csound_Demo.html` file
and drop it on `nw`'s window. You should hear the Csound piece "Xanadu" by Joseph Kung,
which is embedded in the HTML file, and you should be able press the [F12] key
to bring up the NW.js developer tools, where you should see the runtime messages
from Csound being printed in the JavaScript console.

### Linux

There are severa ways of installing on Linux, but the following works for me. Essentially, I am accessing Csound executables from Csound's build directory. This of course assumes you are building Csound from sources. If you are not doing that but only building csound.node itself, create a NODE_PATH environment variable that points to its directory.

After building csound.node, I copy it to ~/csound/cs6make.

I use my Csound build directory as a node_modules directory. I define in my .bashrc file:

<pre>
export CSOUND_HOME=~/csound/csound
# This means that nw and node can load shared libraries loaded by csound.node.
export LD_LIBRARY_PATH=~/csound/cs6make
# This means nw can run an app from any directory and still require csound.node.
export NODE_PATH=~/csound/cs6make
export OPCODE6DIR64=$NODE_PATH
export RAWWAVE_PATH=/usr/share/stk/rawwaves
</pre>

[csound]: http://csound.github.io/
[nwjs]: http://nwjs.io/
[iojs]: https://iojs.org/en/index.html/
[msvs]: https://www.visualstudio.com/
[html5test]: https://html5test.com/
[gcc]: https://gcc.gnu.org/
[python]: http://www.python.org/
[nw-gyp]: https://github.com/nwjs/nw-gyp/
