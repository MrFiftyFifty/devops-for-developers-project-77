resource "yandex_mdb_postgresql_cluster" "app_db" {
  name        = "app-postgresql-cluster"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.app_network.id

  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = var.db_disk_size
    }
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.app_subnet_a.id
  }

  host {
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.app_subnet_b.id
  }
}

resource "yandex_mdb_postgresql_database" "app_database" {
  cluster_id = yandex_mdb_postgresql_cluster.app_db.id
  name       = var.db_name
  owner      = yandex_mdb_postgresql_user.app_db_user.name
}

resource "yandex_mdb_postgresql_user" "app_db_user" {
  cluster_id = yandex_mdb_postgresql_cluster.app_db.id
  name       = var.db_user
  password   = var.db_password
}
