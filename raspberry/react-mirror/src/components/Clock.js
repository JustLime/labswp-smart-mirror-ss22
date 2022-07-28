import React, { useEffect, useState } from 'react'
import Textfit from 'react-textfit'

// Clock component for Widget
function Clock(params) {
    const [clockState, setClockState] = useState();
    let position = {
        gridArea: params.gridPos
    }
    
// Sets time every second
    useEffect(() => {
        setInterval(() => {
            const date = new Date();
            date.setMinutes(date.getMinutes() + params.offset);
            setClockState(date.toLocaleTimeString());
            console.log(date.getTimezoneOffset());
        }, 1000);
    }, [])
// Returns a clock widget that will fit its text to given grid size
  return <div className='clock' style={position}>
            <Textfit mode="single" forceSingleModeWidth={true} max={1080}>
                {clockState}
            </Textfit>
        </div>;
}

export default Clock