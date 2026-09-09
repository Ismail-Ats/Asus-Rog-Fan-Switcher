# 🎮 ASUS ROG Fan Switcher

A lightweight Bash script for switching fan modes on older ASUS ROG laptops using the `asus-nb-wmi` kernel interface.

It cycles through:

**Balanced → Overboost → Silent**

and displays a desktop notification showing the active mode.

> Tested on ASUS ROG Strix Scar II GL504GS.

---

## ✨ Features

- 🔄 Cycle between fan modes
- ⚖️ Balanced mode
- 🚀 Overboost mode
- 🤫 Silent mode
- 🔔 Desktop notification
- ⌨️ Keyboard shortcut support
- 🪶 Lightweight Bash script
- 🚫 No background service required
- 🐧 Works directly with the Linux kernel interface

---

## 🎯 Why does this exist?

Newer ASUS ROG laptops can use [`asusctl`](https://gitlab.com/asus-linux/asusctl) and the Linux platform-profile interface to control performance and fan profiles.

However, some older ASUS ROG laptops do not expose fan profiles through that interface.

For example, running:

```bash
asusctl profile list
```

may return:

```text
Profiles not supported by either this kernel or by the laptop.
```

Older laptops such as the **ASUS ROG Strix Scar II GL504GS / GL504GM** can instead expose a legacy fan-control interface:

```text
/sys/devices/platform/asus-nb-wmi/fan_boost_mode
```

This script communicates directly with that interface.

---

## 💻 Compatibility

### Confirmed working

- ASUS ROG Strix Scar II GL504GS

### Potentially compatible

The script should work on ASUS laptops where the following file exists:

```text
/sys/devices/platform/asus-nb-wmi/fan_boost_mode
```

and accepts the values:

```text
0
1
2
```

Check your system with:

```bash
ls /sys/devices/platform/asus-nb-wmi/ | grep -i fan
```

Then:

```bash
cat /sys/devices/platform/asus-nb-wmi/fan_boost_mode
```

If the file does not exist, this script will not work on your hardware.

You can instead look into:

- [`asusctl`](https://gitlab.com/asus-linux/asusctl)
- [`nbfc-linux`](https://github.com/nbfc-linux/nbfc-linux)

---

## ⚙️ Fan Modes

| Value | Mode         |
|------:|--------------|  
| `0`   | ⚖️ Balanced  |
| `1`   | 🚀 Overboost |
| `2`   | 🤫 Silent    |

The script cycles through the modes:

```text
Balanced
    ↓
Overboost
    ↓
Silent
    ↓
Balanced
    ↓
...
```

---

## 📦 Requirements

You need:

- Linux
- `asus-nb-wmi` kernel module
- `sudo`
- `notify-send`

### Fedora

Install `notify-send` with:

```bash
sudo dnf install libnotify
```

### Ubuntu / Debian

```bash
sudo apt install libnotify-bin
```

---

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/fan-switcher.git
```

Enter the directory:

```bash
cd fan-switcher
```

Make the script executable:

```bash
chmod +x switch_fan.sh
```

Test it manually:

```bash
sudo ./switch_fan.sh
```

You should see a notification showing the new fan mode.

---

## 🔐 Passwordless Execution

To use the script with a keyboard shortcut, `sudo` must be allowed to execute the script without asking for a password.

Create a dedicated sudoers file:

```bash
sudo visudo -f /etc/sudoers.d/fan-switch
```

Add the following line:

```text
YOUR_USERNAME ALL=(root) NOPASSWD: /FULL/PATH/TO/switch_fan.sh
```

For example:

```text
e4yle ALL=(root) NOPASSWD: /home/e4yle/fan-switcher/switch_fan.sh
```

Then set the correct permissions:

```bash
sudo chmod 440 /etc/sudoers.d/fan-switch
```

> ⚠️ The path in the sudoers rule must exactly match the location of `switch_fan.sh`.

If you move the script, update the sudoers rule.

---

## ⌨️ Keyboard Shortcut

The script can be assigned to a keyboard shortcut such as `F5`.

Open your desktop environment's keyboard shortcut settings and create a custom shortcut.

### Command

```bash
sudo /FULL/PATH/TO/switch_fan.sh
```

Example:

```bash
sudo /home/ismail/fan-switcher/switch_fan.sh
```

### Key

```text
F5
```

Now pressing `F5` will cycle through:

```text
⚖️ Balanced
↓
🚀 Overboost
↓
🤫 Silent
↓
⚖️ Balanced
```

---

## 🧩 How It Works

The script first reads the current fan mode:

```bash
CURRENT=$(cat "$FAN_FILE")
```

It then determines the next mode:

```bash
case "$CURRENT" in
    0)
        NEXT=1
        LABEL="🚀 Overboost"
        ;;
    1)
        NEXT=2
        LABEL="🤫 Silent"
        ;;
    2)
        NEXT=0
        LABEL="⚖️ Balanced"
        ;;
esac
```

The new mode is written directly to the kernel interface:

```bash
echo "$NEXT" > "$FAN_FILE"
```

Finally, `notify-send` displays the active mode on the desktop.

---

## 🛠️ Troubleshooting

### `Invalid argument`

Your laptop may not support all three values.

Check the current interface:

```bash
cat /sys/devices/platform/asus-nb-wmi/fan_boost_mode
```

You can also check kernel messages:

```bash
dmesg | tail -n 50
```

---

### No notification appears

The script uses the current user's DBus session:

```text
/run/user/<USER_ID>/bus
```

On unusual desktop or multi-session configurations, the DBus session address may need to be adjusted.

---

### Keyboard shortcut asks for a password

Check the sudoers configuration:

```bash
sudo visudo -f /etc/sudoers.d/fan-switch
```

Make sure the script path is exactly the same as the path in the sudoers rule.

You can also test:

```bash
sudo -n /FULL/PATH/TO/switch_fan.sh
```

If configured correctly, it should run without asking for a password.

---

## 📸 Screenshot

A desktop notification showing the active fan mode:

![Fan Mode Notification](./screenshots/fan-mode_Balanced.png)
(./screenshots/fan-mode_Overboost.png)
(./screenshots/fan-mode_Silent.png)

---

## ⚠️ Disclaimer

This script directly writes to a hardware-related kernel interface.

Use it at your own risk.

Compatibility depends on the laptop model, kernel version, and ASUS firmware.

The author is not responsible for hardware damage, overheating, or other issues caused by using this script.

---

## 📜 License

This project is licensed under the MIT License.

See [`LICENSE`](LICENSE) for more information.# Fan-switch
