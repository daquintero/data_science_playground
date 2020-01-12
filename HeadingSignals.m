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
            % Note random wind gusts
            
            if time < 5
                trueHeading = 1 + random("normal", 0, 0.1);
            elseif (time > 5) && (time < 15)
                trueHeading = 1
            else
                trueHeading = 0
            end
        end
    end
end
