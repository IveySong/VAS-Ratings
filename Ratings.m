%% set screen
sca;
close all;
clearvars;
KbName('UnifyKeyNames');
EscapeKey= KbName('Escape');
RestrictKeysForKbCheck([EscapeKey]);

%%
Screen('Preference', 'SkipSyncTests', 1)
PsychDefaultSetup(2);
screenNumber = max(Screen('Screens'));
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
[w, windowRect] = PsychImaging('OpenWindow', screenNumber, 255);
[xCenter, yCenter] = WindowCenter(w);
[screenXpix, screenYpix] = Screen('WindowSize', w);
screenYcm = 18;                                                                                                                        %computer screen width
screenXcm = screenYcm* (screenXpix / screenYpix);                                                                  %computer  screen height
pixPerCm = screenXpix / screenXcm;

%%
try
    
    %% set the Rating Line
    LengthRect=pixPerCm*20;
    WidthRect=pixPerCm*0.1;
    ColorRect=[0,0.2,0];
    BaseRect = [0 0 LengthRect WidthRect];
    %BaseRectWidthPixels=3;
    centerRect=CenterRectOnPointd(BaseRect,xCenter, yCenter);
    % the follow rect is to make a limit the position when rating
    BaseRect2 = [0 0 LengthRect screenYcm*0.8];
    centerRect2=CenterRectOnPointd(BaseRect,xCenter, yCenter);
    Screen('FillRect', w, ColorRect, centerRect);
    
    %% set the Coordinate Unit & Axis of Rating Line
    OneUnit=LengthRect/20;    %the Pleasantness rating ranges from -10 to 10, thus 20 units in total
    RatingUnit=[-10:10];
    LengthofAxis=-pixPerCm*0.3;
    WidthofAxis=2;
    Screen('TextFont', w, 'Times New Roman'); %the font of the X Axis
    Screen('TextSize', w, 14);
    for i=1:21   % now have 21 label
        DrawFormattedText(w, int2str(RatingUnit(i)), xCenter+OneUnit* RatingUnit(i)-pixPerCm*0.1,yCenter,black);
        OriginalXAxis=xCenter+OneUnit* RatingUnit(i);
        Screen('DrawLine',w,ColorRect,OriginalXAxis, yCenter,OriginalXAxis,yCenter+LengthofAxis,WidthofAxis);
    end
    DrawFormattedText(w,'Very Unpleasant', xCenter-OneUnit* 11,yCenter-OneUnit*1.5,black);
    DrawFormattedText(w,'Very Pleasant', xCenter+OneUnit* 9,yCenter-OneUnit*1.5,black);
    Screen('Flip',w);
    
    %% Mouse Click to Rate & Get the Ratings
    while ~KbCheck
        [mx, my, buttons] = GetMouse(w);
        inside = IsInRect(mx, my, centerRect2);
        if inside == 1 && sum(buttons) > 0    %if the x Axis of mouse position is in the rang of rating line
            Screen('Flip',w);
        end
    end
    XPosRating=(mx-xCenter)/pixPerCm;
    results(1,1)=[XPosRating]; 
    %    KbStrokeWait;
     
    
    %% Unexpected Quit
    while true                                                                                                                                                                  %空格键呈现下一刺激，eac键退出
        [~,~,keyCode]=KbCheck;
        if keyCode(EscapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(SpaceKey)
            break;
        end
    end
    %% Clean Up
    % close the window
    sca;
    ListenChar(0);
    ShowCursor;
catch
    psychrethrow(psychlasterror);
    sca;
end
