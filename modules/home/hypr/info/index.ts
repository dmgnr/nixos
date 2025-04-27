import { file, $ } from "bun";
import { cpus, freemem, totalmem } from "os";

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
    out.match(/^Volume: ([0-9]+(?:\\.[0-9]+))?( \\[MUTED\\])?$/m) ?? [];
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

function getMemPercent() {
  const used = 1 - freemem() / totalmem();
  return { text: `${Math.round(used * 100)}% `, perc: used };
}

async function getNetwork() {
  const out = await $`nmcli -g general.connection d show wlp2s0`.text();
  const network = out.trim();
  if (!network) return { format: "", class: "net" };
  return { format: "", tooltip: network, class: "net", network };
}

async function getNotification() {
  try {
    return await $`swaync-client -c`.json();
  } catch {
    return null;
  }
}

// last cache
let lastVolume: number | null = null;
let lastNetwork: string | null = null;
let volumeTimer = 0;
let networkTimer = 0;
let notificationCache: any = null;
let notificationTimer = 0;
let lastOutput = "";

async function run() {
  const now = Date.now();
  const cpu = getCpuPercent();
  const mem = getMemPercent();

  if (now > notificationTimer) {
    notificationCache = await getNotification();
    notificationTimer = now + 10000;
  }

  let bat: any = null;
  let volume: any = null;
  let network: any = null;

  if (volumeTimer > now || lastVolume === null) {
    volume = await getVolume();
  }
  if (networkTimer > now || lastNetwork === null) {
    network = await getNetwork();
  }
  if (!volume && lastVolume !== null) {
    volume = { volume: lastVolume, text: "", muted: false };
  }
  if (!network && lastNetwork !== null) {
    network = { network: lastNetwork, format: "", class: "net" };
  }

  if (!bat && cpu.perc < 70 && mem.perc < 0.85) {
    bat = await getBatPercent();
  }

  if (volume && volume.volume !== lastVolume) {
    volumeTimer = now + 3000;
    lastVolume = volume.volume;
  }

  if (network && network.network !== lastNetwork) {
    networkTimer = now + 3000;
    lastNetwork = network.network;
  }

  let res = { text: "", alt: "", tooltip: "", class: "", percentage: 0 };

  if (volumeTimer > now && volume) {
    res.text = volume.text;
    res.tooltip = `Volume: ${Math.round(volume.volume)}%`;
    res.class = "vol";
  } else if (networkTimer > now && network) {
    res.text = `${network.network} ${network.format}`;
    res.class = network.class;
  } else if (bat?.low) {
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
  } else if (!network?.network) {
    res.text = network?.format ?? "";
    res.tooltip = "Disconnected";
    res.class = "net";
  } else if (cpu.perc > 70) {
    res.text = cpu.text;
    res.class = "cpu";
  } else if (volume?.muted || volume?.volume > 70) {
    res.text = volume.text;
    res.tooltip = `Volume: ${Math.round(volume.volume)}%`;
    res.class = "vol";
  } else {
    res.text = (notificationCache ? `${notificationCache} ` : "") + "";
  }

  const output = JSON.stringify(res);
  if (output !== lastOutput) {
    lastOutput = output;
    console.log(output);
  }
}

setInterval(run, 1000);
run();
