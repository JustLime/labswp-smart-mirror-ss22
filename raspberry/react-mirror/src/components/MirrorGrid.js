import React, { Component } from 'react'
import Clock from './Clock'
import News from './News'
import Weather from './Weather'
import Calendar from './Calendar'

const components = { //Mapping of component tags
  clock: Clock,
  weather: Weather,
  news: News,
  calendar: Calendar
}

// Grid component to hold all the widgets
export default class MirrorGrid extends Component {
  constructor(props) {// Constructor for fetching json data for widgets
    super(props)
    this.state = {
      widgets: []
    }
    fetch('/data/mirrorWidgets.json'
      , {
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      })
      .then((res) => res.json())
      .then((data) => {
        this.setState(this.state.widgets = data) //Causes warnings but if it doesn't break it's fine for now
        console.log(this.state.widgets)
      })
  }
  render() { //Rendering the components by tag in json
    return (
      <div className='container'>
        {this.state.widgets.map((gridComponent, index) => {
          switch (gridComponent.tagName) {
            case 'clock':
              return React.createElement(components[gridComponent.tagName], {
                key: index,
                gridPos: gridComponent.gridPos,
                offset: gridComponent.offset
              });
            case 'weather':
              return React.createElement(components[gridComponent.tagName], {
                key: index,
                gridPos: gridComponent.gridPos,
                city: gridComponent.city
              });
            case 'news':
              return React.createElement(components[gridComponent.tagName], {
                key: index,
                gridPos: gridComponent.gridPos,
                search: gridComponent.search,
                timespan: gridComponent.timespan
              });
            case 'calendar':
              return React.createElement(components[gridComponent.tagName], {
                key: index,
                gridPos: gridComponent.gridPos
              });
            default: //Default if no type for e.g. IP of mirror
              return React.createElement('p', {
                key: index
              }, JSON.stringify(this.state.widgets));
          }
        })}
      </div>
    )
  }
}
