### Статус проверок Hexlet

[![Actions Status](https://github.com/MrFiftyFifty/devops-for-developers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/MrFiftyFifty/devops-for-developers-project-77/actions)

---

## О проекте

Это учебный DevOps-проект: облако — Yandex Cloud, инфраструктура описана в Terraform, настройка серверов и деплой — Ansible. В контейнере крутится [Redmine](https://www.redmine.org/) (можно было взять что угодно с Docker-образом, остановился на нём). Схема привычная: две ВМ под приложение, балансировщик с HTTPS, снаружи — домен и сертификат, база — управляемый PostgreSQL.

Секреты в репозиторий не кладём: часть в Ansible Vault, часть через переменные окружения для Terraform. Стейт Terraform лежит не в git, а в бакете Object Storage. После `terraform apply` автоматически генерятся `ansible/inventory.ini` и `ansible/group_vars/all/generated.yml` — чтобы не копировать IP и параметры БД руками (я так и делал раньше, надоело).

**Ссылка на задеплоенное приложение** (когда всё реально поднято — подставьте свой домен):

https://example.com

## Что в облаке по сути

Две виртуалки на Ubuntu 22.04 в разных зонах (`ru-central1-a` / `ru-central1-b`), за ними Application Load Balancer с TLS и редиректом с 80 на 443. Сеть своя, подсети `10.1.0.0/24` и `10.2.0.0/24`. В security group снаружи открыты только 80 и 443.

DNS-зона в Yandex Cloud, A-запись на балансировщик, сертификат через Certificate Manager (Let's Encrypt, DNS challenge).

Мониторинг: Datadog — агент на машинах плюс то, что создаёт Terraform (синтетика по HTTP, алерты). Отдельно можно повесить [Upmon](https://www.upmon.com/) — проверка «как с улицы», с разных точек; у них есть бесплатный тариф на несколько мониторов.

## Что поставить себе на машину

Terraform 1.x, Ansible с поддержкой vault. Для полного прогона ещё понадобятся аккаунт Yandex Cloud, бакет под стейт, SSH-ключ (в сгенерированном инвентори по умолчанию путь к ключу — `~/.ssh/id_rsa`, при необходимости поправьте шаблон в `terraform/templates/inventory.tftpl`).

Datadog — по заданию; без аккаунта Terraform на этапе с провайдером может ругаться, если не передавать ключи (или временно убрать блок — но для сдачи проекта обычно заводят trial).

## Как завести с нуля

**Переменные для Terraform** — через `export`, чтобы не светить в `.tfvars` в репозитории:

```bash
export TF_VAR_yc_token="..."
export TF_VAR_yc_cloud_id="..."
export TF_VAR_yc_folder_id="..."
export TF_VAR_db_password="..."
export TF_VAR_domain_name="ваш-домен.ru"
export TF_VAR_datadog_api_key="..."
export TF_VAR_datadog_app_key="..."
export YC_S3_ACCESS_KEY="..."
export YC_S3_SECRET_KEY="..."
```

**Vault для Ansible** — файл `ansible/group_vars/all/vault.yml`. Редактирование:

```bash
make decrypt
# правите файл
make encrypt
```

Там же токены/ключи облака, пароли, `dd_api_key` и т.д. Смысл тот же, что и в Terraform, только то, что нужно плейбуку и ролям.

**Дальше по порядку:**

```bash
make init
make apply
make install-roles
make install-collections
make deploy-all
```

`apply` создаст инфраструктуру и допишет `inventory.ini` + `generated.yml` в `ansible/`. Эти файлы в `.gitignore` — их не коммитим.

## Makefile — что нажимать

Terraform: `make init`, `validate`, `plan`, `apply`, `destroy`, `output`, `fmt`, `state-list`.

Ansible: `install-roles`, `install-collections`, `setup`, `deploy`, `deploy-all`, `healthcheck`, `monitoring`.

Vault: `view-vault`, `decrypt`, `encrypt`.

В плейбуке есть теги — `setup`, `docker`, `monitoring`, `deploy`, `healthcheck`. Если не хочется гонять всё подряд, можно вызывать `ansible-playbook` с `--tags ...` вручную; в Makefile часть целей это уже обёрнула.

## Домен

Купили домен у регистратора → выставили `TF_VAR_domain_name` → `make apply` → в `make output` смотрите NS для зоны в Yandex Cloud → прописали NS у регистратора. Обновление DNS может идти часами — это не баг.

## Структура (кратко)

- `terraform/` — всё про облако, плюс шаблоны для генерации файлов Ansible
- `ansible/` — `playbook.yml`, `requirements.yml`, `ansible.cfg`, переменные в `group_vars`

Ориентир по организации репозитория можно подсмотреть у [hexlet-basics](https://github.com/hexlet-basics/hexlet-basics): там другой стек, но идея та же — инфра отдельно, приложение и обвязка рядом.

---

Если бейдж Actions красный — смотрите лог job в GitHub; чаще всего это не README, а что-то в проверках Hexlet на стороне платформы.
