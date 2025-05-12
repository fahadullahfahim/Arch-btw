#!/bin/bash


# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use 'sudo ./install_virtualbox.sh'."
    exit 1
fi


echo "Updating system..."
pacman -Syu --noconfirm

# Step 2: Install VirtualBox and dependencies
echo "Installing VirtualBox and DKMS..."
pacman -S --noconfirm virtualbox-host-dkms virtualbox virtualbox-guest-iso linux-headers

# Step 3: Install Oracle Extensions (from AUR, requires yay/paru)
echo "Installing VirtualBox Oracle Extensions (from AUR)..."
if ! command -v yay &> /dev/null; then
    echo "yay (AUR helper) not found. Installing yay first..."
    pacman -S --noconfirm --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi
yay -S --noconfirm virtualbox-ext-oracle

# Step 4: Load kernel modules
echo "Loading VirtualBox kernel modules..."
modprobe vboxdrv vboxnetadp vboxnetflt

# Step 5: Enable modules at boot
echo "Enabling kernel modules at boot..."
echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf

# Step 6: Add user to vboxusers group
read -p "Enter your username (to add to vboxusers group): " username
usermod -aG vboxusers "$username"

# Step 7: Final instructions
echo ""
echo "✅ VirtualBox installation complete!"
echo "Reboot your system, then launch VirtualBox from the terminal with:"
echo "   $ virtualbox"
echo ""
echo "To install a VM (e.g., Kali Linux):"
echo "1. Download a .ova file from Kali's website."
echo "2. Open VirtualBox → File → Import Appliance."
echo "3. Follow the wizard."
echo ""

exit 0
