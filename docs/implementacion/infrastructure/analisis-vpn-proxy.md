# ANÁLISIS TÉCNICO OBJETIVO - SOLUCIÓN VPN/PROXY
**Enfoque: Individual/Técnico - Sin Overhead Empresarial**
**Fecha:** 02 de Noviembre, 2025

---

## 🎯 OBJETIVO DEL DOCUMENTO

Análisis puramente técnico de soluciones VPN/proxy para acceso a APIs bloqueadas, eliminando:
- ❌ Perspectivas empresariales
- ❌ Marketing/ventas
- ❌ Compliance/regulaciones
- ❌ Overhead administrativo

**Enfoque:** Soluciones prácticas para usuarios técnicos individuales.

---

## 📊 CONTEXTO TÉCNICO

### Problema Base:
```
APIs bloqueadas:
├─ Claude API (api.anthropic.com)
├─ GitHub Copilot (copilot-proxy.githubusercontent.com)
├─ OpenAI API (api.openai.com)
└─ Otros servicios IA

Métodos de bloqueo observados:
├─ Firewall por IP/dominio
├─ DPI (Deep Packet Inspection)
├─ Port filtering (excepto 80, 443)
└─ DNS poisoning
```

### Soluciones Disponibles:

| Método | Complejidad | Tiempo Setup | Detección | Velocidad |
|--------|-------------|--------------|-----------|-----------|
| **SSH Tunnel** | Baja | 15-30 min | Baja | Alta (>50 Mbps) |
| **WireGuard VPN** | Media | 1-2 horas | Media | Muy Alta (>100 Mbps) |
| **Shadowsocks** | Media | 30-60 min | Baja | Alta (>50 Mbps) |
| **V2Ray** | Alta | 2-3 horas | Muy Baja | Alta (>50 Mbps) |
| **DNS Tunneling** | Muy Alta | 1-2 horas | Muy Baja | Muy Baja (1-5 Mbps) |

---

## 🔧 ARQUITECTURAS TÉCNICAS

### Arquitectura 1: SSH SOCKS5 Tunnel (Recomendada - Quick Start)

```
┌─────────────────────────────────────────────────────────┐
│ CLIENTE (Tu máquina)                                    │
│                                                         │
│  App (VS Code/Python) ──► SOCKS5 Proxy (localhost:1080)│
│                                 │                       │
│                                 ▼                       │
│                     SSH Client (OpenSSH/PuTTY)         │
└─────────────────────────────────┬───────────────────────┘
                                  │
                      Puerto: 53 TCP (DNS) o 443 (HTTPS)
                      Encriptación: SSH (AES-256)
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────┐
│ SERVIDOR VPS (Ubuntu 22.04)                            │
│                                                         │
│  SSH Server (OpenSSH) ──► Dynamic Port Forwarding      │
│                                 │                       │
│                                 ▼                       │
│                           Internet abierto              │
│                                 │                       │
│                                 ▼                       │
│                     api.anthropic.com:443               │
└─────────────────────────────────────────────────────────┘
```

**Características:**
- Latencia añadida: 10-50 ms
- Overhead: ~5% (SSH encryption)
- MTU: 1500 bytes (sin fragmentación)
- Throughput: 50-150 Mbps (depende VPS)

---

### Arquitectura 2: WireGuard VPN (Máximo Rendimiento)

```
┌─────────────────────────────────────────────────────────┐
│ CLIENTE                                                 │
│                                                         │
│  App ──► Sistema Operativo ──► WireGuard Interface     │
│                                 (wg0: 10.0.0.2/24)     │
│                                       │                 │
│                              Routing Table:             │
│                              api.anthropic.com via wg0  │
└───────────────────────────────────┬─────────────────────┘
                                    │
                        Puerto: 443 UDP (camuflado HTTPS)
                        Encriptación: ChaCha20-Poly1305
                        Autenticación: Curve25519
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────┐
│ SERVIDOR VPS                                            │
│                                                         │
│  WireGuard Interface (wg0: 10.0.0.1/24)                │
│            │                                            │
│            ▼                                            │
│      IP Forwarding + NAT                                │
│            │                                            │
│            ▼                                            │
│      Internet (api.anthropic.com)                      │
└─────────────────────────────────────────────────────────┘
```

**Características:**
- Latencia añadida: 5-20 ms (más eficiente que SSH)
- Overhead: ~2% (WireGuard es muy eficiente)
- MTU: 1420 bytes (ajustado para overhead WG)
- Throughput: 100-500 Mbps

---

## 📋 IMPLEMENTACIÓN PASO A PASO

### Setup 1: SSH Tunnel - Puerto 53 (45 minutos)

#### Paso 1: Conseguir VPS (10 min)

**Proveedores testados:**

