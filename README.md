<h1 id="mko">mko</h1>
<p><code>mko</code> is a small Bash helper for Linux that combines:</p>
<ul>
  <li><code>mkdir -p</code> – create parent directories if they do not exist,</li>
  <li><code>touch</code> – create file(s) if they do not exist,</li>
  <li>and opening only the last file in your chosen editor (<code>nano</code> or <code>nvim</code>).</li>
</ul>
<p>It also supports dry-run mode, silent mode, simple logging, persistent editor selection, optional auto-install of <code>nano</code>/<code>nvim</code> on Ubuntu and Arch-based systems, and an interactive safety prompt with a new “empty and open” option.</p>

<hr />

<h2 id="table-of-contents">Table of contents</h2>
<ol>
  <li><a href="#features">Features</a></li>
  <li><a href="#installation">Installation</a></li>
  <li><a href="#uninstallation">Uninstallation</a></li>
  <li><a href="#usage">Usage</a></li>
  <li><a href="#options">Options</a></li>
  <li><a href="#existing-files">Behaviour with existing files</a></li>
  <li><a href="#editor-selection">Editor selection &amp; auto-install</a></li>
  <li><a href="#logging">Logging</a></li>
  <li><a href="#permissions">Permissions, root, and sudoers</a></li>
  <li><a href="#similar-works">Similar works</a></li>
  <li><a href="#license">License</a></li>
</ol>

<hr />

<h2 id="features">1. Features</h2>
<ul>
  <li>Create directory trees if missing using <code>mkdir -p</code>.</li>
  <li>Create file(s) if they do not already exist using <code>touch</code>.</li>
  <li>Accept multiple file paths but open only the last one in the editor.</li>
  <li>Prompt before opening an existing non-empty file, with a choice to keep or empty its contents.</li>
  <li><code>--dry-run</code> mode to show what would happen without changing anything.</li>
  <li><code>--silent</code> mode to suppress normal output (useful in scripts).</li>
  <li>Basic logging of actions to <code>~/.mko.log</code>.</li>
  <li>Colourful terminal messages when appropriate (TTY and not in silent mode).</li>
  <li>Persistent editor choice between <code>nano</code> and <code>nvim</code>.</li>
  <li>Optional auto-install of <code>nano</code>/<code>nvim</code> on Ubuntu / Arch-based systems if missing.</li>
</ul>

<hr />

<h2 id="installation">2. Installation</h2>

<h3 id="installation-sourced">2.1 Recommended: run as a sourced script (auto-reload)</h3>
<p>This form runs the installer inside your current shell, so it can reload your shell configuration automatically if it appends to your rc file.</p>
<pre><code>source &lt;(curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/install.sh)
</code></pre>
<p>This will:</p>
<ol>
  <li>Download <code>mko</code> into <code>$HOME/.local/bin/mko</code>.</li>
  <li>Make it executable.</li>
  <li>Add <code>$HOME/.local/bin</code> to your <code>PATH</code> in your shell config (for example <code>~/.bashrc</code> or <code>~/.zshrc</code>) if it is not already there.</li>
  <li>Reload the relevant rc file in the current shell so <code>mko</code> becomes available immediately.</li>
</ol>
<p>If <code>mko</code> is already installed in <code>$HOME/.local/bin</code>, running this command again will simply download the latest version and update the existing script in place.</p>
<p>After it finishes, you should be able to run:</p>
<pre><code>mko --help
</code></pre>

<h3 id="installation-pipe">2.2 Alternative: classic pipe install</h3>
<p>If you prefer the usual <code>curl | bash</code> style, use:</p>
<pre><code>curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/install.sh | bash
</code></pre>
<p>This does the same file operations as above, but runs in a child shell. It cannot modify the environment of your existing terminal session. After it finishes:</p>
<ul>
  <li>Either open a new terminal, or</li>
  <li>Run <code>source</code> on the rc file mentioned by the installer output (for example <code>source ~/.bashrc</code>).</li>
</ul>
<p>Then test:</p>
<pre><code>mko --help
</code></pre>

<h3 id="installation-manual">2.3 Manual install</h3>
<ol>
  <li>Download the script:</li>
</ol>
<pre><code>curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/mko -o ~/mko
chmod +x ~/mko
</code></pre>
<ol start="2">
  <li>Move it somewhere on your <code>PATH</code>, for example:</li>
</ol>
<pre><code>mkdir -p ~/.local/bin
mv ~/mko ~/.local/bin/
</code></pre>
<ol start="3">
  <li>Ensure <code>~/.local/bin</code> is on your <code>PATH</code> by adding this line to <code>~/.bashrc</code>, <code>~/.zshrc</code> or <code>~/.profile</code>:</li>
