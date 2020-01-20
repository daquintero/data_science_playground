# Overview

I wanted to do a **Github-publishable** data science project to share my knowledge of Pandas and Python I use daily. I found the time to do it with this one for a semi-open ended coursework. In this project, I made an integrated-sensor system, and after many simulations (4GB of many CSV files), I wanted to find the system's optimal design parameters. I used Pandas for the Big-Data analysis, Matplotlib 3D to plot, and [MATLAB/Simulink](./data_generation_model/HeadingSystem.prj) (required) to create the system. See the report on how the data was analysed at the end.

Skills demonstrated in [this project Jupyter lab](./analytics/dataRawAnalytics.ipynb):
* Multi-dimensional data analytics and comprehension with Pandas MultiIndexes (3M+ data lines)
* Multi-dimensional data plotting with Pandas and Matplotlib 3D.
* Some programmatic cleanup for imperfect input file names.
* Data reshaping

The [report analysing all the data with all figures is here](./report/report.pdf)

Some nice figures:
![fullSystemErroCutoffVariations](./analytics/figures/fullSystemErrorCutoffFrequency.png)

![fullSystemTimeResponse](./analytics/figures/fullSystemCutoffFrequency.png)

![allSignalsFullTimeResponse](./analytics/figures/allSignalsFullTimeResponse_1_0476.png)

![standardDeviationErrorAnalytics](./analytics/figures/iterables/error_signals/errorstandardDeviationSignals.png)

Have a great day and hope this is somewhat useful to you!