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

        function step = stepImpl(obj)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            time = 1;

            % Unit Input
            stepInput = ones(1, length(time))
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
