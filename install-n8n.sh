#!/bin/bash
###############################################################################
# ⚡ GOLDENIAN8N - Instalador de n8n con FFmpeg ⚡
# Created by: GOLDENIA
# Repositorio: https://github.com/goldenchickenchannels/goldenian8n
###############################################################################

set -e  # Detener si hay algún error

# ═══════════════════════════════════════════════════════════════════════════
# 🎨 COLORES Y ESTILOS
# ═══════════════════════════════════════════════════════════════════════════
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# ═══════════════════════════════════════════════════════════════════════════
# ⚙️  CONFIGURACIÓN
# ═══════════════════════════════════════════════════════════════════════════
INSTALL_DIR="/docker/n8n"
REPO_URL="https://raw.githubusercontent.com/goldenchickenchannels/goldenian8n/main"

# ═══════════════════════════════════════════════════════════════════════════
# 🎯 FUNCIONES DE UTILIDAD
# ═══════════════════════════════════════════════════════════════════════════

print_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                                                                   ║
    ║   ░██████╗░░█████╗░██╗░░░░░██████╗░███████╗███╗░░██╗██╗░█████╗░  ║
    ║   ██╔════╝░██╔══██╗██║░░░░░██╔══██╗██╔════╝████╗░██║██║██╔══██╗  ║
    ║   ██║░░██╗░██║░░██║██║░░░░░██║░░██║█████╗░░██╔██╗██║██║███████║  ║
    ║   ██║░░╚██╗██║░░██║██║░░░░░██║░░██║██╔══╝░░██║╚████║██║██╔══██║  ║
    ║   ╚██████╔╝╚█████╔╝███████╗██████╔╝███████╗██║░╚███║██║██║░░██║  ║
    ║   ░╚═════╝░░╚════╝░╚══════╝╚═════╝░╚══════╝╚═╝░░╚══╝╚═╝╚═╝░░╚═╝  ║
    ║                                                                   ║
    ╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${PURPLE}${BOLD}"
    echo "                ⚡ INSTALADOR DE N8N + FFMPEG ⚡"
    echo -e "${NC}"
    echo -e "${YELLOW}                    Powered by ${WHITE}${BOLD}GOLDENIA${NC}"
    echo ""
    sleep 1
}

print_step() {
    echo ""
    echo -e "${CYAN}${BOLD}▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰${NC}"
    echo -e "${WHITE}${BOLD}  $1${NC}"
    echo -e "${CYAN}${BOLD}▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}${BOLD}  ✓ $1${NC}"
}

