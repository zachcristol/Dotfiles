# tmux Hands-On Worksheet

Work through these exercises in order. Each one builds on the last.

**Your prefix key:** `Ctrl+b` (written below as `<prefix>`)

---

## Part 1: Sessions

A session is a persistent workspace. When you disconnect or close your terminal, the session keeps running.

### Exercise 1.1 — Start a named session

```
tmux new-session -s main
```

You should now be inside tmux. Notice the status bar at the bottom.

**Checkpoint:** The bottom bar shows `[main]` on the left.

---

### Exercise 1.2 — Detach from a session

Press: `<prefix> d`

That is: hold Ctrl, press b, release both, then press d.

You are now back at your plain terminal. tmux is still running in the background.

**Checkpoint:** You see a message like `[detached (from session main)]`.

---

### Exercise 1.3 — List sessions

```
tmux ls
```

**Checkpoint:** You see `main: 1 windows` (or similar) listed.

---

### Exercise 1.4 — Reattach

```
tmux attach -t main
```

**Checkpoint:** You are back in your session, exactly as you left it.

---

### Exercise 1.5 — Create a second session

While inside tmux, press: `<prefix> :` then type:

```
new-session -s work -d
```

The `-d` flag creates it in the background without switching to it.

**Checkpoint:** Press `<prefix> s` to open the session list. You should see both `main` and `work`. Press `q` to close without switching, or use arrow keys + Enter to switch.

---

### Exercise 1.6 — Switch between sessions

- `<prefix> s` — interactive session picker
- `<prefix> $` — rename current session

Switch to `work`, then switch back to `main`.

**Checkpoint:** The session name in the status bar changes as you switch.

---

### Exercise 1.7 — Kill a session

Switch to `work`, then run:

```
tmux kill-session -t work
```

Or from inside any session: `<prefix> :` then `kill-session -t work`.

**Checkpoint:** Only `main` remains in `tmux ls`.

---

## Part 2: Windows

Windows are tabs within a session. Each window has its own set of panes.

### Exercise 2.1 — Create a window

Press: `<prefix> c`

**Checkpoint:** A new window appears in the status bar. You should see `0:bash` and `1:bash` (or similar). The active window is marked with `*`.

---

### Exercise 2.2 — Rename a window

Press: `<prefix> ,`

Type `editor` and press Enter.

**Checkpoint:** The status bar now shows the window named `editor`.

---

### Exercise 2.3 — Switch between windows

- `<prefix> 0` — go to window 0
- `<prefix> 1` — go to window 1
- `<prefix> n` — next window
- `<prefix> p` — previous window

Practice switching back and forth a few times.

**Checkpoint:** The `*` in the status bar moves to reflect the active window.

---

### Exercise 2.4 — Close a window

In a window you do not need, type:

```
exit
```

Or press `<prefix> &` and confirm with `y`.

**Checkpoint:** The window disappears from the status bar.

---

## Part 3: Panes

Panes split a window into multiple terminals side by side or stacked.

### Exercise 3.1 — Split horizontally (top/bottom)

Press: `<prefix> "`

You now have two panes stacked vertically. Your cursor is in the bottom pane.

**Checkpoint:** You can see two separate terminal areas with a border between them. The active pane has a green border (from your config).

---

### Exercise 3.2 — Split vertically (left/right)

Press: `<prefix> %`

**Checkpoint:** You now have three panes.

---

### Exercise 3.3 — Navigate panes with vim keys

Your config binds h/j/k/l to pane navigation. Press:

- `<prefix> h` — move left
- `<prefix> j` — move down
- `<prefix> k` — move up
- `<prefix> l` — move right

Practice navigating to each pane.

**Checkpoint:** The green border moves to whichever pane you navigate to. You can also click a pane with your mouse (mouse is enabled in your config).

---

### Exercise 3.4 — Resize panes

Press `<prefix>` then hold Ctrl and press an arrow key repeatedly:

- `<prefix>` then `Ctrl+arrow` — resize in that direction

Or with the mouse: click and drag the border between panes.

**Checkpoint:** Pane borders move as expected.

---

### Exercise 3.5 — Zoom a pane (full screen toggle)

Press: `<prefix> z`

The current pane expands to fill the whole window. Press `<prefix> z` again to unzoom.

**Checkpoint:** Zoomed pane fills the window. Unzoom restores the split.

---

### Exercise 3.6 — Close a pane

Type `exit` in a pane, or press `<prefix> x` and confirm with `y`.

**Checkpoint:** The pane closes and the remaining panes fill the space.

---

## Part 4: Copy Mode

Copy mode lets you scroll back through output and copy text.

