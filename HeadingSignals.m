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
            % Long Chirp Period
            longChirpStartFrequency = 0.001;
            longChirpEndFrequency = 1;
            longChirpPeriod = 150;
            longChirpConstant = (longChirpEndFrequency - longChirpStartFrequency) / longChirpPeriod;
            
            % Short Chirp
            chirpStartFrequency = 0.001;
            chirpEndFrequency = 20;
            chirpPeriod = 25;
            chirpConstant = (chirpEndFrequency - chirpStartFrequency) / chirpPeriod;
            
            % Time limits
            step1Time = 3;
            transition12EndTime = step1Time + 5; % 8
            step2Time = transition12EndTime + 2; % 13
            transition23EndTime = step2Time + 2; % 15
            step3Time = transition23EndTime + 5; % 20
            transition34EndTime = step3Time + 5; % 25
            step4Time = transition34EndTime + chirpPeriod; % 30
            step5Time = step4Time + 5;
            step6Time = step5Time + longChirpPeriod;
            
            % State at those specific times
            step1State = 1;
            step2State = maximumTurnRate/2;
            transitionState12 = (time - step1Time) * (step2State - step1State) / (transition12EndTime - step1Time);
            step3State = - maximumTurnRate/2;
            transitionState23 = (time - step2Time -1) * (step3State - step2State) / (transition23EndTime - step2Time);
            step4State = -maximumTurnRate/4;
            transitionState34 = (time - step3Time - 10) * (step4State - step3State) / (transition34EndTime - step3Time);
            step5State = - maximumTurnRate/2;
            variableState = step4State
            
            if time <= step1Time
                trueHeading = step1State;
            elseif (time > step1Time) && (time <= transition12EndTime)
                trueHeading = transitionState12;
            elseif (time > transition12EndTime) && (time <= step2Time)
                trueHeading = step2State;
            elseif (time > step2Time) && (time <= transition23EndTime)
                trueHeading = transitionState23;
            elseif (time > transition23EndTime) && (time <= step3Time)
                trueHeading = step3State;
            elseif (time >= step3Time) && (time < transition34EndTime)
                trueHeading = transitionState34;
            elseif (time >= transition34EndTime) && (time < step4Time)
                trueHeading = step4State/4 * sin(((chirpConstant * (time-step4Time) ^ 2 / 2 +...
                   chirpStartFrequency *(time-step4Time)))) + step4State;
            elseif (time >= step4Time) && (time < step5Time)
                trueHeading = step5State;
            elseif (time >= step5Time) && (time < step6Time)
                if (time < step5Time + 30)
                    variableState = step4State + 3 * (time - step5Time);
                elseif (time >= step5Time + 30) && (time <= step5Time + 3/4 * longChirpPeriod)
                    variableState = variableState - 2 * (time - step5Time) + 200;
                end
                trueHeading = variableState/4 * sin(((2 * longChirpConstant * (time-longChirpPeriod) ^ 2 / 2 +...
                   chirpStartFrequency *(time-step5Time)))) + variableState;
            elseif (time >= step6Time + 20 ) && (time < step6Time + 40)
                trueHeading = step5State;
            else
                trueHeading = step4State;
            end
            trueHeading = trueHeading + random("normal", 0, maximumTurnRate * 0.005);
        end
    end
end
