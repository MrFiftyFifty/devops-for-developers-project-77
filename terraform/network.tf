resource "yandex_vpc_network" "app_network" {
  name = "app-network"
}

resource "yandex_vpc_subnet" "app_subnet_a" {
  name           = "app-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.app_network.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

resource "yandex_vpc_subnet" "app_subnet_b" {
  name           = "app-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.app_network.id
  v4_cidr_blocks = ["10.2.0.0/24"]
}
