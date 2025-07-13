import json
import re

AUDIT_LOG = "audit.log"
OUTPUT_FILE = "audit-extract.json"

# Функция для очистки строки от BOM и лишних символов
def clean_line(line):
    # Удаляем BOM (byte order mark)
    line = line.lstrip('\ufeff').strip()
    return line if re.match(r'^\{.*\}$', line) else None

# Фильтры
def is_secret_get_event(event):
    return (
        event.get("objectRef", {}).get("resource") == "secrets"
        and event.get("verb") == "get"
    )

def is_privileged_pod(event):
    try:
        containers = event["requestObject"]["spec"]["containers"]
        for container in containers:
            if container.get("securityContext", {}).get("privileged"):
                return True
        return False
    except KeyError:
        return False

def is_kubectl_exec(event):
    return (
        event.get("verb") == "create"
        and event.get("objectRef", {}).get("subresource") == "exec"
    )

def is_cluster_admin_binding(event):
    return event.get("requestObject", {}).get("roleRef", {}).get("name") == "cluster-admin"

def is_audit_policy_deletion(event):
    return 'audit-policy' in json.dumps(event).lower()

# Основная логика
filtered_events = []

with open(AUDIT_LOG, "r", encoding="utf-8") as f:
    for line in f:
        cleaned_line = clean_line(line)
        if not cleaned_line:
            continue
        try:
            event = json.loads(cleaned_line)
        except json.JSONDecodeError:
            continue  # Пропускаем некорректные строки

        if any([
            is_secret_get_event(event),
            is_privileged_pod(event),
            is_kubectl_exec(event),
            is_cluster_admin_binding(event),
            is_audit_policy_deletion(event)
        ]):
            filtered_events.append(event)

# Запись результата в JSON-файл
with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    json.dump(filtered_events, f, indent=2)

print(f"Фильтрация завершена. Результат сохранён в {OUTPUT_FILE}")