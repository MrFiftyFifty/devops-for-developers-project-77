resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web-${count.index + 1}"
  platform_id = var.vm_platform_id
  zone        = count.index == 0 ? "ru-central1-a" : "ru-central1-b"

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = var.vm_disk_size
    }
  }

  network_interface {
    subnet_id = count.index == 0 ? yandex_vpc_subnet.app_subnet_a.id : yandex_vpc_subnet.app_subnet_b.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}
