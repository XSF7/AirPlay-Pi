<!-- README.md (modern HTML) -->

<h1 align="center">AirPlay-Pi</h1>

<p align="center">
  <strong>Turn an Orange Pi Zero into an AirPlay receiver using Shairport Sync.</strong><br/>
  Stream audio from Apple devices (or any AirPlay-enabled source) directly to your Orange Pi Zero.
</p>

<p align="center">
  <a href="https://github.com/mikebrady/shairport-sync">Shairport Sync Docs</a>
  ·
  <a href="#getting-started">Getting Started</a>
  ·
  <a href="#troubleshooting">Troubleshooting</a>
</p>

<hr/>

<h2 id="project-overview">Project Overview</h2>

<p>
  <strong>AirPlay-Pi</strong> transforms an <strong>Orange Pi Zero</strong> into an AirPlay receiver using
  <strong>Shairport Sync</strong>. This makes a simple, affordable, and reliable audio endpoint for your network.
</p>

<h3 id="key-features">Key Features</h3>
<ul>
  <li><strong>Auto Start on Boot:</strong> Service runs automatically when the Orange Pi boots.</li>
  <li><strong>Stable AirPlay Service:</strong> Powered by Shairport Sync for robust AirPlay support.</li>
  <li><strong>Service Management:</strong> Easy start/stop/status commands.</li>
</ul>

<hr/>

<h2 id="getting-started">Getting Started</h2>

<h3 id="hardware-requirements">Hardware Requirements</h3>
<ul>
  <li>Orange Pi Zero (256MB / 512MB)</li>
  <li>External audio output (USB sound card, HDMI, or 3.5mm audio jack)</li>
  <li>Power supply (5V, 2A recommended)</li>
</ul>

<h3 id="software-requirements">Software Requirements</h3>
<ul>
  <li>Shairport Sync</li>
  <li>Armbian OS (or any compatible OS for Orange Pi Zero)</li>
  <li>Terminal access (SSH or local)</li>
</ul>

<h3 id="installation-steps">Installation Steps</h3>

<ol>
  <li>
    <strong>Update and upgrade system</strong>
    <pre><code class="language-bash">sudo apt update &amp;&amp; sudo apt upgrade</code></pre>
  </li>

  <li>
    <strong>Install Shairport Sync</strong>
    <pre><code class="language-bash">sudo apt install shairport-sync</code></pre>
  </li>

  <li>
    <strong>Enable Shairport Sync on boot</strong>
    <pre><code class="language-bash">sudo systemctl enable shairport-sync</code></pre>
  </li>

  <li>
    <strong>Start the AirPlay service</strong>
    <pre><code class="language-bash">sudo service shairport-sync start</code></pre>
  </li>

  <li>
    <strong>Check service status</strong>
    <pre><code class="language-bash">sudo systemctl status shairport-sync.service</code></pre>
  </li>
</ol>

<hr/>

<h2 id="verifying-the-setup">Verifying the Setup</h2>
<ul>
  <li><strong>On your AirPlay-enabled device:</strong> Look for the Orange Pi in the AirPlay device list.</li>
  <li><strong>Audio output:</strong> Connect a speaker and play audio through AirPlay to confirm sound output.</li>
</ul>

<hr/>

<h2 id="troubleshooting">Troubleshooting</h2>

<ul>
  <li>
    <strong>No AirPlay device found</strong>
    <ul>
      <li>Confirm Shairport Sync is running:</li>
    </ul>
    <pre><code class="language-bash">sudo systemctl status shairport-sync</code></pre>
  </li>

  <li>
    <strong>Audio issues</strong>
    <ul>
      <li>Verify the selected audio output device (USB/HDMI/analog).</li>
      <li>Restart the service:</li>
    </ul>
    <pre><code class="language-bash">sudo systemctl restart shairport-sync</code></pre>
  </li>
</ul>

<hr/>

<h2 id="additional-resources">Additional Resources</h2>
<ul>
  <li><a href="https://github.com/mikebrady/shairport-sync">Shairport Sync Documentation</a></li>
  <li><a href="http://auseparts.com.au/image/cache/catalog/OrangePi/ExBoard/OPEx%20board1-700x700.jpg">Orange Pi Zero Setup Guide</a></li>
</ul>

<hr/>

<h2 id="contributing">Contributing</h2>
<p>
  Contributions are welcome! Feel free to open an issue or submit a pull request.
</p>

<p align="center">
  <img
    src="https://www.robotistan.com/orange-pi-zero-256mb-board-18295-64-B.jpg"
    alt="Orange Pi Zero board"
    width="720"
  />
</p>
