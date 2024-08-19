FROM ubuntu:latest
LABEL authors="Lukin"

ENTRYPOINT ["top", "-b"]
# frontend/Dockerfile

# Используем официальный образ Node.js
FROM node:apline AS build

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package.json package.json

COPY package-lock.json package-lock.json

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы проекта
COPY . .

# Собираем проект
RUN npm run build

# Устанавливаем nginx для сервировки статических файлов
FROM nginx:alpine

# Копируем сгенерированные статические файлы в директорию nginx
COPY --from=build /dist /usr/share/nginx/html

COPY --from=build nginx.conf /etc/nginx/conf.d/default.conf

# Открываем порт 80 для доступа к приложению
EXPOSE 80

# Запуск nginx
CMD ["nginx", "-g", "daemon off;"]
