<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>mko</title>
</head>
<body>

<h1>mko</h1>

<p><strong>mko</strong> is a small Bash helper for Linux that combines:</p>
<ul>
  <li><code>mkdir -p</code> – create parent directories if they do not exist,</li>
  <li><code>touch</code> – create files if they do not exist,</li>
  <li>and opening <strong>only the last file</strong> in your chosen editor (<code>nano</code> or <code>nvim</code>).</li>
</ul>

<p>It also supports dry-run mode, silent mode, simple logging, persistent editor selection, and optional auto-install of <code>nano</code>/<code>nvim</code> on Ubuntu and Arch-based systems.</p>

<hr>

<h2>Table of contents</h2>
<ol>
  <li><a href="#features">Features</a></li>
  <li><a href="#installation">Installation</a></li>
  <li><a href="#uninstallation">Uninstallation</a></li>
  <li><a href="#usage">Usage</a></li>
  <li><a href="#options">Options</a></li>
  <li><a href="#editor-selection-auto-install">Editor selection &amp; auto-install</a></li>
  <li><a href="#logging">Logging</a></li>
  <li><a href="#behaviour-with-existing-files">Behaviour with existing files</a></li>
  <li><a href="#permissions-root-and-sudoers">Permissions, root, and sudoers</a></li>
  <li><a href="#similar-works">Similar works</a></li>
  <li><a href="#license">License</a></li>
</ol>

<hr>

<h2 id="features">Features</h2>
<ul>
  <li>Create directory tree if missing using <code>mkdir -p</code>.</li>
  <li>Create file if it does not exist using <code>touch</code>.</li>
  <li>Accept multiple file paths but open <strong>only the last one</strong> in the editor.</li>
  <li>Prompt before opening an <strong>existing non-empty</strong> file (safety).</li>
  <li><code>--dry-run</code> mode to show what would happen without changing anything.</li>
  <li><code>--silent</code> mode to suppress normal output (useful in scripts).</li>
  <li>Basic logging of actions to <code>~/.mko.log</code>.</li>
  <li>Colourful terminal messages when appropriate (TTY and not in silent mode).</li>
  <li>Persistent editor choice between <code>nano</code> and <code>nvim</code>.</li>
  <li>Optional <strong>auto-install</strong> of <code>nano</code>/<code>nvim</code> on Ubuntu / Arch-based systems if missing.</li>
</ul>

<hr>

<h2 id="installation">Installation</h2>

<h3>Quick install via curl</h3>

<p>Run this in your terminal:</p>

<pre><code>curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/install.sh | bash
</code></pre>

<p>This will:</p>
<ol>
  <li>Download <code>mko</code> into <code>$HOME/.local/bin/mko</code>.</li>
  <li>Make it executable.</li>
  <li>Add <code>$HOME/.local/bin</code> to your <code>PATH</code> in your shell config
      (for example <code>~/.bashrc</code> or <code>~/.zshrc</code>) if it is not already there.</li>
</ol>

<p>After installation, either open a new terminal or reload your shell config, e.g.:</p>

<pre><code>source ~/.bashrc
# or
source ~/.zshrc
</code></pre>

<p>Then test:</p>

<pre><code>mko --help
</code></pre>

<h3>Manual install</h3>

<ol>
  <li>Download the script:
    <pre><code>curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/mko -o ~/mko
chmod +x ~/mko
</code></pre>
  </li>
  <li>Move it somewhere on your <code>PATH</code>, for example:
    <pre><code>mkdir -p ~/.local/bin
mv ~/mko ~/.local/bin/
</code></pre>
  </li>
  <li>Ensure <code>~/.local/bin</code> is on your <code>PATH</code> by adding this line to
      <code>~/.bashrc</code>, <code>~/.zshrc</code> or <code>~/.profile</code>:
    <pre><code>export PATH="$HOME/.local/bin:$PATH"
</code></pre>
  </li>
</ol>

<hr>

<h2 id="uninstallation">Uninstallation</h2>

<h3>Quick uninstall via curl</h3>

<p>Run:</p>

<pre><code>curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/uninstall.sh | bash
</code></pre>

