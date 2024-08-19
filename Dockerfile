FROM ubuntu:latest
LABEL authors="Lukin"

ENTRYPOINT ["top", "-b"]
# frontend/Dockerfile

# Используем официальный образ Node.js
FROM node:18-alpine AS build

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm cache clean --force && npm install

# Копируем остальные файлы проекта
COPY . .

# Собираем проект
RUN npm run build

# Устанавливаем nginx для сервировки статических файлов
FROM nginx:alpine

# Копируем сгенерированные статические файлы в директорию nginx
COPY --from=build /app .

# Открываем порт 80 для доступа к приложению
EXPOSE 80

# Запуск nginx
CMD ["nginx", "-g", "daemon off;"]
