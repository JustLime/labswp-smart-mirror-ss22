import React, { useEffect, useState } from 'react'
import { Textfit } from 'react-textfit';

// Weather component for Widget
function Weather(params) {
  const [weatherState, setWeatherState] = useState();
  let position = {
    gridArea: params.gridPos
  }

  // API values for requesting weather
  const api = {
    key: "2c153589bf12d0d5821b55bb0c7ba35e",
    base: "https://api.openweathermap.org/data/2.5/",
    location: params.city
  }

  // Fetch weather data
  const fetchWeather = () => {
    fetch(api.base + "weather?q=" + api.location + "&units=metric&APPID=" + api.key)
      .then(res => res.json())
      .then(result => {
        setWeatherState(result);
        console.log(result);
      });
  }
  // Call fetches weather data every 15 Minutes
  useEffect(() => {
    fetchWeather();
    setInterval(() => {
      fetchWeather();
      console.log(weatherState);
    }, 900000);
  }, [])

  // Returns a weather widget
  return (
    <>
      {(typeof weatherState != "undefined") ? (
        <div className='weather' style={position}>
            <img className='weatherIcon' src={'img/' + weatherState.weather[0].icon + '.png'}></img>
            <div className='weatherText'>
              <Textfit mode="single" max={1080}>
              <p>{Math.round(weatherState.main.temp) + "°C"}<br/>{weatherState.name + ", " + weatherState.weather[0].main}</p>
            </Textfit></div>
        </div>
      ) : ("")}
    </>
  )
}

export default Weather