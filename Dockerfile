FROM node:20-slim AS builder
WORKDIR /app

# Instalar OpenSSL no builder (para gerar Prisma Client)
RUN apt-get update -y && apt-get install -y openssl

# Copiar arquivos de dependências + Prisma
COPY package*.json ./
COPY prisma ./prisma

# Instalar dependências
RUN npm install

# Copiar resto do código
COPY . .

# Gerar Prisma Client (garantindo)
RUN npx prisma generate

# Compilar
RUN npm run build

# Etapa 2: Produção (imagem menor e otimizada)
FROM node:20-slim
WORKDIR /app

# Instalar OpenSSL no container de produção
RUN apt-get update -y && apt-get install -y openssl

# Copiar apenas os arquivos necessários do builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma

# Expor a porta da API
EXPOSE 3000

# Comando para rodar em produção
CMD ["node", "dist/main"]