| Proveedor | Costo | RAM | CPU | BW | Latencia (Ejemplo: USA→EU) |
|-----------|-------|-----|-----|----|-----------------------------|
| **Oracle Cloud** | $0 | 1GB | 1 | 10TB | 120-150ms |
| **DigitalOcean** | $6/mes | 1GB | 1 | 1TB | 80-100ms |
| **Vultr** | $6/mes | 1GB | 1 | 2TB | 85-110ms |
| **Hetzner** | €4.5/mes | 4GB | 2 | 20TB | 90-120ms |

**Comando inicial:**
```bash
# Conectar VPS primera vez
ssh root@<IP_VPS>

# Update sistema
apt update && apt upgrade -y

# Verificar SSH funcional
systemctl status sshd
```

---

#### Paso 2: Configurar SSH en Puerto 53 (10 min)

**Archivo:** `/etc/ssh/sshd_config`

```bash
# Backup original
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Añadir puerto 53 (mantener 22 también)
cat >> /etc/ssh/sshd_config << 'EOF'

# Puerto alternativo (DNS)
Port 22
Port 53

# Configuración optimizada
TCPKeepAlive yes
ClientAliveInterval 60
ClientAliveCountMax 3
Compression yes

# Seguridad básica
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
EOF
```

**Reiniciar SSH:**
```bash
# Verificar configuración antes de reiniciar
sshd -t

# Reiniciar servicio
systemctl restart sshd

# Verificar puertos activos
ss -tlnp | grep sshd
# Debería mostrar: :22 y :53
```

---

#### Paso 3: Firewall (5 min)

```bash
# UFW (Ubuntu/Debian)
ufw allow 22/tcp
ufw allow 53/tcp
ufw enable

# iptables (manual)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables-save > /etc/iptables/rules.v4
```

---

#### Paso 4: Cliente (20 min)

**Linux/macOS:**
```bash
# Crear túnel SOCKS5
ssh -D 1080 -C -N -p 53 usuario@<IP_VPS>

# Opciones:
# -D 1080: Dynamic port forwarding (SOCKS5 en puerto 1080)
# -C: Comprimir datos
# -N: No ejecutar comandos remotos
# -p 53: Usar puerto 53

# Verificar túnel activo
netstat -an | grep 1080
# Output esperado: tcp4  0  0  127.0.0.1.1080  *.*  LISTEN
```

**Windows:**
```powershell
# Usando OpenSSH (Windows 10+)
ssh -D 1080 -C -N -p 53 usuario@<IP_VPS>

# O con PuTTY:
# 1. Connection > SSH > Tunnels
# 2. Source port: 1080
# 3. Dynamic
# 4. Add
# 5. Connection > Data: puerto 53
```

**Configurar aplicaciones:**

VS Code (`settings.json`):
```json
{
  "http.proxy": "socks5://127.0.0.1:1080",
  "http.proxyStrictSSL": false
}
```

Python:
```python
import requests

proxies = {
    'http': 'socks5://127.0.0.1:1080',
    'https': 'socks5://127.0.0.1:1080'
}

response = requests.get('https://api.anthropic.com', proxies=proxies)
```

Git:
```bash
git config --global http.proxy socks5://127.0.0.1:1080
```

---

### Setup 2: WireGuard VPN (90 minutos)

#### Paso 1: Instalación Servidor (15 min)

```bash
# Ubuntu 22.04
apt update
apt install wireguard -y

# Habilitar IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
sysctl -p

# Generar claves servidor
cd /etc/wireguard
umask 077
wg genkey | tee server_private.key | wg pubkey > server_public.key
```

---

#### Paso 2: Configurar Servidor (20 min)

**Archivo:** `/etc/wireguard/wg0.conf`

```ini
[Interface]
# IP privada del servidor
Address = 10.0.0.1/24
# Puerto (443 UDP para evitar bloqueos)
ListenPort = 443
# Clave privada servidor
PrivateKey = <CONTENIDO_server_private.key>

# Post-up: Configurar NAT al iniciar
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Post-down: Limpiar reglas al detener
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Cliente 1
[Peer]
# Clave pública del cliente
PublicKey = <CLIENT_PUBLIC_KEY>
# IP asignada al cliente
AllowedIPs = 10.0.0.2/32
```

**Importante:** Reemplaza `eth0` con tu interfaz de red:
```bash
ip route | grep default
# Ejemplo output: default via 192.168.1.1 dev ens3
# Usar: ens3
```

---

#### Paso 3: Firewall Servidor (10 min)

```bash
# Permitir WireGuard
ufw allow 443/udp

# Verificar
ufw status

# Iniciar WireGuard
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0

# Verificar estado
wg show
```

---

#### Paso 4: Cliente (45 min)

**Instalación:**

Linux:
```bash
apt install wireguard  # Ubuntu/Debian
dnf install wireguard-tools  # Fedora
```