<p>This script:</p>
<ul>
  <li>Removes <code>$HOME/.local/bin/mko</code> if present.</li>
  <li>Removes the config directory <code>~/.config/mko</code> (or <code>$XDG_CONFIG_HOME/mko</code>).</li>
  <li>Removes the log file <code>~/.mko.log</code> if present.</li>
  <li>Does <strong>not</strong> edit your shell config; any added <code>PATH</code> lines stay and can be removed manually.</li>
</ul>

<h3>Manual uninstall</h3>

<ol>
  <li>Delete the binary:
    <pre><code>rm -f ~/.local/bin/mko
</code></pre>
  </li>
  <li>Delete config and logs:
    <pre><code>rm -rf ~/.config/mko
rm -f ~/.mko.log
</code></pre>
  </li>
  <li>(Optional) Edit <code>~/.bashrc</code>, <code>~/.zshrc</code> or <code>~/.profile</code> and
      remove the lines added by the installer that are marked
      <code># Added by mko installer</code>.</li>
</ol>

<hr>

<h2 id="usage">Usage</h2>

<p>Basic usage:</p>
<pre><code>mko path/to/file.txt
</code></pre>

<p>This will:</p>
<ol>
  <li>Create <code>path/to</code> if it does not exist.</li>
  <li>Create <code>file.txt</code> if it does not exist.</li>
  <li>Open <code>file.txt</code> in the configured editor (<code>nano</code> or <code>nvim</code>).</li>
</ol>

<p>With multiple files:</p>
<pre><code>mko src/app/main.py src/app/utils/helpers.py
</code></pre>

<ul>
  <li>Ensures both directories and files exist.</li>
  <li>Opens only the <strong>last</strong> file, here <code>src/app/utils/helpers.py</code>, in the editor.</li>
</ul>

<hr>

<h2 id="options">Options</h2>

<pre><code>mko [options] FILE...

Options:
  -n, --dry-run         Show what would be done; do not create or open anything.
  -s, --silent          Suppress informational output (errors still shown).
  -f, --force           Do not ask before opening an existing non-empty file.
  -e, --editor EDITOR   Use EDITOR (nano or nvim) for this run only.
      --set-editor E    Persistently set default editor to nano or nvim.
  -h, --help            Show help and exit.
</code></pre>

<h3>Examples</h3>

<p>Dry run:</p>
<pre><code>mko --dry-run src/main.c include/main.h
</code></pre>

<p>Silent mode (good for scripts):</p>
<pre><code>mko --silent config/app.conf
</code></pre>

<p>Force open even if non-empty:</p>
<pre><code>mko --force notes/today.md
</code></pre>

<p>One-off editor override:</p>
<pre><code>mko -e nvim src/app.py
mko -e nano README.md
</code></pre>

<p>Persistent editor selection:</p>
<pre><code>mko --set-editor nano
# or
mko --set-editor nvim
</code></pre>

<hr>

<h2 id="editor-selection-auto-install">Editor selection &amp; auto-install</h2>

<h3>Persistent editor choice</h3>

<p>By default, <code>mko</code> prefers:</p>
<ol>
  <li>The editor stored in its own config (if set).</li>
  <li><code>$EDITOR</code> if it is exactly <code>nano</code> or <code>nvim</code>.</li>
  <li><code>nvim</code> if installed.</li>
  <li>Otherwise <code>nano</code>.</li>
</ol>

<p>The config file is stored at:</p>
<pre><code>~/.config/mko/config
</code></pre>

<p>Example content:</p>
<pre><code>EDITOR_CHOICE=nvim
</code></pre>

<p>The <code>--set-editor</code> flag writes or updates this file.</p>

<h3>Auto-install on Ubuntu / Arch</h3>

<p>If the chosen editor (<code>nano</code> or <code>nvim</code>) is not installed, and you are on a supported distribution, <code>mko</code> will:</p>

<ol>
  <li>Detect the distribution via <code>/etc/os-release</code>.</li>
  <li>Prompt:
    <pre><code>Editor 'nvim' is not installed. Attempt to install it now (requires sudo)? [y/N]</code></pre>
  </li>
  <li>On Ubuntu / Debian, run (only if you answer <code>y</code>):
    <pre><code>sudo apt update
