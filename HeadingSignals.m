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
    properties(Access = private)
        
        

    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end
        
        function [step, ramp, sine, sawtoothWave] = stepImpl(obj, time)
            step = generateStep(obj, time);
            ramp = generateRamp(obj, time);
            sine = generateSine(obj, time);
            sawtoothWave = generateSawtooth(obj, time);
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
        
        function sawtoothWave = generateSawtooth(obj, time)
            sawtoothWave = sawtooth(time);
        end
        
    end
end