macOS:
```bash
brew install wireguard-tools
# O descargar WireGuard app desde App Store
```

Windows:
- Descargar: https://www.wireguard.com/install/

**Generar claves cliente:**
```bash
wg genkey | tee client_private.key | wg pubkey > client_public.key

# Enviar client_public.key al servidor
cat client_public.key
```

**Configuración cliente:** `/etc/wireguard/wg0.conf` (Linux/macOS)

```ini
[Interface]
# IP privada del cliente
Address = 10.0.0.2/24
# Clave privada cliente
PrivateKey = <CONTENIDO_client_private.key>
# DNS (opcional)
DNS = 1.1.1.1, 8.8.8.8

[Peer]
# Clave pública del servidor
PublicKey = <SERVER_PUBLIC_KEY>
# IP/dominio del servidor
Endpoint = <IP_VPS>:443
# Enrutar TODO el tráfico por VPN
AllowedIPs = 0.0.0.0/0, ::/0
# Keep-alive cada 25 segundos
PersistentKeepalive = 25
```

**Iniciar cliente:**

Linux/macOS:
```bash
# Iniciar
wg-quick up wg0

# Verificar
wg show
ping 10.0.0.1

# Detener
wg-quick down wg0
```

Windows: Usar la aplicación gráfica.

---

## 🧪 TESTING Y TROUBLESHOOTING

### Verificación de Funcionalidad

**Test 1: Conectividad básica**
```bash
# Ping al servidor VPN
ping 10.0.0.1

# Verificar IP pública (debería mostrar IP del VPS)
curl ifconfig.me

# Test API
curl -I https://api.anthropic.com
# Esperado: HTTP/1.1 200 OK (o 401 sin API key)
```

---

**Test 2: Velocidad**
```bash
# Instalar iperf3
apt install iperf3  # Servidor
brew install iperf3  # Cliente macOS

# Servidor VPS:
iperf3 -s

# Cliente:
iperf3 -c <IP_VPS>

# Resultados esperados:
# SSH Tunnel: 50-150 Mbps
# WireGuard: 100-500 Mbps
```

---

**Test 3: Latencia**
```bash
# Ping normal vs VPN
ping -c 10 api.anthropic.com

# Overhead esperado:
# SSH: +10-50ms
# WireGuard: +5-20ms
```

---

### Troubleshooting Común

| Problema | Causa | Solución |
|----------|-------|----------|
| **No conecta** | Firewall bloqueando | Verificar `ufw status`, `ss -tlnp` |
| **Conecta pero sin internet** | IP forwarding deshabilitado | `sysctl net.ipv4.ip_forward` debe ser 1 |
| **Lento** | Compresión/MTU | Ajustar MTU: `ip link set wg0 mtu 1400` |
| **Se desconecta** | NAT timeout | Añadir `PersistentKeepalive = 25` |
| **SSH rechaza puerto 53** | Puerto privilegiado | Ejecutar sshd como root (normal) |

---

## 📈 OPTIMIZACIÓN AVANZADA

### Split Tunneling (Enrutar solo APIs específicas)

**WireGuard con routing selectivo:**

Cliente `wg0.conf`:
```ini
[Interface]
Address = 10.0.0.2/24
PrivateKey = <CLIENT_PRIVATE_KEY>

[Peer]
PublicKey = <SERVER_PUBLIC_KEY>
Endpoint = <IP_VPS>:443
# Solo enrutar IPs de Anthropic/OpenAI
AllowedIPs = 160.79.104.0/23, 104.18.0.0/16
PersistentKeepalive = 25
```

**Obtener rangos IP de APIs:**
```bash
# Claude API
dig +short api.anthropic.com
# Ejemplo: 160.79.104.10

# Verificar rango CIDR
whois 160.79.104.10 | grep CIDR
```

---

### Optimización MTU

**Detectar MTU óptimo:**
```bash
# Ping con DF (Don't Fragment)
ping -M do -s 1472 10.0.0.1

# Si falla, reducir:
ping -M do -s 1400 10.0.0.1

# Aplicar MTU detectado:
ip link set wg0 mtu 1400
```

---

### Automatización con systemd

**Auto-reconectar SSH tunnel:**

`/etc/systemd/system/ssh-tunnel.service`:
```ini
[Unit]
Description=SSH SOCKS5 Tunnel
After=network.target

[Service]
Type=simple
User=tu_usuario
ExecStart=/usr/bin/ssh -D 1080 -C -N -p 53 -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes usuario@<IP_VPS>
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Activar:
```bash
systemctl enable ssh-tunnel
systemctl start ssh-tunnel
systemctl status ssh-tunnel
```

---

## 🔐 SEGURIDAD

### Hardening SSH

**Configuración avanzada** `/etc/ssh/sshd_config`:
```bash
# Limitar intentos de login
MaxAuthTries 3
MaxSessions 5

