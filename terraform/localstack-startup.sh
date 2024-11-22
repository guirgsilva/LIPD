#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Função para verificar qual comando do docker compose está disponível
get_docker_compose_cmd() {
    if command -v docker-compose &> /dev/null; then
        echo "docker-compose"
    elif docker compose version &> /dev/null; then
        echo "docker compose"
    else
        echo "NONE"
    fi
}

# Verificar se o Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker não está instalado. Instalando...${NC}"
    sudo apt-get update
    sudo apt-get install -y docker.io
fi

# Verificar se o Docker Compose está instalado
DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)
if [ "$DOCKER_COMPOSE_CMD" = "NONE" ]; then
    echo -e "${RED}Docker Compose não está instalado. Instalando...${NC}"
    sudo apt-get update
    sudo apt-get install -y docker-compose-plugin
    DOCKER_COMPOSE_CMD="docker compose"
fi

echo "Starting LocalStack environment..."

# Criar diretório para volume se não existir
mkdir -p volume

# Parar containers existentes
$DOCKER_COMPOSE_CMD down 2>/dev/null || true

# Iniciar LocalStack
$DOCKER_COMPOSE_CMD up -d

# Aguardar LocalStack inicializar
echo "Waiting for LocalStack to be ready..."
until curl -s http://localhost:4566/_localstack/health | grep -q "\"running\": true"; do
    printf "."
    sleep 2
done

echo -e "\n${GREEN}LocalStack is ready!${NC}"

# Verificar status dos serviços
echo "Checking service status..."
if command -v jq &> /dev/null; then
    curl -s http://localhost:4566/_localstack/health | jq .
else
    echo -e "${RED}jq não está instalado. Instalando...${NC}"
    sudo apt-get install -y jq
    curl -s http://localhost:4566/_localstack/health | jq .
fi

# Verificar se AWS CLI está instalada
if ! command -v aws &> /dev/null; then
    echo -e "${RED}AWS CLI não está instalada. Instalando...${NC}"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
fi

# Configurar aws cli local profile
aws configure set aws_access_key_id test --profile localstack
aws configure set aws_secret_access_key test --profile localstack
aws configure set region us-east-1 --profile localstack
aws configure set output json --profile localstack

echo -e "${GREEN}LocalStack environment is ready to use!${NC}"
echo "Use 'aws --endpoint-url=http://localhost:4566 --profile localstack' for AWS CLI commands"