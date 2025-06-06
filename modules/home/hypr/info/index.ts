import { file, $ } from "bun";
import { cpus, totalmem } from "os";
async function getBatPercent() {
  const [nowStr, fullStr, status] = await Promise.all([
    file("/sys/class/power_supply/BAT0/energy_now").text(),
    file("/sys/class/power_supply/BAT0/energy_full").text(),
    file("/sys/class/power_supply/BAT0/status").text(),
  ]);
  const now = parseInt(nowStr.trim());
  const full = parseInt(fullStr.trim());
  const icons = ["󰁻", "󰁼", "󰁾", "󰂀", "󰂂", "󰁹"];
  const percent = Math.round((now / full) * 100);
  const low = percent < 40 && status.includes("Discharging");
  const icon = low ? icons[Math.floor(percent / 20)] : "󰁺";
  return {
    text: `${percent}% ${icon}`,
    low,
    percent,
    discharging: status.includes("Discharging"),
  };
}

async function getVolume() {
  const out = await $`wpctl get-volume @DEFAULT_AUDIO_SINK@`.text();
  const [, vol, muted] =
    out.match(/^Volume: ([0-9]+(?:\.[0-9]+))?( \[MUTED\])?$/m) ?? [];
  const volume = parseFloat(vol ?? "0") * 100;
  return {
    text: muted ? "" : `${Math.round(volume)}% ${volume < 5 ? "" : " "}`,
    volume,
    muted: !!muted,
  };
}

var previousTotal: number[] = [],
  previousIdle: number[] = [];
function getCpuPercent() {
  const cpu = cpus();
  const percents = cpu.map((core, i) => {
    const total = Object.values(core.times).reduce((a, b) => a + b, 0);
    const idle = core.times.idle;
    const totalDelta = total - (previousTotal[i] ?? 0);
    const idleDelta = idle - (previousIdle[i] ?? 0);
    previousTotal[i] = total;
    previousIdle[i] = idle;
    return totalDelta > 0 ? ((totalDelta - idleDelta) / totalDelta) * 100 : 0;
  });
  const perc = percents.reduce((a, b) => a + b, 0) / percents.length;
  return { text: `${Math.round(perc)}% `, perc };
}

async function getMemPercent() {
  const available =
    1024 *
    Number(
      (await file("/proc/meminfo").text()).match(/MemAvailable:[ ]+(\d+)/)
    );
  const used = 1 - available / totalmem();
  return { text: `${Math.round(used * 100)}% `, perc: used };
}

async function getNetwork() {
  const out = await $`nmcli -g general.connection d show wlp2s0`.text();
  const network = out.trim();
  if (!network) return { format: "", class: "disconnected" };
  return { format: "", tooltip: network, class: "net", network };
}

async function getNotification() {
  try {
    return await $`swaync-client -c`.json();
  } catch {
    return null;
  }
}

var beforeRecord = 0;
async function getRecord() {
  const isRecording = (await $`pidof wf-recorder`.nothrow()).exitCode === 0;
  if (!isRecording) beforeRecord = Date.now();
  const recordTime = (Date.now() - beforeRecord) / 1000;
  if (recordTime < 1) return false;
  const minutes = Math.floor(recordTime / 60)
    .toString()
    .padStart(2, "0");
  const seconds = Math.floor(recordTime % 60)
    .toString()
    .padStart(2, "0");
  return {
    text: `󰑋 ${minutes}:${seconds}`,
    alt: "recording",
    tooltip: "Recording with wf-recorder",
    class: "rec",
  };
}

function smart() {
  var lastVolume: number | null = null;
  var lastNetwork: string | null = null;
  var volumeTimer = 0,
    networkTimer = 0,
    last = "";
  async function run() {
    try {
      const bat = await getBatPercent();
      const mem = await getMemPercent();
      const net = await getNetwork();
      const cpu = getCpuPercent();
      const vol = await getVolume();
      const ntf = await getNotification();
      const rec = await getRecord();
      if (lastVolume === null) lastVolume = vol.volume;
      if (vol.volume != lastVolume) volumeTimer = Date.now() + 3000;
      if (net.network && lastNetwork === null) lastNetwork = net.network;
      if (net.network != lastNetwork) networkTimer = Date.now() + 3000;
      var res = {
        text: "",
        alt: "",
        tooltip: "",
        class: "",
        percentage: 0,
      };
      if (Date.now() < volumeTimer) {
        res.text = vol.text;
        res.tooltip = "Volume: " + vol.volume + "%";
        res.class = "vol";
        lastVolume = vol.volume;
      } else if (net.network && Date.now() < networkTimer) {
        res.text = net.network + " " + net.format;
        res.class = net.class;
        lastNetwork = net.network;
      } else if (bat.low) {
        res.text = bat.text;
        res.tooltip = "Battery low";
        res.class =
          "bat" +
          (bat.discharging
            ? bat.percent < 15
              ? "critical"
              : bat.percent < 25
              ? "warning"
              : ""
            : "");
      } else if (mem.perc > 0.85) {
        res.text = mem.text;
        res.class = "mem";
      } else if (net.class == "disconnected") {
        res.text = net.format;
        res.tooltip = "Disconnected";
        res.class = "net";
      } else if (cpu.perc > 70) {
        res.text = cpu.text;
        res.class = "cpu";
      } else if (rec) {
        res = { ...res, ...rec };
      } else if (vol.muted || vol.volume > 70) {
        res.text = vol.text;
        res.tooltip = "Volume: " + vol.volume + "%";
        res.class = "vol";
      } else {
        res.text = (ntf ? ntf + " " : "") + "";
        res.class = "ntf";
      }
      const out = JSON.stringify(res);
      if (out == last) return;
      last = out;
      console.log(out);
    } catch (e) {
      console.log(
        JSON.stringify({
          text: "",
          alt: "err",
          tooltip: `${e}`,
          class: "err",
          percentage: 0,
        })
      );
    }
  }

  setInterval(run, 1000);
  run();
}
switch (process.argv[3]) {
  case "mpris":
    // to be implemented
    break;
  default:
  case "smart":
    smart();
}
type Module = () =>
  | Promise<
      { text: string; alt?: string; tooltip: string; class: string } | false
    >
  | { text: string; alt?: string; tooltip: string; class: string }
  | false;