# Timeouts agresivos
LoginGraceTime 30
ClientAliveInterval 60
ClientAliveCountMax 3

# Restricciones de red
# Solo permitir conexiones desde IP específica (opcional)
# AllowUsers usuario@<TU_IP>

# Ciphers modernos
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org
```

---

### Fail2Ban (Protección brute-force)

```bash
# Instalar
apt install fail2ban -y

# Configurar
cat > /etc/fail2ban/jail.local << 'EOF'
[sshd]
enabled = true
port = 22,53
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
EOF

# Iniciar
systemctl enable fail2ban
systemctl start fail2ban

# Verificar
fail2ban-client status sshd
```

---

### Monitoreo de Conexiones

```bash
# Ver conexiones activas (WireGuard)
wg show

# Ver conexiones SSH
who

# Logs en tiempo real
journalctl -u ssh -f
journalctl -u wg-quick@wg0 -f

# Alertas por email (opcional)
apt install mailutils -y
echo "Nueva conexión SSH desde $(echo $SSH_CLIENT | awk '{print $1}')" | mail -s "SSH Alert" tu@email.com
```

---

## 💰 COSTOS ESTIMADOS

| Setup | Costo Inicial | Costo Mensual | Ancho Banda |
|-------|---------------|---------------|-------------|
| **SSH Tunnel (Oracle Free)** | $0 | $0 | 10TB |
| **SSH Tunnel (DigitalOcean)** | $0 | $6 | 1TB |
| **WireGuard (Hetzner)** | €0 | €4.5 | 20TB |
| **Shadowsocks (Vultr)** | $0 | $6 | 2TB |

**Consumo estimado:**
- Desarrollo típico: 50-100 GB/mes
- APIs (requests): ~1-5 GB/mes
- Total: ~100 GB/mes → **Cualquier VPS cubre sobrado**

---

## ⚖️ COMPARACIÓN FINAL

### SSH Tunnel
**Pros:**
- ✅ Setup más rápido (30 min)
- ✅ No requiere cliente adicional
- ✅ Puerto 53 TCP (muy difícil de bloquear)
- ✅ Ideal para testing

**Contras:**
- ❌ Overhead 5%
- ❌ Latencia +10-50ms
- ❌ Menos eficiente CPU

**Usar si:** Necesitas algo rápido, simple, y temporal.

---

### WireGuard
**Pros:**
- ✅ Máximo rendimiento (overhead 2%)
- ✅ Latencia mínima (+5-20ms)
- ✅ Moderno, auditoría de seguridad completa
- ✅ Split-tunneling fácil

**Contras:**
- ❌ Setup más complejo (90 min)
- ❌ Puerto UDP 443 (puede bloquearse en redes restrictivas)
- ❌ Requiere cliente en cada dispositivo

**Usar si:** Necesitas máximo rendimiento, uso permanente, múltiples dispositivos.

---

## 📌 DECISIÓN RÁPIDA

```
┌──────────────────────────────────────────┐
│ ¿Tienes 30 minutos y quieres testear?   │
│          → SSH Tunnel (Puerto 53)        │
└──────────────────────────────────────────┘

┌──────────────────────────────────────────┐
│ ¿Uso diario, máximo rendimiento?         │
│          → WireGuard                     │
└──────────────────────────────────────────┘

┌──────────────────────────────────────────┐
│ ¿Red extremadamente restrictiva (China)?│
│          → V2Ray o Shadowsocks          │
└──────────────────────────────────────────┘
```

---

## 📚 RECURSOS ADICIONALES

**Documentación oficial:**
- WireGuard: https://www.wireguard.com/quickstart/
- OpenSSH: https://www.openssh.com/manual.html

**Testing tools:**
- iperf3: https://iperf.fr/
- MTR (My Traceroute): `mtr api.anthropic.com`
- DNS leak test: https://dnsleaktest.com/

**Scripts automatización:**
```bash
# Script completo SSH setup (GitHub)
# curl -fsSL https://raw.githubusercontent.com/usuario/ssh-tunnel-setup/main/setup.sh | bash

# Script completo WireGuard setup
# curl -fsSL https://git.io/wireguard | bash
```

---

## 🎓 CONCLUSIÓN

Para un usuario técnico individual que necesita acceso a APIs bloqueadas:

1. **Inicio rápido (hoy):** SSH Tunnel puerto 53
2. **Producción (próxima semana):** WireGuard
3. **Backup:** Mantener ambos configurados

**Tiempo total inversión:**
- SSH: 30-45 minutos
- WireGuard: 90-120 minutos
- **Total:** ~2-3 horas para solución completa y robusta

**Costo:** $0-6/mes (según proveedor VPS)

---

**Documento actualizado:** 02/11/2025
**Versión:** 1.0
**Autor:** Análisis Técnico Independiente
