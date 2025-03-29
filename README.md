# Camera-based Cardio-respiratory Monitoring Across the Full Fitness Cycle

This is code repository for the paper "Camera-based Cardio-respiratory Monitoring Across the Full Fitness Cycle".

### Background
Continuous physiological monitoring during exercise offers
critical insights into cardiovascular status, enabling early detection of abnormalities and
supporting diagnosis of cardiorespiratory conditions. 
Current research predominantly focuses on monitoring of specific exercise phases (e.g., post-exercise recovery analysis), neglecting comprehensive physiological profiling across the entire fitness cycle. This limitation results in incomplete characterization of exercisers' dynamic physiological responses. Based on this observation, we introduce the concept of **Full Fitness Cycle Monitoring**, encompassing three critical phases: pre-exercise, during-exercise, post-exercise. 
This approach enables continuous cardiovascular evaluation while overcoming motion artifact challenges inherent in exercise environments, establishing new benchmarks for fitness-oriented health monitoring systems.

This repository implements rPPG extraction code and calculates physiological signals at various stages of the full fitness cycle, comparing the performance of rPPG and PPG. Due to file size limitations, the original and processed data for this project have been uploaded to a cloud storage platform ([URL](https://drive.google.com/drive/folders/10wFQuzyZx9YnZDAJbFmGvNlIBD6AhgNE?usp=sharing)).

### Instructions:
1. we provide a `demo.m` file with sample data to demonstrate rPPG signal extraction by `get_rppg.m`. Run the `demo.m` file to extract rPPG signals based on RGB traces and motion traces.  
2. Execute `hr_hrv_process.m` and `rr_process.m` to calculate heart rate (HR), heart rate variability (HRV), and respiratory rate (RR).  
3. Use the following files to visualize the results:`plot_result.m`, `HR_heatmap.m`, `hr_hrv_plot.m`.


Please cite below paper if the code was used in your research or development.
    
    
    @ARTICLE{xiao2025camera,
     title={Camera-based cardio-respiratory monitoring across the full fitness cycle},
     author={Xiao, Chang and Tan, Chengyifeng and Song, Lixia and Lu, Hongzhou and Wang, Wenjin},
     journal={Physiological Measurement},
     year={2025}
    }



