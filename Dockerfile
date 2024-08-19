FROM ubuntu:latest
LABEL authors="Lukin"

ENTRYPOINT ["top", "-b"]
# frontend/Dockerfile

# Используем официальный образ Node.js
FROM node:18-alpine

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR .

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы проекта
COPY . .

# Собираем проект
RUN npm run build

# Устанавливаем nginx для сервировки статических файлов
FROM nginx:alpine

# Копируем сгенерированные статические файлы в директорию nginx
COPY --from=0 /app/build /usr/share/nginx/html

# Открываем порт 80 для доступа к приложению
EXPOSE 80

# Запуск nginx
CMD ["nginx", "-g", "daemon off;"]