print_error() {
    echo -e "${RED}${BOLD}  ✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${BOLD}  ⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}  ➜ $1${NC}"
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " ${CYAN}[%c]${NC}  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# ═══════════════════════════════════════════════════════════════════════════
# 🚀 INICIO DEL INSTALADOR
# ═══════════════════════════════════════════════════════════════════════════

print_banner

print_step "🔍 VERIFICANDO REQUISITOS DEL SISTEMA"

# Verificar Docker
print_info "Verificando instalación de Docker..."
if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado"
    echo ""
    echo -e "${YELLOW}  Por favor, instala Docker primero:${NC}"
    echo -e "${BLUE}  👉 https://docs.docker.com/get-docker/${NC}"
    echo ""
    exit 1
fi
print_success "Docker detectado correctamente"

# Verificar Docker Compose
print_info "Verificando instalación de Docker Compose..."
if ! command -v docker compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose no está instalado"
    echo ""
    echo -e "${YELLOW}  Por favor, instala Docker Compose primero${NC}"
    echo ""
    exit 1
fi
print_success "Docker Compose detectado correctamente"

sleep 1

# ═══════════════════════════════════════════════════════════════════════════

print_step "📂 PREPARANDO ENTORNO DE INSTALACIÓN"

print_info "Creando directorio: ${BOLD}$INSTALL_DIR${NC}"
sudo mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
print_success "Directorio preparado"

sleep 0.5

# ═══════════════════════════════════════════════════════════════════════════

print_step "📥 DESCARGANDO ARCHIVOS DESDE GITHUB"

# Descargar docker-compose.yml
print_info "Descargando docker-compose.yml..."
if sudo curl -fsSL "$REPO_URL/docker-compose.yml" -o docker-compose.yml; then
    print_success "docker-compose.yml descargado"
else
    print_error "Error descargando docker-compose.yml"
    exit 1
fi

sleep 0.3

# Descargar Dockerfile
print_info "Descargando Dockerfile..."
if sudo curl -fsSL "$REPO_URL/Dockerfile" -o Dockerfile; then
    print_success "Dockerfile descargado"
else
    print_error "Error descargando Dockerfile"
    exit 1
fi

sleep 0.5

# ═══════════════════════════════════════════════════════════════════════════

print_step "🧹 LIMPIEZA DE CONTENEDORES ANTERIORES"

print_info "Deteniendo contenedores existentes..."
sudo docker compose down --remove-orphans 2>/dev/null || true
print_success "Limpieza completada"

sleep 0.5

# ═══════════════════════════════════════════════════════════════════════════

print_step "🏗️  CONSTRUYENDO IMAGEN PERSONALIZADA"

print_warning "Este proceso puede tardar varios minutos..."
echo ""
sudo docker compose build --no-cache
echo ""
print_success "Imagen construida exitosamente"

sleep 0.5

# ═══════════════════════════════════════════════════════════════════════════

print_step "🚀 INICIANDO SERVICIOS"

print_info "Levantando contenedores..."
sudo docker compose up -d
print_success "Servicios iniciados correctamente"

sleep 1

# ═══════════════════════════════════════════════════════════════════════════
# 📋 LEER CONFIGURACIÓN DEL .ENV LOCAL
# ═══════════════════════════════════════════════════════════════════════════

# Leer el DOMAIN_NAME del archivo .env que ya existe en el servidor
if [ -f "$INSTALL_DIR/.env" ]; then
    source "$INSTALL_DIR/.env"
    if [ -n "$DOMAIN_NAME" ]; then
        N8N_URL="https://${DOMAIN_NAME}"
    else
        N8N_URL="http://localhost:5678"
    fi
else
    N8N_URL="http://localhost:5678"
fi

# ═══════════════════════════════════════════════════════════════════════════

clear
echo -e "${YELLOW}${BOLD}"
cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                                                                   ║
    ║                                                                   ║
    ║                     ██╗░░░░░██╗░██████╗████████╗░█████╗░         ║
    ║                     ██║░░░░░██║██╔════╝╚══██╔══╝██╔══██╗         ║
    ║                     ██║░░░░░██║╚█████╗░░░░██║░░░██║░░██║         ║
    ║                     ██║░░░░░██║░╚═══██╗░░░██║░░░██║░░██║         ║
    ║                     ███████╗██║██████╔╝░░░██║░░░╚█████╔╝         ║
    ║                     ╚══════╝╚═╝╚═════╝░░░░╚═╝░░░░╚════╝░         ║
    ║                                                                   ║
    ║                                                                   ║
    ╚═══════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${WHITE}${BOLD}                    INFORMACIÓN DEL SISTEMA${NC}"
echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}${BOLD}  📍 Ubicación:${NC}      $INSTALL_DIR"
echo -e "${GREEN}${BOLD}  🌐 URL de acceso:${NC}  ${WHITE}$N8N_URL${NC}"
echo ""
echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}${BOLD}  Ahora vuelve a tu panel de Hostinger, dale al botón${NC}"
echo -e "${GREEN}${BOLD}  administrar aplicación, crea tus credenciales para n8n${NC}"
echo -e "${GREEN}${BOLD}  y entra a importar o crear tus flujos. 🎬${NC}"
echo ""
echo -e "${PURPLE}${BOLD}              Creado con ❤️  por GOLDENIA${NC}"
echo ""
echo -e "${YELLOW}${BOLD}              ✨ Mantente dorado ✨${NC}"
echo ""