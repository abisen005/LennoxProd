({
    ical_download : function(component, event, helper) {
        console.log('test ');
        //name of event in iCal
        var eventName = 'My Cool Event';
        
        //name of file to download as
        var fileName = 'my-event.ics';
        
        //start time of event in iCal
        var dateStart = '2016-04-01';
        
        //end time of event in iCal
        var dateEnd = '2016-04-02';
        
        
        //helper functions
        
       /* //iso date for ical formats
        var _isofix = function(d){
            var offset = ("0"+((new Date()).getTimezoneOffset()/60)).slice(-2);
            
            if(typeof d=='string'){
                return d.replace(/\-/g, '')+'T'+offset+'0000Z';
            }else{
                return d.getFullYear()+this._zp(d.getMonth()+1)+this._zp(d.getDate())+'T'+this._zp(d.getHours())+"0000Z";
            }
        }*/
        function _isofix(d) {
            var offset = ("0"+((new Date()).getTimezoneOffset()/60)).slice(-2);
            
            if(typeof d=='string'){
                return d.replace(/\-/g, '')+'T'+offset+'0000Z';
            }else{
                return d.getFullYear()+_zp(d.getMonth()+1)+_zp(d.getDate())+'T'+_zp(d.getHours())+"0000Z";
            }
        }
        
        
        //zero padding for data fixes
        function _zp(c) {
            return ("0"+s).slice(-2);
        }
        
        function _save(fileURL) {
            if (!window.ActiveXObject) {
                var save = document.createElement('a');
                save.href = fileURL;
                save.target = '_blank';
                save.download = this.fileName || 'unknown';
                
                var evt = new MouseEvent('click', {
                    'view': window,
                    'bubbles': true,
                    'cancelable': false
                });
                save.dispatchEvent(evt);
                
                //(window.URL || window.webkitURL).revokeObjectURL(save.href);
            }
            
            // for IE < 11
            else if ( !! window.ActiveXObject && document.execCommand)     {
                var _window = window.open(fileURL, '_blank');
                _window.document.close();
                _window.document.execCommand('SaveAs', true, this.fileName || fileURL)
                _window.close();
            }
        }

      // var  _zp = function(s){ return ("0"+s).slice(-2); }
      /*  var _save = function(fileURL){
            if (!window.ActiveXObject) {
                var save = document.createElement('a');
                save.href = fileURL;
                save.target = '_blank';
                save.download = this.fileName || 'unknown';
                
                var evt = new MouseEvent('click', {
                    'view': window,
                    'bubbles': true,
                    'cancelable': false
                });
                save.dispatchEvent(evt);
                
                //(window.URL || window.webkitURL).revokeObjectURL(save.href);
            }
            
            // for IE < 11
            else if ( !! window.ActiveXObject && document.execCommand)     {
                var _window = window.open(fileURL, '_blank');
                _window.document.close();
                _window.document.execCommand('SaveAs', true, this.fileName || fileURL)
                _window.close();
            }	
        }*/    
        
        
        var now = new Date();
        var ics_lines = [
            "BEGIN:VCALENDAR",
            "VERSION:2.0",
            "PRODID:-//Addroid Inc.//iCalAdUnit//EN",
            "METHOD:REQUEST",
            "BEGIN:VEVENT",
            "UID:event-"+now.getTime()+"@addroid.com",
            "DTSTAMP:"+_isofix(now),
            "DTSTART:"+_isofix(this.dateStart),
            "DTEND:"+_isofix(this.dateEnd),
            "DESCRIPTION:"+eventName,
            "SUMMARY:"+eventName,
            "LAST-MODIFIED:"+_isofix(now),
            "SEQUENCE:0",
            "END:VEVENT",
            "END:VCALENDAR"
        ];
        
        var dlurl = 'data:text/calendar;base64,'+btoa(ics_lines.join('\r\n'));
        
        try {
            _save(dlurl);
        }catch(e){
            console.log(e);
        }
        
        
    }
})