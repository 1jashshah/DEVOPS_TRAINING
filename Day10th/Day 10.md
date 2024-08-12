Day 10
Task 1 Shell
Project Overview: Develop a comprehensive shell script for sysops to automate system monitoring and generate detailed reports. The script will leverage advanced Linux shell scripting techniques to monitor system metrics, capture logs, and provide actionable insights for system administrators.
Deliverables:
1. Script Initialization:

    Initialize script with necessary variables and configurations.
    Validate required commands and utilities availability.

2. System Metrics Collection:

    Monitor CPU usage, memory utilization, disk space, and network statistics.
    Capture process information including top processes consuming resources.

# Monitor CPU usage
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/"

# memory utilization
free | awk '/Mem/{printf("%.2f"), $3/$2*100}'

# disk space
df -h / | awk '/\//{print $(NF-1)}'

# network statistics
netstat -i

# Capture top processes
top -bn 1 | head -n 10

3. Log Analysis:

    Parse system logs (e.g., syslog) for critical events and errors.
    Generate summaries of recent log entries based on severity.

# Parse syslog for errors
grep -i "error" /var/log/syslog

# Summarize recent log entries
tail -n 20 /var/log/syslog

4. Health Checks:

    Check the status of essential services (e.g., Apache, MySQL).
    Verify connectivity to external services or databases.

# Check essential services
systemctl is-active <service-name>

# Verify external connectivity (example: ping a server)
ping -c 1 "url" >/dev/null 2>&1 && CONNECTIVITY_STATUS="Connected" || CONNECTIVITY_STATUS="Disconnected"

5. Alerting Mechanism:

    Implement thresholds for critical metrics (CPU, memory) triggering alerts.
    Send email notifications to sysadmins with critical alerts.

# Check CPU Usage
if (( $(echo "$CPU_USAGE >= $THRESHOLD_CPU" | bc -l) )); then
    echo "High CPU usage detected: $CPU_USAGE%"
fi

# Check Memory Usage
if (( $(echo "$MEMORY_USAGE >= $THRESHOLD_MEM" | bc -l) )); then
    echo "High memory usage detected: $MEMORY_USAGE%" 
fi

6. Report Generation:

    Compile all collected data into a detailed report.
    Include graphs or visual representations where applicable.

7. Automation and Scheduling:

    Configure the script to run periodically via cron for automated monitoring.
    Ensure the script can handle both interactive and non-interactive execution modes.

0 18 * * * /path/to/daily_updater.sh >/dev/null 2>&1