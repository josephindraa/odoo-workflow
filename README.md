# Odoo Workflow

Repositori ini berisi *boilerplate* lingkungan pengembangan Odoo 19 berbasis Docker Compose dengan prinsip **Secure by Default**. Sistem ini mengintegrasikan Nginx Reverse Proxy dan mendukung HTTPS untuk kebutuhan *local development* (menggunakan mkcert) serta lingkungan publik (menggunakan Certbot).

---

## 🚀 Quick Start

### 1. Persyaratan Sistem
- **Docker** & **Docker Compose** (Plugin v2+)
- **mkcert** (untuk sertifikat SSL/TLS lokal)
- **Linux / WSL2 / macOS**

### 2. Salin dan Konfigurasi File (.env & local.conf)
Salin file *template*, sesuaikan variabel di dalam `.env` dan `config/odoo/local.conf` sesuai kebutuhan lingkungan pengembangan:

```bash
cp .env.example .env
cp config/odoo/local.conf.example config/odoo/local.conf
```

> 💡 **Tip Keamanan:** Ubah nilai `admin_passwd` pada file `config/odoo/local.conf` untuk mengamankan akses Database Manager Odoo.

### 3. Generate Sertifikat SSL Lokal (mkcert)
Gunakan `mkcert` untuk membuat sertifikat SSL tepercaya pada domain atau IP lingkungan lokal:

```bash
mkcert -install
mkdir -p config/certs/dev/live/<YOUR_DOMAIN_NAME>
mkcert \
  -cert-file config/certs/dev/live/<YOUR_DOMAIN_NAME>/fullchain.pem \
  -key-file config/certs/dev/live/<YOUR_DOMAIN_NAME>/privkey.pem \
  "<YOUR_DOMAIN_NAME>" "*.<YOUR_DOMAIN_NAME>" localhost 127.0.0.1
```

> 💡 **Catatan:** Ganti `<YOUR_DOMAIN_NAME>` (misalnya `odoo-workflow.192-168-10-11.sslip.io`) sesuai dengan variabel `DOMAIN_NAME` yang telah diatur pada file `.env`.

---

Penggunaan SSL lokal memerlukan file `docker-compose.override.yml` di *root folder* proyek. Pastikan file tersebut menggunakan konfigurasi berikut:

```yaml
services:
  webserver:
    volumes:
      - ./config/certs/dev:/etc/letsencrypt:ro

  certs:
    entrypoint: ["echo", "Certbot disabled in local development environment"]
```

### 4. Jalankan Container
```bash
docker compose up -d
```

Akses layanan di *browser* menggunakan domain yang telah dikonfigurasi:

* **HTTPS (Nginx Proxy):** `https://<YOUR_DOMAIN_NAME>`
* **Database Manager:** `https://<YOUR_DOMAIN_NAME>/web/database/manager`

> 💡 **Catatan:** Ganti `<YOUR_DOMAIN_NAME>` dengan domain atau IP lokal yang digunakan (misalnya `odoo-workflow.192-168-10-11.sslip.io`).

## 📂 Struktur Folder
```text
.
├── addons/                       # Custom Odoo modules / addons
├── config/
│   ├── certs/                    # SSL certificates (dev & prod)
│   ├── odoo/
│   │   ├── odoo.conf             # Base configuration
│   │   ├── local.conf            # Active local override (git-ignored)
│   │   └── local.conf.example
│   └── nginx.conf.template       # Nginx reverse proxy template
├── scripts/                      # Utility scripts
├── docker-compose.yml
└── docker-compose.override.yml
```
