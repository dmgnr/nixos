import { $ } from "bun";

type Cmd = $.ShellPromise;

const log = async (msg: string, ..._: unknown[]) =>
	await $`hyprctl notify 1 2000 0 ${msg}`;
const success = async (msg: string, ..._: unknown[]) =>
	await $`hyprctl notify 2 2000 0 ${msg}`;
const error = async (msg: string, ..._: unknown[]) =>
	await $`hyprctl notify 3 2000 0 ${msg}`;

class Node {
	name: string;
	cmds: Cmd[];
	deps = new Set<Node>();
	out = new Set<Node>();

	constructor(name: string, cmd: Cmd | Cmd[]) {
		this.name = name;
		this.cmds = Array.isArray(cmd) ? cmd : [cmd];
	}

	// "child runs after me"
	// biome-ignore lint/suspicious/noThenProperty: no.
	then(...children: Node[]) {
		for (const c of children) c.after(this);
		return this;
	}

	// "I run after ..."
	after(...parents: Node[]) {
		for (const p of parents) {
			this.deps.add(p);
			p.out.add(this);
		}
		return this;
	}

	// sugar: "X runs after me"
	before(...nodes: Node[]) {
		return this.then(...nodes);
	}
}

function dec(name: string, cmd: Cmd | Cmd[]) {
	return new Node(name, cmd);
}

function collect(root: Node) {
	const all = new Set<Node>();
	const stack = [root];
	while (stack.length) {
		// biome-ignore lint/style/noNonNullAssertion: again, no.
		const n = stack.pop()!;
		if (all.has(n)) continue;
		all.add(n);
		for (const c of n.out) stack.push(c);
		for (const d of n.deps) stack.push(d); // in case you built backwards somewhere
	}
	return all;
}

async function run(root: Node) {
	const all = collect(root);
	const pending = new Set(all);
	const done = new Set<Node>();

	while (pending.size) {
		const ready = [...pending].filter((n) =>
			[...n.deps].every((d) => done.has(d)),
		);

		if (ready.length === 0) {
			const remaining = [...pending]
				.map(
					(n) => `${n.name} <- [${[...n.deps].map((d) => d.name).join(", ")}]`,
				)
				.join("\n");
			throw new Error(`Dependency cycle detected:\n${remaining}`);
		}

		await Promise.all(
			ready.map(async (n) => {
				log(`[node ${n.name}] starting`);
				// sequential within node (predictable). If you want parallel, swap to Promise.all.
				for (const cmd of n.cmds) {
					try {
						await cmd;
					} catch (e) {
						error(`[node ${n.name}] fail`, e);
					}
				}
				success(`[node ${n.name}] ok`);
			}),
		);

		ready.forEach((n) => {
			pending.delete(n);
			done.add(n);
		});
	}

	success("startup complete");
}

const tree = dec(
	"alsa fix",
	$`amixer -c 1 set Master 100% unmute && amixer -c 1 set Headphone 100% unmute && amixer -c 1 set Speaker 100% unmute`,
).then(
	dec(
		"daemons",
		["hyprpolkitagent", "hypridle", "hyprpaper", "caelestia", "easyeffects"].map(
			(s) => $`systemctl --user enable --now ${s}`,
		),
	),
	dec(
		"apps",
		["kdeconnectd", "ktailctl"].map(
			(app) => $`pidof ${app} || hyprctl dispatch exec ${app}`,
		),
	),
	dec("shell", $`pidof quickshell || caelestia-shell`),
	dec(
		"blueman-applet",
		$`pgrep -f ..blueman-applet-wrapped-wrapped || hyprctl dispatch exec blueman-applet`,
	),
	dec("cursor", $`hyprctl setcursor Bibata-Modern-Classic 24`),
);

await run(tree);
