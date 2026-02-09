#!/bin/bash

###############################################################################
# 🚀 Instalador rápido de n8n con FFmpeg
# Repositorio: https://github.com/goldenchickenchannels/goldenian8n
###############################################################################

set -e  # Detener si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
INSTALL_DIR="/docker/n8n"
REPO_URL="https://raw.githubusercontent.com/goldenchickenchannels/goldenian8n/main"

echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║   🚀 Instalador de n8n con FFmpeg    ║"
echo "╔════════════════════════════════════════╗"
echo -e "${NC}"

# Verificar que Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Error: Docker no está instalado${NC}"
    echo "Por favor, instala Docker primero: https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar que Docker Compose está instalado
if ! command -v docker compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Error: Docker Compose no está instalado${NC}"
    echo "Por favor, instala Docker Compose primero"
    exit 1
fi

echo -e "${YELLOW}📂 Preparando directorio: $INSTALL_DIR${NC}"

# Crear directorio si no existe
sudo mkdir -p "$INSTALL_DIR"

# Ir al directorio
cd "$INSTALL_DIR"

echo -e "${YELLOW}📥 Descargando archivos desde GitHub...${NC}"

# Descargar docker-compose.yml
if sudo curl -fsSL "$REPO_URL/docker-compose.yml" -o docker-compose.yml; then
    echo -e "${GREEN}✅ docker-compose.yml descargado${NC}"
else
    echo -e "${RED}❌ Error descargando docker-compose.yml${NC}"
    exit 1
fi

# Descargar Dockerfile
if sudo curl -fsSL "$REPO_URL/Dockerfile" -o Dockerfile; then
    echo -e "${GREEN}✅ Dockerfile descargado${NC}"
else
    echo -e "${RED}❌ Error descargando Dockerfile${NC}"
    exit 1
fi

echo -e "${YELLOW}🧹 Deteniendo contenedores existentes...${NC}"
sudo docker compose down --remove-orphans 2>/dev/null || true

echo -e "${YELLOW}🏗️  Construyendo imagen de n8n con FFmpeg (esto puede tardar unos minutos)...${NC}"
sudo docker compose build --no-cache

echo -e "${YELLOW}🚀 Iniciando n8n...${NC}"
sudo docker compose up -d

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     ✅ ¡Instalación completada!       ║${NC}"
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo ""
echo -e "${BLUE}📍 Ubicación:${NC} $INSTALL_DIR"
echo -e "${BLUE}🌐 Accede a n8n en:${NC} http://localhost:5678"
echo ""
echo -e "${YELLOW}Comandos útiles:${NC}"
echo "  Ver logs:      sudo docker compose logs -f"
echo "  Detener:       sudo docker compose down"
echo "  Reiniciar:     sudo docker compose restart"
echo "  Reconstruir:   sudo docker compose build --no-cache && sudo docker compose up -d"
echo ""
