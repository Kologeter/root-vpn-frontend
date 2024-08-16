import React, { useEffect } from 'react';
// @ts-ignore
import axios from 'axios';
import './App.css';

function App() {

  useEffect(() => {
    // Инициализация Telegram WebApp
    const telegram = (window as any).Telegram.WebApp;
    telegram.ready();
  }, []);

  const getLinkRedirect = (url: string) => {
    const telegram = (window as any).Telegram.WebApp;

    const user = telegram.initDataUnsafe.user;

    // Подготовка hex_id
    const hex_id = user && user.id ? user.id.toString(16) : null;

    if (!hex_id) {
      console.error('Hex ID is not available.');
      return;
    }

    const url_get = `https://test.nail-bot.ru/connect/run${hex_id}`;

    axios.get(url_get)
        .then((response: { data: { redirectUrl: any; }; }) => {
          const redirectUrl = response.data.redirectUrl;
          if (redirectUrl) {
            // Выполняем редирект на полученную ссылку
            window.location.href = redirectUrl;
          } else {
            console.error('Redirect URL is not available.');
          }
        })
        .catch((error: any) => {
          console.error('Error:', error);
        });
  };

  const sendUserData = () => {
    const telegram = (window as any).Telegram.WebApp;
    const user = telegram.initDataUnsafe.user;

    if (user) {
      telegram.sendData(JSON.stringify(user)); // Отправка данных в чат
    } else {
      telegram.sendData("User data is not available.");
    }
  };

  return (
      <div className="App">
        <header className="App-header">
          <h1>Telegram WebApp</h1>
          <button onClick={sendUserData}>
            Send User Data
          </button>
          <button onClick={() => getLinkRedirect('some_url')}>
            Redirect Link
          </button>
        </header>
      </div>
  );
}

export default App;

