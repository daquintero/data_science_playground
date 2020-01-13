classdef HeadingSignals < matlab.System
    % This are the heading signals class.
    % It implements a number of functions to test the response behaviour
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
       
    end

    properties(DiscreteState)
    end

    % Pre-computed constants
    properties(Access = public)
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end
        
        function [step, ramp, sine, trueHeading] = stepImpl(obj, time)
            step = generateStep(obj, time);
            ramp = generateRamp(obj, time);
            sine = generateSine(obj, time);
            trueHeading = generateTrueHeading(obj, time);
            % sawtoothWave = generateSawtooth(obj, time);
            % turn180 = generate180Turn(obj, time, turnTime);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
    
    methods(Access = private)
        function step = generateStep(obj, time)
            % Unit step Input
            step = ones(1, length(time));
        end
        
        function ramp = generateRamp(obj, time)
            % Ramp input
            ramp = time;
        end
        
        function sine = generateSine(obj, time)
            % Ramp input
            sine = sin(time);
        end 
        
        % function lowRateTurn = generateLowRateTurn(obj, time, period)
        % 
        % end
        % 
        % function sawtoothWave = generateSawtooth(obj, time, period)
        %      sawtoothWave = sawtooth(time);
        % end
        
    end
    
    methods(Access = public)
        function windGusts = generateWindGusts(obj, time)
        
        end
        
        function trueHeading = generateTrueHeading(obj, time)
            maximumTurnRate = 200;
            
            % Time limits
            step1Time = 3;
            transition12EndTime = step1Time + 5; % 8
            step2Time = transition12EndTime + 5; % 13
            transition23EndTime = step2Time + 2; % 15
            step3Time = transition23EndTime + 5; % 20
            transition34EndTime = step3Time + 5; % 25
            step4Time = transition34EndTime + 5; % 30
            
            % State at those specific times
            step1State = 1;
            step2State = maximumTurnRate/2;
            transitionState12 = (time - step1Time) * (step2State - step1State) / (transition12EndTime - step1Time);
            step3State = -maximumTurnRate/2;
            transitionState23 = (time - step2Time -1) * (step3State - step2State) / (transition23EndTime - step2Time)
            step4State = -maximumTurnRate/4;
            transitionState34 = (time - step3Time) * (step4State - step3State) / (transition34EndTime - step3Time);
            
            if time <= step1Time
                trueHeading = step1State;
            elseif (time > step1Time) && (time <= transition12EndTime)
                trueHeading = transitionState12;
            elseif (time > transition12EndTime) && (time <= step2Time)
                trueHeading = step2State;
            elseif (time > step2Time) && (time <= transition23EndTime)
                trueHeading = transitionState23
            elseif (time > transition23EndTime) && (time <= step3Time)
                trueHeading = step3State;
%             elseif (time >= step3Time) && (time < transition34EndTime)
%                 trueHeading = transitionState34;
%             elseif (time >= transition34EndTime) && (time < step4Time)
%                 trueHeading = step4State;
%             elseif (time >= step4Time)
%                 trueHeading = step4State/2 * sin((time-step4Time)) - 50;
            else
                trueHeading = step3State;
            end
            trueHeading = trueHeading + random("normal", 0, maximumTurnRate * 0.005)
        end
    end
end
