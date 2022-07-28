import React, { useEffect, useState } from 'react'
import { Textfit } from 'react-textfit';

// News component for widget
function News(params) {
  const [newsState, setNewsState] = useState();
  let position = {
    gridArea: params.gridPos
  }

  // API values for requesting weather
  const api = {
    key: "57537cbc5b2b46c887d258e613fba6ef",
    base: "https://newsapi.org/v2/",
    search: params.search,
    timespan: params.timespan
  }

  // Fetch news data
  const fetchNews = async () => {
    await fetch(api.base + api.search + api.timespan + "&sortBy=publishedAt&apiKey=" + api.key)
      .then(res => res.json())
      .then(result => {
        setNewsState(result);
        console.log(result);
      })
      .catch((error) => console.log(error));
  };

  // Call fetch news data every 15 minutes
  useEffect(() => {
    fetchNews();
    setInterval(() => {
      fetchNews();
    }, 900000);
  }, [])

  // Returns a news widget
  return (
    <>
      {(typeof newsState != "undefined") ? (
        <div className='news' style={position}>
            <Textfit max={1080}>
              <h2>{newsState.articles[0].title}</h2>
              <p>{newsState.articles[0].description}</p>
            </Textfit>
            <Textfit max={1080}>
              <h2>{newsState.articles[1].title}</h2>
              <p>{newsState.articles[1].description}</p>
            </Textfit>
            <Textfit max={1080}>
              <h2>{newsState.articles[2].title}</h2>
              <p>{newsState.articles[2].description}</p>
            </Textfit>
        </div>) : ("")}
    </>
  )
}

export default News