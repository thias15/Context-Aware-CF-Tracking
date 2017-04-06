# Context-Aware-CF-Tracking

Authors: Matthias Mueller, Neil Smith and Bernard Ghanem

Project Website: https://goo.gl/6zOpKO

Personal Website: www.matthias.pw

License: See LICENSE file

**If you use any of this work please cite:**  
Matthias Mueller, Neil Smith, Bernard Ghanem  
"Context-Aware Correlation Filter Tracking"  
Conference on Computer Vision and Pattern Recognition (CVPR 2017) [Oral]

## Running trackers on test sequences
Every trackers comes with one sequence from OTB100. Simply run the function *run_tracker*.
If you would like to run a different sequence copy its folder into the sequences folder.
Then change the video name in the *run_tracker* function.


## Running trackers on OTB benchmark
Copy the trackers into the folder trackers of the benchmark.
Add the following to the *config_trackers* function.

```matlab
 trackersCA = {struct('name','MOSSE_CA','namePaper','MOSSE_CA'),...     
     struct('name','DCF_CA','namePaper','DCF_CA'),...   
     struct('name','SAMF_CA','namePaper','SAMF_CA'),...
     struct('name','STAPLE_CA','namePaper','STAPLE_CA')};

trackers = trackersCA;
```
