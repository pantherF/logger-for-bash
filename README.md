# logger-for-bash

> A simple logger for bash scripts with basic logging and command execution logging options.

A lightweight Bash logging utility that provides structured, timestamped log output to both the terminal and a log file. It supports standard log levels and a helper function that runs a command while automatically capturing and logging its output.

---

## Setup

Source the script at the top of your Bash script to make the logging functions available:

```bash
source /path/to/logger.sh
```

### Environment Variables

Configure the logger by setting these variables **before** sourcing the script:

| Variable | Description | Default |
|----------|-------------|---------|
| `LOG_NAME` | Base name for the log file | `log` |
| `LOG_FILE_PATH` | Directory where the log file will be created | None — logs to terminal only |

> If `LOG_FILE_PATH` is not set or does not exist, a warning is printed to stderr and logs are written to the terminal only.

### Example

```bash
export LOG_NAME="my-script"
export LOG_FILE_PATH="/var/log/my-app/"

source /path/to/logger.sh
```

This will create a log file like `/var/log/my-app/my-script_20240101_120000.log`.

---

## Functions

### `log <level> <message>`

Logs a timestamped message at the given level. Output is printed to the terminal and appended to the log file (if configured).

**Log levels:**

| Level | Variable | Use for |
|-------|----------|---------|
| `INFO` | `$INFO` | General information |
| `WARNING` | `$WARN` | Non-critical warnings |
| `ERROR` | `$ERROR` | Errors and failures |
| `DEBUG` | `$DEBUG` | Detailed debug output |

```bash
log $INFO "Starting deployment..."
log $WARN "Config file not found, using defaults."
log $ERROR "Failed to connect to database."
```

**Output format:**
```
2024-01-01 12:00:00 [INFO] : Starting deployment.
```

---

### `log_and_run <command>`

Executes a command, logs it, runs the command, then captures and logs each line of its output at the appropriate level.

- Output lines are logged as `DEBUG` on success, or `ERROR` on failure.
- If the command fails, the exit status code is also logged as an `ERROR`.

```bash
log_and_run mkdir -p /tmp/my-app
log_and_run npm install
log_and_run systemctl restart nginx
```

---

## Full Example

```bash
#!/bin/bash

export LOG_NAME="backup"
export LOG_FILE_PATH="/var/log/backups/"

source /path/to/logger.sh

log $INFO "Backup started."
log_and_run tar -czf /tmp/backup.tar.gz /home/user/data
log $INFO "Backup complete."
```

---

## License

This project is licensed under the [MIT License](LICENSE).
