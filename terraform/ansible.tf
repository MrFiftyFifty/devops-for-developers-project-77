resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.ini"
  content = templatefile("${path.module}/templates/inventory.tftpl", {
    web_servers = yandex_compute_instance.web
  })
  file_permission = "0644"
}

resource "local_file" "ansible_variables" {
  filename = "../ansible/group_vars/all/generated.yml"
  content = templatefile("${path.module}/templates/variables.tftpl", {
    db_host     = yandex_mdb_postgresql_cluster.app_db.host[0].fqdn
    db_name     = var.db_name
    db_user     = var.db_user
    db_password = var.db_password
    db_port     = 6432
    app_port    = var.app_port
    domain_name = var.domain_name
  })
  file_permission = "0644"
}
