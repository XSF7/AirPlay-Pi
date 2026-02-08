<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Orange Pi PC Audio Setup (ALSA) + Duplicate Output</title>
  <style>
    :root {
      --bg: #0b1220;
      --panel: #0f1a2e;
      --text: #e7eefc;
      --muted: #a9b7d6;
      --border: rgba(231, 238, 252, 0.12);
      --code-bg: rgba(0, 0, 0, 0.35);
      --accent: #7aa2ff;
    }

    * { box-sizing: border-box; }
    body {
      margin: 0;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, Cantarell, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
      background: radial-gradient(1200px 600px at 20% 0%, rgba(122,162,255,.20), transparent 60%),
                  radial-gradient(900px 500px at 80% 20%, rgba(122,162,255,.12), transparent 60%),
                  var(--bg);
      color: var(--text);
      line-height: 1.55;
    }

    .container {
      max-width: 980px;
      margin: 0 auto;
      padding: 32px 18px 64px;
    }

    header {
      padding: 18px 18px 22px;
      border: 1px solid var(--border);
      background: linear-gradient(180deg, rgba(255,255,255,.03), rgba(255,255,255,.01));
      border-radius: 14px;
    }

    h1 { margin: 0 0 6px; font-size: 1.55rem; }
    .subtitle { margin: 0; color: var(--muted); }

    section {
      margin-top: 18px;
      padding: 18px;
      border: 1px solid var(--border);
      background: rgba(255,255,255,.02);
      border-radius: 14px;
    }

    h2 { margin: 0 0 10px; font-size: 1.18rem; }
    h3 { margin: 14px 0 8px; font-size: 1.02rem; color: var(--accent); }

    code, pre {
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
    }

    pre {
      margin: 10px 0 0;
      padding: 12px 12px;
      background: var(--code-bg);
      border: 1px solid var(--border);
      border-radius: 12px;
      overflow: auto;
      white-space: pre;
    }

    .steps {
      margin: 10px 0 0;
      padding-left: 20px;
    }

    .note {
      border-left: 3px solid var(--accent);
      padding: 10px 12px;
      background: rgba(122,162,255,.08);
      border-radius: 10px;
      color: var(--text);
      margin-top: 12px;
    }

    .muted { color: var(--muted); }

    footer {
      margin-top: 18px;
      color: var(--muted);
      font-size: 0.95rem;
      text-align: center;
    }

    a { color: var(--accent); text-decoration: none; }
    a:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <div class="container">
    <header>
      <h1>Audio setup (Orange Pi PC / <code>audiocodec</code>) + Duplicate output (Analog + HDMI)</h1>
      <p class="subtitle">
        ALSA mixer unmute + persistent settings + <code>/etc/asound.conf</code> routing + speaker test
      </p>
    </header>

    <section>
      <h2>1) Unmute <strong>Audio lineout</strong></h2>
      <p>Open <code>alsamixer</code>:</p>
      <pre><code>sudo alsamixer</code></pre>

      <ol class="steps">
        <li>Press <strong>F6</strong> → select <strong><code>audiocodec</code></strong></li>
        <li>Go to <strong>Audio lineout</strong></li>
        <li>Press <strong>m</strong> until it shows <strong>OO</strong> (unmuted)</li>
      </ol>

      <p>Persist mixer state:</p>
      <pre><code>sudo alsactl store 0</code></pre>
    </section>

    <section>
      <h2>2) Check ALSA devices <span class="muted">(optional diagnostics)</span></h2>
      <pre><code>arecord -l
aplay -l</code></pre>
    </section>

    <section>
      <h2>3) Configure ALSA to duplicate audio to <strong>Analog + HDMI</strong></h2>
      <p>Edit <code>/etc/asound.conf</code>:</p>
      <pre><code>sudo nano /etc/asound.conf</code></pre>

      <p>Paste the following configuration:</p>

      <pre><code># Thanks to: http://alsa.opensrc.org/Asoundrc#Dupe_output_to_multiple_cards
# https://sourceforge.net/p/alsa/mailman/message/33476395/
# Check that a MUTE doesn't exist on the Audio Line Out for Orange PI PC
# or you'll get no sound other than via HDMI

pcm.!default {
   type plug
   slave.pcm "duplicate"
}

ctl.!default {
    type hw
    card 0
}

# Create the Software Mixer for HDMI and then link to hardware
pcm.hdmi-dmixer  {
  type dmix
  ipc_key 1024
  slave {
    pcm "hdmi-hw"
    period_time 0
    period_size 1024
    buffer_size 4096
    rate 44100
  }
  bindings {
    0 0
    1 1
  }
}

ctl.hdmi-dmixer {
  type hw
  card 0
}

# Create the Software Mixer for Analogue Out and then link to hardware
pcm.analog-dmixer  {
  type dmix
  ipc_key 2048
  slave {
    pcm "analog-hw"
    period_time 0
    period_size 1024
    buffer_size 4096
    rate 44100
  }
  bindings {
    0 0
    1 1
  }
}

ctl.analog-dmixer {
  type hw
  card 0
}

# Route the audio requests to both hardware devices via the mixer.
# For some reason we can't have one mixer and then route to two hardware
# devices (would be more efficient).
pcm.duplicate {
  type route
  slave.pcm {
    type multi
    slaves {
      a { pcm "analog-dmixer" channels 2 }
      h { pcm "hdmi-dmixer" channels 2 }
    }
    bindings [
      { slave a channel 0 }
      { slave a channel 1 }
      { slave h channel 0 }
      { slave h channel 1 }
    ]
  }
  ttable [
    [ 1 0 1 0 ]
    [ 0 1 0 1 ]
  ]
}

ctl.duplicate {
  type hw
  card 0
}

# Physical Output Device Mappings - Analogue and HDMI for Orange PI PC
pcm.analog-hw {
  type hw
  card 0
}

pcm.hdmi-hw {
  type hw
  card 1
}</code></pre>

      <div class="note">
        <strong>Tip:</strong> If your HDMI card isn’t <code>card 1</code> (check via <code>aplay -l</code>),
        update <code>pcm.hdmi-hw</code> and <code>pcm.analog-hw</code> card numbers accordingly.
      </div>
    </section>

    <section>
      <h2>4) Test your speakers</h2>
      <pre><code>speaker-test -t wav</code></pre>
    </section>

    <section>
      <h2>Notes / common gotchas</h2>
      <ul>
        <li>If you get sound only over HDMI, confirm <strong>Audio lineout</strong> shows <strong>OO</strong> in <code>alsamixer</code>.</li>
        <li>Card numbers can differ by image/kernel. Always verify with <code>aplay -l</code> and adjust the config.</li>
      </ul>
    </section>

    <footer>
      <p>Use this page as a GitHub documentation snippet (README → HTML export).</p>
    </footer>
  </div>
</body>
</html>
