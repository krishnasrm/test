#!/bin/bash

# Run with: sudo ./setup_apache.sh

# Exit immediately if any command fails
set -e

echo "=== [1/7] Checking YUM availability ==="
if ! command -v yum &> /dev/null; then
    echo "YUM package manager not found. This script is for RHEL/CentOS-based systems."
    exit 1
fi

echo
echo "=== Available YUM Repositories ==="
yum repolist all

echo
echo "=== [2/7] Checking if Apache (httpd) is already installed ==="
if rpm -q httpd &> /dev/null; then
    echo "httpd is already installed."
else
    read -p "Apache is not installed. Install now? [y/N]: " install_apache
    if [[ "$install_apache" =~ ^[Yy]$ ]]; then
        yum install -y httpd
        echo "Apache installed successfully."
    else
        echo "Aborting setup."
        exit 1
    fi
fi

echo
echo "=== [3/7] Checking httpd service status ==="
if systemctl is-active --quiet httpd; then
    echo "httpd is already running."
else
    read -p "httpd is not running. Start the service now? [y/N]: " start_httpd
    if [[ "$start_httpd" =~ ^[Yy]$ ]]; then
        systemctl start httpd
        echo "httpd service started."
    else
        echo "httpd not started. Aborting."
        exit 1
    fi
fi

echo
echo "=== [4/7] Enabling httpd to start at boot ==="
systemctl enable httpd

echo
echo "=== [5/7] Preparing /var/www/html/index.html ==="
WEB_DIR="/var/www/html"
HTML_FILE="$WEB_DIR/index.html"

cd "$WEB_DIR" || { echo "Failed to access $WEB_DIR"; exit 1; }

if [ -f "$HTML_FILE" ]; then
    echo "index.html already exists."
    read -p "Overwrite it with 'hello world'? [y/N]: " overwrite
    if [[ "$overwrite" =~ ^[Yy]$ ]]; then
        echo "hello world" > "$HTML_FILE"
        echo "index.html updated."
    else
        echo "Keeping existing index.html."
    fi
else
    echo "hello world" > "$HTML_FILE"
    echo "index.html created."
fi

echo
echo "=== [6/7] Restarting httpd to apply changes ==="
systemctl restart httpd

echo
echo "=== [7/7] Verifying httpd is enabled and running ==="
systemctl is-enabled --quiet httpd && echo "httpd is enabled at boot."
systemctl is-active --quiet httpd && echo "httpd is running."

echo
echo "✅ Setup complete. Visit http://<your-server-ip> to verify your webpage."
#!/bin/bash

# Run with: sudo ./setup_apache.sh

# Exit immediately if any command fails
set -e

echo "=== [1/7] Checking YUM availability ==="
if ! command -v yum &> /dev/null; then
    echo "YUM package manager not found. This script is for RHEL/CentOS-based systems."
    exit 1
fi

echo
echo "=== Available YUM Repositories ==="
yum repolist all

echo
echo "=== [2/7] Checking if Apache (httpd) is already installed ==="
if rpm -q httpd &> /dev/null; then
    echo "httpd is already installed."
else
    read -p "Apache is not installed. Install now? [y/N]: " install_apache
    if [[ "$install_apache" =~ ^[Yy]$ ]]; then
        yum install -y httpd
        echo "Apache installed successfully."
    else
        echo "Aborting setup."
        exit 1
    fi
fi

echo
echo "=== [3/7] Checking httpd service status ==="
if systemctl is-active --quiet httpd; then
    echo "httpd is already running."
else
    read -p "httpd is not running. Start the service now? [y/N]: " start_httpd
    if [[ "$start_httpd" =~ ^[Yy]$ ]]; then
        systemctl start httpd
        echo "httpd service started."
    else
        echo "httpd not started. Aborting."
        exit 1
    fi
fi

echo
echo "=== [4/7] Enabling httpd to start at boot ==="
systemctl enable httpd

echo
echo "=== [5/7] Preparing /var/www/html/index.html ==="
WEB_DIR="/var/www/html"
HTML_FILE="$WEB_DIR/index.html"

cd "$WEB_DIR" || { echo "Failed to access $WEB_DIR"; exit 1; }

if [ -f "$HTML_FILE" ]; then
    echo "index.html already exists."
    read -p "Overwrite it with 'hello world'? [y/N]: " overwrite
    if [[ "$overwrite" =~ ^[Yy]$ ]]; then
        echo "hello world" > "$HTML_FILE"
        echo "index.html updated."
    else
        echo "Keeping existing index.html."
    fi
else
    echo "hello world" > "$HTML_FILE"
    echo "index.html created."
fi

echo
echo "=== [6/7] Restarting httpd to apply changes ==="
systemctl restart httpd

echo
echo "=== [7/7] Verifying httpd is enabled and running ==="
systemctl is-enabled --quiet httpd && echo "httpd is enabled at boot."
systemctl is-active --quiet httpd && echo "httpd is running."

echo
echo "✅ Setup complete. Visit http://<your-server-ip> to verify your webpage."