</ol>
<pre><code>export PATH="$HOME/.local/bin:$PATH"
</code></pre>

<hr />

<h2 id="uninstallation">3. Uninstallation</h2>

<h3 id="uninstallation-quick">3.1 Quick uninstall via curl</h3>
<p>Run:</p>
<pre><code>curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/uninstall.sh | bash
</code></pre>
<p>This script:</p>
<ul>
  <li>Removes <code>$HOME/.local/bin/mko</code> if present.</li>
  <li>Removes the config directory <code>~/.config/mko</code> (or <code>$XDG_CONFIG_HOME/mko</code>).</li>
  <li>Removes the log file <code>~/.mko.log</code> if present.</li>
  <li>Does not edit your shell config; any added <code>PATH</code> lines stay and can be removed manually.</li>
</ul>

<h3 id="uninstallation-manual">3.2 Manual uninstall</h3>
<ol>
  <li>Delete the binary:</li>
</ol>
<pre><code>rm -f ~/.local/bin/mko
</code></pre>
<ol start="2">
  <li>Delete config and logs:</li>
</ol>
<pre><code>rm -rf ~/.config/mko
rm -f ~/.mko.log
</code></pre>
<ol start="3">
  <li>(Optional) Edit <code>~/.bashrc</code>, <code>~/.zshrc</code> or <code>~/.profile</code> and remove the lines added by the installer that are marked <code># Added by mko installer</code>.</li>
</ol>

<hr />

<h2 id="usage">4. Usage</h2>
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
  <li>Opens only the last file, here <code>src/app/utils/helpers.py</code>, in the editor.</li>
</ul>

<hr />

<h2 id="options">5. Options</h2>
<pre><code>mko [options] FILE...
</code></pre>
<pre><code>Options:
  -n, --dry-run               Show what would be done; do not create or open anything.
  -s, --silent                Suppress informational output (errors still shown).
  -f, --force, -y, --yes      Do not ask before opening an existing non-empty file.
      --empty                 If the last file exists and is non-empty, empty it and open.
  -e, --editor EDITOR         Use EDITOR (nano or nvim) for this run only.
      --set-editor EDITOR     Persistently set default editor to nano or nvim.
  -h, --help                  Show help and exit.
</code></pre>

<h3 id="options-examples">5.1 Examples</h3>
<p>Dry run:</p>
<pre><code>mko --dry-run src/main.c include/main.h
</code></pre>

<p>Silent mode (good for scripts):</p>
<pre><code>mko --silent config/app.conf
</code></pre>

<p>Force open even if non-empty:</p>
<pre><code>mko --force notes/today.md
mko -y notes/today.md
</code></pre>

<p>Empty existing content and open (no prompt):</p>
<pre><code>mko --empty notes/today.md
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

<hr />

<h2 id="existing-files">6. Behaviour with existing files</h2>
<p>When the last file already exists and is non-empty, <code>mko</code> behaves as follows:</p>
<ul>
  <li>With no special flags (and not in <code>--silent</code> mode), it prompts:</li>
</ul>
<pre><code>File 'path/to/file' exists and is not empty.
Open in nvim? [y/N/d]
</code></pre>
<ul>
  <li><strong><code>y</code>, <code>Y</code>, <code>yes</code>, <code>YES</code></strong> – open the file as it is.</li>
  <li><strong><code>d</code></strong> (lowercase only) – empty the file (truncate it to zero bytes) and then open it.</li>
  <li>Any other answer (including just pressing Enter) – skip opening the file.</li>
</ul>
<p>The <code>d</code> option is deliberately only recognised in lowercase to avoid accidental destructive actions.</p>

<p>Non-interactive control for scripts:</p>
<ul>
  <li><strong><code>-f</code>, <code>--force</code>, <code>-y</code>, <code>--yes</code></strong> – always open an existing non-empty last file without asking, keeping its contents.</li>
  <li><strong><code>--empty</code></strong> – if the last file exists and is non-empty, empty it and open it without prompting (equivalent to answering <code>d</code> in the prompt).</li>
</ul>

<p>Silent mode interaction:</p>
<ul>
  <li>In <code>--silent</code> mode, <code>mko</code> does not prompt. If the last file is non-empty and you have not supplied <code>--force</code>/<code>-y</code> or <code>--empty</code>, the file is left unopened.</li>
  <li>Using <code>--force</code>/<code>-y</code> in <code>--silent</code> mode opens the existing file unchanged.</li>
  <li>Using <code>--empty</code> in <code>--silent</code> mode empties the existing file and then opens it.</li>
</ul>

