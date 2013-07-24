# JEWorkDistributor
=================

A simple class for spreading out a repetitive task on the main thread, allowing the UI to draw. 


## Example Usage:
```
int count = [self.recording eventCountForType:FDRRecordingEventTypeLocation];
__block NSTimeInterval lastEventMET = -1;
__block int i = 0;
__block FDRKMLExporter *weakSelf = self;
[JEWorkDistributor repeatBlock:^{
        FDRLocationRecordingEvent *e = (FDRLocationRecordingEvent *)[weakSelf.recording eventOfType:FDRRecordingEventTypeLocation atIndex:i];
        
        NSTimeInterval dt;
        if (lastEventMET < 0)
        {
            dt = 0.0;
        }
        else
        {
            dt = e.missionElapsedTime - lastEventMET;
        }
        
        NSString *s = [e KMLRepresentation];
        [stream writeString:s];
        
        lastEventMET = e.missionElapsedTime;
        
        progress((float)i/count);
        i++;
        
    } until:^BOOL{
        return count == i;
    } onComplete:^{
        // finish the path
        NSString *pathFinish = @"</coordinates></LineString></Placemark>";
        [stream writeString:pathFinish];
        
        // add the footer
        [stream writeString:[weakSelf footer]];
        
        [stream close];
        completed(nil);
}];
```
