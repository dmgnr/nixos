import { file, $ } from "bun";
import { cpus, freemem, totalmem } from "os";
async function getBatPercent() {
  const now = await file("/sys/class/power_supply/BAT0/energy_now").json();
  const full = await file("/sys/class/power_supply/BAT0/energy_full").json();
  const status = await file("/sys/class/power_supply/BAT0/status").text();
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
  const volume = parseFloat(vol ?? "0");
  return {
    text: muted ? "" : `${volume}%  `,
    volume,
    muted: !!muted,
  };
}
var previousTotal: number[] = [],
  previousIdle: number[] = [];
function getCpuPercent() {
  const cpu = cpus();
  const percents = cpu.reduce((acc, cpu, i) => {
    const rawTotal = Object.values(cpu.times).reduce(
      (acc, time) => acc + time,
      0
    );
    const total = rawTotal - (previousTotal[i] ?? 0);
    previousTotal[i] = rawTotal;
    const rawIdle = cpu.times.idle;
    const idle = rawIdle - (previousIdle[i] ?? 0);
    previousIdle[i] = rawIdle;
    const percent = Math.round(((total - idle) / total) * 100);
    acc.push(percent);
    return acc;
  }, [] as number[]);
  const perc = percents.reduce((acc, cpu) => acc + cpu, 0) / percents.length;
  return {
    text: `${Math.round(perc)}%  `,
    perc,
  };
}
function getMemPercent() {
  const mem = freemem() / totalmem();
  return { text: `${100 - Math.round(mem * 100)}%  `, perc: mem };
}
async function getNetwork() {
  const out = await $`nmcli -g name,device c | grep "wlp2s0"`.text();
  if (!out) return { format: " ", class: "net" };
  return { format: " ", tooltip: out, class: "net" };
}

async function run() {
  /*console.log(
    "\u001bcMem: " +
      getMemPercent() +
      "\nCPU: " +
      getCpuPercent() +
      "\nBat: " +
      (await getBatPercent()) +
      "%\nVolume: " +
      inspect(await getVolume()) +
      "\nNetwork: " +
      inspect(await getNetwork()) +
      "\n"
  );*/
  const bat = await getBatPercent();
  const mem = getMemPercent();
  const net = await getNetwork();
  const cpu = getCpuPercent();
  const vol = await getVolume();
  var res = {
    text: "",
    alt: "",
    tooltip: "",
    class: "",
    percentage: 0,
  };
  if (bat.low) {
    res.text = bat.text;
    res.tooltip = "Battery low";
    res.class =
      "bat" +
      (bat.discharging
        ? bat.percent < 15
          ? "critical"
          : bat.percent < 35
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
  } else if (cpu.perc > 0.7) {
    res.text = cpu.text;
    res.class = "cpu";
  } else if (vol.muted || vol.volume > 0.7) {
    res.text = vol.text;
    res.tooltip = "Volume muted";
    res.class = "vol";
  } else {
    res.text = net.format;
    res.tooltip = `${net.tooltip}`;
    // No class to make it transparent
  }
  console.log(JSON.stringify(res));
}
setInterval(run, 1000);
run();
