# Используем официальный образ Node.js
FROM node:alpine AS build

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package.json package-lock.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы проекта
COPY . .

RUN npm uninstall react-scripts && npm install react-scripts

#RUN #ls -la node_modules/.bin

# Собираем проект
RUN npm run build

# Устанавливаем nginx для сервировки статических файлов
FROM nginx:alpine

# Копируем сгенерированные статические файлы в директорию nginx
COPY --from=build app /usr/share/nginx/html

COPY --from=build app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

# Запуск nginx
CMD ["nginx", "-g", "daemon off;"]
