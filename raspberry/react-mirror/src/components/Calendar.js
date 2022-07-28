import React, { useEffect, useState } from 'react'
import Textfit from 'react-textfit'

// This widget is just a placeholder so the app can place something.

// Calendar filler component for Widget
function Calendar(params) {
    const [calendarState, setCalendarState] = useState();
    let position = {
        gridArea: params.gridPos
    }
    
// Set current day
    useEffect(() => {
        setInterval(() => {
            const date = new Date();
            setCalendarState(date.toLocaleDateString("de-DE", {weekday: 'long'}) + " " + date.toLocaleDateString());
            console.log(date.toLocaleDateString("de-DE", {weekday: 'long'}));
            console.log(date.toLocaleDateString());
        }, 1000);
    }, [])
// Returns a filler calendar widget that will fit its text to given grid size
  return <div className='calendar' style={position}>
            <Textfit mode="single" forceSingleModeWidth={true} max={1080}>
                {calendarState}
            </Textfit>
        </div>;
}

export default Calendar