<p>Dry-run summary:</p>
<ul>
  <li>With <code>--dry-run</code>, no files are created, opened, or emptied.</li>
  <li>If <code>--empty</code> is specified for a non-empty last file, the summary message explicitly states that the file would be emptied and opened.</li>
</ul>

<hr />

<h2 id="editor-selection">7. Editor selection &amp; auto-install</h2>

<h3 id="editor-selection-persistent">7.1 Persistent editor choice</h3>
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
<p>The <code>--set-editor</code> flag writes or updates this file. If you call <code>mko --set-editor nano</code> without any file arguments, it just updates the config and exits successfully.</p>

<h3 id="editor-selection-auto-install">7.2 Auto-install on Ubuntu / Arch</h3>
<p>If the chosen editor (<code>nano</code> or <code>nvim</code>) is not installed, and you are on a supported distribution, <code>mko</code> will:</p>
<ol>
  <li>Detect the distribution via <code>/etc/os-release</code>.</li>
  <li>Check whether <code>sudo</code> is available.</li>
  <li>If <code>sudo</code> is present, prompt:</li>
</ol>
<pre><code>Editor 'nvim' is not installed. Attempt to install it now (requires sudo)? [y/N]
</code></pre>
<ol start="4">
  <li>On Ubuntu / Debian, run (only if you answer <code>y</code>):</li>
</ol>
<pre><code>sudo apt update
sudo apt install -y nano      # or neovim
</code></pre>
<ol start="5">
  <li>On Arch-based systems, run:</li>
</ol>
<pre><code>sudo pacman -Sy --needed --noconfirm nano    # or neovim
</code></pre>
<ol start="6">
  <li>On other distributions, print an error and ask you to install the editor manually.</li>
</ol>
<p>If <code>sudo</code> is not available, <code>mko</code> prints explicit instructions with example package-manager commands for Ubuntu/Debian and Arch-based systems, or a generic message for others, and exits without attempting installation.</p>
<p>If installation via <code>sudo</code> fails (for example you are not in the sudoers list or there is a network issue), <code>mko</code> reports the failure and asks you to install the editor manually as root before trying again.</p>
<p>In <code>--dry-run</code> mode, <code>mko</code> only reports that it would attempt installation; it does not run any package-manager commands.</p>

<hr />

<h2 id="logging">8. Logging</h2>
<p>When not in dry-run mode, real actions are appended to:</p>
<pre><code>~/.mko.log
</code></pre>
<p>Examples of log entries:</p>
<pre><code>2025-11-21 10:15:03 Created directory: /home/user/projects/demo/src
2025-11-21 10:15:03 Created file: /home/user/projects/demo/src/main.py
2025-11-21 10:15:03 Opening file with nvim: /home/user/projects/demo/src/main.py
</code></pre>
<p>No log entries are written when <code>--dry-run</code> is used.</p>

<hr />

<h2 id="permissions">9. Permissions, root, and sudoers</h2>
<ul>
  <li>Installing and running <code>mko</code> does not require root when using the standard installation path:
    <ul>
      <li>The installer places the script in <code>$HOME/.local/bin</code>.</li>
      <li><code>PATH</code> changes are written to your own <code>~/.bashrc</code>, <code>~/.zshrc</code> or <code>~/.profile</code>.</li>
      <li>Directory and file creation only succeed where your user has write permission.</li>
    </ul>
  </li>
  <li><code>sudo</code>/root access is only needed if you agree to the auto-install prompt for <code>nano</code>/<code>nvim</code>:
    <ul>
      <li>If you are in the sudoers list, <code>mko</code> can install the editor using <code>sudo apt …</code> or <code>sudo pacman …</code>.</li>
      <li>If you are not in sudoers, the installation will fail; <code>mko</code> reports this and asks you to install the editor manually as root.</li>
      <li>If <code>sudo</code> is not present at all, <code>mko</code> prints clear instructions and exits without attempting installation.</li>
      <li>You can always answer <code>N</code> to the install prompt; in that case, no <code>sudo</code> command is run.</li>
    </ul>
  </li>
</ul>

<hr />

<h2 id="similar-works">10. Similar works</h2>
<p>These public projects provide related functionality in the general area of file creation and command-line helpers:</p>
<ul>
  <li><code>fuyalasmit/mkfile-cli</code> – a command-line utility focused on creating files along with missing parent directories in a single step.</li>
  <li>Various shell helper collections that combine file and directory utilities into small command-line tools.</li>
</ul>
<p>This project focuses on a single command that prepares the path (directories and file) and then opens the last file in a text editor, with small quality-of-life features for everyday development.</p>

<hr />

<h2 id="license">11. License</h2>
<p>This project uses The Unlicense, which effectively places the code in the public domain.</p>
<pre><code>This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.
In jurisdictions that recognise copyright laws, the author or authors
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
