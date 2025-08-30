/// <reference types="@rbxts/types" />
// Source root for roblox-ts. Compiles into src/ReplicatedStorage/TS.

const Theme = {
	font: Enum.Font.Gotham,
	colors: {
		panel: Color3.fromRGB(34,34,38),
		border: Color3.fromRGB(60,60,66),
		text: Color3.fromRGB(235,235,240),
		muted: Color3.fromRGB(160,160,170),
		accent: Color3.fromRGB(0,170,255),
	},
};

const mount = (parent: Instance) => {
	const frame = new Instance("Frame");
	frame.Name = "TsPanel";
	frame.Size = new UDim2(0,260,0,160);
	frame.BackgroundColor3 = Theme.colors.panel;
	frame.BorderColor3 = Theme.colors.border;
	frame.Parent = parent;

	const title = new Instance("TextLabel");
	title.BackgroundTransparency = 1;
	title.Size = new UDim2(1,0,0,20);
	title.Font = Theme.font;
	title.TextXAlignment = Enum.TextXAlignment.Left;
	title.TextColor3 = Theme.colors.text;
	title.Text = "TS Demo";
	title.Parent = frame;

	const body = new Instance("TextLabel");
	body.BackgroundTransparency = 1;
	body.Position = new UDim2(0,0,0,28);
	body.Size = new UDim2(1,-12,1,-28);
	body.Font = Theme.font;
	body.TextWrapped = true;
	body.TextColor3 = Theme.colors.muted;
	body.TextXAlignment = Enum.TextXAlignment.Left;
	body.TextYAlignment = Enum.TextYAlignment.Top;
	body.Text = "Compiled via roblox-ts. Counter: 0";
	body.Parent = frame;

	let count = 0; let acc = 0;
	const rs = game.GetService("RunService");
	const conn = rs.Heartbeat.Connect(dt => {
		if (!frame.Parent) { conn.Disconnect(); return; }
		acc += dt;
		if (acc >= 1) { acc = 0; count++; body.Text = `Compiled via roblox-ts. Counter: ${count}`; }
	});
	return frame;
};

export = mount;