### Exercise 4.1 — Enter copy mode and scroll

Press: `<prefix> [`

You are now in copy mode. Because your config sets `mode-keys vi`, you navigate with vim keys:

- `k` / `j` — scroll up/down one line
- `Ctrl+u` / `Ctrl+d` — scroll half page
- `q` — exit copy mode

Run a command that produces a lot of output (like `ls -la /usr/bin`), then enter copy mode and scroll through it.

**Checkpoint:** You can scroll up past the visible area and see earlier output.

---

### Exercise 4.2 — Copy text

In copy mode:

1. Move to the start of what you want to copy
2. Press `v` to start visual selection
3. Move to the end
4. Press `y` to yank (copy)

You exit copy mode automatically. The text is in tmux's clipboard. Paste with `<prefix> ]`.

**Checkpoint:** Pasted text appears where your cursor is.

---

## Part 5: tmux-resurrect (Save and Restore)

Your config includes tmux-resurrect. This saves and restores your entire session layout across reboots.

**Note from your config:** Auto-restore is disabled. You must restore manually.

### Exercise 5.1 — Save your session

Arrange a few windows and panes the way you like. Then press:

```
<prefix> Ctrl+s
```

That is: `<prefix>`, then hold Ctrl and press `s`.

**Checkpoint:** You briefly see a message like `[tmux-resurrect] Saving...` in the status bar.

---

### Exercise 5.2 — Simulate a restart and restore

Kill your tmux server:

```
tmux kill-server
```

Start a fresh session:

```
tmux new-session -s recovered
```

Now restore:

```
<prefix> Ctrl+r
```

**Checkpoint:** Your previous windows and pane layout reappear. Note: running processes (like editors) may not fully restore — layout and working directories do.

---

## Part 6: Agentic Dev Layout

This is the practical payoff. A layout for running an AI agent in one pane while working in others.

### Exercise 6.1 — Build a two-pane agent layout

Start fresh in a session:

```
tmux new-session -s agent
```

Split vertically into two side-by-side panes (`<prefix> %`).

Left pane — your agent (e.g., Claude Code):
```
claude
```

Right pane — navigate there with `<prefix> l`, then use it as your working terminal for running tests, reading output, etc.

**Checkpoint:** You can watch Claude run in the left pane while typing commands in the right pane without interrupting the agent.

---

### Exercise 6.2 — Add a third pane for logs or a second context

With your cursor in the right pane, split it horizontally (`<prefix> "`):

- Top-right: run commands
- Bottom-right: tail a log file, run a test watcher, etc.

Example for the bottom-right pane:

```
tail -f /path/to/app.log
```

**Checkpoint:** You have three active panes. Navigate between them with `<prefix> h/j/k/l`. The agent runs uninterrupted.

---

### Exercise 6.3 — Use a second window for a separate context

Press `<prefix> c` to open a new window. Rename it `<prefix> ,` to `scratch`.

Use this window for anything you do not want visible alongside the agent — longer commands, git operations, documentation lookups.

Switch back to the agent window with `<prefix> 0` (or whatever its number is).

**Checkpoint:** You have two windows: one with your agent layout, one clean scratch window. Status bar shows both.

---

### Exercise 6.4 — Save this layout

Press `<prefix> Ctrl+s` to save with tmux-resurrect.

Next time you sit down to work:

```
tmux attach -t agent
```

If the session is gone (reboot, kill-server), start tmux and restore with `<prefix> Ctrl+r`.

**Checkpoint:** Your layout survives detach/reattach and can be recovered after a full restart.

---

## Quick Reference

| Action | Keys |
|---|---|
| Prefix key | `Ctrl+b` |
| New session | `tmux new-session -s name` |
| Attach to session | `tmux attach -t name` |
| Detach | `<prefix> d` |
| Session list | `<prefix> s` |
| New window | `<prefix> c` |
| Rename window | `<prefix> ,` |
| Switch window by number | `<prefix> 0-9` |
| Next / prev window | `<prefix> n` / `<prefix> p` |
| Split left/right | `<prefix> %` |
| Split top/bottom | `<prefix> "` |
| Navigate pane left | `<prefix> h` |
| Navigate pane down | `<prefix> j` |
| Navigate pane up | `<prefix> k` |
| Navigate pane right | `<prefix> l` |
| Zoom pane | `<prefix> z` |
| Close pane | `exit` or `<prefix> x` |
| Copy mode | `<prefix> [` |
| Paste | `<prefix> ]` |
| Save layout (resurrect) | `<prefix> Ctrl+s` |
| Restore layout (resurrect) | `<prefix> Ctrl+r` |
| tmux command prompt | `<prefix> :` |