sudo apt install -y nano      # or neovim
</code></pre>
  </li>
  <li>On Arch-based systems, run:
    <pre><code>sudo pacman -Sy --needed --noconfirm nano    # or neovim
</code></pre>
  </li>
  <li>On other distributions, print an error and ask you to install the editor manually.</li>
</ol>

<p>If <code>sudo</code> is not available at all, <code>mko</code> prints explicit instructions with example package-manager commands and exits, so you can:</p>
<ul>
  <li>Ask an administrator to install <code>nano</code> or <code>neovim</code>, or</li>
  <li>Install them yourself as root using your distribution’s package manager.</li>
</ul>

<p>If installation via <code>sudo</code> fails (for example you are not in the sudoers list or there is a network problem), <code>mko</code> reports the failure and asks you to install the editor manually before trying again.</p>

<p>In <code>--dry-run</code> mode, <code>mko</code> only reports that it would attempt installation; it does not run any package-manager commands.</p>

<hr>

<h2 id="logging">Logging</h2>

<p>When not in dry-run mode, real actions are appended to:</p>
<pre><code>~/.mko.log
</code></pre>

<p>Examples of log entries:</p>
<pre><code>2025-11-21 10:15:03 Created directory: /home/user/projects/demo/src
2025-11-21 10:15:03 Created file: /home/user/projects/demo/src/main.py
2025-11-21 10:15:03 Opening file with nvim: /home/user/projects/demo/src/main.py
</code></pre>

<p>No log entries are written when <code>--dry-run</code> is used.</p>

<hr>

<h2 id="behaviour-with-existing-files">Behaviour with existing files</h2>

<ul>
  <li>If the <strong>last</strong> file exists and is <strong>non-empty</strong>, <code>mko</code> will ask:

    <pre><code>File 'path/to/file' exists and is not empty. Open in nvim? [y/N]</code></pre>
  </li>
  <li>Answer <code>y</code> or <code>yes</code> to open; any other answer skips opening.</li>
  <li>Use <code>--force</code> to bypass the question and open the file anyway.</li>
  <li>In <code>--silent</code> mode, the default is to <strong>not</strong> open non-empty existing files unless <code>--force</code> is given.</li>
</ul>

<hr>

<h2 id="permissions-root-and-sudoers">Permissions, root, and sudoers</h2>

<ul>
  <li><strong>Installing and running mko does not require root</strong> when using the standard installation path:
    <ul>
      <li>The installer places the script in <code>$HOME/.local/bin</code>.</li>
      <li>PATH changes are written to your own <code>~/.bashrc</code>, <code>~/.zshrc</code> or <code>~/.profile</code>.</li>
      <li>Directory and file creation only succeed where your user has write permission.</li>
    </ul>
  </li>
  <li><strong>sudo/root access is only needed if you agree to the auto-install prompt for nano/nvim:</strong>
    <ul>
      <li>If you are in the sudoers list, mko can install the editor using <code>sudo apt …</code> or <code>sudo pacman …</code>.</li>
      <li>If you are not in sudoers, the installation will fail; mko reports this and asks you to install the editor manually as root.</li>
      <li>If <code>sudo</code> is not present at all, mko prints clear instructions and exits without attempting installation.</li>
      <li>You can always answer <code>N</code> to the install prompt; in that case, no sudo command is run.</li>
    </ul>
  </li>
</ul>

<hr>

<h2 id="similar-works">Similar works</h2>

<p>These public projects provide related functionality in the general area of file creation and command-line helpers:</p>

<ul>
  <li><code>fuyalasmit/mkfile-cli</code></li>
  <li>Various shell helper collections that combine file and directory utilities.</li>
</ul>

<p>This project focuses specifically on a single command that prepares the path (directories and file) and then opens the last file in a text editor, with small quality-of-life features for everyday development.</p>

<hr>

<h2 id="license">License</h2>

<p>This project uses <strong>The Unlicense</strong>, which effectively places the code in the public domain.</p>

<pre><code>This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
</code></pre>

</body>
</html>
